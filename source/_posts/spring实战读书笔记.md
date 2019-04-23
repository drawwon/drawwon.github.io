---
title: Spring实战读书笔记
mathjax: true
date: 2019-04-10 21:20:38
tags: [spring]
category: [编程学习]
---

曾经流行的框架名称是`SSH`，由Spring，spring MVC，hibernate组成

后来逐渐切换到`SSM`，由Spring，Spring MVC，MyBatis组成

再到现在流行的框架已经变成SpringBoot和MyBatis组成了

<!--more-->

## Maven

Maven是一个构建项目的工具，他的主要思想是通过配置一个pom.xml文件（project object model），一键式迁移java环境，不管在哪个环境中，只要拿到这个pom.xml，相关依赖就可以一键下载部署。

因为之前对spring了解不多，先看看《spring 实战》这本书

### spring基本概念

bean是spring的基本应用组件，spring最核心的内容就是IOC（DI）与AOP

我们考虑一下DI是怎么实现的。先看一个例子DamselRescuingKnight，实现的Knight接口，有个私有变量quest表示他能干的事情，比如拯救女子，或者是屠杀恶龙，如果你将quest写死为RescueDamselQuest，那么DamselRescuingKnight和RescueDamselQuest的耦合程度就太大了，这样不利于代码的修改和复用。

```java
package com.spring.sample.knights;
public class DamselRescuingKnight implements Knight {
    private RescueDamselQuest quest;
    public DamselRescuingKnight() {
        this.quest = new RescueDamselQuest(); //与RescueDamselQuest紧耦合
    }
    public void embarkOnQuest() {
        quest.emark();
    }
}
```

所谓的耦合就是互相依赖，如果一个类里面完全依赖另外一个类，需要改动的时候，那么要改动的地方可能就很多，所以spring的第一个好处是依赖注入，减少代码耦合。

第一个注入方式，是通过构造器注入，就是在构造器中传入参数，那么这个quest就可以是任何类型的quest了。

```java
package com.spring.sample.knights;

public class BraveKnight implements Knight {
    private Quest quest;

    public BraveKnight(Quest quest) { // Quest实例被注入
        this.quest = quest;
    }

    public void embarkOnQuest() {
        quest.emark();
    }
}
```

第二个注入方式就是Spring当中常用的，叫做装配(创建应用组件之间写作的行为称为装配)，就是用xml的方式来配置。

```java
package com.spring.sample.knights;

import java.io.PrintStream;

public class SlayDragonQuest implements Quest {
    private PrintStream stream;
    public SlayDragonQuest(PrintStream stream) {
        this.stream = stream;
    }
    public void emark() {
        stream.println("Embarking on quest to slay the dragon!");
    }
}
```

装配的xml文件如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

       <bean id="knight" class="com.spring.sample.knights.BraveKnight">
              <constructor-arg ref="quest" />
       </bean>

       <bean id="quest" class="com.spring.sample.knights.SlayDragonQuest">
              <constructor-arg value="#{T(System).out}" />
       </bean>
</beans>
```

Spring 3.0引入了JavaConfig，这种写法比xml文件的好处是具备类型安全检查，例如，上面XML配置文件可以这么写：

```java
package com.spring.sample.knights.config;

import com.spring.sample.knights.BraveKnight;
import com.spring.sample.knights.Knight;
import com.spring.sample.knights.Quest;
import com.spring.sample.knights.SlayDragonQuest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KnightConfig {
    @Bean
    public Knight knight() {
        return new BraveKnight(quest());
    }

    @Bean
    public Quest quest() {
        return new SlayDragonQuest(System.out);
    }
}
```

不论是基于XML的配置还是基于Java文件的配置，都由Spring框架负责管理beans之间的依赖关系。

#### 启动依赖注入

在Spring应用中，由*application context*负责加载beans，并将这些beans根据配置文件编织在一起。Spring框架提供了几种application context的实现：

1. 如果使用XML格式的配置文件，则使用`ClassPathXmlApplicationContext`；
2. 如果使用Java文件形式的配置文件，则使用`AnnotationConfigApplicationContext`。

```java
package com.spring.sample.knights;

import com.spring.sample.knights.config.KnightConfig;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class KnightMain {
    public static void main(String[] args) {
//        ClassPathXmlApplicationContext context =
//                new ClassPathXmlApplicationContext("classpath:/knight.xml");
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(KnightConfig.class);
        Knight knight = context.getBean(Knight.class);
        knight.embarkOnQuest();
        context.close();
    }
}
```

上述代码中，根据`KnightConfig.java`文件创建Spring应用上下文，可以把该应用上下文看成对象工厂，来获取idknight的bean。

#### 1.1.3 切面编程

依赖注入（DI）实现了模块之间的松耦合，而利用面向切面编程（AOP）可以将涉及整个应用的基础功能（安全、日志）放在一个可复用的模块中。

AOP是一种在软件系统中实现关注点分离的技术。软件系统由几个模块构成，每个模块负责一种功能，不过在系统中有些需求需要涉及到所有的模块，例如日志、事务管理和安全等。如果将这些需求相关的代码都分散在各个模块中，一方面是不方便维护、另一方面是与原来每个模块的业务逻辑代码混淆在一起，不符合单一职责原则。

- 实现系统级别处理的代码分散在多个子模块中，这意味着如果要修改这些处理代码，则要在每个模块中都进行修改。即使将这些代码封装到一个模块中，在没给个子模块中只保留对方法的调用，这些方法调用还是在各个模块中重复出现。
- 业务逻辑代码与非核心功能的代码混淆在一起。例如，一个添加address book的方法应该只关心如何添加address book，而不应该关心该操作是否安全或者是否能够实现事务处理。

下面这张图可以体现这种复杂性，左边的业务逻辑模块与右边的系统服务模块沟通太过密切，每个业务模块需要自己负责调用这些系统服务模块。

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190422105019.png)

AOP可以模块化这些系统服务，然后利用声明式编程定义该模块需要应用到那些业务逻辑模块上。这使得业务模块更简洁，更专注于处理业务逻辑，简而言之，切面（aspects）确保POJO仍然是普通的Java类。

可以将切面想象为覆盖在一些业务模块上的毯子，如下图所示。在系统中有一些模块负责核心的业务逻辑，利用AOP可以为所有这些模块增加额外的功能，而且核心业务模块无需知道切面模块的存在。

![image-20190422105135247](/Users/apple/Library/Application Support/typora-user-images/image-20190422105135247.png)

#### AOP实践

继续上面的例子，如果需要一个人记录*BraveKnight*的所作所为，下面代码是该日志服务：

```java
package com.spring.sample.knights;

import java.io.PrintStream;

public class Minstrel {
    private PrintStream stream;
    public Minstrel(PrintStream stream) {
        this.stream = stream;
    }
    public void singBeforeQuest() {
        stream.println("Fa la la, the knight is so brave!");
    }
    public void singAfterQuest() {
        stream.println("Tee hee hee, the brave knight did embark on a quest!");
    }
}
```

然后在XML文件中定义Minstrel对应的切面：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd">
       <bean id="knight" class="com.spring.sample.knights.BraveKnight">
              <constructor-arg ref="quest" />
       </bean>

       <bean id="quest" class="com.spring.sample.knights.SlayDragonQuest">
              <constructor-arg value="#{T(System).out}" />
       </bean>

       <bean id="minstrel" class="com.spring.sample.knights.Minstrel">
              <constructor-arg value="#{T(System).out}" />
       </bean>

       <aop:config>
              <aop:aspect ref="minstrel">
                     <aop:pointcut id="embark" expression="execution(* *.embarkOnQuest(..))"/>
                     <aop:before method="singBeforeQuest" pointcut-ref="embark" />
                     <aop:after method="singAfterQuest" pointcut-ref="embark" />
              </aop:aspect>
       </aop:config>
</beans>
```

在这个配置文件中增加了*aop*配置名字空间。首先定义Minstrel的bean，然后利用`<aop:config>`标签定义aop相关的配置；然后在`<aop:aspect>`节点中引用minstrel，定义方面；aspect负责将pointcut和要执行的函数（before、after或者around）连接在一起。

#### 1.1.4 使用模板消除重复代码
在编程过程中有没有感觉经常需要写重复无用的代码才能实现简单的功能，最经典的例子是JDBC的使用，这些代码就是样板式代码（boilerplate code）。

以JDBC的使用举个例子，这种原始的写法你一定见过：

```java
public Employee getEmployeeById(long id) {
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        conn = dataSource.getConnection();
        stmt = conn.prepareStatement("select id, name from employee where id=?");
        stmt.setLong(1, id);
        rs = stmt.executeQuery();
        Employee employee = null;
        if (rs.next()) {
            employee = new Employee();
            employee.setId(rs.getLong("id"));
            employee.setName(rs.getString("name"));
        }
        return employee;
    } catch (SQLException e) {
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
            }
        } 
       if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
            }
        }
    }
    return null;
}
```

可以看到，上面这么一坨代码中只有少数是真正用于查询数据（业务逻辑）的。除了JDBC的接口，其他JMS、JNDI以及REST服务的客户端API等也有类似的情况出现。

Spring试图通过模板来消除重复代码，这里所用的是模板设计模式。对于JDBC接口，Spring提供了JdbcTemplate模板来消除上面那个代码片段中的样板式代码，例子代码如下：

```java
public Employee getEmployeeById(long id) {
    return jdbcTemplate.queryForObject(
            "select id, name from employee where id=?",
            new RowMapper<Employee>() {
                public Employee mapRow(ResultSet resultSet, int i) throws SQLException {
                    Employee employee = new Employee();
                    employee.setId(resultSet.getLong("id"));
                    employee.setName(resultSet.getString("name"));
                    return employee;
                }
            });
}
```

我们上面已经演示了Spring简化Java开发的四种策略：面向POJO开发、依赖注入（DI）、面向切面编程和模板工具。在举例的过程中，我们稍微提到一点如何使用XML配置文件定义bean和AOP相关的对象，但是这些配置文件的加载原理是怎样的？这就需要研究下Spring的容器，Spring中所定义的bean都由Spring容器管理。

### 1.2 使用容器管理beans

基于Spring框架构建的应用中的对象，都由Spring容器（container）管理，如下图所示。Spring容器负责创建对象、编织对象和配置对象，负责对象的整个生命周期。

容器是Spring框架的核心，通过依赖注入（DI）管理构成Spring应用的组件。正是因为有容器管理各个组件之间的协作关系，使得每个Spring组件都很好理解、便于复用和单元测试。

Spring容器有多种实现，可以分为两类：

-  `Bean factories`（由*org.springframework.beans.factory.BeanFactory*接口定义）是最简单的容器，只提供基本的依赖注入功能；
-  `Application context`（由*org.springframework.context.ApplicationContext*接口定义）在bean factory的基础上提供application-framework框架服务，例如可以从properties文件中解析配置信息、可以对外公布application events。

#### 1.2.1 应用上下文（application context）

Spring提供了多种application context，可列举如下：

-  *AnnotationConfigApplicationContext*——从Java配置文件中加载应用上下文；
-  *AnnotationConfigWebApplicationContext*——从Java配置文件中加载Spring web应用上下文；
-  *ClassPathXmlApplicationContext*——从classpath（resources目录）下加载XML格式的应用上下文定义文件；
-  *FileSystemXmlApplicationContext*——从指定文件系统目录下加载XML格式的应用上下文定义文件；
-  *XmlWebApplicationContext*——从classpath（resources目录）下加载XML格式的Spring web应用上下文。

通过应用上下文实例，可以通过`getBean()`方法获得对应的bean。

#### 1.2.2 bean的生命周期

在传统的Java应用中，一个对象的生命周期非常简单：通过new创建一个对象，然后该对象就可以使用，当这个对象不再使用时，由Java垃圾回收机制进行处理和回收。

在Spring应用中，bean的生命周期的控制更加精细。Spring提供了很多节点供开发人员定制某个bean的创建过程，掌握这些节点如何使用非常重要。Spring中bean的生命周期如下图所示：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190422110224.png)

可以看出，bean factory负责bean创建的最初四步，然后移交给应用上下文做后续创建过程：

1. Spring初始化bean
2. Spring将值和其他bean的引用注入（inject）到当前bean的对应属性中；
3. 如果Bean实现了*BeanNameAware*接口，Spring会传入bean的ID来调用*setBeanName*方法；
4. 如果Bean实现了*BeanFactoryAware*接口，Spring传入bean factory的引用来调用*setBeanFactory*方法；
5. 如果Bean实现了*ApplicationContextAware*接口，Spring将传入应用上下文的引用来调用*setApplicationContext*方法；
6. 如果Bean实现了*BeanPostProcessor*接口，则Spring调用*postProcessBeforeInitialization*方法，这个方法在初始化和属性注入之后调用，在任何初始化代码之前调用；
7. 如果Bean实现了*InitializingBean*接口，则需要调用该接口的*afterPropertiesSet*方法；如果在bean定义的时候设置了*init-method*属性，则需要调用该属性指定的初始化方法；
8. 如果Bean实现了*BeanPostProcessor*接口，则Spring调用*postProcessAfterInitialization*方法
9. 在这个时候bean就可以用于在应用上下文中使用了，当上下文退出时bean也会被销毁；
10. 如果Bean实现了*DisposableBean*接口，Spring会调用*destroy()*方法;如果在bean定义的时候设置了*destroy-method*， 则此时需要调用指定的方法。

本节主要总结了如何启动Spring容器，以及Spring应用中bean的生命周期。

#### 1.3.1 Spring模块

Spring 4.0you 20个独立的模块，每个包含三个文件：二进制库、源文件和文档，完整的库列表如下图所示：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190422111002.png)

按照功能划分，这些模块可以分成六组，如下图所示：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190422111020.png)

这些模块几乎可以满足所有企业级应用开发的需求，但是开发人员并不需要完全使用Spring的这些模块，可以自由选择符合项目需求的第三方模块——Spring为一些第三方模块提供了交互接口。

## 装配bean—依赖注入的本质

在Spring应用中，对象无需自己负责查找或者创建与其关联的其他对象，由容器负责将创建各个对象，并创建各个对象之间的依赖关系。例如，一个订单管理组件需要使用信用卡认证组件，它不需要自己创建信用卡认证组件，只需要定义它需要使用信用卡认证组件即可，容器会创建信用卡认证组件然后将该组件的引用注入给订单管理组件。

创建各个对象之间协作关系的行为通常被称为**装配（wiring）**，这就是依赖注入（DI）的本质。

### 2.1 Spring的配置方法概览

Spring容器负责创建应用中的bean，并通过DI维护这些bean之间的协作关系。作为开发人员，你应该负责告诉Spring容器需要创建哪些bean以及如何将各个bean装配到一起。Spring提供三种装配bean的方式：

- 基于XML文件的显式装配
- 基于Java文件的显式装配
- 隐式bean发现机制和自动装配

我的建议是：尽可能使用自动装配，越少写显式的配置文件越好；当你必须使用显式配置时（例如，你要配置一个bean，但是该bean的源码不是由你维护），尽可能使用类型安全、功能更强大的基于Java文件的装配方式；最后，在某些情况下只有XML文件中才有你需要使用的名字空间时，再选择使用基于XML文件的装配方式。

### 2.2 自动装配bean

Spring通过两个特性实现自动装配：

- *Component scanning*——Spring自动扫描和创建应用上下文中的beans；
- *Autowiring*——Spring自动建立bean之间的依赖关系；

这里用一个例子来说明：假设你需要实现一个音响系统，该系统中包含CDPlayer和CompactDisc两个组件，Spring将自动发现这两个bean，并将CompactDisc的引用注入到CDPlayer中。

#### 2.2.1 创建可发现的beans

首先创建CD的概念——CompactDisc接口，如下所示：

```java
package com.spring.sample.soundsystem;

public interface CompactDisc {
    void play();
}
```

CompactDisc接口的作用是将CDPlayer与具体的CD实现解耦合，即面向接口编程。这里还需定义一个具体的CD实现，如下所示：

```java
package com.spring.sample.soundsystem;

import org.springframework.stereotype.Component;

@Component
public class SgtPeppers implements CompactDisc {
    private String title = "Sgt. Perppers' Lonely Hearts Club Band";
    private String artist = "The Beatles";

    public void play() {
        System.out.println("Playing " + title + " by " + artist);
    }
}
```

这里最重要的是*@Component*注解，它告诉Spring需要创建SgtPeppers bean。除此之外，还需要启动自动扫描机制，有两种方法：基于XML配置文件；基于Java配置文件，代码如下（二选一）：

1. 创建soundsystem.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
       
<context:component-scan base-package="com.spring.sample.soundsystem" />
</beans>
```

在这个XML配置文件中，使用`<context:component-scan>`标签启动Component扫描功能，并可设置base-package属性。

- 创建Java配置文件

```java
package com.spring.sample.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = "com.spring.sample.soundsystem")
public class SoundSystemConfig {
}
```

在这个Java配置文件中有两个注解值得注意：

* `@Configuration`表示这个.java文件是一个配置文件；
* `@ComponentScan`表示开启Component扫描，并且可以设置basePackages属性——Spring将会设置该目录以及子目录下所有被*@Component*注解修饰的类。

自动配置的另一个关键注解是*@Autowired*，基于之前的两个类和一个Java配置文件，可以写个测试

```java
package com.spring.sample.soundsystem;

import com.spring.sample.config.SoundSystemConfig;
import org.junit.Assert;import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = SoundSystemConfig.class)
public class SoundSystemTest {
    @Autowired
    private CompactDisc cd;

    @Test
    public void cdShouldNotBeNull() {
        Assert.assertNotNull(cd);
    }
}
```

运行测试，测试通过，说明*@Autowired*注解起作用了：自动将扫描机制创建的CompactDisc类型的bean注入到SoundSystemTest这个bean中。

#### 2.2.2 给被扫描的bean命名

在Spring上下文中，每个bean都有自己的ID。在上一个小节的例子中并没有提到这一点，但Spring在扫描到*SgtPeppers*这个组件并创建对应的bean时，默认给它设置的ID为*sgtPeppers*——是的，这个ID就是将类名称的首字母小写。

如果你需要给某个类对应的bean一个特别的名字，则可以给*@Component*注解传入指定的参数，例如：

```java
@Component("lonelyHeartsClub")
public class SgtPeppers implements CompactDisc {
  ...
}
```

#### 2.2.3 设置需要扫描的目标basepackage

在之前的例子中，我们通过给*@Component*注解传入字符串形式的包路径，来设置需要扫描指定目录下的类并为之创建bean。

可以看出，*basePackages*是复数，意味着你可以设置多个目标目录，例如：

```java
@Configuration
@ComponentScan(basePackages = {"com.spring.sample.soundsystem", "com.spring.sample.video"})
public class SoundSystemConfig {
}
```

这种字符串形式的表示虽然可以，但是不具备“类型安全”，因此Spring也提供了更加类型安全的机制，即通过类或者接口来设置扫描机制的目标目录，例如：

```java
@Configuration
@ComponentScan(basePackageClasses = {CDPlayer.class, DVDPlayer.class})
public class SoundSystemConfig {
}
```

通过如上设置，会将CDPlayer和DVDPlayer各自所在的目录作为扫描机制的目标根目录。

如果应用中的对象是孤立的，并且互相之间没有依赖关系，例如*SgtPeppers*bean，那么这就够了。

#### 2.2.4 自动装配bean

简单得说，自动装配的意思是让Spring从应用上下文中找到对应的bean的引用，并将它们注入到指定的bean。通过`@Autowired`注解可以完成自动装配。

例如，考虑下面代码中的*CDPlayer*类，它的构造函数被*@Autowired*修饰，表明当Spring创建CDPlayer的bean时，会给这个构造函数传入一个CompactDisc的bean对应的引用。

```java
package com.spring.sample.soundsystem;

import org.springframework.beans.factory.annotation.Autowired;

@Component
public class CDPlayer implements MediaPlayer {
    private CompactDisc cd;

    @Autowired
    public CDPlayer(CompactDisc cd) {
        this.cd = cd;
    }
    public void play() {
        cd.play();
    }
}
```

还有别的实现方法，例如将*@Autowired*注解作用在*setCompactDisc()*方法上:

```java
@Autowired
public void setCd(CompactDisc cd) {
    this.cd = cd;
}
```

或者是其他名字的方法上，例如：

```java
@Autowired
public void insertCD(CompactDisc cd) {
    this.cd = cd;
}
```

更简单的用法是，可以将*@Autowired*注解直接作用在成员变量之上，例如：

```java
@Autowired
private CompactDisc cd;
```

只要对应类型的bean有且只有一个，则会自动装配到该属性上。如果没有找到对应的bean，应用会抛出对应的异常，如果想避免抛出这个异常，则需要设置*@Autowired(required=false)*。不过，在应用程序设计中，应该谨慎设置这个属性，因为这会使得你必须面对*NullPointerException*的问题。

如果存在多个同一类型的bean，则Spring会抛出异常，表示装配有歧义，解决办法有两个：（1）通过*@Qualifier*注解指定需要的bean的ID；（2）通过*@Resource*注解指定注入特定ID的bean；

#### 2.2.5 验证自动配置

通过下列代码，可以验证：CompactDisc的bean已经注入到CDPlayer的bean中，同时在测试用例中是将CDPlayer的bean注入到当前测试用例。

```java
package com.spring.sample.soundsystem;

import com.spring.sample.config.SoundSystemConfig;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = SoundSystemConfig.class)
public class CDPlayerTest {
    public final Logger log = LoggerFactory.getLogger(CDPlayerTest.class);
    @Autowired
    private MediaPlayer player;

    @Test
    public void playTest() {
        player.play();
    }
}
```

### 2.3 基于Java配置文件装配bean

Java配置文件不同于其他用于实现业务逻辑的Java代码，因此不能将Java配置文件业务逻辑代码混在一起。一般都会给Java配置文件新建一个单独的package。

#### 2.3.1 创建配置类

实际上在之前的例子中我们已经实践过基于Java的配置文件，看如下代码：

```java
@Configuration
@ComponentScan(basePackageClasses = {CDPlayer.class, DVDPlayer.class})
public class SoundSystemConfig {
}
```

*@Configuration*注解表示这个类是配置类，之前我们是通过*@ComponentScan*注解实现bean的自动扫描和创建，这里我们重点是学习如何显式创建bean，因此首先将`@ComponentScan(basePackageClasses = {CDPlayer.class, DVDPlayer.class})`这行代码去掉。

#### 2.3.2 定义bean

通过*@Bean*注解创建一个Spring bean，该bean的默认ID和函数的方法名相同，即sgtPeppers。例如：

```java
@Bean
public CompactDisc sgtPeppers() {
    return new SgtPeppers();
}
```

同样，可以指定bean的ID，例如：

```java
@Bean(name = "lonelyHeartsClub")
public CompactDisc sgtPeppers() {
    return new SgtPeppers();
}
```

可以利用Java语言的表达能力，实现类似工厂模式的代码如下：

```java
@Bean
public CompactDisc randomBeatlesCD() {
    int choice = (int)Math.floor(Math.random() * 4);

    if (choice == 0) {
        return new SgtPeppers();
    } else if (choice == 1) {
        return new WhiteAlbum();
    } else if (choice == 2) {
        return new HardDaysNight();
    } else if (choice == 3) {
        return new Revolover();
    }
}
```

#### 2.3.3 JavaConfig中的属性注入

最简单的办法是将被引用的bean的生成函数传入到构造函数或者set函数中，例如：

```java
@Bean
public CDPlayer cdPlayer() {
    return new CDPlayer(sgtPeppers());
}
```

看起来是函数调用，实际上不是：由于sgtPeppers()方法被*@Bean*注解修饰，所以Spring会拦截这个函数调用，并返回之前已经创建好的bean——确保该SgtPeppers bean为单例。

假如有下列代码：

```java
@Bean
public CDPlayer cdPlayer() {
    return new CDPlayer(sgtPeppers());
}

@Bean
public CDPlayer anotherCDPlayer() {
    return new CDPlayer(sgtPeppers());
}
```

如果把*sgtPeppers()*方法当作普通Java方法对待，则*cdPlayer*bean和*anotherCDPlayer*bean会持有不同的*SgtPeppers*实例——结合CDPlayer的业务场景看：就相当于将一片CD同时装入两个CD播放机中，显然这不可能。

默认情况下，Spring中所有的bean都是单例模式，因此*cdPlayer*和*anotherCDPlayer*这俩bean持有相同的*SgtPeppers*实例。

当然，还有一种更清楚的写法：

```java
@Bean
public CDPlayer cdPlayer(CompactDisc compactDisc) {
    return new CDPlayer(compactDisc);
}

@Bean
public CDPlayer anotherCDPlayer() {
    return new CDPlayer(sgtPeppers());
}
```

这种情况下，*cdPlayer*和*anotherCDPlayer*这俩bean持有相同的*SgtPeppers*实例，该实例的ID为*lonelyHeartsClub*。这种方法最值得使用，因为它不要求CompactDisc bean在同一个配置文件中定义——只要在应用上下文容器中即可（不管是基于自动扫描发现还是基于XML配置文件定义）。

### 2.6 总结

这一章中学习了Spring 装配bean的三种方式：自动装配、基于Java文件装配和基于XML文件装配。

由于自动装配几乎不需要手动定义bean，建议优先选择自动装配；如何必须使用显式配置，则优先选择基于Java文件装配这种方式，因为相比于XML文件，Java文件具备更多的能力、类型安全等特点；但是也有一种情况必须使用XML配置文件，即你需要使用某个名字空间（name space），该名字空间只在XML文件中可以使用。

