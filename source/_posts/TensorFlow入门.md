---
title: TensorFlow入门
date: 2017-10-13 16:59:18
tags: [TensorFlow,深度学习]
category: [编程学习,TensorFlow]
---

MNIST是一个深度学习入门的经典例子，是通过对55000张手写数字的识别以及10000张手写数字数据的测试以及5000个验证数据的验证，来了解TensorFlow的基本用法

<!--more-->

每个MNIST数据有两部分，一部分是原始数据，每个图片是28*28的矩阵，在MNIST中已经转换为784的行向量，一行代表一个数据，在python中引用MNIST数据的方式如下：

```python
from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)
```

`mnist.train.images`表示数据，`mnist.train.labels`表示标签，这个标签被分成了10列，其中只有1列为1其他列为0，每行数据称为一个tensor（张量），其值均为0到1之间的像素值，标签是0-9之间的

one-hot vector是一个稀疏向量，也就是大多数维度上都为0，仅有一个为1

## Softmax Regressions

softmax回归是logistic回归的推广，logistics回归主要解决的是二分类的问题，而softmax回归主要解决的是多分类的问题。

我们对输入的原始数据赋予一个权重和偏差，得到：

$evidence_i=\sum_jW_{i,j}x_i+b_i$

其中$W_{i,j}$是权重，$b_i$是偏差，$x_i$是输入变量，$i$表示的是第$i$个类别

然后通过softmax回归，得到：

$y=\text{softmax}(evidece)$

这里的softmax函数可以视作一个激活函数或者是连接函数，把线性函数变换成我们想要的形式，那么我们就得到了10中情况下的概率分布，你可以通过以下的公式得到真正的概率：

$\text{softmax}(x)=\text{normalize}(\text{exp}(x))$

扩展等式后得到：

$\text{softmax}(x)=\frac{\text{exp}(x_i)}{\sum_j\text{exp}(x_j)}$

## 利用TensorFlow实现softmax方法

```python
import TensorFlow as tf
x = tf.placeholder(tf.float32, [None, 784])
```

x表示`tf`的一个占位符`placeholder`，其类型是`tf.float32`，其shape是`[None,784]`，**其中None可以表示任意的值**，在矩阵大小不确定的时候用这种表示方式

再定义权重W和偏量b

```python
W = tf.Variable(tf.zeros([784,10]))
b = tf.Variable(tf.zeros([10]))
```

把W和b都定义为变量，括号内是其**初始值**，`tf.zeros([10])`在这里表示的是一个**一行10列的行向量**，与`np.zeros([10])`表示的是一样的

现在我们使用TensorFlow的矩阵乘法来实现softmax：

```python
y = tf.nn.softmax(tf.matmul(x,W)+b)
```

## 计算机器学习模型的性能

利用交叉熵来评判算法的性能，作为softmax的损失函数，

$H_{y^\prime}(y)=-\sum_i{y_i}{^\prime}\log(y_i) $

其中y是预测的概率分布，$y^\prime$是真实分布，交叉熵是用于测量预测值描述真实值的无效程度的

为了计算交叉熵，需要增加一个占位符

```python
y_=tf.placeholder(tf.float32,[None,10])
```

然后用下式表示交叉熵：

```python
cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_ * tf.log(y), reduction_indices=[1]))
```

## 开始训练和实施模型

通过TensorFlow的train开始训练：

```
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)
```

其中的梯度下降是一个简单的下降方法，训练目标是要求最小化交叉熵

利用`InteractiveSession`来运行模型

```python
sess = tf.InteractiveSession()
```

首先要初始化我们设置的变量

```python
tf.global_variables_initializer().run()
```

下面开始训练，

```
for _ in range(1000):
  batch_xs, batch_ys = mnist.train.next_batch(100)
  sess.run(train_step, feed_dict={x: batch_xs, y_: batch_ys})
```

然后计算预测的准确率

```
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))
```

`tf.argmax(y,1)`用于计算每一列最大值，通过`tf.equal`得到一个全为bool值的向量，通过`tf.reduce_mean`求出精度：

```python
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
```

最终，对测试数据进行实验

```
print(sess.run(accuracy, feed_dict={x: mnist.test.images, y_: mnist.test.labels}))
```















