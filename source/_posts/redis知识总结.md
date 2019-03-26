---
title: redis知识总结
mathjax: true
date: 2018-03-24 15:04:16
tags: [redis]
category: [工作]
---

# 一、Redis

## 1. 简介

**单线程为什么这么快？**

1. 纯内存
2. 非阻塞IO
3. 避免线程切换和竞争消耗

**单线程Redis注意事项**

1. 一次只运行一条命令
2. 拒绝长（慢）命令，例如：keys、flushall、flushdb、slow lua script、mutil/exec、operate big value(collection)
3. Redis其实不是单线程，fysnc file descriptor进行持久化

**Redis特点**

1. 速度快
2. 持久化
3. 多钟数据结构
4. 支持多种编程语言
5. 功能丰富
6. 简单
7. 主从复制
8. 高可用，分布式

**补充知识：同步非同步，阻塞非阻塞**

**1. 同步和异步关注的是消息通信机制** (synchronous communication/ asynchronous communication)

所谓同步，就是在发出一个调用时，在没有得到结果之前，该调用就不返回。但是一旦调用返回，就得到返回值了。换句话说，就是由调用者主动等待这个调用的结果。

异步则是相反，调用在发出之后，这个调用就直接返回了，所以没有返回结果。换句话说，当一个异步过程调用发出后，调用者不会立刻得到结果。而是在调用发出后，被调用者通过状态、通知来通知调用者，或通过回调函数处理这个调用。

总结：同步和异步主要关注的是不是调用函数自己返回调用结果，同步是调用者返回调用结果，异步是调用发出后立马返回空值，由回调函数返回调用结果

**2.阻塞与非阻塞**

**阻塞和非阻塞关注的是程序在等待调用结果（消息，返回值）时的状态.**

阻塞调用是指调用结果返回之前，当前线程会被挂起。调用线程只有在得到结果之后才会返回。
非阻塞调用指在不能立刻得到结果之前，该调用不会阻塞当前线程。

## 2. 应用场景

缓存系统、排行榜、计数器、社交网络、消息队列系统、实时系统

## 3. 数据类型

支持的数据类型：字符串、列表、集合、字典（hash）、有序集合(ZSET)

## 4.持久化

1. Redis 默认开启RDB持久化方式，在指定的时间间隔内，执行指定次数的写操作，则将内存中的数据写入到磁盘中。
2. RDB (Redis Database Backup)持久化适合大规模的数据恢复但它的数据一致性和完整性较差。
3. Redis 需要手动开启AOF(Append Only File)持久化方式，默认是每秒将写操作日志追加到AOF文件中。
4. AOF 的数据完整性比RDB高，但记录内容多了，会影响数据恢复的效率。

## 5.基本指令

1. string

```
set key value [EX seconds] [PX ms] [nx|xx]
```

- key: 键名
- value: 键值
- ex seconds: 键秒级过期时间
- ex ms: 键毫秒及过期时间
- nx: 键不存在才能设置，setnx和nx选项作用一样，用于添加，分布式锁的实现
- xx: 键存在才能设置，setxx和xx选项作用一样，用于更新

2. list

   rpush：右边插入

   lrange list-key start end：列出start到end范围的key值

3. set

   sadd set-key item：set插入值

   smembers set-key：列出set的key值

   sismember set-key item4：查看是否set的member

   srem set-key item2：set remove key

4. hash

   hset user name LotusChing：设置user的name为lotus

   hset user age 21

   hget user name：获取user的name

   hkeys user：获取user的key值

   hvals user：获取user的键值

   hdel user age：删除hash中某个键

   hlen user：获取user的键值对个数

   hmset user name "LotusChing" age 21 gender "Male"：批量设置key-value

   hmget user name age gender：批量获取value

5. zset

   zadd zset-key 728 member1：加入值为728，key为member1的键值对