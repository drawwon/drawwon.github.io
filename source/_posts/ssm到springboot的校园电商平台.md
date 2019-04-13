---
title: ssm到springboot的校园电商平台
mathjax: true
date: 2019-04-10 21:20:38
tags: [spring]
category: [编程学习]
---

曾经流行的框架名称是`SSH`，由Spring，spring MVC，hibernate组成

后来逐渐切换到`SSM`，由Spring，Spring MVC，MyBatis组成

再到现在流行的框架已经变成SpringBoot和MyBatis组成了

## Maven

Maven是一个构建项目的工具，他的主要思想是通过配置一个pom.xml文件（project object model），一键式迁移java环境，不管在哪个环境中，只要拿到这个pom.xml，相关依赖就可以一键下载部署。

因为之前对spring没有了解，先看看《spring 实战》这本书

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



