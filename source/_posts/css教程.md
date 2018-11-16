---
title: css教程
date: 2017-06-30 17:40:58
tags: [css]
category: [编程学习]

---

# CSS定义

<!--more-->

CSS全称为“层叠样式表 (Cascading Style Sheets)”，它主要是用于定义HTML内容在浏览器内的**显示样式**，如文字大小、颜色、字体加粗等。

## css语法格式

**声明：**在英文大括号“｛｝”中的的就是声明，属性和值之间用英文冒号“：”分隔。当有多条声明时，中间可以英文分号“;”分隔，如下所示：

```css
p{
  font-size:12px;
  color:red;
}

```

# CSS 类型

CSS样式可以写在哪些地方呢？从CSS 样式代码插入的形式来看基本可以分为以下3种：内联式、嵌入式和外部式三种。这一小节先来讲解内联式。

## 内联式

`内联式`css样式表就是把css代码直接写在现有的HTML标签中，`style="color=red"`如下面代码：

```css
<p style="color:red">这里文字是红色。</p>
```

并且css样式代码要写在style=""双引号中，如果有多条css样式代码设置可以写在一起，中间用**分号隔开**。如下代码：

```css
<p style="color:red;font-size:12px">这里文字是红色。</p>
```

## 嵌入式

`嵌入式`就是把内联式css样式写在`head`标签的`style`标签中，其属性为`type="text/css"`，具体代码如下

```css
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>嵌入式css样式</title>
<style type="text/css">
span{
   color:red;
}
</style>
</head>
```

## 外部式

外部式css样式(也可称为外联式)就是把css代码写一个单独的外部文件中，这个css样式文件以“`.css`”为扩展名，在`<head>`内（不是在`<style>`标签内）使用`<link>`标签将css样式文件链接到HTML文件内，如下面代码：

```css
<link href="style.css" rel="stylesheet" type="text/css" />
```



三种css属性的优先级是：

`内联式 > 嵌入式 > 外部式`

总的来说，css的优先级遵从就近原则



## 类名

```css
.类选器名称{css样式代码;}
```

使用方法：

第一步：使用合适的标签把要修饰的内容标记起来，如下：

```
<span>胆小如鼠</span>
```

第二步：使用class="类选择器名称"为标签设置一个类，如下：

```
<span class="stress">胆小如鼠</span>
```

第三步：设置类选器css样式，如下：

```
.stress{color:red;}/*类前面要加入一个英文圆点*/
```

## id 选择器

ID选择器都类似于类选择符，但也有一些重要的区别：

1、为标签设置id="ID名称"，而不是class="类名称"。

2、ID选择符的前面是井号**（#）**号，而不是英文圆点**（.）**。

<font color="red">id选择器只能用一次，每个元素只能有一个id，而类选择器可以有很多元素是同一个类，一个元素也可以同时属于多个类</font>

## 子选择器

先写一个类，然后用大于符号`>`指向类中的某个元素，对齐设置样式表：

```css
.food>li{
  border:1px red solid;
}
```

子选择器效果图：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-7-4/44758217.jpg)

## 包含后代的选择器

把子选择器的`>`符号换成空格，其与子选择器的主要区别是：包含后代的选择器会把子类中的所有符合条件的子类都改变，而子选择器只改变第一代后代，代码如下：

```css
.food li{
    border:1px solid red;
}
```

后代选择器效果图：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-7-4/2102811.jpg)

## 适配符

通用适配符：`*`，用于匹配任意样式

伪类适配符：`:hover`,它允许给html不存在的标签（标签的某种状态）设置样式，比如说我们给html中一个标签元素的鼠标滑过的状态来设置字体颜色:

`a:hover{color:red}`

分组选择符：`,`，同时为多个标签设置样式

## 继承

如果对某个父类标签设置了某种样式，其子标签也会自动继承这种样式，比如你为`<p>`标签设置了`color=red`，那么`<p>`标签包含的`<span>`标签也会自动继承这个颜色样式

## 权重

系统根据权重判断到底使用哪种样式，具体来说：继承权重为0.1，标签的权重为1，类选择符权重为10，id选择符权值为100

```css
p{color:red;} /*权值为1*/
p span{color:green;} /*权值为1+1=2*/
.warning{color:white;} /*权值为10*/
p span.warning{color:purple;} /*权值为1+1+10=12*/
#footer .note p{color:yellow;} /*权值为100+10+1=111*/
```

如果遇到权重相同的情况：就近原则

**设置最高权重**：在分号之前加入important`p.first{color:green!important;}`，注意<font color="red">后代选择器是空格，p.first中间不加空格（因为不是后代）,同理p#id也不加空格</font>

## 格式化排版

* 设置字体：`font-family`属性
* 字号：`font-size:20px`
* 颜色：`color:red`
* 粗体：`font-weight：bold`
* 斜体：`font-style:italic`
* 下划线：`text-decoration：underline`
* 删除线：`text-decoration：line-through`
* 首行缩进：`text-indent：2em`
* 行间距：`line-height：1.5em`
* 字间距：`letter-spacing：50px`
* 对齐方式：`text-align：center`

使用方式如下：

```css
<!DOCTYPE HTML>
<html>
<head>
<style type="text/css">
body{
  font-family:"微软雅黑"；
  font-size:20px;
  color:red;
}
</style>
</head>
</html>
```

## 元素分类

在讲解CSS布局之前，我们需要提前知道一些知识，在CSS中，html中的标签元素大体被分为三种不同的类型：**块状元素**、**内联元素(又叫行内元素)**和**内联块状元素**。

**常用的块状元素有：**

`<div>、<p>、<h1>...<h6>、<ol>、<ul>、<dl>、<table>、<address>、<blockquote> 、<form>`

**常用的内联元素有：**

`<a>、<span>、<br>、<i>、<em>、<strong>、<label>、<q>、<var>、<cite>、<code>`

**常用的**内联块状元素有：

`<img>、<input>`

### 块级元素

什么是块级元素？在html中`<div>、 <p>、<h1>、<form>、<ul> 和 <li>`就是块级元素。设置`display:block`就是将元素显示为块级元素。如下代码就是将**内联元素a**转换为**块状元素**，从而使a元素具有**块状元素**特点。

```
a{display:block;}
```

**块级元素特点：**

1、每个块级元素都从新的一行开始，并且其后的元素也另起一行。（真霸道，一个块级元素独占一行）

2、元素的高度、宽度、行高以及顶和底边距都可设置。

3、元素**宽度**在不设置的情况下，是它本身父容器的100%（**和父元素的宽度一致**），除非设定一个宽度。

### 内联元素

在html中，`<span>、<a>、<label>、 <strong> 和<em>`就是典型的**内联元素**（**行内元素**）（inline）元素。当然**块状元素**也可以通过代码`display:inline`将元素设置为**内联元素**。如下代码就是将**块状元素div**转换为**内联元素**，从而使 div 元素具有**内联元素**特点。

```css
 div{
     display:inline;
 }

......

<div>我要变成内联元素</div>
```

**内联元素特点：**

1、和其他元素都在一行上；

2、元素的高度、宽度及顶部和底部边距**不可**设置；

3、元素的宽度就是它包含的文字或图片的宽度，不可改变。

### 内联块状

**内联块状元素（**inline-block**）**就是同时具备内联元素、块状元素的特点，代码`display:inline-block`就是将元素设置为内联块状元素。(css2.1新增)，`<img>、<input>`标签就是这种内联块状标签。

inline-block 元素特点：

1、和其他元素都在一行上；

2、元素的高度、宽度、行高以及顶和底边距都可设置。

## 盒子模型

* 盒子：`div`
* 内容与盒子的距离：`padding`，一共四个方向，`padding-top`，`padding-bottom`，`padding-left`，`padding-right`
* 盒子与另一个盒子的距离：`margin`
* 盒子边框：`border`

### 边框

盒子模型的边框就是围绕着内容及补白的线，这条线你可以设置它的粗细、样式和颜色(边框三个属性)。

如下面代码为 div 来设置边框粗细为 2px、样式为实心的、颜色为红色的边框：

```css
div{
    border:2px  dotted  red;
}
```

上面是 border 代码的缩写形式，可以分开写：

```css
div{
    border-width:2px;
    border-style:dotted;/*虚线*/
    border-color:red;
}
```

也可以单独为一边设置边框

```css
div{
    border-bottom:2px  dotted  red;
}
```

### 宽度和高度

宽度和高度分别使用`width`和`height`来表示

### 填充

元素与边框之间的距离用`padding`，其设置的顺序为：**上，右，下，左**(顺时针)

## CSS布局模型

CSS包含3种基本的布局模型，用英文概括为：Flow、Layer 和 Float。
在网页中，元素有三种布局模型：

1. 流动模型（Flow）
2. 浮动模型 (Float)
3. 层模型（Layer）

### 流动模型

流动模型是默认的网页布局模式，2个典型特征：

1. **块状元素**都会在所处的**包含元素内**自上而下按顺序垂直延伸分布，因为在默认状态下，块状元素的宽度都为**100%**。实际上，块状元素都会以行的形式占据位置。如右侧代码编辑器中三个块状元素标签(div，h1，p)宽度显示为100%。
2. 第二点，在流动模型下，**内联元素**都会在所处的包含元素内从左到右水平分布显示。（内联元素可不像块状元素这么霸道独占一行）

**清除浮动**：①clear：both ② width：100%，overflow：hidden

### 浮动模型

块状元素这么霸道都是独占一行，如果现在我们想让两个块状元素并排显示，怎么办呢？不要着急，设置元素浮动就可以实现这一愿望。使用`float`属性设置浮动：

```css
div{
    width:200px;
    height:200px;
    border:2px red solid;
    float:left;
}
<div id="div1"></div>
<div id="div2"></div>
```

### 层模型

什么是层布局模型？层布局模型就像是图像软件PhotoShop中非常流行的图层编辑功能一样，每个图层能够精确定位操作。

CSS定义了一组定位（positioning）属性来支持层布局模型。层模型有三种形式：

1、**绝对定位**(position: absolute)
加入`position:absolute`

```css
div{
    width:200px;
    height:200px;
    border:2px red solid;
    position:absolute;
    left:100px;
    top:50px;
}
<div id="div1"></div>
```

2、**相对定位**(position: relative)
**absolute表里如一，移动了就是移动了。relative只是表面显示移动了，但实际还在文档流中原有位置，别的元素无法占据。**如果想为元素设置层模型中的相对定位，需要设置`position:relative`（表示相对定位），它通过left、right、top、bottom属性确定元素在**正常文档流中**的偏移位置

3、**固定定位**(position: fixed)
fixed：表示固定定位，与absolute定位类型类似，但它的相对移动的坐标是视图（**屏幕内的网页窗口**）本身。由于视图本身是固定的，**它不会随浏览器窗口的滚动条滚动而变化**，因此固定定位的元素会始终位于浏览器窗口内视图的某个位置，不会受文档流动影响，这与background-attachment:fixed;属性功能相同

### 相对定位和绝对定位配合

必须相对于父辈元素进行定位：在父辈元素加`position:relative`，需要进项相对的加`position:absolute`

## 盒模型代码简写

通常有下面三种缩写方法:

1、如果top、right、bottom、left的值相同，如下面代码：

```
margin:10px 10px 10px 10px;
```

可缩写为：

```
margin:10px;
```

2、如果top和bottom值相同、left和 right的值相同，如下面代码：

```
margin:10px 20px 10px 20px;
```

可缩写为：

```
margin:10px 20px;
```

3、如果left和right的值相同，如下面代码：

```
margin:10px 20px 30px 20px;
```

可缩写为：

```
margin:10px 20px 30px;
```

### 颜色值缩写

关于颜色的css样式也是可以缩写的，当你设置的颜色是16进制的色彩值时，如果每两位的值相同，可以缩写一半。

例子1：

```
p{color:#000000;}
```

可以缩写为：

```
p{color: #000;}
```

例子2：

```
p{color: #336699;}
```

可以缩写为：

```
p{color: #369;}
```

### 字体设置缩写

网页中的字体css样式代码也有他自己的缩写方式，下面是给网页设置字体的代码：

```
body{
    font-style:italic;
    font-variant:small-caps; 
    font-weight:bold; 
    font-size:12px; 
    line-height:1.5em; 
    font-family:"宋体",sans-serif;
}

```

这么多行的代码其实可以缩写为一句：

```
body{
    font:italic  small-caps  bold  12px/1.5em  "宋体",sans-serif;
}
```

注意：

1、使用这一简写方式你至少要指定 font-size 和 font-family 属性，其他的属性(如 font-weight、font-style、font-variant、line-height)如未指定将自动使用默认值。

2、在缩写时 font-size 与 line-height 中间要加入“/”斜扛。

### 颜色值

颜色值有3中设置方式：

1. 英文命令颜色
   `p{color:red;}`

2. RGB颜色

   `p{color：RGB(133,45,200)`

3. 十六进制颜色

   `p{color：#00ffff}`


### 长度值

1. 像素px
2. 字体大小em：就是本元素的字体大小，比如字体大小为14px，那么em大小就位14px
3. 百分比：`p{font-size:12px;line-height:130%}`

## CSS样式设置小技巧

### 设置居中

`p{text-align:center;}`

### 定宽块状元素居中

`div{margn:20px auto;}`

不定宽度的块状元素有三种方法居中（这三种方法目前使用的都很多）：

1. 加入 [table](http://www.imooc.com/code/292) 标签
2. 设置 [display: inline](http://www.imooc.com/code/2049) 方法：与第一种类似，显示类型设为 行内元素，进行不定宽元素的属性设置
3. 设置 [position:relative](http://www.imooc.com/code/2074) 和 left:50%：利用 相对定位 的方式，将元素向左偏移 50% ，即达到居中的目的
   方法三：通过给父元素设置[ float](http://www.imooc.com/code/2071)，然后给父元素设置 [position:relative](http://www.imooc.com/code/2074) 和 left:50%，子元素设置 position:relative 和 left: -50% 来实现水平居中。

### 垂直居中

设置`height`和`line-height`值一样

```css
<style>
.container{
    height:100px;
    line-height:100px;
    background:#999;
}
</style>
```



父元素高度确定的多行文本、图片等的竖直居中的方法有两种：

1. 使用插入 [table](http://www.imooc.com/code/292)  (包括tbody、tr、td)标签，同时设置 vertical-align：middle。
2. 设置块级元素的 display 为 table-cell（设置为表格单元显示），激活 vertical-align 属性，但注意 IE6、7 并不支持这个样式, 兼容性比较差。

## 隐性改变display类型

1. [position : absolute](http://www.imooc.com/code/2073)
2. float : left 或 [float:right](http://www.imooc.com/code/2071) 

简单来说，只要html代码中出现以上两句之一，元素的display显示类型就会自动变为以 `display:inline-block`（[块状元素](http://www.imooc.com/code/2048)）的方式显示，当然就可以设置元素的 width 和 height 了，且默认宽度不占满父元素。

