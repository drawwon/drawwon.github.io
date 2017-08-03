---
title: css对网页进行布局
date: 2017-07-05 10:09:20
tags: [css,网页]
category: [编程学习]

---

## 一列布局使用

三个`div`分别为上中下，分别设置每一个的高度和宽度以及背景颜色

<!--more-->

居中效果的代码是`margin:0 auto`，意思是上下的宽度设置为0，左右的宽度设置为auto

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>1列布局</title>
    <style type="text/css">
        body{
            margin: 0;
            padding: 0
        }     
        .main{
            width: 800px;
            height: 300px;
            background: #ccc;
            margin: 0 auto;
        }
        .top{
            height: 100px;
            background: blue;
        }
        .foot{
            width: 800px;
            height: 100px;
            background: #900;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="top"></div>
<div class="main"></div>
<div class="foot"></div>
</body>
</html>
```

## 两列布局使用

一个大的`div`，包含两个浮动于左右的`div`，`float:left`和`float:right`

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>2列布局</title>
    <style type="text/css">
        body{margin: 0;padding: 0}
        .main{margin: 0 auto;width: 800px;}
        .left{width: 200px;height: 500px;float: left;background: red}
        .right{width: 520px;height: 500px;float: right;background: yellow}
    </style>
</head>
<body>
<div class="main">
    <div class="left"></div>
    <div class="right"></div>
</div>
</body>
</html>
```



## 三列布局使用

三列布局有两种方式，第一种是通过设置三列的width：33.33%

第二种是绝对布局，左右都设置为`position:absolute`

```css
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>3列布局</title>
    <style type="text/css">
        body{margin: 0;padding: 0}
        .main{margin: 0 auto;width: 800px;}
        .left{width: 200px;height: 500px;background: red;position: absolute;left: 0;top: 0}
        .middle{height: 500px;background: green;margin: 0 310px 0 210px}
        .right{width: 300px;height: 500px;background: yellow;position: absolute;right: 0;top: 0}
    </style>
</head>
<body>
    <div class="left">200px</div>
    <div class="middle">middle</div>
    <div class="right">300px</div>
</body>
</html>
```

## 混合布局的使用

上下自动居中，中间使用浮动在左右

```css
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>1列布局</title>
    <style type="text/css">
        body{
            margin: 0;
            padding: 0
        }     
        .main{
            width: 800px;
            height: 300px;
            background: #ccc;
            margin: 0 auto;
        }
        .left{
            width: 200px;
            height: 300px;
            background: yellow;
            float: left;
        }
        .right{
            width: 600px;
            height: 300px;
            background: red;
            float: right;
        }
        .top{
            height: 100px;
            width: 800px;
            background: blue;
            margin: 0 auto;
            text-align: center;
            vertical-align: middle;
        }
        .foot{
            width: 800px;
            height: 100px;
            background: #900;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="top">top</div>
<div class="main">
    <div class="left">left</div>
    <div class="right">right</div>
</div>
<div class="foot">foot</div>
</body>
</html>
```

