---
title: springboot热部署
mathjax: true
date: 2019-04-24 17:29:28
tags: [spring]
category: [spirng]
---

spring-boot-devtools是一个专门用于springboot热部署的插件

## devtools原理

深层原理是使用了两个ClassLoader，一个Classloader加载那些不会改变的类（第三方Jar包），另一个ClassLoader加载会更改的类，称为restart ClassLoader,这样在有代码更改的时候，原来的restart ClassLoader 被丢弃，重新创建一个restart ClassLoader，由于需要加载的类相比较少，所以实现了较快的重启时间。

总的来说，一共需要两个步骤：
第一步：

先设置我们的pom.xml文件，加入依赖，首先是把下面代码在`<dependencies>`中

```xml
<!--添加热部署-->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-devtools</artifactId>
  <optional>true</optional>
  <scope>true</scope>
</dependency>
```

另外下面的代码是放在`<build>  `下面`<plugins>`里的

```xml
<plugin>
  <!--热部署配置-->
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-maven-plugin</artifactId>
  <configuration>
    <!--fork:如果没有该项配置,整个devtools不会起作用-->
    <fork>true</fork>
  </configuration>
</plugin>
```

第二步：

设置IDEA的自动编译：
（1）File-Settings-Compiler勾选 Build Project automatically

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190424173336.png)

（2）快捷键 ctrl + shift + alt + /,选择Registry,勾上 Compiler autoMake allow when app running

<img src="https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190424173533.png" width="500px"/>

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20190424173459.png)

这样我们的热部署就完成了，可以再我们的项目中修改返回值，或者修改Mapping的value值后，在我们的页面中刷新试试。(注意，可能要重启项目才能生效)

