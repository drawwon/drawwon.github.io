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

### 垃圾回收

所有用new构建的对象，java都会自动回收，只有那些不是用new得到的对象所占用的内存，java无法处理，需要你编写`finalize()`函数来进行垃圾回收

1. 对象可能不被垃圾回收
2. 垃圾回收不等于“析构”
3. 垃圾回收只与内存有关











