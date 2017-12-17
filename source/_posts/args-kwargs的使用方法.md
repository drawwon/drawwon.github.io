---
title: '*args,**kwargs的使用方法'
date: 2017-11-25 16:09:50
tags:
category:
---

`*args`和`**kargs`是一种约定俗称的用法，目的是用于传入不定数量的参数，前者把传入的参数变成一个tuple，后者把传入的参数编程一个字典

```
In [1]: def foo(*args):
   ...:     for a in args:
   ...:         print a
   ...:         
   ...:         

In [2]: foo(1)
1


In [4]: foo(1,2,3)
1
2
3
```

The `**kwargs` will give you all **keyword arguments** except for those corresponding to a formal parameter as a dictionary.

```
In [5]: def bar(**kwargs):
   ...:     for a in kwargs:
   ...:         print a, kwargs[a]
   ...:         
   ...:         

In [6]: bar(name='one', age=27)
age 27
name one
```

Both idioms can be mixed with normal arguments to allow a set of fixed and some variable arguments:

```
def foo(kind, *args, **kwargs):
   pass
```

Another usage of the `*l` idiom is to **unpack argument lists** when calling a function.

`*`的另外一个用途就是unpack(打开包裹)，比如调用zip的时候，zip的用法是传入n个对象进行zip，但是每一个都是单独的，比如你可以`zip(*[1,2,3])`

```
In [9]: def foo(bar, lee):
   ...:     print bar, lee
   ...:     
   ...:     

In [10]: l = [1,2]

In [11]: foo(*l)
1 2
```