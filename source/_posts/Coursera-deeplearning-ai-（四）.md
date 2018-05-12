---
title: Coursera-deeplearning-ai-（四）
date: 2018-05-10 09:28:44
tags: [deeplearning,机器学习,深度学习]
category: [机器学习]
---

这篇博文主要讲的是关于deeplearning.ai的第四门课程的内容，《Convolutional Neural Networks》

<!--more-->

## Week one

  ### 计算机视觉

在处理计算机视觉问题的时候，我们可能处理的图片很大，之前我们用的都是64\*64\*3维度的图片，这样的图片不够清晰，如果我们用1000\*1000\*3大小的图片，每张图片的维度就是300w，这就需要很多的数据来调参，并且对系统的资源占用非常大，此时就要用到卷积的技巧，它是卷积神经网络的基础

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/21395179.jpg)

### 利用卷积进行边缘检测的示例

比如我有如下左边这张图，我想检测这张图上面有些上面，我首先要用边缘检测，分别检测出他的横向边缘和纵向边缘

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/16688061.jpg)

边缘检测需要用到卷积，那么上面是卷积呢？

首先，假设我们现在有一张6\*6的灰度图片（仅有一个rgb通道），我们定义一个3\*3的filter，当然有些地方把这个filter称为kernel，我们这里就用filter来表示，那么现在用这个3\*3的filter在6*6的图像上面移动，每移动一个位置进行元素乘积求和，最终得到一个4\*4的结果矩阵，如下图

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/23155888.jpg)

比如左上角的-5，是把3\*3的矩阵放在6\*6的矩阵的左上角得到的，也就是$-5=3\times1+1\times1+2\times1+0\times0+5\times0+7\times0+1\times(-1)+8\times(-1)+2\times(-1)$

然后向右移动一个单位得到-4，一直移动下去得到右边的4\*4矩阵

再举一个直观的例子，比如我们现在有个黑白分明的6\*6灰度图片，我们要检测它的垂直边缘，用一个3\*3的filter卷积，得到一个4\*4的垂直边缘结果，如下

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/45594204.jpg)

4\*4矩阵中间那块白色的就是边缘，此时看起来边缘很大，那是因为我们这里的原始图片太小了，如果原始图片的大小是1000\*1000，那么这个边缘就非常合理了。这里这个边缘也显示了边缘的大体趋势，是正确的

卷积函数在几乎所有深度学习框架当中都有包含，比如TensorFlow当中的`tf.nn.conv2d`

### 更多的边缘检测

边缘有着正边缘和负边缘的说法，从黑到白和从白到黑是不同的，如下图所示：

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/36284135.jpg)

当然，还有水平边缘和垂直边缘的区分，很容易想到水平边缘的filter就是大概将竖直边缘filter转动90度

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/56352677.jpg)

然后，根据filter使用的不同，也可以得到不同的边缘，比如常用的还有sobel filter，参数是1,2,1，还有scharr filter，参数是3,10,3，甚至你可以将这3\*3的filter的9个值都设置为参数，通过反向传播来学习他们，由此你可以检测出任意角度的边缘，比如45度，70度，73度等等

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/88907670.jpg)

### padding 扩充

上面讲到的直接卷积的方法有两个明显的缺点：

1. 图片会被缩小，你输入的是6\*6的图片，最终得到的4\*4的图片，比原始图片大小小了，如果经过若干层网络的卷积之后，得到的图片就相当小了
2. 边缘信息利用得太少了，比如左上角那个像素，你在计算的过程中只会用到1次，但是中间的像素会用到很多次，那么左上角那个像素包含的信息的权重就被减小了

假设我们输入一个n\*n的图片，用一个f\*f的filter进行卷积，那么最终得到的是一个n-f+1的图片

这时，我们可以使用padding的方法，一次解决上面提到的两个问题，所谓的padding就是将原来的图片向外扩充，扩充的值全部填成0，如下图所示

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/92028937.jpg)

假如我们扩充的大小是p，那么最终得到的图片大小就是n+2p-f+1，要使得最终的图片大小等于初始大小，那么p=(f-1)/2，f通常都是一个奇数，不是奇数的时候就要混合padding，就是左右padding的范围不一样

### 带步长的卷积

通常的卷积是每次移动一格，但是如果你加上步长的话，每次就可以移动步长那么多格，比如你现在有一个7\*7的图像，然后有个3\*3的filter，如果你每次移动2步，那么最终得到的是一个3*3的图像

这个计算方法是加入你有一个n\*n的图像，有一个f\*f的filter，stride步长要s，padding的大小p，那么最终得到的图像大小为floor((n+2p-f)/2 +1)，其中floor表示向下取整，以防这是一个非整数的情况

我们在神经网络中用的卷积准确来说应该叫做交叉相关，真正的卷积的filter应该先向右翻转90度，再上下翻转（翻转是为了满足矩阵卷积的结合律），但是因为约定，所以我们在神经网络中的交叉相关都被称为卷积

### 卷积RGB图像

我们之前卷积的都是黑白图像，如果我们需要卷积三通道的RGB图像，我们应该怎么做呢？

如下图，在卷积RGB图像的时候，我们可以用一个同样有三通道的filter进行卷积，filter的每个通道与RGB的红绿蓝三通道相乘并全部求和，最终得到的卷积结果是只有一个通道的而不是三个通道的

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/69668519.jpg)

当我们需要同时取得图像的垂直边缘，水平边缘或者更多的边缘的时候，我们应该怎么做呢？

如果你需要同时取得多个边缘，你只需要同时使用多个filter即可，得到的结果是很多张边缘图，你也可以把他们stack起来

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/57359168.jpg)

那么我们现在总结一下各个层的维度

输入的图片的维度是: $n\times n \times n_c$，其中$n_c$是指图片通道的数量

filter的维度是$f\times f \times n_c$，这里的filter的通道数和图片的通道数应该相同

得到的边缘结果的维度是$(n-f+1)\times (n-f+1) \times n_c^\prime$，其中$n_c^\prime$表示拥有的filter的数量

### 单层卷积神经网络

首先你输入一个RGB三通道的图像，大小是6\*6\*3，然后通过两个filter，大小是3\*3\*3，得到两个4\*4的Z，分别加上bias b1,b2，然后通过Relu函数进行非线性变换，得到4\*4\*2

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/24095269.jpg)

将这个单层的卷积神经网络与神经网络比较，这里的输入图像就是x,也就是$a^{[0]}$，通过的filter相当于w，之后的b相当于偏差，relu函数相当于激活函数g，得到的4\*4\*2的输出相当于$a^{[1]}$

让我们来看看这里面的参数及其维度

用L来表示一个卷积层，$f^{[l]}$表示filter的大小，$p^{[l]}$表示padding的大小，$s^{[l]}$表示stride的大小，$n_c^{[l]}$表示第l层filter的数量

那么输入的维度就是$n_H^{[l-1]}\times n_W^{[l-1]}\times n_c^{[l-1]}$

输出的维度是$n_H^{[l]}\times n_W^{[l]}\times n_c^{[l]}$

其中的$n_H^{[l]}$和$n_W^{[l]}$可以用$n_H^{[l]}=\lfloor \frac{n_H^{[l-1]}+2p^{[l]}-f^{[l]}}{s^{[l]}}+1 \rfloor$来计算

每一个filter的大小是：$f^{[l]} \times f^{[l]} \times n_c^{[l-1]}$，因为filter的通道要和输入相同

激活函数$a^{[l]}$的大小是$n_H^{[l]}\times n_W^{[l]}\times n_c^{[l]}$，如果是批处理$A^{[l]}$的大小是$m \times n_H^{[l]}\times n_W^{[l]}\times n_c^{[l]}$

权重w的大小是$f^{[l-1]}\times f^{[l-1]}\times n_c^{[l-1]} \times n_c^{[l]}$

偏差的大小是$n_c^{[l]}$

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-10/97636140.jpg)

### 简单的卷积网络

下图是一个简单的神经网络的例子，输入层的维度是39\*39\*3，第一层的$f^{[1]}=3$，$s^{[1]}=1$，$p^{[1]}=0$，有10个filter，那么第一层的输出是37\*37\*10；第二层的$f^{[2]}=5$，$s^{[1]}=2$，$p^{[2]}=0$，filter个数是20，第二层的输出是17\*17\*20；第三层的$f^{[3]}=5$，$s^{[3]}=2$，$p^{[3]}=0$，filter个数是40，输出是7\*7\*40

然后，将得到的7\*7\*40的图像flatten成一个7\*7\*40=1960*1的向量，然后把这个向量输入一个logistics或softmax函数，以此进行分类

通常来说，卷积网络的图像大小会越来越小，但通道数会越来越多

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-11/9623750.jpg)

卷及网络中的典型层有：

1. Convolution (conv)
2. Pooling（pool）
3. Fully connected (FC)

### Pooling Layers

利用pooling layer去减小表达的大小，加速计算，并使得某些特征更加稳定

pooling layer最常用的就是max pooling，就是用一个filter去移动，但是不是相乘求和，而是求出这个filter移动过程中的最大值，如下所示

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-11/11785024.jpg)

还有一种pooling叫做average pooling，不是求最大值而是平均值，这种pooling用的非常少

### 一个完整的卷积神经网络示例

如图，我们输入一个32\*32\*3的网络，经过一个conv1层，f=5,s=1，得到一个28\*28\*6的输出，然后经一个maxpoo层pool1，得到14\*14\*6，这个conv1和pool1被合称为layer1，因为layer只算那些有参数的层，pool层没有参数，所以conv1和pool1合称一层layer1

然后经过conv2,f=5,s=1，得到10\*10\*16，然后经过pool2，得到5\*5\*16

此时flatten成400\*1的向量，然后用普通的神经网络继续传输，此时用普通神经网络的层被称之为fully connected层，W[3]的参数是(120,400)，所以a[3]=(120,1)，然后w[4]=(84,120)，得到a[4]=(84,1)，然后经过一个softmax层，因为我们这里是分类数字0-9，所以最后的输出是(10,1)，然后选择概率最大那个

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-11/71162365.jpg)

### 为什么要用卷积神经网络

卷积神经网络可以显著地减少参数，我们来看个例子

如下图你有一个卷积层，本来大小是32\*32\*3，经过一个卷积层之后大小成了28\*28\*6，那么你用到的参数个数应该是5\*5\*6+6=156个，如果你直接用全联通层，那么你需要的参数个数是32\*32\*3\*28\*28\*6=14M个，明显这里的参数就非常多了

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-11/43271742.jpg)

还有种解释是卷及网络有参数共享和稀疏连接的好处

如图，你通过卷积层得到的每一个值，都只与自己的那9个卷积的值相关，与别的值不相关，这就是稀疏连接的意思，各个值之间不干扰

参数共享的意思是，比如你有一个3\*3的filter，可以进行垂直边缘检测，那么这个filter无论是在**同一张图**的哪个地方，都可以进行边缘检测，而不是说只能在某个地方进行

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-11/32143114.jpg)

## 利用TensorFlow搭建卷积神经网络

这周的编程作业就是利用TensorFlow搭建卷积神经网络，那么我们对程序回顾一下

先看看数据读入的程序

```python
def load_dataset():
    train_dataset = h5py.File('datasets/train_signs.h5', "r")
    train_set_x_orig = np.array(train_dataset["train_set_x"][:]) # your train set features
    train_set_y_orig = np.array(train_dataset["train_set_y"][:]) # your train set labels

    test_dataset = h5py.File('datasets/test_signs.h5', "r")
    test_set_x_orig = np.array(test_dataset["test_set_x"][:]) # your test set features
    test_set_y_orig = np.array(test_dataset["test_set_y"][:]) # your test set labels

    classes = np.array(test_dataset["list_classes"][:]) # the list of classes
    
    train_set_y_orig = train_set_y_orig.reshape((1, train_set_y_orig.shape[0]))
    test_set_y_orig = test_set_y_orig.reshape((1, test_set_y_orig.shape[0]))
    
    return train_set_x_orig, train_set_y_orig, test_set_x_orig, test_set_y_orig, classes
```





# Convolutional Neural Networks: Application

Welcome to Course 4's second assignment! In this notebook, you will:

- Implement helper functions that you will use when implementing a TensorFlow model
- Implement a fully functioning ConvNet using TensorFlow 

**After this assignment you will be able to:**

- Build and train a ConvNet in TensorFlow for a classification problem 

We assume here that you are already familiar with TensorFlow. If you are not, please refer the *TensorFlow Tutorial* of the third week of Course 2 ("*Improving deep neural networks*").

## 1.0 - TensorFlow model

In the previous assignment, you built helper functions using numpy to understand the mechanics behind convolutional neural networks. Most practical applications of deep learning today are built using programming frameworks, which have many built-in functions you can simply call. 

As usual, we will start by loading in the packages. 

```python
import math
import numpy as np
import h5py
import matplotlib.pyplot as plt
import scipy
from PIL import Image
from scipy import ndimage
import tensorflow as tf
from tensorflow.python.framework import ops
from cnn_utils import *

%matplotlib inline
np.random.seed(1)
```

Run the next cell to load the "SIGNS" dataset you are going to use.

```python
# Loading the data (signs)
X_train_orig, Y_train_orig, X_test_orig, Y_test_orig, classes = load_dataset()
```

As a reminder, the SIGNS dataset is a collection of 6 signs representing numbers from 0 to 5.

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-12/49434886.jpg)

The next cell will show you an example of a labelled image in the dataset. Feel free to change the value of `index` below and re-run to see different examples. 

```python
# Example of a picture
index = 6
plt.imshow(X_train_orig[index])
print ("y = " + str(np.squeeze(Y_train_orig[:, index])))
```

```
y = 2
```

In Course 2, you had built a fully-connected network for this dataset. But since this is an image dataset, it is more natural to apply a ConvNet to it.

To get started, let's examine the shapes of your data. 

```python
X_train = X_train_orig/255.
X_test = X_test_orig/255.
Y_train = convert_to_one_hot(Y_train_orig, 6).T
Y_test = convert_to_one_hot(Y_test_orig, 6).T
print ("number of training examples = " + str(X_train.shape[0]))
print ("number of test examples = " + str(X_test.shape[0]))
print ("X_train shape: " + str(X_train.shape))
print ("Y_train shape: " + str(Y_train.shape))
print ("X_test shape: " + str(X_test.shape))
print ("Y_test shape: " + str(Y_test.shape))
conv_layers = {}
```

```
number of training examples = 1080
number of test examples = 120
X_train shape: (1080, 64, 64, 3)
Y_train shape: (1080, 6)
X_test shape: (120, 64, 64, 3)
Y_test shape: (120, 6)
```

### 1.1 - Create placeholders

TensorFlow requires that you create placeholders for the input data that will be fed into the model when running the session.

**Exercise**: Implement the function below to create placeholders for the input image X and the output Y. You should not define the number of training examples for the moment. To do so, you could use "None" as the batch size, it will give you the flexibility to choose it later. Hence X should be of dimension **[None, n_H0, n_W0, n_C0]** and Y should be of dimension **[None, n_y]**.  [Hint](https://www.tensorflow.org/api_docs/python/tf/placeholder).

```python
# GRADED FUNCTION: create_placeholders

def create_placeholders(n_H0, n_W0, n_C0, n_y):
    """
    Creates the placeholders for the tensorflow session.
    
    Arguments:
    n_H0 -- scalar, height of an input image
    n_W0 -- scalar, width of an input image
    n_C0 -- scalar, number of channels of the input
    n_y -- scalar, number of classes
        
    Returns:
    X -- placeholder for the data input, of shape [None, n_H0, n_W0, n_C0] and dtype "float"
    Y -- placeholder for the input labels, of shape [None, n_y] and dtype "float"
    """

    ### START CODE HERE ### (≈2 lines)
    X = tf.placeholder(dtype=tf.float32,shape=(None, n_H0, n_W0, n_C0))
    Y = tf.placeholder(dtype=tf.float32,shape=(None,n_y))
    ### END CODE HERE ###
    
    return X, Y
```

```python
X, Y = create_placeholders(64, 64, 3, 6)
print ("X = " + str(X))
print ("Y = " + str(Y))
```

```
X = Tensor("Placeholder:0", shape=(?, 64, 64, 3), dtype=float32)
Y = Tensor("Placeholder_1:0", shape=(?, 6), dtype=float32)
```

**Expected Output**

<table> 
<tr>
<td>

```
X = Tensor("Placeholder:0", shape=(?, 64, 64, 3), dtype=float32)
```

</td>
</tr>
<tr>
<td>

```
Y = Tensor("Placeholder_1:0", shape=(?, 6), dtype=float32)
```

</td>
</tr>
</table>

### 1.2 - Initialize parameters

You will initialize weights/filters $W1$ and $W2$ using `tf.contrib.layers.xavier_initializer(seed = 0)`. You don't need to worry about bias variables as you will soon see that TensorFlow functions take care of the bias. Note also that you will only initialize the weights/filters for the conv2d functions. TensorFlow initializes the layers for the fully connected part automatically. We will talk more about that later in this assignment.

**Exercise:** Implement initialize_parameters(). The dimensions for each group of filters are provided below. Reminder - to initialize a parameter $W$ of shape [1,2,3,4] in Tensorflow, use:

```python
W = tf.get_variable("W", [1,2,3,4], initializer = ...)
```

[More Info](https://www.tensorflow.org/api_docs/python/tf/get_variable).

```python
# GRADED FUNCTION: initialize_parameters

def initialize_parameters():
    """
    Initializes weight parameters to build a neural network with tensorflow. The shapes are:
                        W1 : [4, 4, 3, 8]
                        W2 : [2, 2, 8, 16]
    Returns:
    parameters -- a dictionary of tensors containing W1, W2
    """
    
    tf.set_random_seed(1)                              # so that your "random" numbers match ours
        
    ### START CODE HERE ### (approx. 2 lines of code)
    W1 = tf.get_variable('W1',shape=[4,4,3,8],initializer=tf.contrib.layers.xavier_initializer(seed = 0))
    W2 = tf.get_variable('W2',shape=[2,2,8,16],initializer=tf.contrib.layers.xavier_initializer(seed = 0))
    ### END CODE HERE ###

    parameters = {"W1": W1,
                  "W2": W2}
    
    return parameters
```

```python
tf.reset_default_graph()
with tf.Session() as sess_test:
    parameters = initialize_parameters()
    init = tf.global_variables_initializer()
    sess_test.run(init)
    print("W1 = " + str(parameters["W1"].eval()[1,1,1]))
    print("W2 = " + str(parameters["W2"].eval()[1,1,1]))
```

```
W1 = [ 0.00131723  0.14176141 -0.04434952  0.09197326  0.14984085 -0.03514394
 -0.06847463  0.05245192]
W2 = [-0.08566415  0.17750949  0.11974221  0.16773748 -0.0830943  -0.08058
 -0.00577033 -0.14643836  0.24162132 -0.05857408 -0.19055021  0.1345228
 -0.22779644 -0.1601823  -0.16117483 -0.10286498]
```

** Expected Output:**

<table> 

```
<tr>
    <td>
    W1 = 
    </td>
    <td>
```

[ 0.00131723  0.14176141 -0.04434952  0.09197326  0.14984085 -0.03514394 <br>
 -0.06847463  0.05245192]

```
    </td>
</tr>

<tr>
    <td>
    W2 = 
    </td>
    <td>
```

[-0.08566415  0.17750949  0.11974221  0.16773748 -0.0830943  -0.08058 <br>
 -0.00577033 -0.14643836  0.24162132 -0.05857408 -0.19055021  0.1345228 <br>
 -0.22779644 -0.1601823  -0.16117483 -0.10286498]

```
    </td>
</tr>
```

</table>

### 1.2 - Forward propagation

In TensorFlow, there are built-in functions that carry out the convolution steps for you.

- **tf.nn.conv2d(X,W1, strides = [1,s,s,1], padding = 'SAME'):** given an input $X$ and a group of filters $W1$, this function convolves $W1$'s filters on X. The third input ([1,f,f,1]) represents the strides for each dimension of the input (m, n_H_prev, n_W_prev, n_C_prev). You can read the full documentation [here](https://www.tensorflow.org/api_docs/python/tf/nn/conv2d)
- **tf.nn.max_pool(A, ksize = [1,f,f,1], strides = [1,s,s,1], padding = 'SAME'):** given an input A, this function uses a window of size (f, f) and strides of size (s, s) to carry out max pooling over each window. You can read the full documentation [here](https://www.tensorflow.org/api_docs/python/tf/nn/max_pool)
- **tf.nn.relu(Z1):** computes the elementwise ReLU of Z1 (which can be any shape). You can read the full documentation [here.](https://www.tensorflow.org/api_docs/python/tf/nn/relu)
- **tf.contrib.layers.flatten(P)**: given an input P, this function flattens each example into a 1D vector it while maintaining the batch-size. It returns a flattened tensor with shape [batch_size, k]. You can read the full documentation [here.](https://www.tensorflow.org/api_docs/python/tf/contrib/layers/flatten)
- **tf.contrib.layers.fully_connected(F, num_outputs):** given a the flattened input F, it returns the output computed using a fully connected layer. You can read the full documentation [here.](https://www.tensorflow.org/api_docs/python/tf/contrib/layers/fully_connected)

In the last function above (`tf.contrib.layers.fully_connected`), the fully connected layer automatically initializes weights in the graph and keeps on training them as you train the model. Hence, you did not need to initialize those weights when initializing the parameters. 

**Exercise**: 

Implement the `forward_propagation` function below to build the following model: `CONV2D -> RELU -> MAXPOOL -> CONV2D -> RELU -> MAXPOOL -> FLATTEN -> FULLYCONNECTED`. You should use the functions above. 

In detail, we will use the following parameters for all the steps:

```
 - Conv2D: stride 1, padding is "SAME"
 - ReLU
 - Max pool: Use an 8 by 8 filter size and an 8 by 8 stride, padding is "SAME"
 - Conv2D: stride 1, padding is "SAME"
 - ReLU
 - Max pool: Use a 4 by 4 filter size and a 4 by 4 stride, padding is "SAME"
 - Flatten the previous output.
 - FULLYCONNECTED (FC) layer: Apply a fully connected layer without an non-linear activation function. Do not call the softmax here. This will result in 6 neurons in the output layer, which then get passed later to a softmax. In TensorFlow, the softmax and cost function are lumped together into a single function, which you'll call in a different function when computing the cost. 
```

```python
# GRADED FUNCTION: forward_propagation

def forward_propagation(X, parameters):
    """
    Implements the forward propagation for the model:
    CONV2D -> RELU -> MAXPOOL -> CONV2D -> RELU -> MAXPOOL -> FLATTEN -> FULLYCONNECTED
    
    Arguments:
    X -- input dataset placeholder, of shape (input size, number of examples)
    parameters -- python dictionary containing your parameters "W1", "W2"
                  the shapes are given in initialize_parameters

    Returns:
    Z3 -- the output of the last LINEAR unit
    """
    
    # Retrieve the parameters from the dictionary "parameters" 
    W1 = parameters['W1']
    W2 = parameters['W2']
    
    ### START CODE HERE ###
    # CONV2D: stride of 1, padding 'SAME'
    Z1 = tf.nn.conv2d(X,W1,strides=[1, 1, 1, 1],padding='SAME')
    # RELU
    A1 = tf.nn.relu(Z1)
    # MAXPOOL: window 8x8, sride 8, padding 'SAME'
    P1 = tf.nn.max_pool(A1,ksize=[1, 8, 8, 1],strides=[1, 8, 8, 1],padding='SAME')
    # CONV2D: filters W2, stride 1, padding 'SAME'
    Z2 = tf.nn.conv2d(P1,W2,strides=[1, 1, 1, 1],padding='SAME')
    # RELU
    A2 = tf.nn.relu(Z2)
    # MAXPOOL: window 4x4, stride 4, padding 'SAME'
    P2 = tf.nn.max_pool(A2,ksize=[1, 4, 4, 1],strides=[1, 4, 4, 1],padding='SAME')
    # FLATTEN
    P2 = tf.contrib.layers.flatten(P2)
    # FULLY-CONNECTED without non-linear activation function (not not call softmax).
    # 6 neurons in output layer. Hint: one of the arguments should be "activation_fn=None" 
    Z3 = tf.contrib.layers.fully_connected(P2, num_outputs=6, activation_fn=None)
    ### END CODE HERE ###

    return Z3
```

```python
tf.reset_default_graph()

with tf.Session() as sess:
    np.random.seed(1)
    X, Y = create_placeholders(64, 64, 3, 6)
    parameters = initialize_parameters()
    Z3 = forward_propagation(X, parameters)
    init = tf.global_variables_initializer()
    sess.run(init)
    a = sess.run(Z3, {X: np.random.randn(2,64,64,3), Y: np.random.randn(2,6)})
    print("Z3 = " + str(a))
```

```
Z3 = [[-0.44670227 -1.57208765 -1.53049231 -2.31013036 -1.29104376  0.46852064]
 [-0.17601591 -1.57972014 -1.4737016  -2.61672091 -1.00810647  0.5747785 ]]
```

**Expected Output**:

<table> 

```
<td> 
Z3 =
</td>
<td>
[[-0.44670227 -1.57208765 -1.53049231 -2.31013036 -1.29104376  0.46852064] <br>
```

 [-0.17601591 -1.57972014 -1.4737016  -2.61672091 -1.00810647  0.5747785 ]]

```
</td>
```

</table>

### 1.3 - Compute cost

Implement the compute cost function below. You might find these two functions helpful: 

- **tf.nn.softmax_cross_entropy_with_logits(logits = Z3, labels = Y):** computes the softmax entropy loss. This function both computes the softmax activation function as well as the resulting loss. You can check the full documentation  [here.](https://www.tensorflow.org/api_docs/python/tf/nn/softmax_cross_entropy_with_logits)
- **tf.reduce_mean:** computes the mean of elements across dimensions of a tensor. Use this to sum the losses over all the examples to get the overall cost. You can check the full documentation [here.](https://www.tensorflow.org/api_docs/python/tf/reduce_mean)

** Exercise**: Compute the cost below using the function above.

```python
# GRADED FUNCTION: compute_cost 

def compute_cost(Z3, Y):
    """
    Computes the cost
    
    Arguments:
    Z3 -- output of forward propagation (output of the last LINEAR unit), of shape (6, number of examples)
    Y -- "true" labels vector placeholder, same shape as Z3
    
    Returns:
    cost - Tensor of the cost function
    """
    
    ### START CODE HERE ### (1 line of code)
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=Z3, labels=Y))
    ### END CODE HERE ###
    
    return cost
```

```python
tf.reset_default_graph()

with tf.Session() as sess:
    np.random.seed(1)
    X, Y = create_placeholders(64, 64, 3, 6)
    parameters = initialize_parameters()
    Z3 = forward_propagation(X, parameters)
    cost = compute_cost(Z3, Y)
    init = tf.global_variables_initializer()
    sess.run(init)
    a = sess.run(cost, {X: np.random.randn(4,64,64,3), Y: np.random.randn(4,6)})
    print("cost = " + str(a))
```

```
cost = 2.91034
```



**Expected Output**: 

<table>

```
<td> 
cost =
</td> 

<td> 
2.91034
</td> 
```

</table>

## 1.4 Model

Finally you will merge the helper functions you implemented above to build a model. You will train it on the SIGNS dataset. 

You have implemented `random_mini_batches()` in the Optimization programming assignment of course 2. Remember that this function returns a list of mini-batches. 

**Exercise**: Complete the function below. 

The model below should:

- create placeholders
- initialize parameters
- forward propagate
- compute the cost
- create an optimizer

Finally you will create a session and run a for loop  for num_epochs, get the mini-batches, and then for each mini-batch you will optimize the function. [Hint for initializing the variables](https://www.tensorflow.org/api_docs/python/tf/global_variables_initializer)

```python
# GRADED FUNCTION: model

def model(X_train, Y_train, X_test, Y_test, learning_rate = 0.009,
          num_epochs = 100, minibatch_size = 64, print_cost = True):
    """
    Implements a three-layer ConvNet in Tensorflow:
    CONV2D -> RELU -> MAXPOOL -> CONV2D -> RELU -> MAXPOOL -> FLATTEN -> FULLYCONNECTED
    
    Arguments:
    X_train -- training set, of shape (None, 64, 64, 3)
    Y_train -- test set, of shape (None, n_y = 6)
    X_test -- training set, of shape (None, 64, 64, 3)
    Y_test -- test set, of shape (None, n_y = 6)
    learning_rate -- learning rate of the optimization
    num_epochs -- number of epochs of the optimization loop
    minibatch_size -- size of a minibatch
    print_cost -- True to print the cost every 100 epochs
    
    Returns:
    train_accuracy -- real number, accuracy on the train set (X_train)
    test_accuracy -- real number, testing accuracy on the test set (X_test)
    parameters -- parameters learnt by the model. They can then be used to predict.
    """
    
    ops.reset_default_graph()                         # to be able to rerun the model without overwriting tf variables
    tf.set_random_seed(1)                             # to keep results consistent (tensorflow seed)
    seed = 3                                          # to keep results consistent (numpy seed)
    (m, n_H0, n_W0, n_C0) = X_train.shape             
    n_y = Y_train.shape[1]                            
    costs = []                                        # To keep track of the cost
    
    # Create Placeholders of the correct shape
    ### START CODE HERE ### (1 line)
    X, Y = create_placeholders(n_H0,n_W0,n_C0,n_y)
    ### END CODE HERE ###

    # Initialize parameters
    ### START CODE HERE ### (1 line)
    parameters = initialize_parameters()
    ### END CODE HERE ###
    
    # Forward propagation: Build the forward propagation in the tensorflow graph
    ### START CODE HERE ### (1 line)
    Z3 = forward_propagation(X,parameters)
    ### END CODE HERE ###
    
    # Cost function: Add cost function to tensorflow graph
    ### START CODE HERE ### (1 line)
    cost = compute_cost(Z3,Y)
    ### END CODE HERE ###
    
    # Backpropagation: Define the tensorflow optimizer. Use an AdamOptimizer that minimizes the cost.
    ### START CODE HERE ### (1 line)
    optimizer = tf.train.AdamOptimizer().minimize(cost)
    ### END CODE HERE ###
    
    # Initialize all the variables globally
    init = tf.global_variables_initializer()
     
    # Start the session to compute the tensorflow graph
    with tf.Session() as sess:
        
        # Run the initialization
        sess.run(init)
        
        # Do the training loop
        for epoch in range(num_epochs):

            minibatch_cost = 0.
            num_minibatches = int(m / minibatch_size) # number of minibatches of size minibatch_size in the train set
            seed = seed + 1
            minibatches = random_mini_batches(X_train, Y_train, minibatch_size, seed)

            for minibatch in minibatches:

                # Select a minibatch
                (minibatch_X, minibatch_Y) = minibatch
                # IMPORTANT: The line that runs the graph on a minibatch.
                # Run the session to execute the optimizer and the cost, the feedict should contain a minibatch for (X,Y).
                ### START CODE HERE ### (1 line)
                _ , temp_cost = sess.run([optimizer,cost], feed_dict={X:minibatch_X, Y: minibatch_Y})
                ### END CODE HERE ###
                
                minibatch_cost += temp_cost / num_minibatches
                

            # Print the cost every epoch
            if print_cost == True and epoch % 5 == 0:
                print ("Cost after epoch %i: %f" % (epoch, minibatch_cost))
            if print_cost == True and epoch % 1 == 0:
                costs.append(minibatch_cost)
        
        
        # plot the cost
        plt.plot(np.squeeze(costs))
        plt.ylabel('cost')
        plt.xlabel('iterations (per tens)')
        plt.title("Learning rate =" + str(learning_rate))
        plt.show()

        # Calculate the correct predictions
        predict_op = tf.argmax(Z3, 1)
        correct_prediction = tf.equal(predict_op, tf.argmax(Y, 1))
        
        # Calculate accuracy on the test set
        accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))
        print(accuracy)
        train_accuracy = accuracy.eval({X: X_train, Y: Y_train})
        test_accuracy = accuracy.eval({X: X_test, Y: Y_test})
        print("Train Accuracy:", train_accuracy)
        print("Test Accuracy:", test_accuracy)
                
        return train_accuracy, test_accuracy, parameters
```

Run the following cell to train your model for 100 epochs. Check if your cost after epoch 0 and 5 matches our output. If not, stop the cell and go back to your code!

```python
_, _, parameters = model(X_train, Y_train, X_test, Y_test)
```

```
Cost after epoch 0: 1.920183
Cost after epoch 5: 1.885439
Cost after epoch 10: 1.849110
Cost after epoch 15: 1.730203
Cost after epoch 20: 1.503597
Cost after epoch 25: 1.264177
Cost after epoch 30: 1.095219
Cost after epoch 35: 0.985675
Cost after epoch 40: 0.902660
Cost after epoch 45: 0.831738
Cost after epoch 50: 0.776374
Cost after epoch 55: 0.730666
Cost after epoch 60: 0.678335
Cost after epoch 65: 0.643941
Cost after epoch 70: 0.621297
Cost after epoch 75: 0.594998
Cost after epoch 80: 0.568649
Cost after epoch 85: 0.539469
Cost after epoch 90: 0.514542
Cost after epoch 95: 0.490415

```



![png](output_28_1.png)

```
Tensor("Mean_1:0", shape=(), dtype=float32)
Train Accuracy: 0.860185
Test Accuracy: 0.75

```

**Expected output**: although it may not match perfectly, your expected output should be close to ours and your cost value should decrease.

<table> 
<tr>

```
<td> 
**Cost after epoch 0 =**
</td>

<td> 
  1.917929
</td> 

```

</tr>
<tr>

```
<td> 
**Cost after epoch 5 =**
</td>

<td> 
  1.506757
</td> 

```

</tr>
<tr>

```
<td> 
**Train Accuracy   =**
</td>

<td> 
  0.940741
</td> 

```

</tr> 

<tr>

```
<td> 
**Test Accuracy   =**
</td>

<td> 
  0.783333
</td> 

```

</tr> 
</table>

Congratulations! You have finised the assignment and built a model that recognizes SIGN language with almost 80% accuracy on the test set. If you wish, feel free to play around with this dataset further. You can actually improve its accuracy by spending more time tuning the hyperparameters, or using regularization (as this model clearly has a high variance). 

Once again, here's a thumbs up for your work! 

```python
fname = "images/thumbs_up.jpg"
image = np.array(ndimage.imread(fname, flatten=False))
my_image = scipy.misc.imresize(image, size=(64,64))
plt.imshow(my_image)
```







