---
title: metaspace解析
mathjax: true
date: 2019-07-02 21:41:48
tags: [java,jvm]
category: [java]
---

## 概述

metaspace：顾名思义元数据空间，专门用来存储元数据，他是jdk8中特有的数据结构用来代替perm (permanent space：永久代)。

<!--more-->

## 为什么有metaspace

jdk8之前有perm这一整块内存来寸klass等信息，我们的参数也会配置perm区域的大小：-XX: PermSize以及-XX：MaxPermSize来控制这块内存的大小，jvm在启动时会根据这些配置来分配一块连续的内存块，但随着动态类加载的轻快越来越多，这块内存变得不太可控，到底设置多大合适是每个开发这一要考虑的问题，设置太小，系统容易出现内存溢出，设置太大会造成浪费。基于这样的一个原因，metaspace出现了，希望内存的管理不再受到限制，也不要怎么关注元数据这块的OOM问题。到目前为止，没有完美解决这个问题。

从JVM代码中可以看出一些问题，比如MaxMetaSpaceSize默认值很大，CompressedClassSpaceSize默认值也有1G，从这些参数可以看到metaspace的作者不希望出现OOM相关的问题。

### oop-klass model 概述

上文提到了klass这个信息，这里有必要解释一下。

HotSpot JVM 并没有根据 Java 实例对象直接通过虚拟机映射到新建的 C++ 对象，而是设计了一个 oop-klass model。

当时第一次看到 oop，我的第一反应就是 object-oriented programming，其实这里的 `oop` 指的是 *Ordinary Object Pointer*（普通对象指针），它用来表示对象的实例信息，看起来像个指针实际上是藏在指针里的对象。而 `klass` 则包含 **元数据和方法信息**，用来描述 Java 类。

那么为何要设计这样一个一分为二的对象模型呢？这是因为 HotSopt JVM 的设计者不想让每个对象中都含有一个 vtable（虚函数表），所以就把对象模型拆成 klass 和 oop，其中 oop 中不含有任何虚函数，而 klass 就含有虚函数表，可以进行 method dispatch。这个模型其实是参照的 **Strongtalk VM** 底层的对象模型。

## metaspace的组成

metaspace主要有由两大部分组成：

* Klass MetaSpace
* NoKlass MetaSpace

Klass MetaSpace就是用来寸klass的，klass是我们熟知的class文件在jvm里的运行时数据结构，不过有点要提到的是我们看到的类似A.class其实是存在heap里的，是java.lang.class的一个对象实例，这块内存是近接着Heap的，和之前的perm一样，这块内存大小可通过-XX:CompressedClassSpaceSize参数来控制住，这个参数默认是1G，但是这块内存可以没有，假如没有开启压缩指针就不会有这块内存，这种情况下klass都会存在NoKlass Metaspace里面，另外如果我们把-Xmx设置大于32G的话，也没有这块内存，隐者这么大内存会关闭压缩指针开关，还有就是这块内存最多存在一块。

NoKlass MetaSpace专门用来存放klass相关的其他内容，比如method，constantPool等，这块内存是由多块内存组合起来的。所以可以认为是不连续的内存块组成的，这块内存是必须的，虽然叫NoKlass MetaSpace，但是也可以寸klass的内容。

Klass MetaSpace和NoKlass MetaSpace都是所有classloader共享的，所以类加载器们要分配内存，每个类加载器都有一个SpaceManager，来管理属于这个类加载的内存小块，如果klass metaspace用完了，就会OOM，不过一般情况下，NoKlass MetaSpace是由一块块内存组合起来的，在没有达到限制条件的情况下，会不断增长这条链，让它可以继续工作。

## metaspace的几个参数

* UseLargePagesInMetaspace
* InitialBootClassLoaderMetaspaceSize
* MetaspaceSize
* MaxMetaspaceSize
* CompressedClassSpaceSize
* MinMetaspaceExpansion
* MaxMetaspaceExpansion
* MinMetaspaceFreeRatio
* MaxMetaspaceFreeRatio

### UseLargePagesInMetaspace

默认false，这个参数是说是否在metaspace里使用LargePage，一般情况下我们使用4KB的page size，这个参数依赖于UseLargePages这个参数开启，不过这个参数我们一般不开。

### InitialBootClassLoaderMetaspaceSize

64位下默认4M，32位下默认2200K，metasapce前面已经提到主要分了两大块，Klass Metaspace以及NoKlass Metaspace，而NoKlass Metaspace是由一块块内存组合起来的，这个参数决定了NoKlass Metaspace的第一个内存Block的大小，即2*InitialBootClassLoaderMetaspaceSize，同时为bootstrapClassLoader的第一块内存chunk分配了InitialBootClassLoaderMetaspaceSize的大小

### MetaspaceSize

默认20.8M左右(x86下开启c2模式)，主要是控制metaspaceGC发生的初始阈值，也是最小阈值，但是触发metaspaceGC的阈值是不断变化的，与之对比的主要是指Klass Metaspace与NoKlass Metaspace两块committed的内存和。

### MaxMetaspaceSize

默认基本是无穷大，但是我还是建议大家设置这个参数，因为很可能会因为没有限制而导致metaspace被无止境使用(一般是内存泄漏)而被OS Kill。这个参数会限制metaspace(包括了Klass Metaspace以及NoKlass Metaspace)被committed的内存大小，会保证committed的内存不会超过这个值，一旦超过就会触发GC，这里要注意和MaxPermSize的区别，MaxMetaspaceSize并不会在jvm启动的时候分配一块这么大的内存出来，而MaxPermSize是会分配一块这么大的内存的。

### CompressedClassSpaceSize

默认1G，这个参数主要是设置Klass Metaspace的大小，不过这个参数设置了也不一定起作用，前提是能开启压缩指针，假如-Xmx超过了32G，压缩指针是开启不来的。如果有Klass Metaspace，那这块内存是和Heap连着的。

### MinMetaspaceExpansion

MinMetaspaceExpansion和MaxMetaspaceExpansion这两个参数或许和大家认识的并不一样，也许很多人会认为这两个参数不就是内存不够的时候，然后扩容的最小大小吗？其实不然

这两个参数和扩容其实并没有直接的关系，也就是并不是为了增大committed的内存，而是为了增大触发metaspace GC的阈值

这两个参数主要是在比较特殊的场景下救急使用，比如gcLocker或者`should_concurrent_collect`的一些场景，因为这些场景下接下来会做一次GC，相信在接下来的GC中可能会释放一些metaspace的内存，于是先临时扩大下metaspace触发GC的阈值，而有些内存分配失败其实正好是因为这个阈值触顶导致的，于是可以通过增大阈值暂时绕过去

默认332.8K，增大触发metaspace GC阈值的最小要求。假如我们要救急分配的内存很小，没有达到MinMetaspaceExpansion，但是我们会将这次触发metaspace GC的阈值提升MinMetaspaceExpansion，之所以要大于这次要分配的内存大小主要是为了防止别的线程也有类似的请求而频繁触发相关的操作，不过如果要分配的内存超过了MaxMetaspaceExpansion，那MinMetaspaceExpansion将会是要分配的内存大小基础上的一个增量

### MaxMetaspaceExpansion

默认5.2M，增大触发metaspace GC阈值的最大要求。假如说我们要分配的内存超过了MinMetaspaceExpansion但是低于MaxMetaspaceExpansion，那增量是MaxMetaspaceExpansion，如果超过了MaxMetaspaceExpansion，那增量是MinMetaspaceExpansion加上要分配的内存大小

注：每次分配只会给对应的线程一次扩展触发metaspace GC阈值的机会，如果扩展了，但是还不能分配，那就只能等着做GC了

### MinMetaspaceFreeRatio

MinMetaspaceFreeRatio和下面的MaxMetaspaceFreeRatio，主要是影响触发metaspaceGC的阈值

默认40，表示每次GC完之后，假设我们允许接下来metaspace可以继续被commit的内存占到了被commit之后总共committed的内存量的MinMetaspaceFreeRatio%，如果这个总共被committed的量比当前触发metaspaceGC的阈值要大，那么将尝试做扩容，也就是增大触发metaspaceGC的阈值，不过这个增量至少是MinMetaspaceExpansion才会做，不然不会增加这个阈值

这个参数主要是为了避免触发metaspaceGC的阈值和gc之后committed的内存的量比较接近，于是将这个阈值进行扩大

一般情况下在gc完之后，如果被committed的量还是比较大的时候，换个说法就是离触发metaspaceGC的阈值比较接近的时候，这个调整会比较明显

注：这里不用gc之后used的量来算，主要是担心可能出现committed的量超过了触发metaspaceGC的阈值，这种情况一旦发生会很危险，会不断做gc，这应该是jdk8在某个版本之后才修复的bug

### MaxMetaspaceFreeRatio

默认70，这个参数和上面的参数基本是相反的，是为了避免触发metaspaceGC的阈值过大，而想对这个值进行缩小。这个参数在gc之后committed的内存比较小的时候并且离触发metaspaceGC的阈值比较远的时候，调整会比较明显

## jstat里的metaspace字段

我们看GC是否异常，除了通过GC日志来做分析之外，我们还可以通过jstat这样的工具展示的数据来分析，前面我公众号里有篇文章介绍了jstat这块的实现，有兴趣的可以到我的公众号`你假笨`里去翻阅下jstat的这篇文章。

我们通过jstat可以看到metaspace相关的这么一些指标，分别是`M`，`CCS`，`MC`，`MU`，`CCSC`，`CCSU`，`MCMN`，`MCMX`，`CCSMN`，`CCSMX`

它们的定义如下：

```
column {
    header "^M^"  /* Metaspace - Percent Used */
    data (1-((sun.gc.metaspace.capacity - sun.gc.metaspace.used)/sun.gc.metaspace.capacity)) * 100
    align right
    width 6
    scale raw
    format "0.00"
  }
  column {
    header "^CCS^"    /* Compressed Class Space - Percent Used */
    data (1-((sun.gc.compressedclassspace.capacity - sun.gc.compressedclassspace.used)/sun.gc.compressedclassspace.capacity)) * 100
    align right
    width 6
    scale raw
    format "0.00"
  }

  column {
    header "^MC^" /* Metaspace Capacity - Current */
    data sun.gc.metaspace.capacity
    align center
    width 6
    scale K
    format "0.0"
  }
  column {
    header "^MU^" /* Metaspae Used */
    data sun.gc.metaspace.used
    align center
    width 6
    scale K
    format "0.0"
  }
   column {
    header "^CCSC^"   /* Compressed Class Space Capacity - Current */
    data sun.gc.compressedclassspace.capacity
    width 8
    align right
    scale K
    format "0.0"
  }
  column {
    header "^CCSU^"   /* Compressed Class Space Used */
    data sun.gc.compressedclassspace.used
    width 8
    align right
    scale K
    format "0.0"
  }
  column {
    header "^MCMN^"   /* Metaspace Capacity - Minimum */
    data sun.gc.metaspace.minCapacity
    scale K
    align right
    width 8
    format "0.0"
  }
  column {
    header "^MCMX^"   /* Metaspace Capacity - Maximum */
    data sun.gc.metaspace.maxCapacity
    scale K
    align right
    width 8
    format "0.0"
  }
  column {
    header "^CCSMN^"    /* Compressed Class Space Capacity - Minimum */
    data sun.gc.compressedclassspace.minCapacity
    scale K
    align right
    width 8
    format "0.0"
  }
  column {
    header "^CCSMX^"  /* Compressed Class Space Capacity - Maximum */
    data sun.gc.compressedclassspace.maxCapacity
    scale K
    align right
    width 8
    format "0.0"
  }
```

我这里对这些字段分类介绍下

### MC & MU & CCSC & CCSU

- MC表示Klass Metaspace以及NoKlass Metaspace两者总共committed的内存大小，单位是KB，虽然从上面的定义里我们看到了是capacity，但是实质上计算的时候并不是capacity，而是committed，这个是要注意的
- MU这个无可厚非，说的就是Klass Metaspace以及NoKlass Metaspace两者已经使用了的内存大小
- CCSC表示的是Klass Metaspace的已经被commit的内存大小，单位也是KB
- CCSU表示Klass Metaspace的已经被使用的内存大小

### M & CCS

- M表示的是Klass Metaspace以及NoKlass Metaspace两者总共的使用率，其实可以根据上面的四个指标算出来，即(CCSU+MU)/(CCSC+MC)
- CCS表示的是NoKlass Metaspace的使用率，也就是CCSU/CCSC算出来的

PS：所以我们有时候看到M的值达到了90%以上，其实这个并不一定说明metaspace用了很多了，因为内存是慢慢commit的，所以我们的分母是慢慢变大的，不过当我们committed到一定量的时候就不会再增长了

### MCMN & MCMX & CCSMN & CCSMX

- MCMN和CCSMN这两个值大家可以忽略，一直都是0
- MCMX表示Klass Metaspace以及NoKlass Metaspace两者总共的reserved的内存大小，比如默认情况下Klass Metaspace是通过CompressedClassSpaceSize这个参数来reserved 1G的内存，NoKlass Metaspace默认reserved的内存大小是2* InitialBootClassLoaderMetaspaceSize
- CCSMX表示Klass Metaspace reserved的内存大小

综上所述，其实看metaspace最主要的还是看`MC`，`MU`，`CCSC`，`CCSU`这几个具体的大小来判断metaspace到底用了多少更靠谱

本来还想写metaspace内存分配和GC的内容，不过那块说起来又是一个比较大的话题，因为那块大家看起来可能会比较枯燥，有机会再写

PS:本文最先发布在听云博客