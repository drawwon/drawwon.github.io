---
title: react+react-router搭建管理系统
mathjax: true
date: 2018-06-17 19:55:15
tags: [react]
category: [react,前端]
---



### 本地存储

因为http是一种无状态的请求，如果需要记录访问者的身份，那么就需要借助cookie和session

cookie是浏览器保存的一系列值，其字段及定义如下：

![](http://ooi9t4tvk.bkt.clouddn.com/18-6-17/92453069.jpg)

与cookie对应的是session，session由服务器端产生记录请求者身份，其字段定义如下：

![](http://ooi9t4tvk.bkt.clouddn.com/18-6-17/62150518.jpg)

session在关闭页面之后就会自动删除

localStorage是H5引入的机制，是一些key-value的键值对，有域名限制（完全匹配，不存在域的概念），关闭浏览器之后内容仍然存在，用setItem和removeItem进行添加和删除

sessionStorage与localStorage很相似，在关闭浏览器之后消失

## react-router

### 页面的三种路由

管理浏览器不同页面跳转的机制

包含三个部分：

1. 历史：堆栈的结构，入栈和出栈记录访问历史
2. 跳转：在不同页面之间的跳转，并且可以传递参数
3. 事件：打开新页面或者退回上一页面的逻辑

常见的router：

1. 页面Router：整个页面重新加载
2. hash router：跳转时只有页面的hash值变化，页面本身并没有重新加载
3. H5 Router：可以操作整个路径，既能操作hash又能操作页面

用浏览器尝试进行跳转，用下面这条指令可以跳到baidu：

```js
window.location.href = 'http://www.baidu.com'
history.back()
```

点返回按钮，可以看到整个的路由历史

再试一下hash跳转：

```js
window.location = '#test'
windows.onhashChange = ()=>{console.log('current hash', window.location.hash)} //监听所有的hash改变的情况
```

发现只是在原本的地址后面加了一个`#test`

再试一下H5的跳转方法，H5是用`history.pushState`来手动改变地址，既可以hash跳转，也可以直接跳转到其他页面

```js
history.pushState('name','title','#test')
history.pushState('name','title','/index/user')
window.onpopstate = e=>{            //监听后退的事件,也就是pop栈的时候
    console.log('h5 router change',e.state );
    console.log('绝对路径',window.location,href);
    console.log('相对路径',window.location.pathname);
    console.log('hash值',windows.location.hash);
    console.log('search值',windows.location.search);
} 

history.replaceState('name','title','#test')//替换当前的路由，但是不记录上一次的路由，就是直接替换，不入栈
```

### react-router

提供了两种router，`<BrowsorRouter>`和`<HashRouter>`

* `<Route>`：router里面的路由选项，哪个页面对应哪个组件
* `<Switch>`：解决多次匹配的问题，返回第一个符合规则的匹配
* `<Link>`和`<NavLink>`：跳转导航，相当于HTML当中的`<a>`，后者是加了选中状态的处理，适合做导航菜单
* `<Redirect>`：用于自动跳转，匹配到某个路径的时候，自动跳转到另外的路径





