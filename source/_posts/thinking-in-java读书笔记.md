---
title: thinking in java读书笔记
mathjax: true
date: 2018-06-24 16:38:23
tags: [Java]
category: [java,编程学习]
---

## 基础语法

大多数语法与c++相似，只记录部分不熟悉的或者是不一样的语法

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









