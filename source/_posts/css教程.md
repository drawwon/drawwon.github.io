---
title: css教程
date: 2017-06-30 17:40:58
tags: [css]
category: [编程学习]

---

# CSS定义

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

