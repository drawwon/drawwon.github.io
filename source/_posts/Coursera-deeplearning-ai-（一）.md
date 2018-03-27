---
title: Coursera deeplearning.ai (一)
date: 2018-03-15 21:23:58
tags: [deeplearning,机器学习,深度学习]
category: [机器学习]
---

Coursera上面关于deeplearning.ai的课程一共有五门，在申请助学金之后都可以免费参与，这篇博文主要讲的是关于deeplearning.ai的第一门课程的

<!--more-->

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-15/44184824.jpg)

在房价预测中，最普通的如右上角转弯的函数，称之为ReLU(rectified linear unit)函数，给定一个大小，通过一个神经元就可以得到房子的价格，这就是一个神经元。

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-15/68262402.jpg)

如果你对房价预测还有别的因素，比如卧室的数量，地理位置，学区信息等等来对房价进行预测，你只需要给定大量的x的输入数据，就可以用来预测房价y的值，这样就得到了一个较大的神经元

最左边的一层是输入层，中间一层是隐藏层，最后是输出层

## Week 2

首先介绍一下logistics二分类：经典的二分类算法

首先来看看图像分类的问题，输入一张图片，我们标记1作为猫，标记0作为不是猫

图片在电脑中保存为红绿蓝三个色彩强度矩阵，如果是一幅$64\times64$的图片，就有3个$64\times64$的色彩矩阵，为了进行分类，将这些矩阵中的像素值展开为一个向量x作为算法的输入

输入x的定义为：红黄蓝三张矩阵的像素值按顺序放进去，x在$64\times64$的图片的情况下就是，$64\times64\times3=(12288,1)$的矩阵，有m个训练数据，则有m个x向量，m个y

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-17/57255797.jpg)

如图，每个训练数据占一列，m个训练数据，一共是$m*n$行，Y是标签，m个标签为1*m

### logistics 回归

给定x，预测y，y只能是0和1，也就是二分类问题

有两个参数，w和b，w也是（n，1）的向量，$\hat{y} = w^Tx+b$，这样的表示并不好，因为y可能是一个小数或者甚至是负数，我们想要结果是0或1，因此我们对结果用sigmoid函数，如下：

$\hat{y} = \sigma(w^Tx+b)$

sigmoid函数的定义为：$f(z)=\frac{1}{1+e^{-z}}$

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-19/84173695.jpg)

### Logistic Regression Cost Function

为了优化logistic回归的w和b，我们定义一个损失函数，

损失函数（loss function）：定义一个估计量$\hat{y}$和一个真实值$y$之间的误差，我们在这里用到的是平方损失函数，$L(\hat{y},y)=\frac{1}{2}(\hat{y}-y)^2$

另一种适用的损失函数定义为：$L(\hat{y},y)=- (y\log\hat{y}+(1-y)\log({1-\hat{y}}))$

* 这个函数在y=1的时候，$L(\hat{y},y)=- \log\hat{y}$，要让损失函数尽可能小，那么$\hat{y}$就要尽可能大（因为前面有负号，log是增函数），由于$\hat{y}$是sigmoid函数，最大为1
* 这个函数在y=0的时候，$L(\hat{y},y)=- \log({1-\hat{y}})$，要让损失函数尽可能小，那么$\hat{y}$就要尽可能小（因为前面有负号，log是增函数），由于$\hat{y}$是sigmoid函数，最小为0

代价函数（cost function）：定义整个训练集的平均损失：$J(\hat{y},y)=\frac{1}{m}\sum_{i=1}^{n}L(\hat{y}^{(i)},y^{(i)})$

### 梯度下降

已经知道了逻辑回归算法的参数w和b，以及代价函数$J(\hat{y},y)$，我们需要一个方法来训练我们的模型，那就是梯度下降。

目标是使代价函数$J(\hat{y},y)$最小，也就是下面这个公式最小：

$J(w,b) = \frac{1}{m}\sum_{i=1}^mL(\hat{y}^{(i)},y^{(i)})=\frac{1}{m}y^{(i)}\log\hat{y}^{(i)}+(1-y^{(i)})\log(1-\hat{y}^{(i)})$

这是一个凸优化问题，有且仅有一个最优值，在初始化w和b的时候，可以令初始w=1，b=0，也可以随机初始化。

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-19/36310473.jpg)

每次迭代找到下一个点的方法是通过找到斜率的方向，因为斜率的方向是下降最快的

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-19/42922001.jpg)

直到找到全局最优值，w和b每次迭代更新的公式如下：

$w:=w-\alpha\frac{\partial{J(w,b)}}{\partial{w}}$

$b:=b-\alpha\frac{\partial{J(w,b)}}{\partial{b}}$

### 计算图

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-20/26861114.jpg)

如图是一个计算图，$J(a,b,c)=3(a+bc)$，令bc=u，bc=v，3v=j，这样就是如上图一步一步的计算

在代码中，我们要表示dJ/da的时候，只需要写da就行了 

所谓的反向传播，就是通过链式法则求导倒数的过程

### logistic回归梯度下降法应用

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-20/84901446.jpg)

一直z，$\hat{y}$，以及L(a,y)公式如上，要通过调节w和b得到最大或者最小的L，应该用L对w和b求偏导，然后运用

$w:=w-\alpha dw$

$$b:=b-\alpha db$$

这两个公式进行迭代，其中dw就是L对w的偏导，db就L对b的偏导

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-20/16345016.jpg)

首先L对a求偏导，得到$da=-\frac{y}{a}+\frac{1-y}{1-a}$，接下来a对z求偏导，乘以L对a求偏导，得到$dz=\frac{dL}{dz}=\frac{dL}{da}\frac{da}{dz}$，有

$\frac{da}{dz}=(\frac{1}{1+e^{-z}})'=\frac{e^{-z}}{(1+e^{-z})^2}=\frac{1+e^{-z}-1}{(1+e^{-z})^2}=\frac{1}{1+e^{-z}}(1-\frac{1}{1+e^{-z}})=f(z)(1-f(z))=a(1-a)$

因此，$dz=a-y$，$dw_1=x_1dz$，$dw_2=x_2dz$，$db=dz$，再用上图右下角的迭代公式，即可实现梯度下降迭代

### m个训练数据的梯度下降

代价函数$J(w,b)=\frac{1}{m}\sum_{i=1}^{n}L(a^{(i)},y^{(i)})$

其中$a^{(i)}=\hat{y}^{(i)}=\sigma(w^Tx^{(i)}+b)$

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-21/50315744.jpg)

如图，有两层循环，第一层是循环m个训练数据，第二层是循环n个w

### 通过向量化减少逻辑回归的循环

如下图，我们先减少内层的n个w的循环，通过$dw+=x^{(i)}dz^{(i)}$减少内层循环

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-21/66629047.jpg)

我们再来减少外层的循环

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-21/44301965.jpg)

通过图片中Z和A的计算，就可以减少外层的循环

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-21/69750118.jpg)

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-21/26767201.jpg)

## week 3

神经网络的定义，我们可以从前两周学的逻辑回归来进入，给定x，w，b，可以算出z，由z可以算出a，由a算出损失函数，

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/77110335.jpg)

这是一个两层神经网络（包括1个隐藏层和1个输出层，输入层并不算在其中）

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/30753349.jpg)

### 神经网络的计算公式

我们先看看逻辑回归的计算方法：没有隐藏层，直接通过输入就算出最终的输出a

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/11306728.jpg)

神经网络与之类似，不过多了一层隐藏层，

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/15254553.jpg)

通过如下的公式进行计算隐藏层的每一个点的值

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/76248903.jpg)

整理一下四个点的计算公式如下：右上角的方括号表示所在层，右下角角标表示第几个点

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/88933716.jpg)

我们将公式矢量化：

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/21544575.jpg)

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/41708289.jpg)

得到最终的计算公式如下：其中a[0]表示输入x

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/72894768.jpg)

### 多个训练样本的矢量化

要将如下图所示的循环进行矢量化：其中方括号表示所在层，圆括号表示第几个隐藏单元

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/86500821.jpg)

矢量化之后得到如下公式：Z和A的横向表示m个样本

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-22/12794340.jpg)