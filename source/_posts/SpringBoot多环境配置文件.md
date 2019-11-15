---
title: SpringBoot多环境配置文件
mathjax: true
date: 2019-11-14 14:11:16
tags: [SpringBoot]
category: [SpringBoot]
---

SpringBoot可以根据环境不同设置多个配置文件，比如可以设置`application-dev.yml`配置，就是开发环境，`application-prod.yml`配置就是生产环境

<img src="https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191114141224.png" width="50%" height="50%"  style="margin: 0 auto;"/>

那么系统该如何决定激活哪个文件呢？

在application.yml里面，设置spring.profiles.active来配置激活哪一个

```yaml
server:
  port: 8080
  servlet:
    context-path: /demo
spring:
  profiles:
    active: prod
```

