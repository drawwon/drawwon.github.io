---
title: mybatis generator使用
mathjax: true
date: 2019-12-25 20:38:54
tags: [mybatis]
category: [java, 中间件]
---

mybatis generator可以说是java开发中必备的工具，可以根据数据库结构生成对应的java object，mapper接口以及`mappers.xml`文件，可以极大节省开发的时间，提高开发效率。

<!--more-->

mybatis generator又被称为mbg，其有多种运行方式，这里主要讲基于java的方式和基于jar包的方式

### 基于jar包的方式

添加如下插件配置，因为`mybatis-generator-maven-plugin`这个插件的classpath只包含mybatis-generator-core，所以要使用mysql driver的话，需要添加响应的依赖。然后点击maven插件的generate就可以了

```
<plugin>
  <groupId>org.mybatis.generator</groupId>
  <artifactId>mybatis-generator-maven-plugin</artifactId>
  <version>1.4.0</version>
  <executions>
    <execution>
      <id>Generate MyBatis Artifacts</id>
      <goals>
        <goal>generate</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <configurationFile>src/main/resources/generatorConfig.xml</configurationFile>
    <verbose>true</verbose>
    <overwrite>true</overwrite>
  </configuration>
  <dependencies>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.18</version>
    </dependency>
    <dependency>
      <groupId>org.mybatis.generator</groupId>
      <artifactId>mybatis-generator-core</artifactId>
      <version>1.4.0</version>
    </dependency>
  </dependencies>
</plugin>
```

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20191225213404.png)

### 使用java生成

首先添加依赖，需要mysql和mybatis两个的依赖

```
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.18</version>
</dependency>
<dependency>
  <groupId>org.mybatis.generator</groupId>
  <artifactId>mybatis-generator-core</artifactId>
  <version>1.4.0</version>
</dependency>
```

然后创建生成类：

```java
import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class Generate {
    public static void main(String[] args) throws Exception {
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        InputStream configFile = Generate.class.getResourceAsStream("/generatorConfig.xml");
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = cp.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        myBatisGenerator.generate(null);
    }
}
```

配置文件如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <properties resource="generator.properties"/>
    <context id="MySqlContext" targetRuntime="MyBatis3" defaultModelType="flat">
        <property name="beginningDelimiter" value="`"/>
        <property name="endingDelimiter" value="`"/>
        <property name="javaFileEncoding" value="UTF-8"/>
        <!-- 为模型生成序列化方法-->
        <plugin type="org.mybatis.generator.plugins.SerializablePlugin"/>
        <!-- 为生成的Java模型创建一个toString方法 -->
        <plugin type="org.mybatis.generator.plugins.ToStringPlugin"/>
        <!--生成mapper.xml时覆盖原文件-->
        <plugin type="org.mybatis.generator.plugins.UnmergeableXmlMappersPlugin" />
        <commentGenerator type="com.drawon.mall.mbg.CustomCommentGenerator">
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true"/>
            <property name="suppressDate" value="true"/>
            <property name="addRemarkComments" value="true"/>
        </commentGenerator>

        <jdbcConnection driverClass="${jdbc.driverClass}"
                        connectionURL="${jdbc.connectionURL}"
                        userId="${jdbc.username}"
                        password="${jdbc.password}">
            <!--解决mysql驱动升级到8.0后不生成指定数据库代码的问题-->
            <property name="nullCatalogMeansCurrent" value="true" />
        </jdbcConnection>

        <javaModelGenerator targetPackage="com.drawon.mall.model" targetProject="src/main/java/"/>

        <sqlMapGenerator targetPackage="com.drawon.mall.mapper" targetProject="src/main/resources/"/>

        <javaClientGenerator type="XMLMAPPER" targetPackage="com.drawon.mall.mapper"
                             targetProject="src/main/java/"/>
        <!--生成全部表tableName设为%-->
        <table tableName="%">
            <generatedKey column="id" sqlStatement="MySql" identity="true"/>
        </table>
    </context>
</generatorConfiguration>
```

### 自定义注解

配置文件中commentGenerator是用于生成注解的，我们关闭所有注解，然后再添加自定义的注解，注解生成的配置类是`com.drawon.mall.mbg.CustomCommentGenerator`，自定义注解继承`DefaultCommentGenerator`类，覆写其中的`addFieldComment`和`addJavaFileComment`函数，如下，这里自定义的主要目的是，添加swagger2的相关注解，用于自动生成接口文档

```java
import javafx.beans.property.Property;
import org.mybatis.generator.api.IntrospectedColumn;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.dom.java.CompilationUnit;
import org.mybatis.generator.api.dom.java.Field;
import org.mybatis.generator.api.dom.java.FullyQualifiedJavaType;
import org.mybatis.generator.config.PropertyRegistry;
import org.mybatis.generator.internal.DefaultCommentGenerator;
import org.mybatis.generator.internal.util.StringUtility;

import java.util.Properties;

import static org.mybatis.generator.internal.util.StringUtility.isTrue;

public class CustomCommentGenerator extends DefaultCommentGenerator {
    private static final String EXAMPLE_SUFFIX = "Example";
    private static final String API_MODEL_PROPERTY_FULL_CLASS_NAME = "io.swagger.annotations.ApiModelProperty";
    boolean addRemarkComments;

    @Override
    public void addConfigurationProperties(Properties properties) {
        super.addConfigurationProperties(properties);
        this.addRemarkComments = isTrue(properties.getProperty(PropertyRegistry.COMMENT_GENERATOR_ADD_REMARK_COMMENTS));
    }


    @Override
    public void addFieldComment(Field field, IntrospectedTable introspectedTable, IntrospectedColumn introspectedColumn) {
        String remarks = introspectedColumn.getRemarks();
        if (addRemarkComments && StringUtility.stringHasValue(remarks)) {
            if (remarks.contains("\"")) {
                remarks = remarks.replace("\"", "'");
            }
            field.addAnnotation("@ApiModelProperty(value = \"" + remarks + "\")");
        }
    }

    @Override
    public void addJavaFileComment(CompilationUnit compilationUnit) {
        super.addJavaFileComment(compilationUnit);
        if (!compilationUnit.getClass().isInterface() &&
                !compilationUnit.getType().getFullyQualifiedName().contains(EXAMPLE_SUFFIX)) {
            compilationUnit.addImportedType(new FullyQualifiedJavaType(API_MODEL_PROPERTY_FULL_CLASS_NAME));
        }
    }
}

```

