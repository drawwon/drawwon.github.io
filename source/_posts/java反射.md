---
title: java反射
mathjax: true
date: 2020-06-08 16:58:10
tags: [反射]
category: [java]
---

java当中，除了基本类型外，其他都是class（interface），没有继承关系的数据类型是无法赋值的。本身class是一种数据类型（type）。

<!--more-->

而class本身是在jvm执行过程中动态加载的，每加载一种class，JVM就为其创建一个Class类型的实例，并关联起来。

这里的`Class`类型是一个名叫`Class`的`class`

```java
public final class Class{
  private Class(){}
}
```

以`String`类为例，当JVM加载`String`类的时候，它首先读取String.class文件到内存，然后为`String`类创建一个`Class`实例并关联起来。

```java
Class cls = new Class(String)
```

查看`Class`源码时，可以发现Class的构造方法是private的，因此只有JVM能够创建`Class`实例。

所以，JVM持有的每个Class实例都指向一个数据类型。

<img src="https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20200608172204.png" style="zoom:50%; margin-left:0px" />

一个Class实例包含了该calss的所有完整信息。

<img src="https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/20200608172144.png" style="zoom:50%;margin-left:0px" />

通过Class实例获取class信息的方法称为反射（Reflection）

有三个办法可以通过一个class获取对应的Class实例：

1. 通过class静态变量获取：

   ```java
   Class cls = String.class
   ```

2. 通过实例变量的getClass()方法获取

   ```java
   String s ="abc";
   Class cls = s.getClass();
   ```

3. 知道一个class的完整类名，可以通过静态方法`Class.forName()`获取

   ```java
   Class cls = Class.forName("java.lang.String");
   ```

因为`Class`实例在JVM当中是唯一的，因此上述三种方法获取的`Class`实例是同一个实例，可以用`==`比较。

```java
Class cls1 = String.class;

String s = "abc";
Class cls2 = s.getClass();

boolean sameClass = cls1 == cls2; // true
```

注意Class实例比较和instanceof的区别：

* `instanceof`是判断是否a是b的子类

  ```java
  Integer n = new Integer(123);
  
  boolean b1 = n instanceof Integer; // true，因为n是Integer类型
  boolean b2 = n instanceof Number; // true，因为n是Number类型的子类
  ```

* `==`判断的是是否是同一个class

  ```java
  boolean b3 = n.getClass() == Integer.class; // true，因为n.getClass()返回Integer.class
  boolean b4 = n.getClass() == Number.class; // false，因为Integer.class!=Number.class
  ```

拿到某个对象的class后，就可以通过反射获取该`Object`的`class`信息

```java
package com.drawon.reflection;

public class Reflection {
    public static void main(String[] args) {
        printClassInfo("".getClass());
        printClassInfo(Runnable.class);
        printClassInfo(java.time.Month.class);
        printClassInfo(String[].class);
        printClassInfo(int.class);
    }

    static void printClassInfo(Class cls) {
        System.out.println("Class name:" + cls.getName());
        System.out.println("Simple name: " + cls.getSimpleName());
        if (cls.getPackage() != null) {
            System.out.println("Package name: " + cls.getPackage().getName());
        }
        System.out.println("is interface: " + cls.isInterface());
        System.out.println("is enum: " + cls.isEnum());
        System.out.println("is array: " + cls.isArray());
        System.out.println("is primitive: " + cls.isPrimitive());
        System.out.println("--------");
    }
}
```

注意：数组也是一种class（比如String[]），并且它不同于`String.class`，它的类名是`[Ljava.lang.String`。

如果获取到了一个Class实例，我们就可以通过该class实例来创建对应类型的实例。

```java
// 获取String的Class实例:
Class cls = String.class;
// 创建一个String实例:
String s = (String) cls.newInstance();
```

上述代码等同于`new String()`。通过`newInstance（）`方法创建实例的局限是只能调用`public`的无参构造方法，带参数的活非`public`的构造方法都无法被`class.newInstance（）`方法调用

#### 动态加载

JVM在执行java程序的时候，在需要用某个class时才对其进行加载。例如，Commons Logging总是优先使用Log4j，只有当Log4j不存在时，才使用JDK的logging。利用JVM动态加载特性，大致的实现代码如下：

```java
// Commons Logging优先使用Log4j:
LogFactory factory = null;
if (isClassPresent("org.apache.logging.log4j.Logger")) {
    factory = createLog4j();
} else {
    factory = createJdkLog();
}

boolean isClassPresent(String name) {
    try {
        Class.forName(name);
        return true;
    } catch (Exception e) {
        return false;
    }
}
```

这就是为什么我们只需要把Log4j的jar包放到classpath中，Commons Logging就会自动使用Log4j的原因。

### 访问字段

通过获取某个Object的Class对象，就可以获取关于这个类的一切信息，

- Field getField(name)：根据字段名获取某个public的field（包括父类）
- Field getDeclaredField(name)：根据字段名获取当前类的某个field（不包括父类）
- Field[] getFields()：获取所有public的field（包括父类）
- Field[] getDeclaredFields()：获取当前类的所有field（不包括父类）

```java
public class Main {
    public static void main(String[] args) throws Exception {
        Class stdClass = Student.class;
        // 获取public字段"score":
        System.out.println(stdClass.getField("score"));
        // 获取继承的public字段"name":
        System.out.println(stdClass.getField("name"));
        // 获取private字段"grade":
        System.out.println(stdClass.getDeclaredField("grade"));
    }
}

class Student extends Person {
    public int score;
    private int grade;
}

class Person {
    public String name;
}

```

#### 获取字段值

利用反射拿到字段的一个`Field`实例只是第一步，我们还可以拿到一个实例对应的该字段的值。

例如，对于一个`Person`实例，我们可以先拿到`name`字段对应的`Field`，再获取这个实例的`name`字段的值：

```java
import java.lang.reflect.Field;

public class GetFiled {
    public static void main(String[] args) throws Exception {
        Object p = new Person("xiaoming");
        Class cls = p.getClass();
        Field f = cls.getDeclaredField("name");
        f.setAccessible(true);
        Object o = f.get(p);
        System.out.println(o);

    }


}
class Person{
    private String name;

    public Person(String name) {
        this.name = name;
    }
}
```

获取字段值的方法是：

1. 获取class
2. 通过`getFiled()`函数获取field实例f
3. 如果要获取的字段值是private的，需要先执行field.setAccessible(true);
4. 通过field.get(object)获取字段值，返回类型为Object

#### 设置字段值

除了获取字段值，还可以设置字段值

```java
package com.drawon.reflection;

import java.lang.reflect.Field;

public class GetFiled {
    public static void main(String[] args) throws Exception {
        Person p = new Person("xiaoming");
        Class cls = p.getClass();
        Field f = cls.getDeclaredField("name");
        f.setAccessible(true);
        f.set(p,"gugu");
        System.out.println(p.getName());

    }


}
class Person{
    private String name;

    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

### 调用方法

除了`Field`对象，还可以通过class对象获取类的`Method`

- `Method getMethod(name, Class...)`：获取某个`public`的`Method`（包括父类）
- `Method getDeclaredMethod(name, Class...)`：获取当前类的某个`Method`（不包括父类）
- `Method[] getMethods()`：获取所有`public`的`Method`（包括父类）
- `Method[] getDeclaredMethods()`：获取当前类的所有`Method`（不包括父类）

ps：所有public的属性和方法用getxxx()，所有private的方法用getDeclaredxxx()

```java
public class GetMethod {
    public static void main(String[] args) throws NoSuchMethodException {
        Person p = new Person("xiaoming");
        Class cls = p.getClass();
        Method method = cls.getMethod("getName");
        System.out.println(method);
    }
}
```

打印出`public java.lang.String com.drawon.reflection.Person.getName()`

method包含信息如下：

- `getName()`：返回方法名称，例如：`"getScore"`；
- `getReturnType()`：返回方法返回值类型，也是一个Class实例，例如：`String.class`；
- `getParameterTypes()`：返回方法的参数类型，是一个Class数组，例如：`{String.class, int.class}`；
- `getModifiers()`：返回方法的修饰符，它是一个`int`，不同的bit表示不同的含义。

#### 调用方法

获取method之后，可以通过invoke来调用

```java
public class GetMethod {
    public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        Person p = new Person("xiaoming");
        Class cls = p.getClass();
        Method method1 = cls.getMethod("getName");
        Method method2 = cls.getMethod("getAge", int.class);

        System.out.println(method1.invoke(p));
        int age = (int) method2.invoke(p,10);
    }
}

class Person{
    private String name;

    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public int getAge(int age){
        return age;
    }
}
```

#### 调用静态方法

如果获取到的Method表示一个静态方法，调用静态方法时，由于无需指定实例对象，所以`invoke`方法传入的第一个参数永远为`null`。我们以`Integer.parseInt(String)`为例：

```
// reflection import java.lang.reflect.Method; 
public class Main {
    public static void main(String[] args) throws Exception {
        // 获取Integer.parseInt(String)方法，参数为String:
        Method m = Integer.class.getMethod("parseInt", String.class);
        // 调用该静态方法并获取结果:
        Integer n = (Integer) m.invoke(null, "12345");
        // 打印调用结果:
        System.out.println(n);
    }
}

```

#### 调用非public方法

和Field类似，对于非public方法，我们虽然可以通过`Class.getDeclaredMethod()`获取该方法实例，但直接对其调用将得到一个`IllegalAccessException`。为了调用非public方法，我们通过`Method.setAccessible(true)`允许其调用：

```java
public class Main {
    public static void main(String[] args) throws Exception {
        Person p = new Person();
        Method m = p.getClass().getDeclaredMethod("setName", String.class);
        m.setAccessible(true);
        m.invoke(p, "Bob");
        System.out.println(p.name);
    }
}

class Person {
    String name;
    private void setName(String name) {
        this.name = name;
    }
}
```

#### 多态

我们来考察这样一种情况：一个`Person`类定义了`hello()`方法，并且它的子类`Student`也覆写了`hello()`方法，那么，从`Person.class`获取的`Method`，作用于`Student`实例时，调用的方法到底是哪个？

```java
public class Main {
    public static void main(String[] args) throws Exception {
        // 获取Person的hello方法:
        Method h = Person.class.getMethod("hello");
        // 对Student实例调用hello方法:
        h.invoke(new Student());
    }
}

class Person {
    public void hello() {
        System.out.println("Person:hello");
    }
}

class Student extends Person {
    public void hello() {
        System.out.println("Student:hello");
    }
}
```

打印结果为：`Student:hello`

这表明在反射时，依旧遵守多态原则

### 调用构造方法

通常对象用`new`来创建

```java
Person p = new Person();
```

如果通过反射创建，可以调用`newInstance()`方法

```java
Person p = Person.class.newInstance();
```

通过`newInstance()`新建对象的局限是只能调用该类的public无参构造方法

为了调用任意构造函数，反射提供了一个`Constructor`对象，包含构造方法的所有信息，`Constructor`和`Method`很像，只是Constructor调用的是构造方法，method使用invoke，constructor使用newinstance

```java
public class GetConstructor {
    public static void main(String[] args) throws Exception{
        Class cls = Person.class;
        Constructor cons = cls.getConstructor(String.class);
        Person p = (Person) cons.newInstance("kuku");
        System.out.println(p);
    }
}
```

通过class获取constructor的方法如下：

- `getConstructor(Class...)`：获取某个`public`的`Constructor`；
- `getDeclaredConstructor(Class...)`：获取某个`Constructor`；
- `getConstructors()`：获取所有`public`的`Constructor`；
- `getDeclaredConstructors()`：获取所有`Constructor`。

调用非`public`的`Constructor`时，必须首先通过`setAccessible(true)`设置允许访问。

### 获取继承关系

通过class实例的getSuperClass方法获取父类的class

```java
public class Main {
    public static void main(String[] args) throws Exception {
        Class i = Integer.class;
        Class n = i.getSuperclass();
        System.out.println(n);
        Class o = n.getSuperclass();
        System.out.println(o);
        System.out.println(o.getSuperclass());
    }
}

```

打印结果为：

```java
class java.lang.Number
class java.lang.Object
null
```

表示integer的父类是Number，Number的父类是Object，Object的父类为null

#### 获取interface

获取类实现的一个或多个接口，方法如下：

```java
package com.drawon.reflection;

public class GetInterface {
    public static void main(String[] args) {
        Class[] interfaces = Integer.class.getInterfaces();
        for (Class i:interfaces){
            System.out.println(i);
        }
    }
}

```

发现Integer类实现了Comparable接口，打印结果如下：

```java
interface java.lang.Comparable
```

注意：`getInterfaces()`只返回当前类实现的接口，并不包含父类实现的接口。要找到父类实现的接口，需要用getSuperclass()方法。

但对interface使用getSuperClass得到的是null，获取接口的父接口需要用`getInterfaces()`，如果一个类没有实现任何接口，会返回null

#### 继承关系

判断是否属于某个类型，用`instanceof`来进行判断

如果两个class实例，判断是否能够向上转型，用`isAssignableFrom()`

```java
// Integer i = ?
Integer.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Integer
// Number n = ?
Number.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Number
// Object o = ?
Object.class.isAssignableFrom(Integer.class); // true，因为Integer可以赋值给Object
// Integer i = ?
Integer.class.isAssignableFrom(Number.class); // false，因为Number不能赋值给Integer
```

### 动态代理

参考[Spring AOP的实现机制]([https://drawon.cn/2019/12/11/Spring-AOP%E7%9A%84%E5%AE%9E%E7%8E%B0%E6%9C%BA%E5%88%B6/](https://drawon.cn/2019/12/11/Spring-AOP的实现机制/))





