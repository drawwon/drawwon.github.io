---
title: python数据分析过程--kaggle房价预测
date: 2018-03-11 17:14:36
tags: [kaggle,数据分析]
category: [python,编程练习,数据分析]
---

具体来说可以分为五个部分:

1. 问题理解
2. 单变量分析
3. 多变量分析
4. 基本的数据清理
5. 假设测验

首先导入过程中需要用到的python库
```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from scipy.stats import norm
from sklearn.preprocessing import StandardScaler
from scipy import stats
import warnings
warnings.filterwarnings('ignore')
%matplotlib inline
```
接下来读入数据:
```python
df_train = pd.read_csv('../input/train.csv')
```
看一下每列都是些什么值
```python
df_train.columns
```
得到如下的结果
```python
Index(['Id', 'MSSubClass', 'MSZoning', 'LotFrontage', 'LotArea', 'Street',
       'Alley', 'LotShape', 'LandContour', 'Utilities', 'LotConfig',
       'LandSlope', 'Neighborhood', 'Condition1', 'Condition2', 'BldgType',
       'HouseStyle', 'OverallQual', 'OverallCond', 'YearBuilt', 'YearRemodAdd',
       'RoofStyle', 'RoofMatl', 'Exterior1st', 'Exterior2nd', 'MasVnrType',
       'MasVnrArea', 'ExterQual', 'ExterCond', 'Foundation', 'BsmtQual',
       'BsmtCond', 'BsmtExposure', 'BsmtFinType1', 'BsmtFinSF1',
       'BsmtFinType2', 'BsmtFinSF2', 'BsmtUnfSF', 'TotalBsmtSF', 'Heating',
       'HeatingQC', 'CentralAir', 'Electrical', '1stFlrSF', '2ndFlrSF',
       'LowQualFinSF', 'GrLivArea', 'BsmtFullBath', 'BsmtHalfBath', 'FullBath',
       'HalfBath', 'BedroomAbvGr', 'KitchenAbvGr', 'KitchenQual',
       'TotRmsAbvGrd', 'Functional', 'Fireplaces', 'FireplaceQu', 'GarageType',
       'GarageYrBlt', 'GarageFinish', 'GarageCars', 'GarageArea', 'GarageQual',
       'GarageCond', 'PavedDrive', 'WoodDeckSF', 'OpenPorchSF',
       'EnclosedPorch', '3SsnPorch', 'ScreenPorch', 'PoolArea', 'PoolQC',
       'Fence', 'MiscFeature', 'MiscVal', 'MoSold', 'YrSold', 'SaleType',
       'SaleCondition', 'SalePrice'],
      dtype='object')
```

## 接下来我们需要做些什么
为了理解数据，我推荐用excel做一个如下的表格，每一列数据变成一类，包含6部分内容：
1. 变量名；
2. 变量类型：有两种可能的值在这个域中，“数值型”或者是“分类型”，数值型意味着数据都是数值，而“分类型”意味着变量值是类别；
3. 变量分割：根据大类对变量分段。比如在房价问题中，可以大致分为3大类：“建筑本身”，“空间大小”，“位置”，当我们说建筑本身的时候，我们意味着建筑的物理特征；说空间大小的时候，指的是空间特征，比如有几个卫生间之类的；说位置的时候，指的是地理位置相关的特征，比如街区之类的；
4. 期望：我们自认为的哪些因素对最终分析目标的影响，可以分为高中低三类。
5. 结论：我们认为这个变量重要性的结论，可以跟期望一样分为几类
6. 补充评论：任何我们能想到的一般性评论

最后，我们结合自身实际，看看哪些因素是真的重要的，比如买房子的时候，房子外观重要吗？
再看看哪些因素可能重复了，地势等高线之后就不需要地势斜度了

在房价预测这个问题中，我们总结了四个最重要的影响因素：
1. OverallQual ：整体质量，虽然不知道怎么算出来的，但是很有可能是通过其余所有变量综合计算得到的；
2. YearBuilt：建筑年份
3. TotalBsmtSF：总地下室面积
4. GrLivArea：总的非地下室面积

在这个问题中，我们最终是以2个“建筑本身”变量（整体质量和建筑年份），和2个“空间大小”变量（地下室面积和非地下室面积）结束。

## 先说最重要的：分析房价
房价是我们这个问题探索的目标，首先看看数据描述
```python
#获得数据的整体性描述
df_train['SalePrice'].describe()
```
```python
count      1460.000000
mean     180921.195890
std       79442.502883
min       34900.000000
25%      129975.000000
50%      163000.000000
75%      214000.000000
max      755000.000000
Name: SalePrice, dtype: float64
```
非常好，至少最低的房价是大于0的
```python
#画个直方图来看看数据分布
sns.distplot(df_train['SalePrice']);
```
![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/82259654.jpg)

看上去似乎是一个变形的正态分布图片，我们来计算机下他的偏度和峰度：

```python
#skewness and kurtosis
print("Skewness: %f" % df_train['SalePrice'].skew())
print("Kurtosis: %f" % df_train['SalePrice'].kurt())
```

得到结果如下

```python
Skewness: 1.882876
Kurtosis: 6.536282
```



其中峰度和偏度的解释如下：

1. 峰度（skewness）：峰度衡量数据分布的平坦度（flatness）。尾部大的数据分布，其峰度值较大。正态分布的峰度值为3![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/48112617.jpg)
   如图，黑线的峰度值大于3，红线峰度值等于3
2. 偏态（Skewness）：偏态量度对称性。0说明是最完美的对称性，正态分布的偏态就是0。如图所示，右偏态为正，表明平均值大于中位数。反之为左偏态，为负。

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/6978903.jpg)

## 数值类型因素之间的关系

先来画一画grlivarea/saleprice两者之间的散点图

```python
#scatter plot grlivarea/saleprice
var = 'GrLivArea'
data = pd.concat([df_train['SalePrice'], df_train[var]], axis=1)
data.plot.scatter(x=var, y='SalePrice', ylim=(0,800000));
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/83913021.jpg)

可以看到两者几乎呈现正相关，也就是非地下室面积和售价呈现正相关

我们再来画一下totalbsmtsf和售价的关系

```
#scatter plot totalbsmtsf/saleprice
var = 'TotalBsmtSF'
data = pd.concat([df_train['SalePrice'], df_train[var]], axis=1)
data.plot.scatter(x=var, y='SalePrice', ylim=(0,800000));
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/38930281.jpg)

可以看到两者同样几乎呈现正相关，关系似乎是指数关系

## 分类类型变量的关系

画一个box图（箱形图），看看整体质量和售价之间的关系

```python
var = 'OverallQual'
data = pd.concat([train['SalePrice'], train[var]], axis=1)
sns.boxplot(x=var,y='SalePrice',data=data)
plt.show()
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/97679736.jpg)

* 箱形图的解释：又称为**盒须图**、**盒式图**、**盒状图**或**箱线图**，是一种用作显示一组数据分散情况资料的[统计图](https://zh.wikipedia.org/wiki/%E7%BB%9F%E8%AE%A1%E5%9B%BE)。因型状如箱子而得名。在各种领域也经常被使用，常见于品质管理。不过作法相对较繁琐。它能显示出一组数据的[最大值](https://zh.wikipedia.org/wiki/%E6%9C%80%E5%A4%A7%E5%80%BC)、[最小值](https://zh.wikipedia.org/wiki/%E6%9C%80%E5%B0%8F%E5%80%BC)、[中位数](https://zh.wikipedia.org/wiki/%E4%B8%AD%E4%BD%8D%E6%95%B8)、及[上下四分位数](https://zh.wikipedia.org/wiki/%E5%9B%9B%E5%88%86%E4%BD%8D%E6%95%B0)。
* 上四分位数Q3-下四分位数Q1 = 四分位间距$\Delta{Q}$
* 在区间$Q3+1.5\Delta{Q}$和区间$Q1-1.5\Delta{Q}$之外的值应该被忽视，被称为异常值，异常值被画在图上

再看看建造年份和售价的关系

```python
var = 'YearBuilt'
data = pd.concat([train['SalePrice'], train[var]], axis=1)
fig = sns.boxplot(x=var,y='SalePrice',data=data)
# 将x轴坐标旋转90度
plt.xticks(rotation=90)
plt.show()
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-11/60100096.jpg)

看上去似乎并没有什么强烈的关系

## 关系总结

* 地上面积和总的地下面积看上去和房价线性相关，两者的关系都是正向的；并且在总地下面积的关系中可以看到，其与售价面积相关性的斜度非常大
* 总体质量和建筑年代似乎与售价也有一定关系，其中总体质量关系比较大，箱形图显示出房价随着整体质量的上升而上涨

## 试验性分析

为了更加理性的对房价数据进行分析，我们先用一下几个办法来进行分析：

* 相关矩阵（热力图heatmap）
* 房价的相关矩阵（缩放热力图）
* 大多数相关变量之间的散点图

### 相关矩阵

画个热力图看看相关系数

```python
cormat = train.corr()
f, ax = plt.subplots(figsize=(12, 9))
sns.heatmap(cormat,vmax=.8,square=True)
plt.xticks(rotation=90)
plt.yticks(rotation=360)
plt.show()
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-12/40765273.jpg)

在我看来，热力图的确是一个最好的看一个大致影响程度的方法。

可以看到，总地下室面积和一楼面积很大程度上影响了房价，还有关于车库的好几个因素都很大程度上影响了房价。这让我们感觉到heatmap非常适合做特征选择。

### 售价相关矩阵

看完了上面的heatmap的最后一行，我们只是从颜色上看出了各个因素与售价的关系，接下来我们画一个缩放的heatmap来具体看看每个因素的影响有多大

```python
cormat = train.corr()
k = 10
cols = cormat.nlargest(10, 'SalePrice')['SalePrice'].index
cm = train[cols].corr()#np.corrcoef(train[cols].values.T)
print(train[cols].values)
sns.set(font_scale=1.25)
hm = sns.heatmap(cm, cbar=True, annot= True, fmt='.2f', annot_kws={'size':10}, yticklabels=cols.values, xticklabels=cols.values)
plt.xticks(rotation=90)
plt.yticks(rotation=360)
plt.show()
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-12/35746800.jpg)

可以看到这些变量是影响房价最大的10个因素，从图中的数值可以看出来，OverallQual和GrLiveArea以及GarageCars和GarageArea是影响房价最大的几个因素。

* 然而我们可以看到，GarageArea和GarageCars是有因果关系的，车库面积决定了可以停多少车，所以我们最终选择影响更大的GarageCars这个因素
* 总地下室面积（**TotalBsmtSF**）和一楼面积**1stFlrSF**似乎也有强烈相关性，我们选择地下室面积作为因素
* 地上房间数目（**TotRmsAbvGrd**）和地上居住面积（**GrLivArea**）也有相当大关系，所以选其中一个

### 售价和相关变量之间的散点图

![](http://ooi9t4tvk.bkt.clouddn.com/18-3-12/86254176.jpg)































