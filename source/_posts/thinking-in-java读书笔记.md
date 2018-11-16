---
title: thinking in java读书笔记
mathjax: true
date: 2018-06-24 16:38:23
tags: [Java]
category: [java,编程学习]
---

## 基础语法

大多数语法与c++相似，只记录部分不熟悉的或者是不一样的语法。

### static关键字

<!--more-->

static的作用是，用static修饰的部分，不需要实例化类，可以直接通过类名+"."来使用

static还可以用来修饰变量，如果被static修饰之后，在内存中只有一个拷贝，只分配一次内存，没有用static修饰的在内存中有多个拷贝，每次new都会分配一个新地址

### 运算符

* `^`：异或操作符
* `&`和`&&`符号的区别：`&`符号两边的运算都要执行，`&&`只有在左边条件为真的时候才执行，例如`if(str!=null && !"".equals(str))`：
  * 用`&&`的时候，此时如果`str!=null`，右边的`!"".equals(str)`会被执行，如果此时`str=null`，那么右边的`!"".equals(str)`不会被执行；
  * 如果用`&`：不管`str!=null`的结果如何，后面的`!"".equals(str)`都会被执行
* `>>>`：无符号右移操作

### foreach

如果要遍历一个数组，可以使用在java SE5中引入的foreach方法：`for(int i : range(10))`

```java
Random rand = new Random();
float f[] = new float[10];
for(int i = 0;i < 10; i++){
    f[i] = rand.nextFloat();
}
for (float x: f){
    System.out.println(x);
}
```

## 构造器和垃圾回收器

### 构造器

构造器就相当于js当中的构造函数，python中的`__init__`函数，在java当中构造器的名称就是和类名相同的一个函数

```java
class Rock2{
    Rock2(int i){
        System.out.println('Rock' + i);
    }
}
```

### 方法重载

方法重载就是同一个函数，在其参数不同的时候执行不同的函数的过程，比如：

```java
class Tree{
    int height;
    Tree(){
        System.out.println("a seed")
    }
    Tree(int initialHeight){
        height = initialHeight;
        System.out.println("a tree high is" + height);
    }
}
```

### 在构造函数中调用构造函数

一个class可以有多个构造函数，还可以在某个构造函数中调用另一个构造函数，调用的方法是用`this(构造参数)`来实现的，**注意**：在一个构造其中最多只能调用一次别的构造函数，因为某个class只能被构造一次。且只能在构造函数中调用构造函数，还要在构造函数的最前面调用。

```java
class Flower {
    int petalCount = 0;
    String s = "initial string";

    private Flower(int petal) {
        petalCount = petal;
        println("petal only constructor,petalCount=" + petalCount);
    }

    Flower(String ss) {
        println("constructor with string only" + ss);
    }

    private Flower(String s, int petal) {
        this(petal);
        //this(s) ，只能调用一次，如果调用第二次会报错
        this.s = s;
        petalCount = petal;
        println("string and int constructor");
    }

    Flower() {
        this("hi", 47);
        println("petalCount=" + petalCount + ",s=" + s);
    }
    public static void main(String[] args) {
        Flower flower = new Flower();
    }
}

```

## 垃圾回收

所有用new构建的对象，java都会自动回收，只有那些不是用new得到的对象所占用的内存，java无法处理，需要你编写`finalize()`函数来进行垃圾回收

1. 对象可能不被垃圾回收
2. 垃圾回收不等于“析构”
3. 垃圾回收只与内存有关

因为垃圾回收本身也要消耗一定资源，所以在jvm内存耗尽之前，它是不会浪费时间去执行垃圾回收的。

在垃圾回收的时候，会自动调用`finalize()`函数，通常是一些销毁时对对象的验证

```java
public class Main {
    public static void main(String[] args) {
        Book novel = new Book(true);
        novel.checkIn();
        new Book(true);
        System.gc();
    }
}

class Book{
    boolean checkedOut = false;
    Book(boolean checkOut){
        checkedOut = checkOut;
    }
    void checkIn(){
        checkedOut = false;
    }
    protected void finalize(){
        if (checkedOut){
            println("error:checked out");
        }
    }
}
```

### 垃圾回收的自适应技术

所谓的自适应，就是在两种垃圾回收方式中切换：**标记-清扫**模式和**停止-复制**模式

先来介绍一下这两种模式的工作机理：

1. 标记-清扫模式：遍历所有的引用，找出存活的对象。每找到一个存活对象，就会给对象一个标记，这个过程不会回收任何对象。只有标记完所有对象的时候，才开始清理，没有标记的对象将被释放。剩下的空间是不连续的，如果希望得到连续空间，就需要重新整理剩下的对象。
2. 停止-复制模式：暂停程序运行，将所有存活的对象从当前堆复制到另一个堆，没有被复制到都是垃圾。得到的新堆是连续的。这种方法需要两倍的程序运行内存（一个本身，一个复制堆），在程序稳定时只有少量垃圾，大量复制会产生内存浪费。

自适应模式：如果对象很稳定，就切换到“标记-清扫”模式；要是标记清扫模式的堆空间中出现很多碎片，就会切换回“停止-复制”模式

### 类成员初始化顺序

首先被初始化的是静态变量，然后是普通变量，比如定义的int，或者是定义的new 类元素，然后是构造器，最后是函数对象

```java

package javastatic;
class Window{
	Window(int marker){
		System.out.println("Windows("+marker+")");
	}
}
class House{
	Window w1=new Window(1);
	House(){
		System.out.println("House()");
		w3=new Window(33);
	}
	Window w2=new Window(2);
	void f(){
		System.out.println("f()");
	}
	Window w3=new Window(3);
}
 
public class OrderOfInitialization {
 
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		House house=new House();
		house.f();
	}
}

/* output:
Window(1)
Window(2)
Window(3)
House()
Window(33)
f()
*///:~
```

### 静态数据

无论创建多少个对象，静态数据都只占用一份存储区域，static不能用于局部变量，且静态变量的初始化优先级最高，在最前面

```java

package test;
 
class Bowl{
	Bowl(int marker){
		System.out.println("Bowl("+marker+")");
	}
	void f1(int marker){
		System.out.println("f1("+marker+")");
	}
}
 
class Table{
	static Bowl bowl1=new Bowl(1);
	Table(){
		System.out.println("Table()");
		bowl2.f1(1);
	}
	void f2(int marker){
		System.out.println("f2("+marker+")");
	}
	static Bowl bowl2=new Bowl(2);
}
 
class Cupboard{
	Bowl bowl3=new Bowl(3);
	static Bowl bowl4=new Bowl(4);
	Cupboard(){
		System.out.println("Cupboard()");
		bowl4.f1(2);
	}
	void f3(int marker){
		System.out.println("f3("+marker+")");
	}
	static Bowl bowl5=new Bowl(5);
}
 
public class Static {
	public static void main(String args[])
	{
		System.out.println("Creating new Cupboard() in main");
		new Cupboard();
		System.out.println("Creating new Cupboard() in main");
		new Cupboard();
		table.f2(1);
		cupboard.f3(1);
	}
	static Table table=new Table();
	static Cupboard cupboard=new Cupboard();
}

/* output：
Bowl(1)
Bowl(2)
Table()
f1(1)

Bowl(4)
Bowl(5)
Bowl(3)
Cupboard()
f1(2)

Creating new Cupboard() in main
Bowl(3)
Cupboard()
f1(2)

Creating new Cupboard() in main
Bowl(3)
Cupboard()
f1(2)
f2(1)
f3(1)
*/
```

**静态方法**：静态方法不能访问this变量，但静态方法可以访问静态变量

### 数组初始化

数组在java中的定义形式推荐的是：

```java
int[] array;
```

方括号在前，定义的是一个int类型的数组，比在后面更容易理解

数组的初始化有三种方法，

* 第一种是先定义长度，然后遍历数组，一个个赋值
* 第二种是用大括号直接赋值
* 第三种是用new+类型名[]+{值}

```java

public static void main(String[] args) {
    Random rand = new Random(47);
    //第一种
    int[] a = new int[rand.nextInt(20) + 1];
    System.out.println("array a length:" + a.length);
    for (int i = 0; i < a.length; i++) {
        a[i] = rand.nextInt(500);
    }
    System.out.println(Arrays.toString(a));
    //第二种
    Integer[] b = {
        new Integer(1),
        new Integer(2),
        3,
    };
	//第三种
    Integer[] c = new Integer[]{
        new Integer(1),
        new Integer(2),
        3,
    };
}
```

### 数组排序

可以自己写冒泡排序：

```java
for (int i = 0; i < ns.length; i++) {
    for (int j = i+1; j < ns.length; j++) {
        if (ns[i] > ns[j]){
            int t = ns[i];
            ns[i] = ns[j];
            ns[j] = t;
        }
    }
}
```

也可以直接调用`Arrays.sort`方法

```java
int[] ns=[1,33,4,2,5]
Arrays.sort(ns)
System.out.println(Arrays.toString(ns));
```

打印数组的方法：

```java
//方法一 Arrays.toString或者Arrays.deeptoString(打印多维数组)
System.out.println( Arrays.toString(ns));
//方法二 foreach遍历
for(int i: ns){
    System.out.println(i);
}
//方法三 for遍历
for(i=0;i<ns.length;i++){
    System.out.println(ns[i]);
}
```



**tips:**

idea快捷键：

* `psvm`：快速创建main函数
* `sout`：快速输入`System.out.println()`
* `fori`：快速创建for模板

### 可变参数列表

在java se5之前用的方法是输入内容放在args里面

```java
public class VarArgs {
    static void printArray(Object[] args) {
        for (Object obj : args)
            System.out.print(obj + "   ");
        System.out.println();
    }

    public static void main(String[] args) {
        printArray(new Object[] { new Integer(55), new Float(5.34),
                new Double(3.56) });
        printArray(new Object[] { "one", "two", "three" });
        printArray(new Object[] { new A(), new A(), new A() });
    }
}
```

在se5之后，就可以直接使用可变参数了，这与之前看的javascript的多参数用法一样，与python的`*args`一样，用法是`... args`

```java
public class NewVarArgs {
    static void printArray(Object... args) {
        for (Object obj : args)
            System.out.print(obj + "  ");
        System.out.println();
    }

    public static void main(String[] args) {
        printArray(new Integer(33), new Float(5.23), new Double(3.55));
        printArray(33,5.23f,3.55d);
        printArray("one","two","three");
        printArray(new A(),new A(),new A());
        printArray((Object[])new Integer[]{1,2,3,4,5,6});
        printArray();
    }

}
```

### 枚举enum

枚举可以用于switch语句，自带ordinal()方法用于得到index，和values方法用于创建数组

```java
public static void main(String[] args) {
    for (Money m : Money.values()){
        System.out.println("money " + m);
    }
    Money money;
    switch(money){
        case one: System.out.println("case one");break;
        case two://剩余逻辑
        case default: //xxxx
    }
enum Money{
    one,five,ten,twenty,fifty,hundred
}
```

## 访问权限控制

### 包

一个包里面有多各类，然而有且仅有一个public类与包的名字相同，其他类主要为public类提供支持

### 包定义与引用

声明包的方法是用`package`关键字

```java
package my.mypackage
public class Myclass{}
```

引用的方法可以写全`包名+类名`，或者是使用`import 包名`

### 访问权限控制

public：都可以访问

private：只有拥有成员的当前类可以访问

protected：当前和继承的对象可以访问

### 封装

将类中的属性标记为private，外部代码不可以直接访问类元素，而是通过一些封装好的函数来访问，比如

```java
public class Person {
    private String name;
    private int age;
    public void setAge(int age) {
        this.age = age;
    }
    
    public void setName(String name) {
        this.name = name.trim();
    }
    
    public int getAge() {
        return age;
    }
    
    public String getName() {
        return name;
    }
}
```

### 重载和重写

重载：与父类的函数名相同，返回值类型相同，但是**参数类型不同**

重写（覆写）：与父类的**函数名和参数都相同**，只是函数内容不同

se5中引入了一个`@override`关键字，在你想要重写的时候，可以把这个关键字放在返回值之前，如果不是重写，那么将会报错

```java
class Lisa extends Homer{
    @override 
    void doh(Milhouse m){
        System.out.println('doh(Milhouse)')
    }
}
```

### 继承

关键字`extends`，子类继承了父类所有元素和方法，可以重写这些方法

java只允许单继承，也就是每个类只能有一个父类

用`super()`表示父类的构造方法，用`super.函数名()`调用父类中被覆写的方法

```java
public class Student extends Person{
    private int score;

    public void setScore(int score){
        this.score = score;
    }

    public int getScore() {
        return score;
    }
    
    public String hello(){
        return super().hello() + "!";
    }
}

```

#### 向上向下转型

在java中，一个类型可以安全地向上转型，因为一个子类肯定包含父类的所有元素和方法，但是父类不一定能够安全地向下转型。

转型之前先用`instanceof`判断

```java
if (p instanceof Student){
    p = (Student) p;
}
```

### 多态

java的方法调用总是作用于对象的实际类型

如果一个变量的声明类型和实际类型值不同，那么他调用方法的时候，调用的是实际类型的方法

在java中，多态的含义是：

* 针对某个类型的方法调用，其真正执行的方法取决于运行时期的实际类型的方法
* 对某个类型调用某个方法，执行的方法可能是某个子类的覆写方法
* 利用多态，允许添加更多类型的子类实现功能扩展

```java
public class Hello {
    public static void main(String[] args) {
        Person p = new Person();
        Person s = new Student();
        p.run(); //unamed run
        s.run(); //student run
    }
}

class Person{
    protected String name;
    private int age;
    Person(String name, int age){
        this.name = name;
        this.age = age;
    }
    Person(){
        this("unamed",0);
    }
    public void run(){
        System.out.println(this.name +  "run");
    }
}

class Student extends Person{
    public void run(){
        System.out.println("student "+  "run");
    }
}
```

java中所有类都继承于object，因此拥有object的所有方法，object中定义了如下的重要方法

* `toString`：把instance输出为String
* `equals`：判断两个instance是否逻辑相等
* `hashCode`：计算一个instance的hash值

#### final

* 用`final`关键字修饰的**方法**不能被override

* 用`final`关键字修饰的**类**不能被继承

* 用`final`关键字修饰的**字段**在初始化之后不能被修改

### 抽象类

如果一个类包含一个抽象方法，那么这个类就是抽象类

抽象方法：就是一个只有函数名，但是没有函数主体

用abstract关键字修饰，抽象方法无法被实例化，但其子类可以被实例化

```java
public abstract class Person{
    public abstract void run();
        }
```

抽象方法的作用就是用来**被继承**

从抽象类继承的子类必须实现抽象方法，不然该子类仍是一个抽象类

```java
public class Rectangle extends Shape {
    private double width;
    private double height;
    Rectangle(double width, double height){
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width*height;
    }
}
```

### 接口

如果一个抽象类没有字段，并且所有方法都是抽象方法，那么我们就可以把这个抽象类改写为接口

接口用interface进行声明，接口默认的是public和abstract，所以在定义接口的时候不用写public和abstract

```java
public interface Shape {
 double area();
 default double perimeter(){return 0;};
}
```

`default`关键字可以实现interface的默认方法，这样就不必在每个implements中实现这个方法

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-7-25/70419102.jpg)

一个接口可以用extends继承另一个接口

### 包

java定义的名字空间叫做包，用于解决名字冲突的问题

```java
package xiaoming;
public class Person{}
```

```java
package xiaohong;
public class Person{};
```

小明的Person类：xiaoming.Person

小红的Person类：xiaohong.Person

#### 包作用域

同一个包中的类，可以访问包作用域的字段和方法

包作用域就是不使用任何public，private，protected修饰的字段和方法

### classpath

classpath是一个环境变量，定义java如何搜索class的路径，在windows中用分号`；`分割，在Linux和mac中用冒号`:`分割，如果目录含有空格，这个路径就要用双引号括起来

先找当前目录，然后找classpathPATH的路径

运行java的时候可以通过`java -cp classpath`指定当前运行java时候的classpath

### jar包

jar包是一种zip格式的压缩文件，包含若干个.class文件

jar包相当于目录，classpath可以包含jar文件

一个jar包中可以包含另一个jar包

JDK自带的class叫做rt.jar

### idea打包jar包的方法

1.选择菜单File->Project Structure，将弹出Project Structure的设置对话框。

2.选择左边的Artifacts后点击上方的“+”按钮

3.在弹出的框中选择jar->from moduls with dependencies..

4.选择要启动的类，然后 确定

5.应用之后选择菜单Build->Build Artifacts,选择Build或者Rebuild后即可生成，生成的jar文件位于工程项目目录的out/artifacts下。

 ### String字符串类型

String可以不用new来实例化，可以通过双引号`String s = "xxx"`直接赋值

String的内容是不可以变的，对比两个string是否相同要调用string的equal方法，equalIgnoreCase，这个方法可以忽略大小写

String提供的方法：

* contains：查看是否包含子串
* indexOf：找到子串的索引位置
* lastIndexOf：从后向前找
* startswith：返回字符串是否由某个子串开始
* endwith：返回字符串是否由某个子串结束
* trim：移除首位的空白字符，`String S = "\t abc\r\n ；String S2 = S.trim()"`
* substring：提取子串，`String S="hello, world"; String S1 = S.substring(7)//"world";s.substring(1,5)//"ello"`，从0开始，包含最后一个数字
* toUppercase, toLowerCase：转换大小写
* replace：替换子串
* replaceAll：用正则表达式替换子串
* join：将一个String数组连接成一个字符串
* valueOf：将一个整型转换为一个string类型，也可以用tostring方法转换为字符串
* Interger.parseInt("123")：将一个String类型转换为一个int类型
* toCharArray()：将String转换为char数组，`String s ="hello;        char[] c = s.toCharArray();"`
* getBytes("UTF-8")：将string转换为bytes

打印一个array的方法：`Arrays.toString(array)`

UTF-8和unicode的区别：utf-8是变长的，1-6个字节不等（英文字母只占用1个字节，节省内存）。而unicode所有内容都是2个字节的编码

#### StringBuilder

StringBuilder是一个支持链式操作的字符串拼接对象，可以不停地apped，然后用toString变成需要的字符串

```java
public static void main(String[] args) {
        StringBuilder sb = new StringBuilder(1000);
        for (int i = 0; i < 100; i++) {
            sb.append(String.valueOf(i));
        }
        System.out.println(sb.toString());
}
```

### JavaBean

很多java类都是先定义一堆private字段，然后定义相应的get和set方法，这样的类就称为JavaBean

在idea中，定义完一个private字段，在字段上点击`alt+enter`，就可以快速生成get和set方法

### enum枚举类

用于定义枚举常量

```
public enum Person {
    a,b,c,d,e;
}
```

```java
public static void main(String[] args) {
    for (Person p: Person.values()){
        System.out.println(p);
    }
```

```java
System.out.println(Person.valueOf("a").name());
```

### jdk常用工具类

1. Math类用于数学计算

   Math有random方法，可以生成一个0-1之间的数`0<=x<1`

2. Random类用于构建伪随机数
   使用之前要先实例化random

   ```java
   public static void main(String[] args) {
       Random r = new Random();
       System.out.println(r.nextInt());
       System.out.println(r.nextLong());
       System.out.println(r.nextFloat());//0-1之间的float
       System.out.println(r.nextDouble());//0-1之间的double
   }
   //结果
   //453685453
   //-6144617524281204827
   //0.8796719
   //0.9157346073901224
   ```

## 异常处理

### 异常

异常处理的方式是用try，catch

java中必须捕获的异常是Exception及其子类，但不包括RuntimeException及其子类

因为error是发生了严重错误，程序本身是无法处理的；而exception是运行时候的逻辑错误，程序可以捕获和处理这些错误，而RuntimeException是因为程序自身有bug，需要我们去修复程序

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-11/24168308.jpg)

Main方法是捕获异常的最后机会，其余子函数可以用throws将异常抛出，由上层方法来捕获

#### 异常捕获的顺序

异常是按照catch的顺序依次捕获的，所以要把更小的异常（子类）放在前面，不然父类在前面，只要发生了错误就一定会被执行

#### finally

无论是否有错都要执行就用finally

#### multi-catch

可以用或操作符`|`来同时捕获多个Exception

#### printStackTrace

printStackTrace()方法可以打印出异常的传播路径，对于调试很有用

```java
public class Main {
    public static void main(String[] args) {
        process1();
    }
    static void process1(){
        try {
            process2();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
    static void process2(){
        Integer.parseInt(null);
    }
}

//抛出如下异常：
//java.lang.NumberFormatException: null
//	at java.base/java.lang.Integer.parseInt(Integer.java:614)
//	at java.base/java.lang.Integer.parseInt(Integer.java:770)
//	at test.Main.process2(Main.java:158)
//	at test.Main.process1(Main.java:151)
//	at test.Main.main(Main.java:147)
```

#### JDK已定义的异常

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-11/18751939.jpg)

#### 自定义异常

自定义异常，最好使用RuntimeException继承得到，其构造方法可以通过ide提供的`alt+insert`插入父类的构造方法

```java
package test;

public class BaseExceptions extends RuntimeException {
    public BaseExceptions() {
    }

    public BaseExceptions(String message) {
        super(message);
    }

    public BaseExceptions(String message, Throwable cause) {
        super(message, cause);
    }

    public BaseExceptions(Throwable cause) {
        super(cause);
    }
}
```

```java
package test;

public class UserNotFoundException extends BaseExceptions {
    public UserNotFoundException() {
    }

    public UserNotFoundException(String message) {
        super(message);
    }

    public UserNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public UserNotFoundException(Throwable cause) {
        super(cause);
    }
}
```

### 断言

assert关键字，如果条件为true则继续执行，条件为false则抛出AssertionError，可以加入一个断言消息，打印出断言结果

断言是一种条件方式，只能在开发和测试阶段使用

```java
assert x>0: "x<0 now"+x;
```

### 日志

jkd自带的日志系统在java.utils.logging，可以定义格式或者是重定向到文件等

```java
public class Main {
    public static void main(String[] args) {
        Logger logger = Logger.getGlobal();
        logger.info("create new person");
        logger.log(Level.WARNING,"create failed");
        logger.info("end");
    }
}

//输出
//9月 11, 2018 10:47:09 上午 test.Main main
//信息: create new person
//9月 11, 2018 10:47:09 上午 test.Main main
//警告: create failed
//9月 11, 2018 10:47:09 上午 test.Main main
//信息: end
```

### common logging

更常用的log方法是commom logging，一共六个日志级别如下

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-11/56679818.jpg)

tips:

#### idea添加jar包的方法

1. 点击file，project structure
2. 点击左边的module，点击dependencies，点击add
3. 选择其中的add jar，选中后确定即可

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-12/59568280.jpg)

### log4j

log4j是目前最流行的日志框架，其可以输出到控制台，文件（file），或者是远程（socket）

filter用于过滤：哪些日志需要输出，哪些日志不需要输出

layout：格式化输出

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-12/97700605.jpg)

## java反射与泛型

### 反射

class/interface的数据类型是Class

将通过Class实例来获取class信息的方法称为反射（reflection）——class实例-->class信息

```java
//方法1
Class cls = String.class;
//方法2
String s= "abcd";
Class cls = s.getClass();
//方法3
Class cls = Class.forName("abc");
```

反射的目的：获得某个object实例的时候，可以获得该object的class的所有信息

从class可以判断出class的类型，class提供以下几个方法：

```java
//1
isInterface();
//2
isArray();
//3
isEnum();
//4
isPrimitive();//是否基本类型
```

判断类是否存在：

```java
Class.forName(name)
```

通过class获取Constructor

```java
getConstructor(Class):获取某个public的Constructor
getDeclaredConstructor(class)：获取某个Constructor
getConstructor()：获取所有public的Constructor
getDeclaredConstructor():获取所有Constructor    
```

#### 通过反射获得继承关系

用class的`getSuperclass()`方法获取分类的class对象，注意：object和interface的父类是null

`getInterfaces()`方法返回当前对象的interface

通过class的`isAssignabelFrom()`方法可以判断一个向上转型是否正确

### 注解

注解是放在java源码的类、方法、字段、参数前的标签，用`@`开始，有点像python的装饰器

常用的注解包括：

1. `@Override`：检查是否覆写
2. `@Deprecated`：告诉编译器该方法已经废弃，如果被调用出现警告
3. `@SuppressWarnings('unused')`：抑制警告
4. `@Time(timeout=100)`：时间检查
5. `Check(min=0,max=100,value=55)`：值的检查

#### 定义注解

用`public @interface name`来定义注解

元注解：注解可以修饰别的注解

用@Target定义Annotation可以被应用于源码的哪些位置

* 类或接口：ElementType.TYPE
* 字段：ElementType.FIELD
* 方法：ElementType.METHOD
* 构造方法：ElementType.CONSTRUCTOR
* 方法参数：ElementType.PARAMETER

```java
@Target(ElementType.METHOD)
public @interface Report{
    int type() default 0;
    String level() default "info";
    String value() default "";
}
```

Annotaiton的生命周期，用`Retention()`来定义

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-13/62763668.jpg)

用`@Repeatable`定义Annotation是否可以重复

用`@Inherited`定义子类是否可以继承父类的Anootation

#### 处理Annotation

通过反射可以处理注解，得到class对象后，可以用`class.isAnnotationPresent(Class)`来判断注解是否存在，用`class.getAnnotation()`得到Annotation

### 泛型

就是用`<>`来泛化某个类型，比如arraylist在使用过程中，你要指定这个list当中存放的元素类型，就要用`ArraryList<String> al = new ArrayList<>();`

## 集合

### List

list是一种有序链表，每个元素都可以通过索引来确定位置

常用方法包括：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-13/79886639.jpg)

list的实现有ArrayList和LinkedList两种：

ArrayList就和数组是一样的结构，当添加的时候大小不够了，就创建一个更大数组，把之前的值全部复制过去，再加一个值

而LinkedList和链表一样的结构，上一个指向下一个

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-13/21021379.jpg)

#### 遍历list的方法

1. get遍历

```java
List<String> list = new List<>();
for(int i=0;i<list.size();i++){
    String s = list.get(i);
}
```

2. Iterator遍历

```java
List<String> list = new List<>();
for (Iterator<String> it = list.iterator();it.hasNext();){
    String s = it.next();
}
```

3. foreach循环，最推荐这种方法

```java
List<String> list = new List<>();
for (String s:list){
    System.out.println(s);
}
```

#### List和Array的转换

1. Object[] toArray()

```java
List<Interger> list = new List<>();
list.add(1);
list.add(2);
list.add(3);
Object[] array = list.toArray();
```

2. `<T> T[] toArray(T[] a)`

```java
List<Interger> list = new List<>();
list.add(1);
list.add(2);
list.add(3);
Integer[] array = list.toArray(list[size]);
```

#### 查找某个元素是否存在

1. list.contains(Object o)，返回true包含，false不包含
2. list.indexOf(Object o)，返回正数就是有，返回-1就是不存在

### Map

map就是一种键值对映射的数据结构，与python中的dict是一样的

```java
public class Strudent{
    public String name;
    public String address;
    public float grade;
}
Map<String,Student> map = ...;
Student target = map.get("xiao ming")
```

map的常用方法

1. put：将key-value对放入map
2. get：通过key获取value
3. containsKey：判断key是否存在

#### 遍历Map的方法

1. 遍历key

```java
Map<String,Student> map = ...;
// 用keySet遍历key，用get方法获取值
for (String key:map.keySet()){
    Integer value = map.get(key);
}
```

2. 同时遍历key和value

```java
Map<String,Student> map = ...;
// 用entrySet同时遍历key，value
for (Map.Entry<String,Integer> entry:map.entrySet()){
    String key = entry.getKey();
    Integer value = entry.getValue();
}
```

#### HashMap和TreeMap

Map最常用的实现类是HashMap，其内部存储不保证有序

* 遍历时的顺序不一定是put的顺序，也不一定是key的顺序

SortedMap保证遍历时以key排序，其实现类是TreeMap

```java
Map<String,Integer> map = new TreeMap<>();
map.put("orange",1);
map.put("apple",2);
map.put("banana",3);
for (Map.Entry<String,Integer> entry:map.entrySet()){
    System.out.println(entry.getKey()+" "+entry.getValue());
}

```

### Set

set就是python里面的set，不包含重复值，常用方法包括

1. add
2. remove
3. contains
4. size

set不保证有序，HashSet是无序的，TreeSet是有序的

### Queue

Queue是一个FIFO的队列，常用方法包括：

1. size()：获取长度
2. 添加元素到队尾:add/offer
3. 获取队列头部元素并删除:remove/poll
4. 获取队列头部元素但不删除：element()/peek()

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-15/26816433.jpg)

Queue的实现对象是LinkedList()

### PriorityQueue

PriorityQueue就是带有优先级顺序的Queue，其常用方法与Queue相同

### Deque

是Queue的一种实现，是双向队列

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-15/95736586.jpg)

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-15/93267961.jpg)

### Stack

是一种LIFO（last In First out）的结构，常用方法

* push
* pop
* peek

使用Deque来实现stack，只调用push，pop，peek三个函数，这样就实现了栈

## IO

IO流，顺序读写数据的模式，单向流动，以字节为单位，byte类型

如果不是字节流，那么久用Reader/Writer表示字符流，字符流的最小单位是char，字符流输出的byte取决于编码方式

```java
char[] hello = "hi你好";
writeChars(hello,"utf-8");
//output.txt，英文字符占一个字节，中文占3个字节
//0x48, 0x69, 0xe4,0xbd,0xa0,0xe5,0xa5,0xbd
```

Reader/Writer本质上是一个能自动编解码的InputStream/OutputStream

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-16/53060354.jpg)

其实现类如下：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-16/43531365.jpg)

### File

构造方法

```java
File f = new File("c\\Windows\\notepad.txt")
```

file有三种路径

```java
File file = new File("./Person.java");
System.out.println("绝对路径："+file.getAbsolutePath());
//      C:\Users\jeffrey\IdeaProjects\MyHelloWorld\.\Person.java
System.out.println("canonical（规范）路径："+file.getCanonicalPath());
//      C:\Users\jeffrey\IdeaProjects\MyHelloWorld\Person.java
System.out.println("相对路径："+file.getPath());
//    .\Person.java

```

规范路径就是绝对路径删掉`.`和`..`

用`isFile()`判断是否为文件，`isDirectory()`判断是否为目录

构造file对象就算是文件不存在也不会报错，因此要用上面两个文件来判断

1. `canRead()/canWrite() `用于判断是否可以读/写
2. `createNewFile()`：创建文件
3. `createTempFile()`:创建临时文件
4. `delete()`：删除文件
5. `deleteOnExit()`：在JVM退出时删除该文件
6. `String[] list()`：列出文件目录下的文件和子目录名
7. `File[] listFiles()`：列出文件和子目录名
8. `Boolon mkdir()`：创建目录
9. `Boolon mkdirs()`：创建目录，如果上层目录不存在，同样创建

### InputStream

是所有输入流的超类，最重要的方法是`abstract int read()`，读取下一个字节，并返回字节(0-255)，如果已经读到末尾，返回-1

完整读取一个inputstream流程如下：

1. 方法1：用finally保证文件被关闭

```java
InputStream input = new FileInputStream("./src/test/a.txt");
try {
    int n;
    while ((n = input.read())!=-1){
        System.out.println(n);
    }
}
finally {
    if (input!=null){
        input.close();
    }
}
```

2. 用jdk1.7新增的try写法保证inputStream自动关闭，类似于python的with open('xxx') as f

```java
try (InputStream input = new FileInputStream("./src/test/a.txt")) {
    int n;
    while ((n = input.read()) != -1) {
        System.out.println(n);
    }
}
```

3. 用数组一次读取多个字节

```java
try (InputStream input = new FileInputStream("./src/test/a.txt")) {
    byte[] buffer = new byte[1000];
    int n;
    while ((n=input.read(buffer))!=-1){
        System.out.println(n);
    }
}
```

### Reader/Writer

reader读取的是字符，其read方法读取下一个字符，读到末尾时返回-1

Writer读取的也是字符，write方法写入

## java处理时间

计算机用时间戳来表示时间，这样全球统一表示，然后需要哪个时区的时候再转换为那个时区

java通常使用Date和Calendar处理时间，1.8之后使用LocalDate，LocalTime，ZonedDateTime，Instant

```java
Date date = new Date();
System.out.println(System.currentTimeMillis());
System.out.println(date);
System.out.println(date.getTime());
System.out.println(new Date(System.currentTimeMillis()));
```

### LocalDate

```java
LocalTime localTime = LocalTime.now();
LocalDate localDate = LocalDate.now();
LocalDateTime lt = LocalDateTime.now();
System.out.println(localDate);
System.out.println(localTime);
System.out.println(lt);
```

用DateTimeFormatter来格式化时间

```java
DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
System.out.println(dtf.format(lt));
LocalDateTime dt2 = LocalDateTime.parse("2016/11/30 15:16:17",dtf);
System.out.println(dt2);
```

新api加入了时间增减的运算，plusDays()增加天数，minusHours()介绍小时

还加入了对时间的调整，比如你获取到了当前日期，你可以使用`withDayOfMounth(1)`，把日期调整到本月的第一天，`withMonth()`：调整到第几个月；还可以用with方法，计算本月的最后一天，方法如下

```java
//计算本月最后一天
LocalDate lastDay = LocalDate.now().with(TemporalAdjusters.lastDayOfMonth());
System.out.println(lastDay);
//计算本月第一个周末
LocalDate firstSunday = LocalDate.now().with(TemporalAdjusters.firstInMonth(DayOfWeek.SUNDAY));
System.out.println(firstSunday);
```

还可以判断时间的先后

1. isBefore()
2. isAfter()
3. equals()

得到当前的Period，就是一段时间间隔的Year，month，day

```
LocalDate d1 = LocalDate.of(2014,3,12);
LocalDate d2 = LocalDate.now();
Period p = d1.until(d2);
System.out.println(d2.toEpochDay()-d1.toEpochDay());
```

### ZonedDateTime

就是一个localtime加上一个时区ZoneId

```java
LocalDateTime d1 = LocalDateTime.of(2014,3,12,8,0);
//转换到北京时区
ZonedDateTime bj = d1.atZone(ZoneId.systemDefault());
System.out.println(bj);
//转换到纽约时区
ZonedDateTime ny = d1.atZone(ZoneId.of("America/New_York"));

//从北京时区转换到纽约时区
ZonedDateTime ny1 = bj.withZoneSameInstant(ZoneId.of("America/New_York"));
```

instant表示时刻

## 多线程编程

要启动一个新的线程，首先要创建一个新的线程对象

```java
Thread t = new Thread();
t.start();
```

将自己的线程extends Thread，覆写其中的run方法

```java
public class MyThread extends Thread{
    public void run{
        System.out.println();
    }
}
public class Main{
    public static void main(String[] args){
        Thread t = New Mythread();
        t.start();
}}
```

如果本身已经extends，就用implements Runnable，覆写其中的run方法

```java
public class MyThread implements Runnable{
    public void run{
        System.out.println();
    }
}
public class Main{
    public static void main(String[] args){
        Runnable r = New Mythread();
        Thread t = new Thread(r);
        t.start();
}}
```

一个实现的例子如下：

```java
System.out.println("Main start.....");
Thread t = new Thread(){
    public void run(){
        System.out.println("thread run.....");
        System.out.println("thread end.....");
    }
};
    t.start();
    System.out.println("Main end......");
}
```

### 线程状态

一个线程只能调用一次start

线程的状态如下：

* New：新创建
* Runnable：运行中
* Blocked：被阻塞
* Waiting：等待
* Timed Waiting：计时等待
* Terminated：终止

线程终止的原因有：

* run执行到return
* 因未捕获的异常终止

#### join

线程的join方法就是等待该线程结束，才继续向下运行

### 中断线程

中断线程需要检测一个isIterrupted标志，调用isIterrupte()方法中断线程

线程之间共享变量需要使用关键字volatile，确保线程能读到更新后的变量值

```java
public class Main {
    public static void main(String[] args) throws IOException, InterruptedException {
    System.out.println("Main start.....");
    Thread t = new HelloThread();
    t.start();
    Thread.sleep(1000);
    t.interrupt();
    System.out.println("Main end......");
}
}

class HelloThread extends Thread{
    @Override
    public void run() {
        while (!isInterrupted()) {
        System.out.println("true");
}
}
}
```

也可以用标志位来中断线程，要用到volatile关键字：

```java
class HelloThread extends Thread{
    volatile boolean running = true;
    @Override
    public void run() {
        while (running) {
            System.out.println("true");
        }
}
```

### 守护线程

守护线程的关键字是`t.setDaemon(true)`

守护线程是为其他线程服务的线程，守护线程在其他所有非守护线程结束的时候结束线程

守护线程不能持有任何资源（打开文件等）

如下，如果不使用守护线程，那么在主线程结束后，下面那个打印时间的线程就无法停下来

```java
public static void main(String[] args){
System.out.println("main start");
        Timerthread t = new Timerthread();
        t.start();
        System.out.println("main end");
}

class Timerthread extends Thread{
    @Override
    public void run() {
        while (true)
        {     System.out.println(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss")));
            try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            break;
        }
    }
    }
}
```

### 线程同步

当多个线程同时运行的时候，就需要对其同步，比如下面这个例子，对一个count+10000次，再-10000次，最终结果不为0，这是因为对共享变量写入的时候，必须是原子操作（不能被中断的操作），这时就需要线程同步。

```java
Public class Main{
    public int count = 0;
	public static void main(String[] args) {
        Thread t1 = new AddThread();
        Thread t2 = new DecThread();
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        System.out.println(count);
}}

class AddThread extends Thread{
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            Main.count +=1;
        }
    }
}

class DecThread extends Thread{
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            Main.count -=1;
        }
    }
}
```

不对的原因：加法的执行过程是load，add，store，如果中间被打断了，比如先执行了Thread 1的load，然后用了thread2的load，add，store操作，再回来执行thread的add操作，此时n仍然是100，因为已经load为100了，所以两次加法之后n只加了1次，等于101，因此必须加解锁

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-17/43911450.jpg)

用synchronized对对象进行加锁，其他线程就算开始执行，没有获得锁，也无法执行

```java
synchronized(lock){
    n += 1;
    m -= 1;
    p = m + n
}
```

上面问题的加锁过程如下：

```java
public class Main{    
public static final Object Lock = new Object();
}



class AddThread extends Thread{
    @Override
    public void run() {

        for (int i = 0; i < 10000; i++) {
            synchronized (Main.Lock){
            Main.count +=1;
            }
        }
    }
}

class DecThread extends Thread{
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            synchronized (Main.Lock){
            Main.count -=1;
            }
        }
    }
}
```

## Maven

Maven是一个项目管理工具，用于管理java代码及文件的编译，打包等过程

用Maven管理的项目路径如下：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-17/42386933.jpg)













