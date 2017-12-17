---
title: numpy教程
date: 2017-10-22 21:17:06
tags: [数据分析]
category: [编程学习]
---

## 使用jupyter notebook 分析数据之前导入的包

```
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

%matplotlib inline
import matplotlib.pyplot as plt  # Matlab-style plotting
import seaborn as sns
color = sns.color_palette()
sns.set_style('darkgrid')

import warnings
def ignore_warn(*args, **kwargs):
    pass
warnings.warn = ignore_warn #ignore annoying warning (from sklearn and seaborn)
```

<!--more-->

在`numpy`的使用过程中，最重要的概念就是`ndarray`，实质上就是数组，在`numpy`中的所有对象都是`ndarray` 

每一个ndarray对象都有一个shape和dtype属性，用于存储**数组的形状**和**数据类型**

| 函数               | 说明                                       |
| :--------------- | :--------------------------------------- |
| array            | 将输入的数据转换为ndarray                         |
| asarray          | 将输入转换为ndarray                            |
| arange           | range的数组版本                               |
| ones、ones_like   | 根据指定的形状创建一个全1的数组，ones_like以另一个数组为参数，创建一个与该数组大小相同的全为1的数组 |
| zero、zeros_like  | 与ones和ones_like类似                        |
| empty、empty_like | 创建一个没有赋予初始值的数组，用法与ones和ones_like类似       |
| eye，identity     | 创建一个单位矩阵                                 |

可以通过ndarray的astype方法将数组的数据类型转换为其他类型

### 乘法

*：直接用乘号或者除号，表示数组**元素之间直接相乘**，这个操作称之为广播（不同大小数组之间的运算）

**np.dot(x,y)或x.dot(y)：用于矩阵乘积**

### 索引和复制

```python
In [1]: arr = np.arange(10)
In [2]: arr
Out[2]: array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
In [3]: arr[5:8] = 12
In [4]: arr
Out[4]: array([ 0,  1,  2,  3,  4, 12, 12, 12,  8,  9])
In [5]: arr_slice = arr[5:8]
In [6]: arr_slice[1] = 12345
In [7]: arr
Out[7]: array([    0,     1,     2,     3,     4,    12, 12345,    12,     8,     9])
```

numpy当中所有数据切片赋值时都是没有进行复制的，视图上的任何修改都会直接反映到原数组上，因为numpy一般处理非常大的数据集，如果numpy每次进行操作的话就是复制非常多的数据。

### 花式索引（fancy indexing）

 ```
In [1]: arr = np.arange(32).reshape((8,4))

In [2]: arr
Out[2]:
array([[ 0,  1,  2,  3],
       [ 4,  5,  6,  7],
       [ 8,  9, 10, 11],
       [12, 13, 14, 15],
       [16, 17, 18, 19],
       [20, 21, 22, 23],
       [24, 25, 26, 27],
       [28, 29, 30, 31]])

In [3]: arr[[-1,1,3]]
Out[3]:
array([[28, 29, 30, 31],
       [ 4,  5,  6,  7],
       [12, 13, 14, 15]])
In [4]: arr[[1,2,3,-1],[3,2,1,0]]
Out[4]: array([ 7, 10, 13, 28])
 ```

同时传入多个索引，一次索引出多个值

### 转置

arr.T表示arr的转置，或者transpose方法表示转置

tanspose有一个换维度的操作

```
In [4]: arr = np.arange(16).reshape((2,2,4))

In [5]: arr
Out[5]:
array([[[ 0,  1,  2,  3],
        [ 4,  5,  6,  7]],

       [[ 8,  9, 10, 11],
        [12, 13, 14, 15]]])

In [6]: arr.transpose((1,0,2))
Out[6]:
array([[[ 0,  1,  2,  3],
        [ 8,  9, 10, 11]],

       [[ 4,  5,  6,  7],
        [12, 13, 14, 15]]])
简而言之就是将原来的0，1，2轴变成现在的1，0，2，转换后的0轴是原来的1轴，转换后的1轴是原来的0轴，2轴未变。
换种解释：比如说8元素的索引是[1,0,0]，0，1轴变换后是[0,1,0]。
```

### 通用函数

（ufunc）：快速的元素级数组函数

| 函数                         | 说明                                 |
| -------------------------- | ---------------------------------- |
| abs,fabs                   | 计算绝对值，对于非复数，可以使用更快的fabs            |
| sqrt                       | 计算元素的平方根，相当于arr**0.5               |
| square                     | 计算各元素平，相当于arr**2                   |
| log，log10，log2，log1p       | 计算自然对数，以10位底的对数，底数为2的对数，以及log（1+x） |
| sign                       | 取元素的符号，1正，0零，-1负                   |
| ceil                       | 向上取整                               |
|                            | 向下取整                               |
|                            | 四舍五入取整                             |
|                            | 将数组的小数和整数部分分别用两个数组返回               |
| isfinite,isinf             | 返回哪些元素是有穷的，哪些元素是无穷的布尔型数组           |
| cos,cosh,sin,sinh,tan,tanh | 三角函数                               |
| logical_not                | 计算各元素not x的真值，相当于-arr              |

二元ufunc

| 函数                                       | 说明                   |
| ---------------------------------------- | -------------------- |
| add                                      | 将数组对应元素相加            |
| subtract                                 | 对应元素相减               |
| multiply                                 | 对应元素相乘               |
| divide，floor_divide                      | 除法或丢掉余数的整除法          |
| pow                                      | 计算$A^B$              |
| maximum, fmax                            | 元素级的最大值计算，fmax忽略nana |
| minimum,fmin                             | 最小值计算                |
| mod                                      | 求模运算                 |
| copysign                                 | 将B数组的符号复制给第一个数组      |
| greater，greater_equal，less，less_equal,equal, not_equal | 元素比较                 |
| logical_and, logical_or，logical_xor      | 元素级别真值逻辑运算           |

### meshgrid函数

`X,Y = np.meshgrid(a,b)` 得到X为a作为行向量，扩展b.shape那么多行，Y是以b为列向量，扩展a.shape那么多列

```
In [67]: xnums
Out[67]: array([0,1, 2, 3])
 
In [68]: ynums
Out[68]: array([0,1, 2, 3, 4])
 
In [69]: data_list= np.meshgrid(xnums,ynums)
 
In [70]: data_list
Out[70]:
[array([[0, 1, 2,3],
        [0, 1, 2, 3],
        [0, 1, 2, 3],
        [0, 1, 2, 3],
        [0, 1, 2, 3]]), array([[0, 0, 0, 0],
        [1, 1, 1, 1],
        [2, 2, 2, 2],
        [3, 3, 3, 3],
        [4, 4, 4, 4]])]
```

### np.where（）

np.where可以进行`x if condition else y`的快捷形式

比如我们在下面的例子中，将所有正数替换为2，负数替换为1

```
In [7]: arr = np.random.randn(4,4)

In [8]: arr
Out[8]:
array([[ 0.67616266, -0.05338506,  1.24429511, -0.01608611],
       [ 1.19887484, -0.26227917, -1.06689128,  1.6256341 ],
       [ 1.33528028, -0.56730727,  0.00761954,  0.15508178],
       [-1.4552253 ,  0.12884633,  0.63242436, -0.62763473]])

In [9]: np.where(arr>0, 2, 1)
Out[9]:
array([[2, 1, 2, 1],
       [2, 1, 1, 2],
       [2, 1, 2, 2],
       [1, 2, 2, 1]])
```

### 基本统计方法

sum求和，mean均值，std标准差，var方差，min，max最小最大值

**argmin，argmax最小最大值的索引**

**cumsum：所有元素的累积和**，和search_sorted方法配合可以算出分位数所在的位置

```
In [10]: arr = np.random.randn(1000)

In [11]: arr.sort()

In [12]: arr.searchsorted(int(0.05*(max(arr)-min(arr))))
Out[12]: 458
```

**cumprod：所有元素的累积积**

### 唯一化及逻辑运算

`np.unique`效果与python中的set对于list的效果一样，只保留不相同的值

`np.in1d`用于测试参数是否在数组中

```
In [13]: arr = np.arange(6)

In [14]: arr
Out[14]: array([0, 1, 2, 3, 4, 5])

In [15]: np.in1d(arr,[0,3,4])
Out[15]: array([ True, False, False,  True,  True, False], dtype=bool)
```

### 集合运算的函数

| 函数               | 说明                          |
| ---------------- | --------------------------- |
| unique           | 返回唯一元素的有序结果                 |
| intersect1d(x,y) | 交集（计算xy的公共元素并返回有序结果）        |
| union            | 并集                          |
| in1d（x,y）        | y是否存在于x中的布尔数组               |
| setdiff1d        | 差集                          |
| setxor1d         | 对称差，存在于一个数组中但不同时存在于两个书注重的元素 |

### 元素保存

`np.save('filename', arr)`:如果没有加后缀会自动加上.npy，然后可以使用np.load读取这个array

`np.savez('filename', a=arr1, b=arr2)`:存储到压缩文件，后缀为.npz，读取时用load，然后通过字典key，value的索引方式分别取出a和b

`np.loadtxt('array.txt',delimiter=',')`：读取txt文件，指定分隔符号为delimiter

`np.savetxt('filename', arr)`：保存为txt文件

### 线性代数运算

| 函数    | 说明                      |
| ----- | ----------------------- |
| diag  | 返回方阵的对角线元素，或者把一维数组转化为方阵 |
| dot   | 矩阵乘法                    |
| trace | 对角线元素和                  |
| det   | 矩阵行列式                   |
| eig   | 计算方阵的特征值和特征向量           |
| inv   | 求方阵的逆                   |
| pinv  | 伪逆                      |
|       | 计算QR分解值                 |
| svd   | 奇异值分解                   |
|       | 解线性方程Ax=b，其中A是一个矩阵      |
|       | 计算Ax=b的最小二乘解            |

### 随机数生成

| 函数          | 说明                      |
| ----------- | ----------------------- |
| seed        | 确定随机数生成器的种子             |
| permutation | 返回一个序列的随机排列或者一个随机排列的范围  |
| **shuffle** | **随机打乱一个序列**            |
| **rand**    | 产生均匀随机分布的样本值            |
| **randint** | **从给定的上下范围内随机选取整数**     |
| randn       | 产生正态分布（平均值为0，标准差为1）的样本值 |
|             | 产生二项分布的样本值              |
|             | 产生正态分布的样本值              |
|             | 产生beta分布的样本值            |

 