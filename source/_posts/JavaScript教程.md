---
title: JavaScript教程
date: 2017-06-29 16:07:50
tags: [JavaScript]
category: [编程学习]
---

# JavaScript 简介

<!--more-->

JavaScript 是互联网上最流行的脚本语言，这门语言可用于 HTML 和 web，更可广泛用于服务器、PC、笔记本电脑、平板电脑和智能手机等设备。

## JavaScript：直接写入 HTML 输出流

```javascript
document.write("<h1>这是一个标题</h1>");
document.write("<p>这是一个段落。</p>");
```

## JavaScript：对事件的反应

```javascript
<button type="button" onclick="alert('欢迎!')">点我!</button>
```

## JavaScript：改变 HTML 内容

```javascript
x=document.getElementById("demo")  //查找元素
x.innerHTML="Hello JavaScript";    //改变内容
```

您会经常看到 ***document.getElementById***("***some id***")。这个方法是 HTML DOM 中定义的。

DOM (**D**ocument **O**bject **M**odel)（文档对象模型）是用于访问 HTML 元素的正式 W3C 标准。

