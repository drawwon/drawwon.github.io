---
title: java常用数据结构
mathjax: true
date: 2018-09-27 10:18:49
tags: [数据结构]
category: [java]
---

java.util包中三个重要的接口及特点：List（列表）、Set（保证集合中元素唯一）、Map（维护多个key-value键值对，保证key唯一）。其不同子类的实现各有差异，如是否同步（线程安全）、是否有序。

<!--more-->

java常见数据结构：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-27/36575200.jpg)

java常见数据结构的主要方法

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-9-27/39355028.jpg)

**可根据实际情况来选择使用ArrayList（非同步、非频繁删除时选择）、Vector（需同步时选择）、LinkedList（频繁在任意位置插入、删除时选择）。**

### HashMap和Hashtable的区别

 HashMap和Hashtable都实现了Map接口，但决定用哪一个之前先要弄清楚它们之间的分别。主要的区别有：线程安全性，同步(synchronization)，以及速度。

1. HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，并可以接受null(HashMap可以接受为null的键值(key)和值(value)，而Hashtable则不行)。
2. HashMap是非synchronized，而Hashtable是synchronized，这意味着Hashtable是线程安全的，多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的。Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好。
3. 另一个区别是HashMap的迭代器(Iterator)是fail-fast迭代器，而Hashtable的enumerator迭代器不是fail-fast的。所以当有其它线程改变了HashMap的结构（增加或者移除元素），将会抛出ConcurrentModificationException，但迭代器本身的remove()方法移除元素则不会抛出ConcurrentModificationException异常。但这并不是一个一定发生的行为，要看JVM。这条同样也是Enumeration和Iterator的区别。
4. 由于Hashtable是线程安全的也是synchronized，所以在单线程环境下它比HashMap要慢。如果你不需要同步，只需要单一线程，那么使用HashMap性能要好过Hashtable。
5. HashMap不能保证随着时间的推移Map中的元素次序是不变的。



### 初始化方法

1. list
   初始化方法1：

   ```java
   List<String> s = new ArrayList();
   s.add("a");
   s.add("b");
   System.out.println(s.toString());
   ```

   初始化方法2：

   ```java
   List<String> s = Arrays.asList("a","b");
   System.out.println(s.toString());
   ```

2. Map

   ```java
   Map<String,String> map = new HashMap<>();
   map.put("a","b");
   map.put("c","d");
   System.out.println(map.toString());
   //输出格式为 {a=b,c=d}
   ```
