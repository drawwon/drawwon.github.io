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