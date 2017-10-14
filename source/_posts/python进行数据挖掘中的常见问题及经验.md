---
title: python进行数据挖掘中的常见问题及经验
date: 2017-10-09 14:31:21
tags: [数据挖掘,pandas]
category: [编程学习,数据挖掘]

---

<!--more-->

## 在数据分析程序中需要引入的包及设置

用python进行数据分析的时候，需要在文件开头导入一下包

```python
import numpy as np # linear algebra 引入线性代数包numpy
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

#%matplotlib inline
import matplotlib.pyplot as plt  # Matlab-style plotting 画图工具包
import seaborn as sns # 画图美化工具包
color = sns.color_palette()
sns.set_style('darkgrid')

import warnings
def ignore_warn(*args, **kwargs):
    pass
warnings.warn = ignore_warn #ignore annoying warning (from sklearn and seaborn)

from scipy import stats
from scipy.stats import norm, skew #for some statistics

pd.set_option('display.float_format', lambda x: '{:.3f}'.format(x)) #Limiting floats output to 3 decimal points 设置在pd中只显示3位小数
```

## 画数据分布图

使用`seaborn`包进行画图，其中数据分布图为`distplot`，fit参数表示需要拟合的分布类型，`norm`表示拟合正态分布，正态分布的参数可以由`norm.fit`来获得

```
sns.distplot(data_train['SalePrice'],fit=norm)
(mu, sigma) = norm.fit(data_train['SalePrice'])
plt.legend(['norm distribution with $\mu$={:.2f},$\sigma$={:.2f}'.format(mu,sigma)])
```

## 将分类描述变量转换为数值类型

有两种方式可以进行转换：

1. `pd.get_dummies(train)`：直接传入一个DataFrame，就可以得到改变之后的结果

2. ```python
   from sklean.preprocessing import LabelEncoder
   for label in train.index:
   	encoder = LabelEncoder()
       train[label] = labencoder.fit_transform(train[encoder])
   ```



### 



## 矩阵相乘

对应元素相乘:`np.multiply(A,B)`或者是直接用`*`

矩阵乘法:`np.dot(A,B)`