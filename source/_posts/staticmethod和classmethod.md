---
ptitle: staticmethod和classmethod
mathjax: true
date: 2018-09-13 14:44:00
tags: [python]
category: [python]
---

一般来说，要使用某个类的方法，需要先实例化一个对象再调用方法。

而使用@staticmethod或@classmethod，就可以不需要实例化，直接类名.方法名()来调用。

这有利于组织代码，把某些应该属于某个类的函数给放到那个类里去，同时有利于命名空间的整洁。

<!--more-->



既然@staticmethod和@classmethod都可以直接类名.方法名()来调用，那他们有什么区别呢

从它们的使用上来看,

- @staticmethod不需要表示自身对象的self和自身类的cls参数，就跟使用函数一样。
- @classmethod也不需要self参数，但第一个参数需要是表示自身类的cls参数。

如果在@staticmethod中要调用到这个类的一些属性方法，只能直接类名.属性名或类名.方法名。

而@classmethod因为持有cls参数，可以来调用类的属性，类的方法，实例化对象等，避免硬编码。

下面上代码。

```python
class A(object):
    bar = 1
    def foo(self):
        print 'foo'
    @staticmethod
    def static_foo():
        print 'static_foo'
        print A.bar
    @classmethod
    def class_foo(cls):
        print 'class_foo'
        print cls.bar
        cls().foo()

A.static_foo()
A.class_foo()
```

输出

```
static_foo
1
class_foo
1
foo
```



再看一个例子，是classmethod用于处理init的重构问题的：

看下面的定义的一个时间类：

```python
class Data_test(object):
    day=0
    month=0
    year=0
    def __init__(self,year=0,month=0,day=0):
        self.day=day
        self.month=month
        self.year=year

    def out_date(self):
        print "year :"
        print self.year
        print "month :"
        print self.month
        print "day :"
        print self.day

t=Data_test(2016,8,1)
t.out_date()
```

输出：

```text
year :
2016
month :
8
day :
1
```

符合期望。

如果用户输入的是 "2016-8-1" 这样的字符格式，那么就需要调用Date_test 类前做一下处理：

```python
string_date='2016-8-1'
year,month,day=map(int,string_date.split('-'))
s=Data_test(year,month,day)
```

先把‘2016-8-1’ 分解成 year，month，day 三个变量，然后转成int，再调用Date_test(year,month,day)函数。 也很符合期望。

那我可不可以把这个字符串处理的函数放到 Date_test 类当中呢？

那么@classmethod 就开始出场了

```python
class Data_test2(object):
    day=0
    month=0
    year=0
    def __init__(self,year=0,month=0,day=0):
        self.day=day
        self.month=month
        self.year=year

    @classmethod
    def get_date(cls,string_date):
        #这里第一个参数是cls， 表示调用当前的类名
        year,month,day=map(int,string_date.split('-'))
        date1=cls(year,month,day)
        #返回的是一个初始化后的类
        return date1

    def out_date(self):
        print "year :"
        print self.year
        print "month :"
        print self.month
        print "day :"
        print self.day
```



在Date_test类里面创建一个成员函数， 前面用了@classmethod装饰。 它的作用就是有点像静态类，比静态类不一样的就是它可以传进来一个当前类作为第一个参数。

那么如何调用呢？

```python
r=Data_test2.get_date("2016-8-6")
r.out_date()
```

输出：

```text
year :
2016
month :
8
day :
1
```