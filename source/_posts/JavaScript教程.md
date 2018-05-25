---
title: JavaScript教程
date: 2017-06-29 16:07:50
tags: [JavaScript]
category: [编程学习]
---

之前在慕课网上看了看JavaScript的教程，但是整个教程的内容不够详细，因此在廖雪峰官方网站看看关于js的教程，并重新学习和记录如下。

js用于在静态HTML页面上添加一些动态效果 ，网景公司的Brendan Eich这哥们在两周之内设计出了JavaScript语言 。为了让js称为全球标砖，欧洲计算机制造协会(European Computer Manufacturers Association)制定了js的标准，称为RCMAscript标准，最新版ECMAscript 6标准于2015年6月发布（简称ES6)。

### 快速入门

js代码一般放在`<head>`当中，由封闭的`<script>...</script>`包含起来

第二种是将js放在一个单独的js文件中，然后在head中声明该文件

```html
<head>
    <script src="/static/js/abc.js"></script>
</head>
```

有时候会看到定义js的类型，`<script type="text/javascript">`，但是实际上是没有必要的，因为默认的script的类型就是javascript

### 基础语法

每一句以分号(';')结束，语句块用大括号括起来

//表示注释，/\*...\*/也表示注释

### 数据类型和变量

#### Number

js不区分整数和浮点数，统一用Number表示

#### 字符串

字符串是以单引号或双引号引起来的任何文本，比如'abc'或者"xyz"

#### 布尔值

布尔值只有true和false两种，可以直接使用true，false来表示，也可以使用布尔运算来计算出来（比如大小比较或者与或非），js的与运算是&&，或运算是||，非运算是!

#### 比较运算符

大小比较与其他语言没有区别，但是js有个特殊的等于比较，两个等号"=="会自动转换类型之后再比较，而三个等号"==="不会自动转换类型，由于JavaScript这个设计缺陷，*不要*使用`==`比较，始终坚持使用`===`比较。

```javascript
false == 0; // true
false === 0; // false
```

还有一个问题就是NaN与任何值都不相等，包括他自己

```js
NaN === NaN; // false
```

唯一判断NaN的方法就是使用`isNaN()`函数

浮点数运算的相等比较中，由于浮点数运算会出现误差，因此计算机无法精确标识无限循环小数，要比较两个浮点数是否相等，智能计算他们之间的绝对值，看是否小于某个阈值

```js
1 / 3 === (1 - 2 / 3); // false
Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
```

#### null和undefined

null表示空值，与0和空字符串`''`都是不同的，null和undefined大致类似，大多数情况下都应该用`null`，`undefined`只有在判断函数参数是否传递的情况下有用

#### 数组

js的数组和python的list类似，可以包含任意类型的数据，例如：

```js
[1, 2, 3.14, 'Hello', null, true];
```

 另一种创建数组的方法是通过`Array()`函数实现

```js
new Array(1,2,3);// 创建了数组[1, 2, 3]
```

更建议直接使用方括号`[]`来建立数组，数组索引也和python类似，起始索引为0

```js
var arr = [1, 2, 3.14, 'Hello', null, true];
arr[0]; // 返回索引为0的元素，即1
arr[5]; // 返回索引为5的元素，即true
arr[6]; // 索引超出了范围，返回undefined
```

#### 对象

js的对象是由一组键值对组成的字典，与python中的字典类型基本一样：

```js
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```

js对象的键都是字符串类型，值可以是任何类型，要获取一个对象的属性，就直接用`对象变量.属性名 `的方式：

```js
person.name; // 'Bob'
person.zipcode; // null
```

#### 变量

js的变量要以var定义，变量名是大小写英文、数字、`$`和`_`的组合 ，不能以数字开头

用等号对变量赋值，但一个变量只需要初始化一次

```js
var a = 123; // a的值是整数123
a = 'ABC'; // a变为字符串
```

#### strict模式

如果不用var进行初始化的话，那么变量将是全局变量，这会导致很严重的错误

ECMA为了修补js的这一严重缺陷，在后续退出了strict模式，如果不用var初始化变量将会报错，启用strict模式的方法是在js代码的第一行写上

```
'use strict';
```



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

