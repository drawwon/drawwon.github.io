---
title: HTML教程.md
date: 2017-06-29 11:21:30
tags: 网页
category: 编程学习
---

[**HTML常用标签和属性参考**](http://www.runoob.com/tags/html-reference.html)

# HTML定义

超文本标记语言（英语：HyperText Markup Language，简称：HTML）是一种用于创建网页的标准标记语言。

<!--more-->

# HTML简介

## HTML实例

网页中需要展示出来的内容都在`<body>`标签中，整体结构如下：

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
  </head>
  <body>
    <p>.....</p>
    <a href='www.baidu.com'>........</a>
  </body>
</html>    
```

实例如下：

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
</head>
<body>
 
<h1>我的第一个标题</h1>
 
<p>我的第一个段落。</p>
 
</body>
</html>
```

* `<!DOCTYPE html>`：表示为HTML5文档，这个声明不区分大小写
* `<html>`：是HTML页面的根元素
* `<head>`元素包含了文档的元`<meta>`数据
* `<title>`元素表示文档的标题
* `<body>`元素包含了可见的页面内容
* `<h1>`元素定义了一个大标题
* `<p>`元素定义了一个段落
* `<meta charset="utf-8">`：可以使得输出中文时正常显示
* `<q>`：表示引用
* `<br/>`：换行符，回车在html文件中是无效的
* `&nbsp;`：空格符号
* `<hr/>`：横线
* `<code>`：代码，`<pre>`:多行代码
* ​

## HTML 元素语法

- HTML 元素以**开始标签**起始
- HTML 元素以**结束标签**终止

## HTML 属性

- HTML 元素可以设置**属性**
- 属性可以在元素中添加**附加信息**
- 属性一般描述于**开始标签**
- 属性总是以名称/值对的形式出现，**比如：name="value"**。

HTML **链接** 由 <a> 标签定义。链接的地址在 **href 属性**中指定：

```html
<a href="http://www.runoob.com">这是一个链接</a>
```

[**HTML常用标签和属性参考**](http://www.runoob.com/tags/html-reference.html)

| 标签                                       | 描述         |
| ---------------------------------------- | ---------- |
| [<html>](http://www.runoob.com/tags/tag-html.html) | 定义 HTML 文档 |
| [<body>](http://www.runoob.com/tags/tag-body.html) | 定义文档的主体    |
| [<h1>-<h6> ](http://www.runoob.com/tags/tag-hn.html) | 定义 HTML 标题 |
| [<hr>](http://www.runoob.com/tags/tag-hr.html) | 定义水平线      |
| [<!--...-->](http://www.runoob.com/tags/tag-comment.html) | 定义注释       |

## HTML 文本格式化标签

| 标签                                       | 描述     |
| ---------------------------------------- | ------ |
| [<b>](http://www.runoob.com/tags/tag-b.html) | 定义粗体文本 |
| [<em>](http://www.runoob.com/tags/tag-em.html) | 定义着重文字 |
| [<i>](http://www.runoob.com/tags/tag-i.html) | 定义斜体字  |
| [<small>](http://www.runoob.com/tags/tag-small.html) | 定义小号字  |
| [<strong>](http://www.runoob.com/tags/tag-strong.html) | 定义加重语气 |
| [<sub>](http://www.runoob.com/tags/tag-sub.html) | 定义下标字  |
| [<sup>](http://www.runoob.com/html/m/tags/tag-sup.html) | 定义上标字  |
| [<ins>](http://www.runoob.com/tags/tag-ins.html) | 定义插入字  |
| [<del>](http://www.runoob.com/tags/tag-del.html) | 定义删除字  |

## HTML 链接语法

标签`<a>`加上属性`href`

```html
<a href="www.baidu.com">百度</a>
```

如果需要在新标签中打开网页，需要加上：`target="_blank"`

```html
<a href="www.baidu.com" target="_blank">百度</a>
```

## 邮件语法

在连接中使用`mailto`，第一个符号使用`？`分隔，后面用`&`分隔

```html
<a href = "mailto:xxxx@qq.com? & cc=xxx@qq.com & bcc=xxx@qq.com & subject="主题" & body="内容">发送按钮</a>
```



## 表格实例

由`table`标签开始，然后用`tbody`使表可以加载多少显示多少，`th`：table head表示表头，`tr`表示table row表行，`td`表示table data单元格

加入边框的方式有2种；第一种是直接加入`border` 属性，第二种是在`<head>`标签中加入`style`标签，具体如下：

```html
<style type="text/css">
table tr td,th{border:1px solid #000;}
</style>
```

表格标题`caption`

表格摘要用属性表示，`<table summary=“xxxxx”`

```html
<table border="1">
    <tr>
        <td>row 1, cell 1</td>
        <td>row 1, cell 2</td>
    </tr>
    <tr>
        <td>row 2, cell 1</td>
        <td>row 2, cell 2</td>
    </tr>
</table>
```

表格标签是`<tr>`，每一个单元格的标签是`<td>`，边框的属性是`border`

## HTML无序列表

无序列表是一个项目的列表，此列项目使用粗体圆点（典型的小黑圆圈）进行标记。

* 无序列表使用 <ul> 标签，每个列表项始于 <li> 标签。

```html
<ul>
<li>Coffee</li>
<li>Milk</li>
</ul>
```

* 有序列表始于 <ol> 标签。每个列表项始于 <li> 标签。

```html
<ol>
<li>Coffee</li>
<li>Milk</li>
</ol>
```

## 图片

图片使用`<img sec="sss.jpg">`来表示，如果要改变鼠标滑过时的文字，加入`title`属性

```html
<img src="aa.jpg" title="xxxx">
```

# HTML 表单

表单用于把用户输入的数据传送到服务端

## 表单语法

语法：

```html
<form   method="传送方式"   action="服务器文件">
```

1.`<form> ：<form>`标签是成对出现的，以`<form>`开始，以`</form>`结束。
2.`action` ：浏览者输入的数据被传送到的地方,比如一个PHP页面(save.php)

3.**method** **：** 数据传送的方式（get/post）。

```html
<form    method="post"   action="save.php">
        <label for="username">用户名:</label>
        <input type="text" name="username" />
        <label for="pass">密码:</label>
        <input type="password" name="pass" />
</form>
```

## 输入大段多行文字

用到`texarea`

```html
<textarea  rows="行数" cols="列数">文本</textarea>
```

## 复选框

`ratio`：圆框

`checkbox`：方框

如果要做到单选效果，就需要名字相同

`语法：`

```html
<input   type="radio/checkbox"   value="值"    name="名称"   checked="checked"/>
```

## 下拉框

`select`标签，每个选项使用`<option>`标签

`value`为向系统提交的值，后面的文字为显示的内容

```html
<form action="save.php" method="post" >
    <label>爱好:</label>
    <select>
      <option value="看书">看书</option>
      <option value="旅游">旅游</option>
      <option value="运动">运动</option>
      <option value="购物">购物</option>
    </select>
</form>
```

* 提交按钮：`<input type="submit" value="提交"/>`
* 重置按钮：`<input type="reset" value="重置">`

## label

`<label>`：作用是点击文字时也可以选定复选框，不需要移动到框那里