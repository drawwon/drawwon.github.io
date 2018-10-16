---
title: Spring boot 入门
mathjax: true
date: 2018-09-18 09:39:57
tags: [java,Spring]
category: [编程学习]
---

SpringBoot其实就是Spring的简化版本，因为Spring依赖的项目太多，其xml文件的配置显得尤为繁琐，因此出现了一键配置的SpringBoot框架

<!--more-->

### SpringBoot项目生成方法

在idea中构建一个springboot项目的方法如下：

1. 点击new->project->Spring initializr，选好java版本后点击下一步
2. 配置项目的名称等信息，点击下一步
3. 在可选插件中选择需要的插件，一般来说只用选择web->web就行了
4. 最后输入项目名称点击结束即可生成项目

### 运行方法

一共有3种方法

1. 通过idea运行：直接在idea中找到java主文件，然后点击run，即可运行
2. 用maven启动：`mvn  spring-boot:run`
3. 通过maven编译成jar后启动：`mvn install`->`java -jar xxx.jar`

### 配置文件

有两种配置文件的配置方法：

1. applicaiton.properties：就是直接赋值的方法

   ```
   server.port=8081
   server.servlet.context-path=/girl
   ```

2. applicaiton.yml：以yaml格式进行配置

   ```
   server:
     port: 8081
     servlet:
       context-path: /girl
   ```

在配置文件中还可以加入一些自定义的内容，比如一些变量的值，然后在网页中使用，比如我们加入身高Height

```yaml
server:
  port: 8080
Height: 165
```

然后在新建的`HelloControler.java`类中打印这个变量

```java
@RestController
public class HelloControler {
    @Value("${height}")
    private String height;

    @RequestMapping(value = "/hello",method = RequestMethod.GET)
    public String say(){
        return height;
    }
}
```

也可以把配置写到一个类里面：

1. 现在yml配置文件中写入配置：

   ```yaml
   girl:
     Height: 165
     age: 18
   ```

2. 新建一个用于存放这些变量类，`GirlProperties.java`

   ```java
   @Component
   @ConfigurationProperties(prefix = "girl")
   public class GirlProperties {
       private String Height;
       private Integer age;
   
       public String getHeight() {
           return Height;
       }
   
       public void setHeight(String height) {
           Height = height;
       }
   
       public Integer getAge() {
           return age;
       }
   
       public void setAge(Integer age) {
           this.age = age;
       }
   }
   ```

3. 在需要调用的类里面新建一个对象`GirlProperties`，用`@Autowired`（自动装配）关键字修饰

   ```java
   @RestController
   public class HelloControler {
       @Autowired
       GirlProperties girlProperties;
   
       @RequestMapping(value = "/hello",method = RequestMethod.GET)
       public String say(){
           return girlProperties.getHeight() + girlProperties.getAge();
       }
   }
   ```

### 多个配置文件切换

建立多个配置文件，如下：

```
application.yml
application-dev.yml
application-prod.yml
```

在dev和prod两个文件中分别填上需要的配置，然后在applicaiton.yml中指定需要激活的配置

```yaml
spring:
  profiles:
    active: dev
```

### Controller的使用

controller是用来处理http请求的

| 名称              | 作用                                                         |
| ----------------- | ------------------------------------------------------------ |
| `@Controller`     | 处理http请求                                                 |
| `@RestController` | Spring4之后的注解，原来返回json需要`@ResponseBody`配合`@Controller` |
| `@RequestMapping` | 配置url映射                                                  |

还有几个参数注解

| 名称            | 作用             |
| --------------- | ---------------- |
| `@PathVariable` | 获取url中的数据  |
| `@RequestParam` | 获取请求参数的值 |
| `@GetMapping`   | 组合注解         |

`@PathVariable`用法如下：

```java
@RestController
public class HelloControler {
    @RequestMapping(value = "/hello/{id}",method = RequestMethod.GET)
    public String say(@PathVariable("id") Integer myid){
        return "id: "+myid;
    }
}
```

`@RequestParam`用法如下：

```java
@RestController
public class HelloControler {
    @RequestMapping(value = "/hello",method = RequestMethod.GET)
    public String say(@RequestParam("id") Integer myid){
        return "id: "+myid;
    }
}
```

当你访问`http://127.0.0.1:8080/hello?id=12233`即可与得到显示id的页面

`@GetMapping`等同于将上面的`@RequestMapping(value = "/hello",method = RequestMethod.GET)`简化，此时只需要填一个值就好了，方法已经设置为get了

### 数据库操作

现在pom.xml中添加mysql的依赖，注意，这里要在idea的设置中，将maven的设置加上`always update snapshot`

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

然后再在`application.yml`中加入对mysql的配置

```yaml
spring:
  profiles:
    active: dev
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/dbgirl
    username: root
    password: root
  jpa:
    hibernate:
      ddl-auto: create
    show-sql: true
```

此时只需要建立一个Girl类，在其中加入`id`,`height`,`age`等字段，即可运行时自动生成表，注意：最上面要加入`@Entity`，id要自增的话要加入`@Id`,`@GeneratedValue`

```java
@Entity
public class Girl {
    @Id
    @GeneratedValue
    private Integer id;

    private Integer age;
    private Integer height;

    public Girl() {
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }
}
```

### 对数据库的增删改查

在`GirlController.java`这个类里面进行增删改查，要创建一个专用的`GirlRepository.java`类用于操作数据库

`GirlRepository.java`是一个接口类，继承自`JpaRepository`

```java
package com.drawon.demo;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GirlRepository extends JpaRepository<Girl,Integer> {
    //通过年龄来查询
    public List<Girl> findByAge(Integer age);
}

```

`GirlController.java`

```java
package com.drawon.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
public class GirlController {
    @Autowired
    private GirlRepository girlRepository;

    /**
     * 查询所有女生的列表
     *
     * @return
     */
    @GetMapping("/girls")
    public List<Girl> girllist() {
        return girlRepository.findAll();
    }

    /**
     * 为女神的身高，年龄赋值
     *
     * @param height
     * @param age
     */
    @PostMapping("/girls")
    public Girl girlAdd(@RequestParam("height") Integer height,
                        @RequestParam("age") Integer age
    ) {
        Girl girl = new Girl();
        girl.setAge(age);
        girl.setHeight(height);
        return girlRepository.save(girl);
    }

    //查询一个女生
    @GetMapping("/girls/{id}")
    public Optional<Girl> findGirlById(@PathVariable("id") Integer id) {
        return girlRepository.findById(id);
    }

    //通过年龄查询
    @GetMapping("/girls/age/{age}")
    public List<Girl> findGirlByAge(@PathVariable("age") Integer age){
        return girlRepository.findByAge(age);
    }

    //更新
    @PutMapping("/girls/{id}")
    public Girl girlUpdate(@RequestParam("height") Integer height,
                           @RequestParam("age") Integer age, @PathVariable("id") Integer id) {
        Girl girl = new Girl();
        girl.setId(id);
        girl.setHeight(height);
        girl.setAge(age);
        return girlRepository.save(girl);

    }

    //删除
    @DeleteMapping("/girls/{id}")
    public void delGirl(@PathVariable("id") Integer id) {
        Girl girl = new Girl();
        girl.setId(id);
        girlRepository.delete(girl);
    }
}

```

### 事务管理

比如我们同时操作多条数据，有可能会失败，但是前面那些我希望已经插入的可以回滚到未插入的状态。

也就是说，我们要求插入多条数据的时候，要么同时插入，要么一条也不插入。

此时用到`Transactional`关键字，新建一个`GirlService.java`

`GirlService.java`，在事务操作前面加上`@Transactional`关键字

```java
package com.drawon.demo;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;

@Service
public class GirlService {
    GirlRepository girlRepository;
    @Transactional
    public void insertTwo() {
        Girl girlA = new Girl();
        girlA.setAge(10);
        girlA.setHeight(100);
        girlRepository.save(girlA);

        Girl girlB = new Girl();
        girlB.setAge(20);
        girlB.setHeight(200);
        girlRepository.save(girlB);
    }
}
```

然后在controller里面调用这个service

```java
//添加2个girl
@PostMapping("/girls/two")
public void girlAddTwo(){
    girlService.insertTwo();
}
```

### 表单验证

验证表单的值是否满足要求，不满足要求的时候终止提交

比如在girl项目中，我们限制年龄小于18的进入，在`Girl.java`中定义如下内容：

```java
public class Girl {
    ...
        @Min(value = 18, message = "未成年禁止入内")
        private Integer age;
    ...}
```
用`@valid`进行验证，返回BindingResult验证结果，用`BindingResult.hasErrors()`方法检测有没有错误，有错误就直接返回null

```java
@PostMapping("/girls")
    public Girl girlAdd(@Valid Girl girl, BindingResult bindingResult
    ) {
//        Girl girl = new Girl();
        if (bindingResult.hasErrors()){
            System.out.println(bindingResult.getFieldError().getDefaultMessage());
            return null;
        }
        girl.setAge(girl.getAge());
        if (girl.getHeight() != null) {
            girl.setHeight(girl.getHeight());
        } else {
            girl.setHeight(0);
        }
        return girlRepository.save(girl);
    }
```

### 使用AOP（Aspect Oriented Programming）处理请求

AOP是一种编程思想，意思是面向切面编程

AOP主要思想是将通用模块独立出来，以便代码复用

比如我们要对所有的内容写入log，我们此时只需要建立一个HttpAspect类，使用aspect之前先在`pom.xml`中添加依赖

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>
```

然后建立一个aspect文件夹，在其中加入httpAspect类，用`@Aspect`和`@component`注解

```java
@Aspect
@Component
public class HttpAspect {
    @Before("execution(public * com.drawon.demo.controller.GirlController.*(..))")
    public void log(){
        System.out.println(111111);
    }
    @After("execution(public * com.drawon.demo.controller.GirlController.*(..))")
    public void doAfter(){
        System.out.println(22222);
    }
}
```

`@Before("execution(public * com.drawon.demo.controller.GirlController.*(..))")`保证了监听所有`GirlController`类中的方法，一定要写`*(..)`，不然不会监听所有函数

上面这段aspect的代码，其中的before和after注解后面的内容很长，并且重复了，我们想要增加代码复用性，简洁性，我们要把这一段抽出来，用`pointcut`关键字来表示，pointcut是切面编程中要切的点。

```java
@Aspect
@Component
public class HttpAspect {
    @Pointcut("execution(public * com.drawon.demo.controller.GirlController.*(..))")
    public void log(){
    }
    @Before("log()")
    public void doBefore(){
        System.out.println(11111);
    }
    @After("log()")
    public void doAfter(){
        System.out.println(22222);
    }
}
```

然后我们需要将之前的`system.out.println`修改为spring自带的log模块来打印

```java
@Aspect
@Component
public class HttpAspect {
    private final static Logger logger = LoggerFactory.getLogger(HttpAspect.class);

    @Pointcut("execution(public * com.drawon.demo.controller.GirlController.*(..))")
    public void log() {
    }

    @Before("log()")
    public void doBefore(JoinPoint joinPoint) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        //记录url
        logger.info("url={}", request.getRequestURI());
        //记录method
        logger.info("method={}", request.getMethod());
        //ip
        logger.info("ip={}", request.getRemoteAddr());

        //类方法
        logger.info("class_method={}", joinPoint.getSignature().getDeclaringTypeName() + '.' + joinPoint.getSignature().getName());
        //参数
        logger.info("args={}", joinPoint.getArgs());

    }

    @After("log()")
    public void doAfter() {
        logger.info("22222");
    }
    
	//记录返回的内容，需要覆写Girl.java的tostring()方法
    @AfterReturning(returning = "object",pointcut = "log()")
    public void doAfterReturning(Object object){
        logger.info("response={}",object);
    }
}
```













