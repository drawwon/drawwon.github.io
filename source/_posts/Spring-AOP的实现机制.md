---
title: Spring AOP的实现机制
mathjax: true
date: 2019-12-11 16:59:37
tags: [java,Spring]
category: [java,Spring]
---

spring aop属于第二代AOP，采用动态代理和字节码生成技术实现。所谓第一代AOP技术，就是在代码编译的时候，为需要添加aop功能的类，直接编译到系统的静态类中，也被称为静态aop。

要了解spring的aop实现方法，就要先了解一个设计模式：代理模式

<!--more-->

### 代理模式

既然这个模式的名字叫做代理模式，那么肯定就有一个代理，简单来说，买房的时候，有房产代理，由代理分别接触房东和客户，而买卖双方不接触。在软件系统当中，这个模式被称为代理模式

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191211171814.png)

如图所示，代理模式有一个proxy代理，当client想要访问Isubject这个接口的时候，需要通过subjectProxy这个代理进行访问，这个代理持有一个Isubject的实例。

这样看上去，访问的过程中间加上代理似乎多此一举，但是实际上代理模式的最大的作用，在于对请求添加更多访问限制。

```java
public class SubjectProxy implements Isubject{
    private ISubject subject;
    public String request{
        // add logic
        String originalResult = subject.request();
        // add logic
    }
}
```

可以看到，SubjectProxy类中的request方法，对原有的request方法的前后可以添加逻辑，比如，你可以限制只有在某一特定时间，接口才可用，其余时间直接返回null。

```java
public class ServiceControlSubjectProxy implements Isubject{
    private ISubject subject;
    public ServiceControlSubjectProxy(ISubject s){
        this.subject = s;
    }
    public String request{
		TimeOfDay startTime = new TimeOfDay(0,0,0);
        TimeOfDay endTime = new TimeOfDay(5,59,59);
        TimeOfDay currentTime = new TimeOfDay();
		if (currentTime.isAfter(startTime)  && currentTime.isBofore(endTime)){
            return null;
        }
        String originalResult = subject.request();
        return "proxy: " + originalResult;
    }
}
```

具体使用的时候，我们就可以用ServiceControlSubjectProxy代替SubjectImpl来使用，如下所示

```java
Isubject target = new SubjectImpl();
Isubject finalSubject = new ServiceControlSubjectProxy(target);
finalSubject.request();
```

这样就实现了一个代理模式来限制接口的访问时间，但是如果还有一个类，IRequetable接口，同样要限制时间，那么是不是也要新建一个`ServiceControlSubjectProxy`呢，这样有多少个服务需要限制，就要新建多少个类来实现对应的接口，尽管他们的逻辑是一模一样的。显然这样的效率会比较低，解决这个问题的方法称为动态代理。

### 动态代理

动态代理是在JDK1.3之后引入的，这个机制康有为指定的接口在系统运行期间动态的生成代理对象。动态代理机制的实现主要由一个类和一个接口组成，即`java.lang.reflect.Proxy`类和`java.lang.reflect.InvocationHandler`接口。

下面我们将使用动态代理来实现限制ISubject和IRequestable两个接口的限制接口时间的功能。

```java
public class RequestCtrolInovationHandler implements InvocationHandler {
    private Object target;

    public RequestCtrolInovationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        if (method.getName().equals("request")) {
            TimeOfDay startTime = new TimeOfDay(0, 0, 0);
            TimeOfDay endTime = new TimeOfDay(5, 59, 59);
            TimeOfDay currentTime = new TimeOfDay();
            if (currentTime.isAfter(startTime) && currentTime.isBofore(endTime)) {
                return null;
            }
            return method.invoke(target, args);
        }
        return null;
    }
}
```

然后使用Proxy类，根据RequestCtrolInovationHandler的逻辑，为ISubject和IRequestable两个类生成对应的代理实例

```java
ISubject subject = (ISubject) Proxy.newProxyInstance(ProxyRunner.class.getClassLoader), new Class[]{Isubject.class}, new RequestCtrlInvocationHandler(new SubjectImpl());

subject.request();


IRequestable requestable = (IRequestable) Proxy.newProxyInstance(ProxyRunner.class.getClassLoader), new Class[]{IRequestable.class}, new RequestCtrlInvocationHandler(new RequestableImpl());

subject.request();
```

动态代理虽然效果好，但是并不能满足所有的需求，因为动态代理只能对实现了interface的类进行代理（因为目标类和代理类都向上转型成接口类，这样代理类就可以持有目标类的接口），如果一个类没有实现任何接口，那么就不能使用动态代理，只能使用动态字节码生成。

### 动态字节码生成

原理：对目标对象进行集成，生成相应的子类，子类通过覆写来扩展父类的行为，将横切逻辑放到子类中，让系调用扩展后的目标对象的子类，就达到了和代理模式一样的效果。

使用集成的方式来扩展对象定义，不能像静态代理那样，为每个类生成一个子类，因此要借助CGLIB这样的动态字节码生成库，在系统运行期间动态的为目标对象生成相应的扩展子类。

```java
public class Requestable{
    public void request(){
        System.out.println("excute request in requestable");
    }
}
```

对Requestable进行扩展，首先需要实现一个`net.sf.cglib.proxy.Callback`，不过更多时候直接用`net.sf.cglib.proxy.MethodInterceptor`接口（MethodInterceptor扩展了Callback接口）

```java
public class RequestCtrlCallback implements MethodInterceptor {
    @Override
    public Object intercept(Object o, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        if (method.getName().equals("request")) {
            TimeOfDay startTime = new TimeOfDay(0, 0, 0);
            TimeOfDay endTime = new TimeOfDay(5, 59, 59);
            TimeOfDay currentTime = new TimeOfDay();
            if (currentTime.isAfter(startTime) && currentTime.isBofore(endTime)) {
                return null;
            }
            return methodProxy.invokeSuper(o, args);
        }
        return null;
    }
}
```

`RequestCtrlCallback`实现了对`request()`方法请求进行访问控制的逻辑，我们现在通过CGLIB的Enhancer为目标对象动态地生成一个子类，并将`RequestCtrlCallback`中的横切逻辑添加到子类中

```
Enhancer enhancer = new Enhancer();
enhancer.setSupercalss(Requestable.class);
enhancer.setCallback(new RequestCtrlCallback());

Requestable proxy = (Requestable) enhancer.create();
proxy.request();
```

