---
title: pyplot入门
date: 2017-11-28 10:31:25
tags: [plt, python]
category: [编程学习]
---

## plt画图

总体思想，先使用`fig = plt.figure(),ax=fig.add_subplot()`创建图片，画好图之后，用ax.set_xxx来设置各项参数

### 设置子图之间的间距

plt.subplots_adjust(wspace, hspace)：参数分别代表水平间距和竖直间距
### 设置x轴坐标及范围

set_xticks：刻度值的显示值

set_xticklabels：将任意标签转换为x轴标签

set_xlim：只显示某一部分的时候使用

```
ax.set_xticks(range(0,1001,250))
ax.set_xticklabels(['one','two','three','four','five'],rotation=30,fontsize='small')
```

同样y轴同理

### 设置title,label

set_title：设置图片title

set_xlabel：设置x轴的名称

```
fig = plt.figure()
ax = fig.add_subplot(1,1,1)
ax.plot(randn(1000).cumsum(),'k-')
ax.set_xticks(range(0,1001,250))
ax.set_xticklabels(['one','two','three','four','five'],rotation=30,fontsize='small')
ax.set_xlabel('stage')
plt.show()
```

### 添加图例

在画图的时候传入label，在添加图例的时候用legend就好了

```
ax.plot(randn(1000).cumsum(),'k-',label='one')
ax.plot(randn(1000).cumsum(),'g--',label='two')
ax.plot(randn(1000).cumsum(),'r-',label='three')
ax.legend(loc='best')
```

### 添加注释

注释可以通过text，arrow，annotate等函数添加

### 保存图片到文件

`plt.savefig('a.svg')`

## pandas当中的plot

### Series.plot绘图参数

label：用于图例的标签

ax：绘制的画布

style：风格，包括颜色和线型

alpha：不透明度，0-1

kind：'line','bar','barh','kde'

logy：对y轴做对数

use_index：将对象的索引用作刻度标签

rot：旋转刻度标签（0-360）

xticks：用作x轴刻度的值

yticks：用作y刻度的值

xlim，ylim：x，y轴界限

grid：显示网格线

### DataFrame.plot参数

subplots：将各个dataframe列绘制到单独的subplot中

sharex，sharey：如果subplots为true，共用一个x轴，或y轴

figsize：图像大小

title：名称

legend：添加图例，默认为true

sort_columns：以字母表顺序绘制各列



























