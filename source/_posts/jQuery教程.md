---
title: jQuery教程
date: 2017-07-09 15:31:37
tags: [编程]
category: [编程学习]

---

## 什么是jQuery

<!--more-->

是一个JavaScript框架，或者说我们也可以把它称之为一个JavaScript库，里面封装了一些常用的JavaScript函数代码，其兼容性比较好，支持所有主流的浏览器。

## 如何使用jQuery

有两种方法可以引用jQuery代码，

* 一是从官网上下载，和html文件放到同一个文件夹下，然后通过`<script type = "text/JavaScript", src = "jquery-3.2.1.js"></script>`
* 二是直接通过cdn的方式进行网页引用，`script type = "text/JavaScript", src = “http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js"`进行引用

## 使用jQuery写hello world

$(document).ready()表示等网页上所有元素加载好之后再进行括号内的内容

$("div")表示寻找所有标签为div的元素

$("div").html()用于更改div的内容

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>第一个简单的jQuery程序</title>
    <style type="text/css">
        div{
            padding:8px 0px;
            font-size:12px;
            text-align:center;
            border:solid 1px #888;
        }
    </style>
    <script src="http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js"></script>
    <script type="text/javascript">
            $(document).ready(function() {
            $("div").html("您好，通过慕课网学习jQuery才是最佳的途径。")
            });
    </script>
</head>
<body>
    <div></div>
</body>
</html>
```

## 使用jQuery获取元素对象

通过`$`符号来进行对象获取，获取的对象是一个数组对象，比如文章中一共有三个`div`标签，那么`$("div")`获取到的是一个长度为3的数组，可以通过get方法转换成`DOM`对象，也可以直接用数组进行转换，方法如下：

```javascript
var $div = $("div");
var div  = $div.get(0); //或者var div = $div[0];
```

将DOM对象转换为jQuery对象：

```javascript
var div = document.getElementById("div1");
$div = $(div);
```

## jQuery的层级选择器

一共有4种常用选择器如下：

1. 子选择器：`$("parent > child")`
2. 后代选择器：`$("ancestor descendant")`
3. 相邻兄弟选择器：`$("prev + next")`
4. 一般兄弟选择器：`$("bro1 ~ bro2")`

## jQuery的一般筛选选择器

一共有12种常用筛选选择器，$(":")，美元符号加括号，引号，然后以冒号开头：

1. $(":eq(index)")：选择等于给定索引的元素
2. $(":lt(index)")：选择小于给定索引的元素
3. $(":gt(index)")：选择大于给定索引的元素
4. $(":odd")：选择索引为奇数的元素
5. $(":even")：选择索引为偶数的元素
6. $(":first")：选择第一个元素
7. $(":last")：选择最后一个元素
8. $(":animated")：选择正在进行动画效果的元素
9. $(":root")：选择根元素
10. $("lang(language)")：选择指定语言的元素
11. $(":header")：选择标题元素
12. $("not(selector)")：选择除了不匹配给定的选择器元素

## jQuery内容选择器

一共有四种常用的内容选择器：

1. `$(":contains(text)")`：选择含有指定文本内容的元素
2. `$(":parent")`：选择所有含有子元素或者内容的元素
3. `$(":has(selector)")`：选择符合选择器的元素
4. `$(:empty)`：选择没有子元素的元素

## jQuery可见性选择器

有可见和不可见两种：

1. `$(":visible")`：显示所有可见元素
2. $(":hidden")：显示所有隐藏元素

## jQuery属性选择器

属性选择器是判断属性与所给定值之间的关系，通常的形式是`$("[attribute=value]")`，有如下几种：

1. `$("[attribute|=value]")`：属性值等于所给值或者以所给值为前缀（在所给值最后加一个"-"）
2. `$("[attribute=value]")`：属性值等于所给值
3. `$("[attribute!=value]")`：属性值不等于所给值的元素
4. `$("[attribute*=value]")`：属性值包含一个给定的子字符串的元素
5. `$("[attribute~=value])"`：以空格分隔的属性值中有一个给定值的元素
6. `$("[attribute]")`：指定属性的元素
7. `$("[attribute^=value]")`：以给定值为开始的元素
8. `$("[attribute$=value]")`：以给定值为结束的元素
9. `$("[attributeFilter1][attributeFilter2]")`：匹配所有属性选择器的元素

## jQuery子元素选择器

通常有如下5中子元素选择器：

1. `$(":first-child")`：选择第一个子元素
2. `$(":last-child")`：选择最后一个子元素
3. `$(":only-child")`：选择子元素为唯一元素的子元素
4. `$（":nth-child"）`：选择第n个子元素
5. `$(":nth-last-child")`：选择父元素的第n个子元素，计数是从后到前的

## jQuery表单元素选择器

表单选择器有如下10种：

1. `$(":input")`：选择所有的input,select,button和textarea元素
2. `$(":text")`：选择所有文本框
3. `$(":password")`：选择所有密码框
4. `$(":radio")`：选择所有单选框
5. `$(":checkbox")`：选择所有复选框
6. `$(:submit)`：选择所有提交按钮
7. `$(:image)`：选择所有图像域
8. `$(":reset")`：匹配所有重置按钮
9. `$(":button")`：匹配所有按钮
10. `$(":file")`：匹配所有文件域

## jQuery对象属性筛选选择器

表单筛选选择器主要有一下4种：

1. `$(":enabled"`：可用的表单元素
2. `$(:disabled)`：选取不可用的表单元素
3. `$(:checked)`：选取被选中的`<input>`元素
4. `$(":selected")`：选取被选中的`<option>`元素

添加点击事件的函数：

```javascript
var p1 = getElementById("p1")
p1.addEventListener('click')
```

