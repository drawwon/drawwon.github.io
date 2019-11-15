---
title: SpringBoot启动的三种方式
mathjax: true
date: 2019-11-14 14:17:49
tags: [SpringBoot]
category: [SpringBoot]
---

### 方法1：通过idea的Application配置启动

一般通过idea创建springboot项目后，可以直接点击启动按钮进行启动项目，如果启动按钮不可用，可以新建一个配置如下，填入主类的类名后即可上传

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191114142408.png)

### 方法2：通过mvn命令启动

直接通过mvn命令启动

```shell
mvn spring-boot:run
```

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191114142606.png)

### 方法3：打包成jar文件，通过命令行启动

打包的命令：`mvn clean install`

然后打开target文件夹，会找到跟项目同名的jar文件，通过`java -jar xxx.jar`即可启动项目

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191114142737.png)



