---
title: spring ioc源码分析
mathjax: true
date: 2020-05-12 11:12:26
tags: [spring,java]
category: [java,spring]
---

Spring有两大核心，IoC和AOP。之前有用过Spring，但对于源码还不够了解，因此专门写一篇博文来记录阅读这部分源码的过程。

<!--more-->

### 什么是IoC

要阅读IoC的源码，首先要搞清楚IoC是干嘛的，IoC全称Inversion of Control ，意为控制反转，有时候也被称为DI (Dependency Injection，依赖注入)。

需要注意的是，两个概念是有区别的。控制反转是目的，依赖注入是手段。所谓控制反转，我们在Java中要使用对象的时候，通常是new一个对象出来用，控制反转就是把对象的管理交给Spring，我们只需要用。依赖注入就是需要用的时候，你只要标明你需要这个对象，由Spring帮你注入就行了。

### 源码分析

假设我们现在有一个AccountDao对象，其实现类为AccountDaoImpl，其中只有一个save方法

```java
//AccountDao.JAVA
public interface AccountDao {
    void save();
}

//AccountDaoImpl.JAVA
/**
 * 账户持久层实现类
 */
@Repository("accountDao")
public class AccountDaoImpl implements AccountDao {
    public void save() {
        System.out.println("账户已保存");
    }
}
```

为了进行依赖注入，在Spring当中我们采用xml的配置方式，其中xmlns表示namespace，也就是命名空间，定义了这个xml文件是用来干嘛的，需要不同的功能就要引入不同的命名空间，其最基本的是`beans`的定义功能，文件中的accountDao已经被指定了`id`和`class`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--基于注解的IOC约束需要导入context空间-->
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">
    <!--告知spring创建容器时要扫描的包-->
    <context:component-scan base-package="day2_01_annotationIOC">
    </context:component-scan>

    <!--告知Spring properties文件的位置-->
    <context:property-placeholder location="day2_01_annotationIOC/jdbcConfig.properties"/>

    <!--要有set方法才能用显示bean的方法注入-->
    <!--配置持久层-->
    <bean id="accountDao" class="day2_01_annotationIOC.dao.impl.AccountDaoImpl"/>
</beans>
```

我们需要一个applicationContext作为容器来获取`beans`，这里使用`ClassPathXmlApplicationContext`进行，当然也可以使用`FileSystemXmlApplicationContext`，二者区别只是前者不需要指定绝对路径。我们明明这个类为Client，返回的容器用`ApplicationContext`接收。

```Java
public class Client {
    /**
     * 获取spring的核心容器，并且根据bean的id获取对象
     */
    public static void main(String[] args) {
        ////获取spring核心容器
        ApplicationContext ac = new ClassPathXmlApplicationContext("day2_01_bean.xml");
        //持久层对象
        AccountDao accountDao = ac.getBean("accountDao", AccountDao.class);
        System.out.println(accountDao);
    }
}
```

我们跳入`ClassPathXmlApplicationContext`的构造方法看看

```java
//org.springframework.context.support.ClassPathXmlApplicationContext 84
public ClassPathXmlApplicationContext(String configLocation) throws BeansException {
  this(new String[] {configLocation}, true, null);
}


//ClassPathXmlApplicationContext 137
public ClassPathXmlApplicationContext(
  String[] configLocations, boolean refresh, @Nullable ApplicationContext parent)
  throws BeansException {

  //这里的父类指的是bean的父子继承，不是class的继承关系，具体可以查看后面的"Bean继承"小节
  super(parent);
  
  //找出所有的配置文件路径
  setConfigLocations(configLocations);
  //核心方法
  if (refresh) {
    refresh();
  }
}
```

继续往下看refresh方法：

```java
//AbstractApplicationContext 516
	public void refresh() throws BeansException, IllegalStateException {
		synchronized (this.startupShutdownMonitor) {
      //记录开始时间,设置状态为开始创建,关闭状态设为false
			prepareRefresh();

      // 最重要的步骤,这里之后就获取到了BeanFactory了
      // 把所有bean的信息都提取出来，注册到beanFactory里面，这里的bean还没有初始化
      // 提取出来的信息是beanName-> beanDefination的map
			ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();

      //手动注册特殊的bean
			prepareBeanFactory(beanFactory);

			try {
        //BeanFactoryPostProcessor的处理
        //点进去看到方法是protected的空函数，主要是给子类继承来处理BeanFactory的
				postProcessBeanFactory(beanFactory);

        //调用 BeanFactoryPostProcessor 各个实现类的 postProcessBeanFactory(factory) 方法
				invokeBeanFactoryPostProcessors(beanFactory);

        //注册BeanPostProcessor
				registerBeanPostProcessors(beanFactory);

				// 初始化MessageSource，用于国际化，不涉及就不说了
				initMessageSource();

				// 初始化ApplicationContext的时间广播器，不展开说了
				initApplicationEventMulticaster();

				// 从方法名能看出来，钩子方法
        // 子类可以在这里初始化一些特殊的Bean(初始化Singleton Beans之前)
				onRefresh();

				// 注册时间监听器,不展开
				registerListeners();

				// 实例化所有非lazy-init的singleton beans
				finishBeanFactoryInitialization(beanFactory);

				// 广播事件，ApplicaitonContext初始化完成
				finishRefresh();
			}

			catch (BeansException ex) {
				if (logger.isWarnEnabled()) {
					logger.warn("Exception encountered during context initialization - " +
							"cancelling refresh attempt: " + ex);
				}

				// 销毁已经创建的singleton beans，以免资源占用
				destroyBeans();

				// Reset 'active' flag.
				cancelRefresh(ex);

				// Propagate exception to caller.
				throw ex;
			}

			finally {
				// Reset common introspection caches in Spring's core, since we
				// might not ever need metadata for singleton beans anymore...
        //释放bean描述器的缓存
				resetCommonCaches();
			}
		}
	}

```

下面，我们将一个个函数来解析这个refresh函数，上面的`prepareRefresh()`函数功能主要是设定active状态为true，closed状态为false，两个状态值都是AtomicBoolean。并检查xml文件中是否包含必要的值。

### 创建Bean容器，加载、注册Bean

refresh方法种的第二个函数：`obtainFreshBeanFactory()`

这个方法是IoC过程中最重要的一个函数之一，在这里初始化BeanFactory，加载Bean，注册Bean，但是这一步之后Bean初始化并未完成,因为还没有实例化Bean。

//AbstractApplicationContext 620

```java
protected ConfigurableListableBeanFactory obtainFreshBeanFactory() {
  //如果有BeanFactory，先销毁旧的，再创建新的，加载Bean定义，注册Bean
  refreshBeanFactory();
  
  // 返回上一步创建的Bean
  ConfigurableListableBeanFactory beanFactory = getBeanFactory();
  if (logger.isDebugEnabled()) {
    logger.debug("Bean factory for " + getDisplayName() + ": " + beanFactory);
  }
  return beanFactory;
}
```

// AbstractRefreshableApplicationContext 124

```java
@Override
protected final void refreshBeanFactory() throws BeansException {
  //如果有BeanFactory，先销毁所有的Bean，关闭已有BeanFactory
  if (hasBeanFactory()) {
    destroyBeans();
    closeBeanFactory();
  }
  try {
    // 初始化一个DefaultListableBeanFactory
    DefaultListableBeanFactory beanFactory = createBeanFactory();
    // 用于序列化BeanFactory的设置
    beanFactory.setSerializationId(getId());
    // 配置Bean是否允许覆盖，是否允许循环引用
    customizeBeanFactory(beanFactory);
    
    //加载Bean到BeanFactory中
    loadBeanDefinitions(beanFactory);
    synchronized (this.beanFactoryMonitor) {
      this.beanFactory = beanFactory;
    }
  }
  catch (IOException ex) {
    throw new ApplicationContextException("I/O error parsing bean definition source for " + getDisplayName(), ex);
  }
}
```

我们来看看继承关系，ApplicationContext是BeanFactory的子类，但其实这里不应该这个理解，应该理解成ApplicationContext里面包含一个实例化的BeanFactory。

![image-20200512213557235](/Users/apple/Library/Application Support/typora-user-images/image-20200512213557235.png)

第二个问题，Spring为什么要选择`DefaultListableBeanFactory`作为默认的BeanFactory呢，下面图中看到，BeanFactory有三个子接口，而这个`DefaultListableBeanFactory`刚好把实现了三个子接口，意思是三个子接口当中的功能都被继承下来了。

![image-20200512214229003](/Users/apple/Library/Application Support/typora-user-images/image-20200512214229003.png)

Bean是如何被存在BeanFactory当中的呢，其实是通过BeanDefinition存进去的，我们来看看BeanDefinition

### BeanDefinition

```java
public interface BeanDefinition extends AttributeAccessor, BeanMetadataElement {

   // Spring默认只提供 sington 和 prototype 两种，
   // 很多人可能知道还有 request, session, globalSession, application, websocket 这几种，
   // 不过，它们属于基于 web 的扩展。
   String SCOPE_SINGLETON = ConfigurableBeanFactory.SCOPE_SINGLETON;
   String SCOPE_PROTOTYPE = ConfigurableBeanFactory.SCOPE_PROTOTYPE;

   // 不重要，直接跳过
   int ROLE_APPLICATION = 0;
   int ROLE_SUPPORT = 1;
   int ROLE_INFRASTRUCTURE = 2;

   // 设置父 Bean，这里涉及到 bean 继承，不是 java 继承。
   // 一句话就是：继承父 Bean 的配置信息而已
   void setParentName(String parentName);

   // 获取父 Bean
   String getParentName();

   // 设置 Bean 的类名称，将来是要通过反射来生成实例的
   void setBeanClassName(String beanClassName);

   // 获取 Bean 的类名称
   String getBeanClassName();


   // 设置 bean 的 scope
   void setScope(String scope);

   String getScope();

   // 设置是否懒加载
   void setLazyInit(boolean lazyInit);

   boolean isLazyInit();

   // 设置该 Bean 依赖的所有的 Bean，注意，这里的依赖不是指属性依赖(如 @Autowire 标记的)，
   // 是 depends-on="" 属性设置的值。
   void setDependsOn(String... dependsOn);

   // 返回该 Bean 的所有依赖
   String[] getDependsOn();

   // 设置该 Bean 是否可以注入到其他 Bean 中，只对根据类型注入有效，
   // 如果根据名称注入，即使这边设置了 false，也是可以的
   void setAutowireCandidate(boolean autowireCandidate);

   // 该 Bean 是否可以注入到其他 Bean 中
   boolean isAutowireCandidate();

   // 主要的。同一接口的多个实现，如果不指定名字的话，Spring 会优先选择设置 primary 为 true 的 bean
   void setPrimary(boolean primary);

   // 是否是 primary 的
   boolean isPrimary();

   // 如果该 Bean 采用工厂方法生成，指定工厂名称。
   // 一句话就是：有些实例不是用反射生成的，而是用工厂模式生成的
   void setFactoryBeanName(String factoryBeanName);
   // 获取工厂名称
   String getFactoryBeanName();
   // 指定工厂类中的 工厂方法名称
   void setFactoryMethodName(String factoryMethodName);
   // 获取工厂类中的 工厂方法名称
   String getFactoryMethodName();

   // 构造器参数
   ConstructorArgumentValues getConstructorArgumentValues();

   // Bean 中的属性值，后面给 bean 注入属性值的时候会说到
   MutablePropertyValues getPropertyValues();

   // 是否 singleton
   boolean isSingleton();

   // 是否 prototype
   boolean isPrototype();

   // 如果这个 Bean 是被设置为 abstract，那么不能实例化，
   // 常用于作为 父bean 用于继承，其实也很少用......
   boolean isAbstract();

   int getRole();
   String getDescription();
   String getResourceDescription();
   BeanDefinition getOriginatingBeanDefinition();
}
```

继续看`AbstractRefreshableApplicationContext`当中的`refreshBeanFactory()`方法，还剩下两个主要的内容

```java
customizeBeanFactory(beanFactory);
loadBeanDefinitions(beanFactory);	
```

#### 配置Bean覆盖和循环依赖 customizeBeanFactory

配置bean是否允许覆盖，是否允许循环依赖

//AbstractRefreshableApplicationContext 224

```java
protected void customizeBeanFactory(DefaultListableBeanFactory beanFactory) {
  //配置是否允许覆盖
  if (this.allowBeanDefinitionOverriding != null) {
    beanFactory.setAllowBeanDefinitionOverriding(this.allowBeanDefinitionOverriding);
  }
  //配置是否允许循环引用
  if (this.allowCircularReferences != null) {
    beanFactory.setAllowCircularReferences(this.allowCircularReferences);
  }
}
```

BeanDefinition的覆盖，在配置文件定义了多个相同的id或name的时候，如果不配置允许覆盖，那么系统会报错，但是在多个配置文件中，系统不会报错，会进行覆盖。

循环覆盖，默认Spring是允许的，但是不能在构造方法种循环依赖，那么就会报错。

#### 加载Bean loadBeanDefinitions

`loadBeanDefinitions`这个方法是最重要的方法了，这个方法将配置读出来，加载各个Bean，放到BeanFactory中，读取和解析配置文件的操作在`XmlBeanDefinitionReader`类中。

// AbstractXmlApplicationContext 81

```java
@Override
protected void loadBeanDefinitions(DefaultListableBeanFactory beanFactory) throws BeansException, IOException {
  // Create a new XmlBeanDefinitionReader for the given BeanFactory.
  XmlBeanDefinitionReader beanDefinitionReader = new XmlBeanDefinitionReader(beanFactory);

  // Configure the bean definition reader with this context's
  // resource loading environment.
  beanDefinitionReader.setEnvironment(this.getEnvironment());
  beanDefinitionReader.setResourceLoader(this);
  beanDefinitionReader.setEntityResolver(new ResourceEntityResolver(this));

  // 初始化BeanDefinitionReader，提供给子类覆盖
  initBeanDefinitionReader(beanDefinitionReader);
  //开始读定义，继续跳进去
  loadBeanDefinitions(beanDefinitionReader);
}
```

// AbstractXmlApplicationContext 121

```java
// 两个分支，但第二个分支转换为Resource之后，会跟上面到一个函数中
protected void loadBeanDefinitions(XmlBeanDefinitionReader reader) throws BeansException, IOException {
  Resource[] configResources = getConfigResources();
  if (configResources != null) {
    reader.loadBeanDefinitions(configResources);
  }
  String[] configLocations = getConfigLocations();
  if (configLocations != null) {
    reader.loadBeanDefinitions(configLocations);
  }
}


// 上面虽然有两个分支，不过第二个分支很快通过解析路径转换为 Resource 以后也会进到这里
@Override
public int loadBeanDefinitions(Resource... resources) throws BeanDefinitionStoreException {
   Assert.notNull(resources, "Resource array must not be null");
   int counter = 0;
   // 注意这里是个 for 循环，也就是每个文件是一个 resource
   for (Resource resource : resources) {
      // 继续往下看
      counter += loadBeanDefinitions(resource);
   }
   // 最后返回 counter，表示总共加载了多少的 BeanDefinition
   return counter;
}

// XmlBeanDefinitionReader 303
@Override
public int loadBeanDefinitions(Resource resource) throws BeanDefinitionStoreException {
   return loadBeanDefinitions(new EncodedResource(resource));
}

// XmlBeanDefinitionReader 314
public int loadBeanDefinitions(EncodedResource encodedResource) throws BeanDefinitionStoreException {
   Assert.notNull(encodedResource, "EncodedResource must not be null");
   if (logger.isInfoEnabled()) {
      logger.info("Loading XML bean definitions from " + encodedResource.getResource());
   }
   // 用一个 ThreadLocal 来存放配置文件资源
  //private final ThreadLocal<Set<EncodedResource>> resourcesCurrentlyBeingLoaded =
  //			new NamedThreadLocal<>("XML bean definition resources currently being loaded");
   Set<EncodedResource> currentResources = this.resourcesCurrentlyBeingLoaded.get();
  
   if (currentResources == null) {
      currentResources = new HashSet<EncodedResource>(4);
      this.resourcesCurrentlyBeingLoaded.set(currentResources);
   }
   if (!currentResources.add(encodedResource)) {
      throw new BeanDefinitionStoreException(
            "Detected cyclic loading of " + encodedResource + " - check your import definitions!");
   }
   try {
      InputStream inputStream = encodedResource.getResource().getInputStream();
      try {
         InputSource inputSource = new InputSource(inputStream);
         if (encodedResource.getEncoding() != null) {
            inputSource.setEncoding(encodedResource.getEncoding());
         }
         // 核心部分是这里，往下面看
         return doLoadBeanDefinitions(inputSource, encodedResource.getResource());
      }
      finally {
         inputStream.close();
      }
   }
   catch (IOException ex) {
      throw new BeanDefinitionStoreException(
            "IOException parsing XML document from " + encodedResource.getResource(), ex);
   }
   finally {
      currentResources.remove(encodedResource);
      if (currentResources.isEmpty()) {
         this.resourcesCurrentlyBeingLoaded.remove();
      }
   }
}

// XmlBeanDefinitionReader 388
protected int doLoadBeanDefinitions(InputSource inputSource, Resource resource)
  throws BeanDefinitionStoreException {
  try {
    // 将xml转换为document对象
    Document doc = doLoadDocument(inputSource, resource);
    return registerBeanDefinitions(doc, resource);
  }
  catch (BeanDefinitionStoreException ex) {
    throw ex;
  }
  catch (...)
  }
}

// XmlBeanDefinitionReader 505
public int registerBeanDefinitions(Document doc, Resource resource) throws BeanDefinitionStoreException {
  BeanDefinitionDocumentReader documentReader = createBeanDefinitionDocumentReader();
  int countBefore = getRegistry().getBeanDefinitionCount();
  // 把读出来的配置信息，解析成BeanDefinition
  documentReader.registerBeanDefinitions(doc, createReaderContext(resource));
  //返回从当前文件加载了多少的Bean
  return getRegistry().getBeanDefinitionCount() - countBefore;
}

//DefaultBeanDefinitionDocumentReader.java:94
@Override
public void registerBeanDefinitions(Document doc, XmlReaderContext readerContext) {
  this.readerContext = readerContext;
  logger.debug("Loading bean definitions");
  Element root = doc.getDocumentElement();
  //从根节点开始解析
  doRegisterBeanDefinitions(root);
}
```

此时的xml文件已经被解析成了一棵dom树，下面开始解析内容

DefaultBeanDefinitionDocumentReader.java:122

```java
	protected void doRegisterBeanDefinitions(Element root) {
		// 因为<beans>内部还可以定义<beans>，因此定义父节点
    // 当前的根节点可能只是嵌套在内部的根节点，因此要从最外面的根节点开始解析
		BeanDefinitionParserDelegate parent = this.delegate;
		this.delegate = createDelegate(getReaderContext(), root, parent);

		if (this.delegate.isDefaultNamespace(root)) {
      // 检查xml配置中的<beans ... profile="dev" /> ，其中profile是不是当前的环境
			String profileSpec = root.getAttribute(PROFILE_ATTRIBUTE);
			if (StringUtils.hasText(profileSpec)) {
				String[] specifiedProfiles = StringUtils.tokenizeToStringArray(
						profileSpec, BeanDefinitionParserDelegate.MULTI_VALUE_ATTRIBUTE_DELIMITERS);
				if (!getReaderContext().getEnvironment().acceptsProfiles(specifiedProfiles)) {
					if (logger.isInfoEnabled()) {
						logger.info("Skipped XML bean definition file due to specified profiles [" + profileSpec +
								"] not matching: " + getReaderContext().getResource());
					}
					return;
				}
			}
		}

		preProcessXml(root);//钩子方法
    //继续跳进去
		parseBeanDefinitions(root, this.delegate);
		postProcessXml(root);//钩子方法
    //两个钩子方法是用于处理xml文件，给子类覆盖之后实现的

		this.delegate = parent;
	}
```

继续往下看parseBeanDefinitions方法

```java
// DefaultBeanDefinitionDocumentReader.java 186
protected void parseBeanDefinitions(Element root, BeanDefinitionParserDelegate delegate) {
  if (delegate.isDefaultNamespace(root)) {
    NodeList nl = root.getChildNodes();
    for (int i = 0; i < nl.getLength(); i++) {
      Node node = nl.item(i);
      if (node instanceof Element) {
        Element ele = (Element) node;
        if (delegate.isDefaultNamespace(ele)) {
          // 解析default的element
          parseDefaultElement(ele, delegate);
        }
        else {
          // 解析custom element
          delegate.parseCustomElement(ele);
        }
      }
    }
  }
  else {
    delegate.parseCustomElement(root);
  }
}
```

可以看到，最终要么解析default的element，要么解析custom的element

default element包括`<import />`、`<alias/>`、`<bean />`、`<beans/>`这四个

这里的四个标签之所以是 **default** 的，是因为它们是处于这个 namespace 下定义的：

```
http://www.springframework.org/schema/beans
```

而对于其他的标签，将进入到 delegate.parseCustomElement(element) 这个分支。如我们经常会使用到的 `<mvc />`、`<task />`、`<context />`、`<aop />`等

有了这些custom的element，也要在xml的name space中加入对应的内容，比如mvc的是

`      xmlns:mvc="http://www.springframework.org/schema/mvc"`

同时代码中要提供对应的parser来解析，比如有MvcNamespaceHandler、TaskNamespaceHandler、ContextNamespaceHandler、AopNamespaceHandler等解析类。

继续往下看看，对于default标签的处理方法：

```java
private void parseDefaultElement(Element ele, BeanDefinitionParserDelegate delegate) {
  //解析<import/>标签
  if (delegate.nodeNameEquals(ele, IMPORT_ELEMENT)) {
    importBeanDefinitionResource(ele);
  }
  // 解析<alias/>标签
  else if (delegate.nodeNameEquals(ele, ALIAS_ELEMENT)) {
    processAliasRegistration(ele);
  }
  // 解析<bean/>标签
  else if (delegate.nodeNameEquals(ele, BEAN_ELEMENT)) {
    processBeanDefinition(ele, delegate);
  }
  // 解析<beans/> 标签，递归进行
  else if (delegate.nodeNameEquals(ele, NESTED_BEANS_ELEMENT)) {
    // recurse
    doRegisterBeanDefinitions(ele);
  }
}
```

挑选其中比较重要的bean标签进行分析

```java
protected void processBeanDefinition(Element ele, BeanDefinitionParserDelegate delegate) {
  // 把<bean/>标签内容读出来，放在BeanDefinitionHolder中
  BeanDefinitionHolder bdHolder = delegate.parseBeanDefinitionElement(ele);
  if (bdHolder != null) {
    bdHolder = delegate.decorateBeanDefinitionIfRequired(ele, bdHolder);
    try {
      // Register the final decorated instance.
      BeanDefinitionReaderUtils.registerBeanDefinition(bdHolder, getReaderContext().getRegistry());
    }
    catch (BeanDefinitionStoreException ex) {
      getReaderContext().error("Failed to register bean definition with name '" +
                               bdHolder.getBeanName() + "'", ele, ex);
    }
    // Send registration event.
    getReaderContext().fireComponentRegistered(new BeanComponentDefinition(bdHolder));
  }
}
```

`<bean/>`标签当中包含以下内容

| Property                 |                                                              |
| ------------------------ | ------------------------------------------------------------ |
| class                    | 类的全限定名                                                 |
| name                     | 可指定 id、name(用逗号、分号、空格分隔)                      |
| scope                    | 作用域                                                       |
| constructor arguments    | 指定构造参数                                                 |
| properties               | 设置属性的值                                                 |
| autowiring mode          | no(默认值)、byName、byType、 constructor                     |
| lazy-initialization mode | 是否懒加载(如果被非懒加载的bean依赖了那么其实也就不能懒加载了) |
| initialization method    | bean 属性设置完成后，会调用这个方法                          |
| destruction method       | bean 销毁后的回调方法                                        |

举个例子：

```xml
<bean id="exampleBean" name="name1, name2, name3" class="com.javadoop.ExampleBean"
      scope="singleton" lazy-init="true" init-method="init" destroy-method="cleanup">

    <!-- 可以用下面三种形式指定构造参数 -->
    <constructor-arg type="int" value="7500000"/>
    <constructor-arg name="years" value="7500000"/>
    <constructor-arg index="0" value="7500000"/>

    <!-- property 的几种情况 -->
    <property name="beanOne">
        <ref bean="anotherExampleBean"/>
    </property>
    <property name="beanTwo" ref="yetAnotherBean"/>
    <property name="integerProperty" value="1"/>
</bean>
```

当然，除了上述的内容外，还包含factory-bean、factory-method、`<lockup-method />`（计算一个函数 返回的是null，但函数会返回声明的空类型）、`<replaced-method />`、`<meta />`、 `<qualifier/>`这几个。

继续往下看bean的配置是如何被解析出来的：

// BeanDefinitionParserDelegate.java 404

```java
public BeanDefinitionHolder parseBeanDefinitionElement(Element ele) {
   return parseBeanDefinitionElement(ele, null);
}

// BeanDefinitionParserDelegate.java 414
public BeanDefinitionHolder parseBeanDefinitionElement(Element ele, @Nullable BeanDefinition containingBean) {
  // 获取id
  String id = ele.getAttribute(ID_ATTRIBUTE);
  // 获取name
  String nameAttr = ele.getAttribute(NAME_ATTRIBUTE);

  //因为alias可以有多个，所以用list放
  // 别名的配置方式为：
  //<bean id="messageService" name="m1, m2, m3" class="com.javadoop.example.MessageServiceImpl">，name就是别名，用都好分割，此时有三个别名
  List<String> aliases = new ArrayList<>();
  if (StringUtils.hasLength(nameAttr)) {
    String[] nameArr = StringUtils.tokenizeToStringArray(nameAttr, MULTI_VALUE_ATTRIBUTE_DELIMITERS);
    aliases.addAll(Arrays.asList(nameArr));
  }

  //如果没有指定id，那么就用别名的第一个作为id
  String beanName = id;
  if (!StringUtils.hasText(beanName) && !aliases.isEmpty()) {
    beanName = aliases.remove(0);
    if (logger.isDebugEnabled()) {
      logger.debug("No XML 'id' specified - using '" + beanName +
                   "' as bean name and " + aliases + " as aliases");
    }
  }

  //检查名字是否重复
  if (containingBean == null) {
    checkNameUniqueness(beanName, aliases, ele);
  }

  //根据xml的配置，将配置信息放到BeanDefinition中，下面继续跳入该方法
  AbstractBeanDefinition beanDefinition = parseBeanDefinitionElement(ele, beanName, containingBean);
  if (beanDefinition != null) {
    // 又没有id又没有name，那么系统将生成一个名字
    if (!StringUtils.hasText(beanName)) {
      try {
        //原先有bean，那么对bean生成名字，包含父类名加上"$child"这种形式
        if (containingBean != null) {
          beanName = BeanDefinitionReaderUtils.generateBeanName(
            beanDefinition, this.readerContext.getRegistry(), true);
        }
        else {          
          //原先有bean，那么对bean直接命名
          beanName = this.readerContext.generateBeanName(beanDefinition);
          // Register an alias for the plain bean class name, if still possible,
          // if the generator returned the class name plus a suffix.
          // This is expected for Spring 1.2/2.0 backwards compatibility.
          String beanClassName = beanDefinition.getBeanClassName();
          if (beanClassName != null &&
              beanName.startsWith(beanClassName) && beanName.length() > beanClassName.length() &&
              !this.readerContext.getRegistry().isBeanNameInUse(beanClassName)) {
            aliases.add(beanClassName);
          }
        }
        if (logger.isDebugEnabled()) {
          logger.debug("Neither XML 'id' nor 'name' specified - " +
                       "using generated bean name [" + beanName + "]");
        }
      }
      catch (Exception ex) {
        error(ex.getMessage(), ele);
        return null;
      }
    }
    String[] aliasesArray = StringUtils.toStringArray(aliases);
    // 返回BeanDefinitionHolder
    return new BeanDefinitionHolder(beanDefinition, beanName, aliasesArray);
  }

  return null;
}

```

来看看parseBeanDefinitionElement方法是怎么创建BeanDefinition的

// BeanDefinitionParserDelegate.java 500

```
public AbstractBeanDefinition parseBeanDefinitionElement(
      Element ele, String beanName, @Nullable BeanDefinition containingBean) {

   this.parseState.push(new BeanEntry(beanName));

   String className = null;
   // 解析class
   if (ele.hasAttribute(CLASS_ATTRIBUTE)) {
      className = ele.getAttribute(CLASS_ATTRIBUTE).trim();
   }
   String parent = null;
   //解析parent
   if (ele.hasAttribute(PARENT_ATTRIBUTE)) {
      parent = ele.getAttribute(PARENT_ATTRIBUTE);
   }

   try {
      AbstractBeanDefinition bd = createBeanDefinition(className, parent);

      parseBeanDefinitionAttributes(ele, beanName, containingBean, bd);
      bd.setDescription(DomUtils.getChildElementValueByTagName(ele, DESCRIPTION_ELEMENT));
      // 解析 <meta />
      parseMetaElements(ele, bd);      
      // 解析 <lookup-method />
      parseLookupOverrideSubElements(ele, bd.getMethodOverrides());
      // 解析 <replaced-method />
      parseReplacedMethodSubElements(ele, bd.getMethodOverrides());

			// 解析 <constructor-arg />
      parseConstructorArgElements(ele, bd);
      // 解析 <property />
      parsePropertyElements(ele, bd);
      // 解析 <qualifier />
      parseQualifierElements(ele, bd);

      bd.setResource(this.readerContext.getResource());
      bd.setSource(extractSource(ele));

      return bd;
   }
   catch (ClassNotFoundException ex) {
      error("Bean class [" + className + "] not found", ele, ex);
   }
   catch (NoClassDefFoundError err) {
      error("Class that bean class [" + className + "] depends on not found", ele, err);
   }
   catch (Throwable ex) {
      error("Unexpected failure during bean definition parsing", ele, ex);
   }
   finally {
      this.parseState.pop();
   }

   return null;
}
```

此时一个BeanDefinitionHolder就创建完成了，回到需要BeandefinitionHolder的地方

// DefaultBeanDefinitionDocumentReader.java:319

```java
protected void processBeanDefinition(Element ele, BeanDefinitionParserDelegate delegate) {
   BeanDefinitionHolder bdHolder = delegate.parseBeanDefinitionElement(ele);
   if (bdHolder != null) {
     // 解析自定义属性，不展开
      bdHolder = delegate.decorateBeanDefinitionIfRequired(ele, bdHolder);
      try {
         // 注册Bean
         BeanDefinitionReaderUtils.registerBeanDefinition(bdHolder, getReaderContext().getRegistry());
      }
      catch (BeanDefinitionStoreException ex) {
         getReaderContext().error("Failed to register bean definition with name '" +
               bdHolder.getBeanName() + "'", ele, ex);
      }
      // 发送注册事件，本文不展开
      getReaderContext().fireComponentRegistered(new BeanComponentDefinition(bdHolder));
   }
}
```

此时得到的BeanDefinitionHolder包含三部分：BeanDefinition、beanName、aliases

```java
public class BeanDefinitionHolder implements BeanMetadataElement {

  private final BeanDefinition beanDefinition;

  private final String beanName;

  private final String[] aliases;
...
```

#### 注册Bean

// BeanDefinitionReaderUtils.java:144

```java
public static void registerBeanDefinition(
      BeanDefinitionHolder definitionHolder, BeanDefinitionRegistry registry)
      throws BeanDefinitionStoreException {

   // Register bean definition under primary name.
   String beanName = definitionHolder.getBeanName();
  //注册Bean
   registry.registerBeanDefinition(beanName, definitionHolder.getBeanDefinition());

   // 如果有别名，也都注册一遍
   String[] aliases = definitionHolder.getAliases();
   if (aliases != null) {
      for (String alias : aliases) {
        //保存一个alias->beanName的map，找的时候，先从alias到beanName，然后去查找
         registry.registerAlias(beanName, alias);
      }
   }
}
```

// DefaultListableBeanFactory.java:788

```java
public void registerBeanDefinition(String beanName, BeanDefinition beanDefinition)
  throws BeanDefinitionStoreException {

  Assert.hasText(beanName, "Bean name must not be empty");
  Assert.notNull(beanDefinition, "BeanDefinition must not be null");

  //验证beanDefinition的有效性
  if (beanDefinition instanceof AbstractBeanDefinition) {
    try {
      ((AbstractBeanDefinition) beanDefinition).validate();
    }
    catch (BeanDefinitionValidationException ex) {
      throw new BeanDefinitionStoreException(beanDefinition.getResourceDescription(), beanName,
                                             "Validation of bean definition failed", ex);
    }
  }

  // 是否允许覆盖
  BeanDefinition existingDefinition = this.beanDefinitionMap.get(beanName);
  if (existingDefinition != null) {
    //不允许覆盖的情况，抛异常
    if (!isAllowBeanDefinitionOverriding()) {
      throw new BeanDefinitionStoreException...
    }
    
    else if (existingDefinition.getRole() < beanDefinition.getRole()) {
      // 用框架生成的beandefinition覆盖用户的beanDefinition
      // log()
    }
    else if (!beanDefinition.equals(existingDefinition)) {
      //用新bean替换旧bean
    }
    else {
      // 用同等bean覆盖旧bean，这里同等指的是equals方法返回为true的bean
      }
    }
  //覆盖
    this.beanDefinitionMap.put(beanName, beanDefinition);
  }
  else {
    //判断是否有bean已经在初始化了
    if (hasBeanCreationStarted()) {
      
      synchronized (this.beanDefinitionMap) {
        this.beanDefinitionMap.put(beanName, beanDefinition);
        List<String> updatedDefinitions = new ArrayList<>(this.beanDefinitionNames.size() + 1);
        updatedDefinitions.addAll(this.beanDefinitionNames);
        updatedDefinitions.add(beanName);
        this.beanDefinitionNames = updatedDefinitions;
        if (this.manualSingletonNames.contains(beanName)) {
          Set<String> updatedSingletons = new LinkedHashSet<>(this.manualSingletonNames);
          updatedSingletons.remove(beanName);
          this.manualSingletonNames = updatedSingletons;
        }
      }
    }
    else {
      // Still in startup registration phase
      //放到beanDefinitionMap里面，beanName->beanDefinition的map
      this.beanDefinitionMap.put(beanName, beanDefinition);
      //按照bean初始化顺序放所有的beanName
      this.beanDefinitionNames.add(beanName);
      //到这个分支的肯定不需要手动注册了，那么就从手动初始化的map中移除
      //有些系统自带的bean需要spring手动注册，比如"environment"、"systemProperties"
      // 手动注册需要调用registerSingleton(String beanName, Object singletonObject)方法
      this.manualSingletonNames.remove(beanName);
    }
    this.frozenBeanDefinitionNames = null;
  }

  if (existingDefinition != null || containsSingleton(beanName)) {
    resetBeanDefinition(beanName);
  }
}
```

总结一下，到目前为止，已经初始化了BeanFactory，`<bean/>`配置也转化成了 一个个beanDefinition，注册了BeanDefinition到注册中心，发送了注册事件。

### BeanFactory实例化完成后

到这里，我们回到refresh方法

```java
//AbstractApplicationContext 516
	public void refresh() throws BeansException, IllegalStateException {
		synchronized (this.startupShutdownMonitor) {
      //记录开始时间,设置状态为开始创建,关闭状态设为false
			prepareRefresh();

      // 最重要的步骤,这里之后就获取到了BeanFactory了
      // 把所有bean的信息都提取出来，注册到beanFactory里面，这里的bean还没有初始化
      // 提取出来的信息是beanName-> beanDefination的map
      
      //！！！注意！！！，此时已经拿到了BeanFactory了
			ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();

      //设置BeanFactory的类加载器，手动注册特殊的bean，跳进去继续看
			prepareBeanFactory(beanFactory);

			try {
        //BeanFactoryPostProcessor的处理
        //点进去看到方法是protected的空函数，主要是给子类继承来处理BeanFactory的
				postProcessBeanFactory(beanFactory);

        //调用 BeanFactoryPostProcessor 各个实现类的 postProcessBeanFactory(factory) 方法
				invokeBeanFactoryPostProcessors(beanFactory);

        //注册BeanPostProcessor
				registerBeanPostProcessors(beanFactory);

				// 初始化MessageSource，用于国际化，不涉及就不说了
				initMessageSource();

				// 初始化ApplicationContext的时间广播器，不展开说了
				initApplicationEventMulticaster();

				// 从方法名能看出来，钩子方法
        // 子类可以在这里初始化一些特殊的Bean(初始化Singleton Beans之前)
				onRefresh();

				// 注册时间监听器,不展开
				registerListeners();

				// 实例化所有非lazy-init的singleton beans
				finishBeanFactoryInitialization(beanFactory);

				// 广播事件，ApplicaitonContext初始化完成
				finishRefresh();
			}

			catch (BeansException ex) {
				if (logger.isWarnEnabled()) {
					logger.warn("Exception encountered during context initialization - " +
							"cancelling refresh attempt: " + ex);
				}

				// 销毁已经创建的singleton beans，以免资源占用
				destroyBeans();

				// Reset 'active' flag.
				cancelRefresh(ex);

				// Propagate exception to caller.
				throw ex;
			}

			finally {
				// Reset common introspection caches in Spring's core, since we
				// might not ever need metadata for singleton beans anymore...
        //释放bean描述器的缓存
				resetCommonCaches();
			}
		}
	}


```

我们看看prepareBeanFactory()方法

// AbstractApplicationContext.java:634

```java
protected void prepareBeanFactory(ConfigurableListableBeanFactory beanFactory) {
  // 设置BeanFactory的类加载器，这里设置为当前ApplicationContext的类加载器
  beanFactory.setBeanClassLoader(getClassLoader());
  // 设置 BeanExpressionResolver
  beanFactory.setBeanExpressionResolver(new StandardBeanExpressionResolver(beanFactory.getBeanClassLoader()));
  beanFactory.addPropertyEditorRegistrar(new ResourceEditorRegistrar(this, getEnvironment()));

  // 添加BeanPostProcessor，这里加的是ApplicationContextAware的Processor。
   // 注意：它不仅仅回调 ApplicationContextAware，
   //   还会负责回调 EnvironmentAware、ResourceLoaderAware 等，看下源码就清楚了
  beanFactory.addBeanPostProcessor(new ApplicationContextAwareProcessor(this));
  
  //如果bean依赖下面几个接口的实现类，会在这里忽略掉，用其他方式来处理这些依赖
  beanFactory.ignoreDependencyInterface(EnvironmentAware.class);
  beanFactory.ignoreDependencyInterface(EmbeddedValueResolverAware.class);
  beanFactory.ignoreDependencyInterface(ResourceLoaderAware.class);
  beanFactory.ignoreDependencyInterface(ApplicationEventPublisherAware.class);
  beanFactory.ignoreDependencyInterface(MessageSourceAware.class);
  beanFactory.ignoreDependencyInterface(ApplicationContextAware.class);

  // 几个特殊bean的赋值
  beanFactory.registerResolvableDependency(BeanFactory.class, beanFactory);
  beanFactory.registerResolvableDependency(ResourceLoader.class, this);
  beanFactory.registerResolvableDependency(ApplicationEventPublisher.class, this);
  beanFactory.registerResolvableDependency(ApplicationContext.class, this);

   // 这个 BeanPostProcessor 处理：如果是 ApplicationListener 的子类，
   // 那么将其添加到 listener 列表中，可以理解成：注册 事件监听器
   beanFactory.addBeanPostProcessor(new ApplicationListenerDetector(this));

  // LoadTimeWeaver是AspectJ当中的运行器织入，这里不深究
  if (beanFactory.containsBean(LOAD_TIME_WEAVER_BEAN_NAME)) {
    beanFactory.addBeanPostProcessor(new LoadTimeWeaverAwareProcessor(beanFactory));
    // Set a temporary ClassLoader for type matching.
    beanFactory.setTempClassLoader(new ContextTypeMatchClassLoader(beanFactory.getBeanClassLoader()));
  }

  // Spring注册的默认的几个bean，包括ENVIRONMENT，SYSTEM_PROPERTIES，SYSTEM_ENVIRONMENT
  if (!beanFactory.containsLocalBean(ENVIRONMENT_BEAN_NAME)) {
    beanFactory.registerSingleton(ENVIRONMENT_BEAN_NAME, getEnvironment());
  }
  if (!beanFactory.containsLocalBean(SYSTEM_PROPERTIES_BEAN_NAME)) {
    beanFactory.registerSingleton(SYSTEM_PROPERTIES_BEAN_NAME, getEnvironment().getSystemProperties());
  }
  if (!beanFactory.containsLocalBean(SYSTEM_ENVIRONMENT_BEAN_NAME)) {
    beanFactory.registerSingleton(SYSTEM_ENVIRONMENT_BEAN_NAME, getEnvironment().getSystemEnvironment());
  }
}

```

### 初始化所有的 singleton beans

回到refresh函数中，上面的一系列处理postProcessor和awareProcessor的内容处理完之后，就到了				finishBeanFactoryInitialization(beanFactory)方法，这个方法就是真正的实例化singleton bean了

// AbstractApplicationContext.java:841

```java
	protected void finishBeanFactoryInitialization(ConfigurableListableBeanFactory beanFactory) {
		// 初始化名字为conversionService的Bean，用于convert前端传输的内容
		if (beanFactory.containsBean(CONVERSION_SERVICE_BEAN_NAME) &&
				beanFactory.isTypeMatch(CONVERSION_SERVICE_BEAN_NAME, ConversionService.class)) {
			beanFactory.setConversionService(
					beanFactory.getBean(CONVERSION_SERVICE_BEAN_NAME, ConversionService.class));
		}

		// Register a default embedded value resolver if no bean post-processor
		// (such as a PropertyPlaceholderConfigurer bean) registered any before:
		// at this point, primarily for resolution in annotation attribute values.
		if (!beanFactory.hasEmbeddedValueResolver()) {
			beanFactory.addEmbeddedValueResolver(strVal -> getEnvironment().resolvePlaceholders(strVal));
		}

    //与loadTimeWaver相关的内容，跳过
		String[] weaverAwareNames = beanFactory.getBeanNamesForType(LoadTimeWeaverAware.class, false, false);
		for (String weaverAwareName : weaverAwareNames) {
			getBean(weaverAwareName);
		}

		// Stop using the temporary ClassLoader for type matching.
		beanFactory.setTempClassLoader(null);

		// spring准备初始化bean了，要进制bean定义解析，加载，注册
		beanFactory.freezeConfiguration();

		// 开始注册
		beanFactory.preInstantiateSingletons();
	}

```

继续preInstantiateSingletons函数，又回到了DefaultListableBeanFactory方法

//DefaultListableBeanFactory 726

```java
public void preInstantiateSingletons() throws BeansException {
  if (logger.isDebugEnabled()) {
    logger.debug("Pre-instantiating singletons in " + this);
  }

  // beanDefinitionNames保存了所有需要注册的beanNames
  List<String> beanNames = new ArrayList<>(this.beanDefinitionNames);

  // 触发所有非懒加载的singleton beans的初始化操作
  for (String beanName : beanNames) {
    // 处理 FactoryBean
    RootBeanDefinition bd = getMergedLocalBeanDefinition(beanName);
    if (!bd.isAbstract() && bd.isSingleton() && !bd.isLazyInit()) {
      // 处理FactoryBean
      if (isFactoryBean(beanName)) {
        // FactoryBean 的话，在 beanName 前面加上 ‘&’ 符号。再调用 getBean，getBean 方法别急
        Object bean = getBean(FACTORY_BEAN_PREFIX + beanName);
        if (bean instanceof FactoryBean) {
          final FactoryBean<?> factory = (FactoryBean<?>) bean;
          boolean isEagerInit;
          if (System.getSecurityManager() != null && factory instanceof SmartFactoryBean) {
            isEagerInit = AccessController.doPrivileged((PrivilegedAction<Boolean>)
                                                        ((SmartFactoryBean<?>) factory)::isEagerInit,
                                                        getAccessControlContext());
          }
          else {
            // 判断当前 FactoryBean 是否是 SmartFactoryBean 的实现，跳过
            isEagerInit = (factory instanceof SmartFactoryBean &&
                           ((SmartFactoryBean<?>) factory).isEagerInit());
          }
          if (isEagerInit) {
            getBean(beanName);
          }
        }
      }
      else {
        // 对于普通的 Bean，只要调用 getBean(beanName) 这个方法就可以进行初始化了
        getBean(beanName);
      }
    }
  }

  // 非懒加载的singleton beans已经完成初始化了
  // 如果bean实现了SmartInitializingSingleton接口，在这里回调
  for (String beanName : beanNames) {
    Object singletonInstance = getSingleton(beanName);
    if (singletonInstance instanceof SmartInitializingSingleton) {
      final SmartInitializingSingleton smartSingleton = (SmartInitializingSingleton) singletonInstance;
      if (System.getSecurityManager() != null) {
        AccessController.doPrivileged((PrivilegedAction<Object>) () -> {
          smartSingleton.afterSingletonsInstantiated();
          return null;
        }, getAccessControlContext());
      }
      else {
        smartSingleton.afterSingletonsInstantiated();
      }
    }
  }
}

```

继续跳入上面的getBean方法

#### getBean方法

```java
// AbstractBeanFactory 198

@Override
public Object getBean(String name) throws BeansException {
  return doGetBean(name, null, null, false);
}

//AbstractBeanFactory 239
// 这个方法是从BanFactory返回bean实例的方法，这里就是如果已经出师话，直接返回，如果没有初始化，则开始初始化
protected <T> T doGetBean(final String name, @Nullable final Class<T> requiredType,
                          @Nullable final Object[] args, boolean typeCheckOnly) throws BeansException {

  final String beanName = transformedBeanName(name);
  
  //返回值
  Object bean;

  // 检查是否已经初始化过了.
  Object sharedInstance = getSingleton(beanName);
  // 如果args不为空，则方法是创建bean，为空是获取bean
  // 进入条件是已经创建过，且只是来获取bean的
  if (sharedInstance != null && args == null) {
    if (logger.isDebugEnabled()) {
      if (isSingletonCurrentlyInCreation(beanName)) {
        logger.debug("..")      
      else {
        logger.debug("Returning cached instance of singleton bean '" + beanName + "'");
      }
    }
      // 如果是普通bean，直接返回sharedInstance
      // 如果是FactoryBean，则返回它创建的实例对象
    bean = getObjectForBeanInstance(sharedInstance, name, beanName, null);
  }

  else {
    //这个分支是用来创建bean的
    //是否正在创建
    if (isPrototypeCurrentlyInCreation(beanName)) {
      throw new BeanCurrentlyInCreationException(beanName);
    }

    // 检查BeanFactory里面是否包含对应的BeanDefinition
    BeanFactory parentBeanFactory = getParentBeanFactory();
    if (parentBeanFactory != null && !containsBeanDefinition(beanName)) {
      //检查父容器是否有对应的bean
      String nameToLookup = originalBeanName(name);
      if (parentBeanFactory instanceof AbstractBeanFactory) {
        return ((AbstractBeanFactory) parentBeanFactory).doGetBean(
          nameToLookup, requiredType, args, typeCheckOnly);
      }
      else if (args != null) {
  			// 返回父容器查询结果
        return (T) parentBeanFactory.getBean(nameToLookup, args);
      }
      else {
        // 没有args参数，直接获取bean
        return parentBeanFactory.getBean(nameToLookup, requiredType);
      }
    }

    // typeCheckOnly在创建时是false，将beanName放入一个alreadyCreated的set中
    if (!typeCheckOnly) {
      markBeanAsCreated(beanName);
    }

    //至此开始创建bean
    //singleton类型的bean容器中还不存在
    // prototype的bean，本来就要创建一个
    try {
      final RootBeanDefinition mbd = getMergedLocalBeanDefinition(beanName);
      // 检查rootBeanDefinition是否合法
      checkMergedBeanDefinition(mbd, beanName, args);

      // 先初始化bean的依赖bean，是配置中的denpend-on字段
      String[] dependsOn = mbd.getDependsOn();
      if (dependsOn != null) {
        for (String dep : dependsOn) {
          // 检查以免循环依赖
          if (isDependent(beanName, dep)) {
            throw new BeanCreationException(...)
          }
          //注册依赖关系
          registerDependentBean(dep, beanName);
          try {
            //初始化依赖项
            getBean(dep);
          }
          catch (NoSuchBeanDefinitionException ex) {
            throw new BeanCreationException(..)
          }
        }
      }

      // 创建singleton实例
      if (mbd.isSingleton()) {
        sharedInstance = getSingleton(beanName, () -> {
          try {
            // 创建bean，继续跳入
            return createBean(beanName, mbd, args);
          }
          catch (BeansException ex) {           
            destroySingleton(beanName);
            throw ex;
          }
        });
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
      }

      // 创建prototype实例
      else if (mbd.isPrototype()) {
        // It's a prototype -> create a new instance.
        Object prototypeInstance = null;
        try {
          beforePrototypeCreation(beanName);
          prototypeInstance = createBean(beanName, mbd, args);
        }
        finally {
          afterPrototypeCreation(beanName);
        }
        bean = getObjectForBeanInstance(prototypeInstance, name, beanName, mbd);
      }

      // 不是singleton也不是prototype，委托给对应的类创建
      else {
        String scopeName = mbd.getScope();
        final Scope scope = this.scopes.get(scopeName);
        if (scope == null) {
          throw new IllegalStateException("No Scope registered for scope name '" + scopeName + "'");
        }
        try {
          Object scopedInstance = scope.get(beanName, () -> {
            beforePrototypeCreation(beanName);
            try {
              return createBean(beanName, mbd, args);
            }
            finally {
              afterPrototypeCreation(beanName);
            }
          });
          bean = getObjectForBeanInstance(scopedInstance, name, beanName, mbd);
        }
        catch (IllegalStateException ex) {
          throw new BeanCreationException(...);
        }
      }
    }
    catch (BeansException ex) {
      cleanupAfterBeanCreationFailure(beanName);
      throw ex;
    }
  }

  // 检查创建的bean和需求的bean是否一致，对就返回，不对就抛异常
  if (requiredType != null && !requiredType.isInstance(bean)) {
    try {
      T convertedBean = getTypeConverter().convertIfNecessary(bean, requiredType);
      if (convertedBean == null) {
        throw new BeanNotOfRequiredTypeException(name, requiredType, bean.getClass());
      }
      return convertedBean;
    }
    catch (TypeMismatchException ex) {
      if (logger.isDebugEnabled()) {
        logger.debug("Failed to convert bean '" + name + "' to required type '" +
                     ClassUtils.getQualifiedName(requiredType) + "'", ex);
      }
      throw new BeanNotOfRequiredTypeException(name, requiredType, bean.getClass());
    }
  }
  return (T) bean;
}
```

继续看createBean方法，参数包括三个如下：

```java
protected abstract Object createBean(String beanName, RootBeanDefinition mbd, Object[] args) throws BeanCreationException;
```

从上面的getBean方法，args参数是构造函数的参数，但在这个函数调用的时候为空。

继续看具体的createBean方法

```java
protected Object createBean(String beanName, RootBeanDefinition mbd, @Nullable Object[] args)
  throws BeanCreationException {

  if (logger.isDebugEnabled()) {
    logger.debug("Creating instance of bean '" + beanName + "'");
  }
  RootBeanDefinition mbdToUse = mbd;

  // 确保beanDefinition中的class被加载
  Class<?> resolvedClass = resolveBeanClass(mbd, beanName);
  if (resolvedClass != null && !mbd.hasBeanClass() && mbd.getBeanClassName() != null) {
    mbdToUse = new RootBeanDefinition(mbd);
    mbdToUse.setBeanClass(resolvedClass);
  }

  // 准备方法覆写
  // 主要和bean的lookup-method和replace-method相关
  try {
    mbdToUse.prepareMethodOverrides();
  }
  catch (BeanDefinitionValidationException ex) {
    throw new BeanDefinitionStoreException(..."Validation of method overrides failed", ex);
  }

  try {
    // 让InstantiationAwareBeanPostProcessor 在这里有机会返回代理类型
    Object bean = resolveBeforeInstantiation(beanName, mbdToUse);
    if (bean != null) {
      return bean;
    }
  }
  catch (Throwable ex) {
    throw new BeanCreationException(mbdToUse.getResourceDescription(), beanName,
                                    "BeanPostProcessor before instantiation of bean failed", ex);
  }

  try {
    // 创建bean，继续往里跳
    Object beanInstance = doCreateBean(beanName, mbdToUse, args);
    if (logger.isDebugEnabled()) {
      logger.debug("Finished creating instance of bean '" + beanName + "'");
    }
    return beanInstance;
  }
  catch (BeanCreationException | ImplicitlyAppearedSingletonException ex) {
    throw ex;
  }
  catch (Throwable ex) {
    throw new BeanCreationException(..."Unexpected exception during bean creation", ex);
  }
}
```

#### 创建 Bean

继续看doCreateBean方法

```java
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final @Nullable Object[] args)
  throws BeanCreationException {

  // Instantiate the bean.
  BeanWrapper instanceWrapper = null;
  if (mbd.isSingleton()) {
    instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
  }
  if (instanceWrapper == null) {
    // 证明不是factoryBean，直接实例化，继续往里跳
    instanceWrapper = createBeanInstance(beanName, mbd, args);
  }
  // bean实例
  final Object bean = instanceWrapper.getWrappedInstance();
  // bean类型
  Class<?> beanType = instanceWrapper.getWrappedClass();
  if (beanType != NullBean.class) {
    mbd.resolvedTargetType = beanType;
  }

  // MergeBeanDefinition的postProcessor，这里不展开
  synchronized (mbd.postProcessingLock) {
    if (!mbd.postProcessed) {
      try {
        applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
      }
      catch (Throwable ex) {
        throw new BeanCreationException(mbd.getResourceDescription(), beanName,
                                        "Post-processing of merged bean definition failed", ex);
      }
      mbd.postProcessed = true;
    }
  }

  // Eagerly cache singletons to be able to resolve circular references
  // even when triggered by lifecycle interfaces like BeanFactoryAware.
  // 下面这块代码为了解决循环依赖问题
  boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
                                    isSingletonCurrentlyInCreation(beanName));
  if (earlySingletonExposure) {
    if (logger.isDebugEnabled()) {
      logger.debug("Eagerly caching bean '" + beanName +
                   "' to allow for resolving potential circular references");
    }
    addSingletonFactory(beanName, () -> getEarlyBeanReference(beanName, mbd, bean));
  }

  // Initialize the bean instance.
  Object exposedObject = bean;
  try {
    // 填充bean，前面只是实例化了bean，参数还没有填充进去
    populateBean(beanName, mbd, instanceWrapper);
    // 处理init-method，initializingBean接口和BeanPostProcessor接口
    exposedObject = initializeBean(beanName, exposedObject, mbd);
  }
  catch (Throwable ex) {
    if (ex instanceof BeanCreationException && beanName.equals(((BeanCreationException) ex).getBeanName())) {
      throw (BeanCreationException) ex;
    }
    else {
      throw new BeanCreationException(
        mbd.getResourceDescription(), beanName, "Initialization of bean failed", ex);
    }
  }

  if (earlySingletonExposure) {
    Object earlySingletonReference = getSingleton(beanName, false);
    if (earlySingletonReference != null) {
      if (exposedObject == bean) {
        exposedObject = earlySingletonReference;
      }
      else if (!this.allowRawInjectionDespiteWrapping && hasDependentBean(beanName)) {
        String[] dependentBeans = getDependentBeans(beanName);
        Set<String> actualDependentBeans = new LinkedHashSet<>(dependentBeans.length);
        for (String dependentBean : dependentBeans) {
          if (!removeSingletonIfCreatedForTypeCheckOnly(dependentBean)) {
            actualDependentBeans.add(dependentBean);
          }
        }
        if (!actualDependentBeans.isEmpty()) {
          throw new BeanCurrentlyInCreationException(beanName,,...)                                                 
        }
      }
    }
  }

  // Register bean as disposable.
  try {
    registerDisposableBeanIfNecessary(beanName, bean, mbd);
  }
  catch (BeanDefinitionValidationException ex) {
    throw new BeanCreationException(
      mbd.getResourceDescription(), beanName, "Invalid destruction signature", ex);
  }

  return exposedObject;
}
```

doCreateBean当中有两个重要方法`createBeanInstance`、`populateBean`

#### 创建bean实例

继续看`createBeanInstance`方法

```java
protected BeanWrapper createBeanInstance(String beanName, RootBeanDefinition mbd, @Nullable Object[] args) {
   // 确保已经加载了这个class
   Class<?> beanClass = resolveBeanClass(mbd, beanName);

  //检查类是public还是private的
   if (beanClass != null && !Modifier.isPublic(beanClass.getModifiers()) && !mbd.isNonPublicAccessAllowed()) {
      throw new BeanCreationException(mbd.getResourceDescription(), beanName,
            "Bean class isn't public, and non-public access not allowed: " + beanClass.getName());
   }

   Supplier<?> instanceSupplier = mbd.getInstanceSupplier();
   if (instanceSupplier != null) {
      return obtainFromSupplier(instanceSupplier, beanName);
   }

   if (mbd.getFactoryMethodName() != null)  {
      // 采用工厂方法实例化
      return instantiateUsingFactoryMethod(beanName, mbd, args);
   }

   // 创建同一个bean，比如第二次创建prototype bean，
  // 可以从第一次创建的信息知道，采用无参构造函数，还是构造函数依赖注入来实例化
   boolean resolved = false;
   boolean autowireNecessary = false;
   if (args == null) {
      synchronized (mbd.constructorArgumentLock) {
         if (mbd.resolvedConstructorOrFactoryMethod != null) {
            resolved = true;
            autowireNecessary = mbd.constructorArgumentsResolved;
         }
      }
   }
   if (resolved) {
      if (autowireNecessary) {
        //构造函数依赖注入
         return autowireConstructor(beanName, mbd, null, null);
      }
      else {
        //无参构造函数
         return instantiateBean(beanName, mbd);
      }
   }

   // 是否使用有参构造函数
   Constructor<?>[] ctors = determineConstructorsFromBeanPostProcessors(beanClass, beanName);
   if (ctors != null ||
         mbd.getResolvedAutowireMode() == RootBeanDefinition.AUTOWIRE_CONSTRUCTOR ||
         mbd.hasConstructorArgumentValues() || !ObjectUtils.isEmpty(args))  {
      return autowireConstructor(beanName, mbd, ctors, args);
   }

   // 调用无参构造函数
   return instantiateBean(beanName, mbd);
}
```

选择无参构造函数，跳入

```java
// AbstractAutowireCapableBeanFactory.java:1211
protected BeanWrapper instantiateBean(final String beanName, final RootBeanDefinition mbd) {
   try {
      Object beanInstance;
      final BeanFactory parent = this;
      if (System.getSecurityManager() != null) {
         beanInstance = AccessController.doPrivileged((PrivilegedAction<Object>) () ->
               getInstantiationStrategy().instantiate(mbd, beanName, parent),
               getAccessControlContext());
      }
      else {
        // 实例化
         beanInstance = getInstantiationStrategy().instantiate(mbd, beanName, parent);
      }
     //包装成beanWrapper返回
      BeanWrapper bw = new BeanWrapperImpl(beanInstance);
      initBeanWrapper(bw);
      return bw;
   }
   catch (Throwable ex) {
      throw new BeanCreationException(
            mbd.getResourceDescription(), beanName, "Instantiation of bean failed", ex);
   }
}
```

继续看实例化的函数

// SimpleInstantiationStrategy.java:61

```java
	public Object instantiate(RootBeanDefinition bd, @Nullable String beanName, BeanFactory owner) {
		// 如果不允许方法覆写，则使用java反射进行实例化，否则使用CGLIB进行实例化
		if (!bd.hasMethodOverrides()) {
			Constructor<?> constructorToUse;
			synchronized (bd.constructorArgumentLock) {
				constructorToUse = (Constructor<?>) bd.resolvedConstructorOrFactoryMethod;
				if (constructorToUse == null) {
					final Class<?> clazz = bd.getBeanClass();
					if (clazz.isInterface()) {
						throw new BeanInstantiationException(clazz, "Specified class is an interface");
					}
					try {
						if (System.getSecurityManager() != null) {
							constructorToUse = AccessController.doPrivileged(
									(PrivilegedExceptionAction<Constructor<?>>) clazz::getDeclaredConstructor);
						}
						else {
							constructorToUse =	clazz.getDeclaredConstructor();
						}
						bd.resolvedConstructorOrFactoryMethod = constructorToUse;
					}
					catch (Throwable ex) {
						throw new BeanInstantiationException(clazz, "No default constructor found", ex);
					}
				}
			}
      // 用构造方法实例化
			return BeanUtils.instantiateClass(constructorToUse);
		}
		else {
			//存在方法覆写，使用CGLIB进行实例化，通过CGLIB生成子类
			return instantiateWithMethodInjection(bd, beanName, owner);
		}
	}

```

#### bean属性注入

看populateBean方法

// AbstractAutowireCapableBeanFactory.java:1277

```java
protected void populateBean(String beanName, RootBeanDefinition mbd, @Nullable BeanWrapper bw) {
   if (bw == null) {
      if (mbd.hasPropertyValues()) {
         throw new BeanCreationException(
               mbd.getResourceDescription(), beanName, "Cannot apply property values to null instance");
      }
      else {
         // Skip property population phase for null instance.
         return;
      }
   }

   // bean实例化完成，但属性还没有值
  // InstantiationAwareBeanPostProcessor的实现类对bean修改
   boolean continueWithPropertyPopulation = true;

   if (!mbd.isSynthetic() && hasInstantiationAwareBeanPostProcessors()) {
      for (BeanPostProcessor bp : getBeanPostProcessors()) {
         if (bp instanceof InstantiationAwareBeanPostProcessor) {
            InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
           // 如果返回false，代表不需要对属性设置值，不在对其他的beanPostProcessor处理
            if (!ibp.postProcessAfterInstantiation(bw.getWrappedInstance(), beanName)) {
               continueWithPropertyPopulation = false;
               break;
            }
         }
      }
   }

   if (!continueWithPropertyPopulation) {
      return;
   }

   PropertyValues pvs = (mbd.hasPropertyValues() ? mbd.getPropertyValues() : null);

   if (mbd.getResolvedAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_NAME ||
         mbd.getResolvedAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_TYPE) {
      MutablePropertyValues newPvs = new MutablePropertyValues(pvs);

      // 通过名字找到属性值，如果是bean依赖，先初始化bean，记录依赖关系
      if (mbd.getResolvedAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_NAME) {
         autowireByName(beanName, mbd, bw, newPvs);
      }

      // 通过type装配
      if (mbd.getResolvedAutowireMode() == RootBeanDefinition.AUTOWIRE_BY_TYPE) {
         autowireByType(beanName, mbd, bw, newPvs);
      }

      pvs = newPvs;
   }

   boolean hasInstAwareBpps = hasInstantiationAwareBeanPostProcessors();
   boolean needsDepCheck = (mbd.getDependencyCheck() != RootBeanDefinition.DEPENDENCY_CHECK_NONE);

   if (hasInstAwareBpps || needsDepCheck) {
      if (pvs == null) {
         pvs = mbd.getPropertyValues();
      }
      PropertyDescriptor[] filteredPds = filterPropertyDescriptorsForDependencyCheck(bw, mbd.allowCaching);
      if (hasInstAwareBpps) {
         for (BeanPostProcessor bp : getBeanPostProcessors()) {
            if (bp instanceof InstantiationAwareBeanPostProcessor) {
               InstantiationAwareBeanPostProcessor ibp = (InstantiationAwareBeanPostProcessor) bp;
              //对采用@Autowired和@Value注解的依赖进行设值
               pvs = ibp.postProcessPropertyValues(pvs, filteredPds, bw.getWrappedInstance(), beanName);
               if (pvs == null) {
                  return;
               }
            }
         }
      }
      if (needsDepCheck) {
         checkDependencies(beanName, mbd, filteredPds, pvs);
      }
   }

   if (pvs != null) {
     //设置bean实例的属性值
      applyPropertyValues(beanName, mbd, bw, pvs);
   }
}
```

##### initializeBean

populateBean后面还有一个initializeBean方法，我们进入initializeBean方法

// AbstractAutowireCapableBeanFactory.java:1678

这个方法里面是各种回调

```java
protected Object initializeBean(final String beanName, final Object bean, RootBeanDefinition mbd) {
   if (System.getSecurityManager() != null) {
      AccessController.doPrivileged(new PrivilegedAction<Object>() {
         @Override
         public Object run() {
            invokeAwareMethods(beanName, bean);
            return null;
         }
      }, getAccessControlContext());
   }
   else {
      // 如果 bean 实现了 BeanNameAware、BeanClassLoaderAware 或 BeanFactoryAware 接口，回调
      invokeAwareMethods(beanName, bean);
   }

   Object wrappedBean = bean;
   if (mbd == null || !mbd.isSynthetic()) {
      // BeanPostProcessor 的 postProcessBeforeInitialization 回调
      wrappedBean = applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName);
   }

   try {
      // 处理 bean 中定义的 init-method，
      // 或者如果 bean 实现了 InitializingBean 接口，调用 afterPropertiesSet() 方法
      invokeInitMethods(beanName, wrappedBean, mbd);
   }
   catch (Throwable ex) {
      throw new BeanCreationException(
            (mbd != null ? mbd.getResourceDescription() : null),
            beanName, "Invocation of init method failed", ex);
   }

   if (mbd == null || !mbd.isSynthetic()) {
      // BeanPostProcessor 的 postProcessAfterInitialization 回调
      wrappedBean = applyBeanPostProcessorsAfterInitialization(wrappedBean, beanName);
   }
   return wrappedBean;
}
```










#### lookup-method

我们来看一下 Spring Reference 中提供的一个例子：

```java
@Component
public class MySingletonBean {

    public void showMessage(){
        MyPrototypeBean bean = getPrototypeBean();
        //each time getPrototypeBean() call
        //will return new instance
    }

    public MyPrototypeBean getPrototypeBean(){
        //spring will override this method
        return null;
    }
}
```

xml 配置 ：

```xml
<!-- a stateful bean deployed as a prototype (non-singleton) -->
<bean id="myCommand" class="fiona.apple.AsyncCommand" scope="prototype">
    <!-- inject dependencies here as required -->
</bean>

<!-- commandProcessor uses statefulCommandHelper -->
<bean id="MySingletonBean" class="com.drawon.MySingletonBean">
    <lookup-method name="getPrototypeBean" bean="MyPrototypeBean"/>
</bean>
```

虽然返回的是getPrototypeBean方法返回值是null，但因为配置了lookup-method，因此最终返回的结果也是MyPrototypeBean实例

也可以用注解的方式进行：

```java
@Component
public class MySingletonBean {

    public void showMessage(){
        MyPrototypeBean bean = getPrototypeBean();
        //each time getPrototypeBean() call
        //will return new instance
    }

    @Lookup
    public MyPrototypeBean getPrototypeBean(){
        //spring will override this method
        return null;
    }
}
```

#### replaced-method

记住它的功能，就是替换掉 bean 中的一些方法。用一个实现org.springframework.beans.factory.support.MethodReplacer的类，实现其中的`reimplement`方法，然后配置好，就可以覆盖某个类当中某个方法的返回值

```java
public class MyValueCalculator {

    public String computeValue(String input) {
        // some real code...
    }
}
```

实现MethodReplacer接口

```java
public class ReplacementComputeValue implements org.springframework.beans.factory.support.MethodReplacer {

    public Object reimplement(Object o, Method m, Object[] args) throws Throwable {
        // get the input value, work with it, and return a computed result
        ...
        return ...;
    }
}
```

配置xml如下：

```xml
<bean id="myValueCalculator" class="x.y.z.MyValueCalculator">
    <!-- 定义 computeValue 这个方法要被替换掉 -->
    <replaced-method name="computeValue" replacer="replacementComputeValue">
        <arg-type>String</arg-type>
    </replaced-method>
</bean>

<bean id="replacementComputeValue" class="a.b.c.ReplacementComputeValue"/>
```



### Bean 继承

在初始化 Bean 的地方，我们说过了这个：

```java
RootBeanDefinition bd = getMergedLocalBeanDefinition(beanName);
```

这里涉及到的就是 `<bean parent="" />` 中的 parent 属性，我们来看看 Spring 中是用这个来干什么的。

首先，我们要明白，这里的继承和 java 语法中的继承没有任何关系，不过思路是相通的。child bean 会继承 parent bean 的所有配置，也可以覆盖一些配置，当然也可以新增额外的配置。

Spring 中提供了继承自 AbstractBeanDefinition 的 `ChildBeanDefinition` 来表示 child bean。

看如下一个例子:

```java
<bean id="inheritedTestBean" abstract="true" class="org.springframework.beans.TestBean">
    <property name="name" value="parent"/>
    <property name="age" value="1"/>
</bean>

<bean id="inheritsWithDifferentClass" class="org.springframework.beans.DerivedTestBean"
        parent="inheritedTestBean" init-method="initialize">

    <property name="name" value="override"/>
</bean>
```

parent bean 设置了 `abstract="true"` 所以它不会被实例化，child bean 继承了 parent bean 的两个属性，但是对 name 属性进行了覆写。

child bean 会继承 scope、构造器参数值、属性值、init-method、destroy-method 等等。

当然，我不是说 parent bean 中的 abstract = true 在这里是必须的，只是说如果加上了以后 Spring 在实例化 singleton beans 的时候会忽略这个 bean。

比如下面这个极端 parent bean，它没有指定 class，所以毫无疑问，这个 bean 的作用就是用来充当模板用的 parent bean，此处就必须加上 abstract = true。

```java
<bean id="inheritedTestBeanWithoutClass" abstract="true">
    <property name="name" value="parent"/>
    <property name="age" value="1"/>
</bean>
```

### ConversionService

将前端传过来的参数和后端的controller方法绑定

前端如果穿字符串，后端很容易转化为一个String或者Integer，但如果需要一个枚举值，或者是Date之类的，就要用ConversionService来转换

```xml
<bean id="conversionService"
  class="org.springframework.context.support.ConversionServiceFactoryBean">
  <property name="converters">
    <list>
      <bean class="com.javadoop.learning.utils.StringToEnumConverterFactory"/>
    </list>
  </property>
</bean>
```

用converter接口实现更简单

```java
public class StringToDateConverter implements Converter<String, Date> {

    @Override
    public Date convert(String source) {
        try {
            return DateUtils.parseDate(source, "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "HH:mm:ss", "HH:mm");
        } catch (ParseException e) {
            return null;
        }
    }
}
```









