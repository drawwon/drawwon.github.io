---
title: JavaScript教程
date: 2017-06-29 16:07:50
tags: [JavaScript]
category: [编程学习]
---

# JavaScript 简介

<!--more-->

JavaScript 是互联网上最流行的脚本语言，这门语言可用于 HTML 和 web，更可广泛用于服务器、PC、笔记本电脑、平板电脑和智能手机等设备。

每一句后面添加“；”

放在html的head之间：

①`<script type="text/javascript">     </script>`；

②`<script src="script.js">           </script> ;`

## 直接写入 HTML 输出流

```javascript
document.write("<h1>这是一个标题</h1>");
document.write("<p>这是一个段落。</p>");
```

输出多个内容时与python一样用+连接

输出html标签时（例如输出`“<br/>”`)，需要用引号扩上并用`<>`包围

## 对事件的反应

```javascript
<button type="button" onclick="alert('欢迎!')">点我!</button>
```

## 改变 HTML 内容

```javascript
x=document.getElementById("demo")  //查找元素
x.innerHTML="Hello JavaScript";    //改变内容
```

您会经常看到 ***document.getElementById***("***some id***")。这个方法是 HTML DOM 中定义的。

DOM (**D**ocument **O**bject **M**odel)（文档对象模型）是用于访问 HTML 元素的正式 W3C 标准。

## 定义变量

定义变量使用关键词`var`，语法如下：

`var 变量名`

**变量名可以任意取名，但要遵循命名规则:**

​    1.变量必须使用字母、下划线(_)或者美元符($)开始。

​    2.然后可以使用任意多个英文字母、数字、下划线(_)或者美元符($)组成。

​    3.不能使用JavaScript关键词与JavaScript保留字。

**注意：Javascript里面区分大小写，变量mychar和myChar是不同的变量**

## 条件判断语句

语法：

```javascript
if(条件)
{ 条件成立时执行的代码 }
else
{ 条件不成立时执行的代码 }
```

## JavaScript定义函数

关键字`function`，用法如下：

```javascript
function 函数名(){
  函数代码；
}
```

点击按钮出提示的例子：

```javascript
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>函数调用</title>
   <script type="text/javascript">
       function contxt() //定义函数
      {
         alert("哈哈，调用函数了!");
      }
   </script>
</head>
<body>
   <form>
      <input type="button"  value="点击我" onclick="contxt()"/>  
   </form>
</body>
</html>
```

## alert 警告框

`alert`是在屏幕上弹出一个警示框，点击确认之后消失，其使用方法如下：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <script type="text/javascript">
    function alert_test() {
         var mychar = "一个警告";
        alert(mychar);
    } 
    </script>>
</head>
<body>
<input type="button" name="button" onclick="rec()" value="点击我弹出对话框">
</body>
</html>
```

## confirm 选择框

`confirm`是在屏幕上弹出一个选择框，点击确认返回true，否则返回false

```html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>confirm</title>
  <script type="text/javascript">
  function rec(){
    var mymessage= confirm("你是女士吗")     ;
    if(mymessage==true)
    {
    	document.write("你是女士!");
    }
    else
    {
        document.write("你是男士!");
    }
  }    
  </script>
</head>
<body>
    <input name="button" type="button" onClick="rec()" value="点击我，弹出确认对话框" />
</body>
</html>
```

## prompt提示框

`“”`是弹出一个提示框，同时你可以在这个提示框中输入值并返回

```html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>prompt</title>
  <script type="text/javascript">
  function rec(){
	var score; //score变量，用来存储用户输入的成绩值。
	score = prompt("请输入你的成绩");
	if(score>=90)
	{
	   document.write("你很棒!");
	}
	else if(score>=75)
    {
	   document.write("不错吆!");
	}
	else if(score>=60)
    {
	   document.write("要加油!");
    }
    else
	{
       document.write("要努力了!");
	}
  }
  </script>
</head>
<body>
    <input name="button" type="button" onClick="rec()" value="点击我，对成绩做评价!" />
</body>
</html>
```

## 打开新窗口

`open()` 方法可以查找一个已经存在或者新建的浏览器窗口。语法如下：

```
window.open([URL], [窗口名称], [参数字符串])
```

```
窗口名称：可选参数，被打开窗口的名称。
    1.该名称由字母、数字和下划线字符组成。
    2."_top"、"_blank"、"_self"具有特殊意义的名称。
       _blank：在新窗口显示目标网页
       _self：在当前窗口显示目标网页
       _top：框架网页中在上部窗口中显示目标网页
    3.相同 name 的窗口只能创建一个，要想创建多个窗口则 name 不能相同。
   4.name 不能包含有空格。
参数字符串：可选参数，设置窗口参数，各参数用逗号隔开。
```

![](http://ooi9t4tvk.bkt.clouddn.com/17-7-7/21084204.jpg)

## 关闭窗口

`window.close`关闭窗口

## DOM

dom意思是document object model，文档对象模型，是把html代码分割成3类节点：文本节点，属性节点，元素节点的树形结构

## 通过id寻找元素

`document.getElementByid('id')`

## innerHTML改变html元素内容

用于改变html代码中的内容，通过`docment.getElementById`找到元素并赋值给object，然后用`object.innerHTML = "new content"`进行赋值

## 改变html样式

用`object.style.property ="xxx"`来改变html中元素的样式，object是通过`document.getElementById()`取得的元素对象

## 显示或隐藏

通过`object.style.display = value`，`value`的值为`none`或者是`block`

## 更改类名

通过`object.className=“xxx”`改变一个元素的类名

## 移除style设置

`object.removeAttribute("style")`

用于移除对元素style的设置

