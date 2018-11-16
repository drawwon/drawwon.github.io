---
title: kaggle-titanic实战--数据挖掘实例
date: 2017-09-25 08:59:41
tags: [kaggle, 数据挖掘]
category: [编程学习]
---

kaggle是一个国外的数据挖掘竞赛平台，大家做完竞赛之后会写一些指导，因此可以通过其他人写的指导文件进行学习，[kaggle传送门](https://www.kaggle.com)。

其中有一个入门类的分析问题是分析Titanic号的救援问题，分析哪些因素会影响到是否被救援，首先打开Titanic这个问题的具体页面，[Titanic: Machine Learning from Disaster](https://www.kaggle.com/c/titanic),

<!--more-->![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-25/69961399.jpg)

<!--more-->
先看一看overview里面的description和evaluation，看看问题背景和最终需要预测的内容，然后点击数据，下载三个csv格式的数据集，第一个`train.csv`是训练集，第二个`test.csv`是测试集，第三个`gender_submission.csv`是验证集，

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-25/35388132.jpg)

下载好之后打开pycharm，新建名为Titanic的工程，新建Titanic.py开始进行分析

首先，导入需要用到的包

```python
import numpy as np
import pandas as pd
import matplot.pyplot as plt
from pandas import DataFrame,Series
```

接下来导入数据

```python
train_data = pd.read_csv('train.csv')
```

查看数据的信息

```python
train_data.info()
```

得到的数据信息如下

```python
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 891 entries, 0 to 890
Data columns (total 12 columns):
PassengerId    891 non-null int64
Survived       891 non-null int64
Pclass         891 non-null int64
Name           891 non-null object
Sex            891 non-null object
Age            714 non-null float64
SibSp          891 non-null int64
Parch          891 non-null int64
Ticket         891 non-null object
Fare           891 non-null float64
Cabin          204 non-null object
Embarked       889 non-null object
dtypes: float64(2), int64(5), object(5)
memory usage: 83.6+ KB
```

一共是891行，12列，其中Age列和Cabin列还有Embarked列数据不完整，每一列的含义如下：

- PassengerId => 乘客ID
- Pclass => 乘客等级(1/2/3等舱位)
- Name => 乘客姓名
- Sex => 性别
- Age => 年龄
- SibSp => 堂兄弟/妹个数
- Parch => 父母与小孩个数
- Ticket => 船票信息
- Fare => 票价
- Cabin => 客舱
- Embarked => 登船港口

然后我们可以看看各个数据的统计值

```
train_data.describe()
```

|       | PassengerId | Survived | Pclass   | Age      | SibSp    | Parch    | Fare     |
| ----- | ----------- | -------- | -------- | -------- | -------- | -------- | -------- |
| count | 891         | 891      | 891      | 714      | 891      | 891      | 891      |
| mean  | 446         | 0.383838 | 2.308642 | 29.69912 | 0.523008 | 0.381594 | 32.20421 |
| std   | 257.3538    | 0.486592 | 0.836071 | 14.5265  | 1.102743 | 0.806057 | 49.69343 |
| min   | 1           | 0        | 1        | 0.42     | 0        | 0        | 0        |
| 25%   | 223.5       | 0        | 2        | 20.125   | 0        | 0        | 7.9104   |
| 50%   | 446         | 0        | 3        | 28       | 0        | 0        | 14.4542  |
| 75%   | 668.5       | 1        | 3        | 38       | 1        | 0        | 31       |
| max   | 891         | 1        | 3        | 80       | 8        | 6        | 512.3292 |

得到一个如图的描述，可以看到被救援的人数只有38%，且二，三等舱位人数居多，平均年龄29岁

这样得到的数据有一定的参考性，但是这么多个属性，究竟哪些和最终被救援有关系呢，我们可以画出图像来进行更加形象的描述

所有DataFrame类型的数据都可以在其后面直接调用plot函数，然后在其中输入kind来选择图的类型，绘制代码如下，

```python
## 绘制被救情况
plt.subplot2grid((2,3),(0,0))## 画子图的第一个
fig1 = train_data.Survived.value_counts().plot(kind='bar')
plt.title('救援情况(1为被救)')
plt.ylabel('人数')
for patch in fig1.patches:
    fig1.annotate(str(int(patch.get_height())),(patch.get_x(),patch.get_height()))

## 绘制被救援和舱位之间的关系
ax2 = plt.subplot2grid((2,3),(0,1))
Survived_0 = train_data.Pclass[train_data.Survived == 0].value_counts()
Survived_1 = train_data.Pclass[train_data.Survived == 1].value_counts()
df=pd.DataFrame({ u'未获救':Survived_0, u'获救':Survived_1})
fig2 = df.plot(kind='bar', stacked=False , ax=ax2)
plt.title(u"各乘客等级的获救情况")
plt.xlabel(u"乘客等级")
plt.ylabel(u"人数")
## 用于标注直方图
for patch in fig2.patches:
    fig2.annotate(str(int(patch.get_height())),(patch.get_x(),patch.get_height()))

## 年龄与获救的关系
ax3 = plt.subplot2grid((2,3),(0,2))
plt.scatter(train_data.Survived, train_data.Age)
plt.title('获救与年龄的关系')
plt.ylabel('年龄')
# plt.xlim([0,1])
plt.xticks([0,1])

## 各等级舱位年龄分布
plt.subplot2grid((2,3),(1,0),colspan=2)
train_data.Age[train_data.Pclass == 1].plot(kind='kde')
train_data.Age[train_data.Pclass == 2].plot(kind='kde')
train_data.Age[train_data.Pclass == 3].plot(kind='kde')
plt.title('各等级舱位年龄分布')
plt.legend(['头等舱','二等舱','三等舱'])

## 各个口岸登船人数
plt.subplot2grid((2,3),(1,2))
train_data.Embarked.value_counts().plot(kind='bar')
plt.title('各个口岸登船人数')

plt.show()
```

绘制得到的图片如下：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-25/98568081.jpg)

其中标注直方图的代码为：

```python
def Annotate(fig,plus_times=1.005):
    for patch in fig.patches:
        fig.text(patch.get_x()+patch.get_width()/2,patch.get_height()*plus_times,
                 str(int(patch.get_height())),ha='center',va='bottom')
```

接下来具体看看每个属性和是否被救援的关系

首先画出被**救援和性别之间的关系**

```python
survived_m = train_data.Survived[train_data.Sex == 'male'].value_counts()
survived_f = train_data.Survived[train_data.Sex == 'female'].value_counts()
df_sex =  DataFrame(data={'男性':survived_m,'女性':survived_f})
df_sex.plot(kind='bar')
plt.title('被救援和性别的关系',fontsize=20)
plt.ylabel('人数',fontsize=15)
## 将横坐标的值改成中文
plt.xticks(range(2),['未获救','获救'],fontsize=15,rotation=360)
plt.legend(['男性','女性'],fontsize=15)
plt.show()
```

其中的字体大小设置可以用`ctrl+B`跳到原始代码中去看，大多数情况都是直接设置`fontsize`

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-25/4950204.jpg)

舱位级别和性别对获救的影响

```python
fig = plt.figure()
plt.suptitle('舱位级别和性别对获救的影响',fontsize=20)

#用于标注和设置横坐标的xticklables
def Annotate(fig,plus_times=1.005):
    for patch in fig.patches:
        fig.text(patch.get_x()+patch.get_width()/2,patch.get_height()*plus_times,
                 str(int(patch.get_height())),ha='center',va='bottom')
    fig.set_xticklabels(['未获救','获救'],rotation=0)
    
# 第一幅图
ax1 = fig.add_subplot(1,4,1)
a = train_data.Survived[train_data.Sex == 'female'][train_data.Pclass == 1].sort_values()
# train_data.Survived[train_data.Sex == 'female'][train_data.Pclass == 1].value_counts().plot(kind='bar',color='pink')
unsurvived = len(train_data.Survived[train_data.Survived==0][train_data.Sex == 'female'][train_data.Pclass == 1])
survived = len(train_data.Survived[train_data.Sex == 'female'][train_data.Pclass == 1][train_data.Survived==1])
ax1.bar(range(0,2),[unsurvived,survived],width=0.3,color='pink')
ax1.set_title('高级舱女性获救情况')
plt.xticks([0,1])
Annotate(ax1)

# 第二幅图
ax2 = fig.add_subplot(1,4,2)
train_data.Survived[train_data.Sex == 'female'][train_data.Pclass == 3].value_counts().plot(kind='bar',color='green')
Annotate(ax2)
ax2.set_title('低级舱女性获救情况')

# 第三幅图
ax1 = fig.add_subplot(1,4,3)
train_data.Survived[train_data.Sex == 'male'][train_data.Pclass == 1].value_counts().plot(kind='bar',color=['blue','yellow'])
ax1.set_title('高级舱男性性获救情况')
Annotate(ax1)

# 第四幅图
ax1 = fig.add_subplot(1,4,4)
train_data.Survived[train_data.Sex == 'male'][train_data.Pclass == 3].value_counts().plot(kind='bar',color='grey')
ax1.set_title('低级舱男性性获救情况')
Annotate(ax1)
plt.show()
```

接下来画出登船港口与是否获救的关系：

```python
def Annotate(fig,plus_times=1.005):
    for patch in fig.patches:
        fig.text(patch.get_x() + patch.get_width() / 2, patch.get_height() * plus_times,
                                   str(int(patch.get_height())),ha='center',va='bottom')
unsurvived_Embarked = train_data.Embarked[train_data.Survived == 0].value_counts()
survived_Embarked = train_data.Embarked[train_data.Survived == 1].value_counts()
ax = pd.DataFrame(data={'获救':survived_Embarked,'未获救':unsurvived_Embarked}).plot(kind='bar')
plt.legend(['获救','未获救'],fontsize=15)
plt.title('登船港口与是否获救的关系',fontsize=20)
plt.ylabel('人数',fontsize=15)
ax.set_xticklabels(['s','c','q'],rotation=0,fontsize=15)
Annotate(ax)
plt.show()
```

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-26/88248188.jpg)

接下来画出堂兄弟姐妹对是否获救的影响：

```python
# 堂兄弟/妹对是否获救的影响
g = train_data.groupby(['SibSp','Survived'])
a=g.count()['PassengerId']
colors = ['blue','green']
fig = plt.figure()
x = [2*i for i in range(int(len(a)/2))]
plt.bar(x,a.iloc[x].values,color='blue',label='未获救',width=0.3)
plt.bar(x,a.iloc[::2].values,color='blue',label='未获救',width=0.3)
plt.bar([i+0.4 for i in x],a.iloc[1::2].values,color='green',label='未获救',width=0.3)
plt.legend()
plt.show()
pass
```

pandas选取偶数行和奇数行分别为：df.iloc[::2], df.iloc[1::2]

要获得Mutiindex的值只需要:df.index.values



下面看看cabin这个参数，这个参数的缺失很多，并且值的种类实在是太多了，基本是每个值都不同，我们要把这个参数作为一个特征的话，也许可以试试cabin是否缺失作为特征

```python
survived_cabin = train_data.Survived[pd.notnull(train_data.Cabin)].value_counts()
survived_nocabin = train_data.Survived[pd.isnull(train_data.Cabin)].value_counts()
df = DataFrame(data={'有':survived_cabin, '没有':survived_nocabin}).T
ax = df.plot(kind='bar')
print(df)
# plt.xticks([0,1],['未获救','获救'])
plt.show()
```

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-9-26/70177085.jpg)

看来有cabin这个参数更容易获救

因此我们需要将Cabin的有无转化为bool型变量：

```python
# 将cabin的有无转化为bool型变量
def bool_Cabin(df):
    df.loc[pd.notnull(df.Cabin), 'Cabin']= 'Yes'
    df.loc[pd.isnull(df.Cabin), 'Cabin']= 'No'
    return df
```



### 使用RandomForest Regression 对年龄数据进行拟合

因为年龄数据差的比较多，所以我们想到要将年龄数据进行补全，所以想到了拟合年龄的曲线，在这里我们使用的方法是RandomForestRegressor

```python
from sklearn.ensemble import RandomForestRegressor
def matchAge(df):
  	# 通过已知的数值型变量来拟合Age这个参数
    age_df = df[['Age','Pclass','SibSp','Parch','Fare']]
	
    #通过pd.notnull和pd.isnull来判断是否有年龄这个值，并转化为as_matrix()
    knowAge = age_df[pd.notnull(age_df.Age)].as_matrix()
    unknowAge = age_df[pd.isnull(age_df.Age)].as_matrix()
	
    # 建立label，即为需要预测的标签的已知值，即训练时用到的标签
    lable = knowAge[:,0]
    # 建立x，即输入的训练样本
    x = knowAge[:,1:]
    
  # 初始化随机森林回归的参数，n_estimators=2000表示迭代2000次，n_jobs=-1表示用cpu的所有核进行并行计算
    rfc = RandomForestRegressor(random_state=0, n_estimators=2000, n_jobs=-1)
   # 开始训练
    rfc.fit(x,lable)
   
  # 开始利用训练好的模型进行预测
    predictedAges = rfc.predict(unknowAge[:, 1:])
    
   # 将原始数据的空值部分赋值为预测的数据
    df.Age[pd.isnull(df.Age)] = predictedAges
    # 返回数据集
    return df,rfc
```



### 将非数字的值转化为数字

pandas提供了一个get_dummies函数，可以直接把可以分类的数据转换为多个成标量值，比如下面的将Cabin转化为了Cabin_yes 和Cabin_no:

```python
dummies_Cabin = pd.get_dummies(train_data['Cabin'], prefix='Cabin')
dummies_Embarked = pd.get_dummies(train_data['Embarked'], prefix='Embarked')
dummies_Sex = pd.get_dummies(train_data['Sex'], prefix='Sex')
dummies_Pclass = pd.get_dummies(train_data['Pclass'], prefix='Pclass')
```



### 连接两个DataFrame

只要用`pd.concat([df1,df2], axis=1)`，就可以按列连接

```
train_data = pd.concat([train_data,dummies_Cabin,dummies_Embarked,dummies_Sex,dummies_Pclass],axis=1)
```



### 删除某些列

直接`df.drop(['column1','column2'], axis=1, inplace=True)`，就是按列删除，并且inplace=True表示将原来的df直接替换成删除掉某些列之后的数据

```python
train_data.drop(['Name','Sex','Ticket','Cabin','Embarked'],axis=1, inplace=True)
```



### 数据归一化

使用`sklearn.preprocessing`包的preprocessing函数，先定义一个scaler实例，用`preprocessing`的`StandardScaler`，用scaler先fit出你想要归一化的那一列的参数，然后用fit_transform进行归一化，传入的参数是需要归一化的值和归一化参数

```
#数据预处理
import sklearn.preprocessing as preprocessing

scaler = preprocessing.StandardScaler()
age_scale_param = scaler.fit(train_data[['Age']])
train_data['Age_scaled'] = scaler.fit_transform(train_data[['Age']],age_scale_param)
Fare_scale_param = scaler.fit(train_data[['Fare']])
train_data['Fare_scaled'] = scaler.fit_transform(train_data[['Fare']],Fare_scale_param)
```



### 逻辑回归预测

计算完这些部分，将测试数据导入并进行与训练数据相同的预处理，然后进行逻辑回归预测，先用train_data进行fit，然后用训练数据的x进行预测

```python
from sklearn import linear_model

train_data = pd.read_csv('prepross_train.csv',index_col=0)
train_data.info()

train_df = train_data.iloc[:,1:].as_matrix()
y = train_df[:,0]
x = train_df[:,1:]
# test_data = prepross('test.csv','prepross_test.csv')
test_data = pd.read_csv('prepross_test.csv',index_col=0)

clf = linear_model.LogisticRegression(penalty='l1',C=1.0,tol=1e-6)
clf.fit(x, y)
test_x = test_data.iloc[:,1:]
prediction = clf.predict(test_x)

result = DataFrame(data={'PassengerId':test_data['PassengerId'].as_matrix(),'Survived':[int(i) for i in prediction]})
result.to_csv('result.csv')
```



### 检验预测精度

因为我们一开始在进行测试数据预处理的时候，删除了一行，所以在比较的时候应该把这一行补上，在补充完毕之后index是乱的，所以我们直接reset_index，并且sort_values，按照PassengerId排序

```python
auth_df = pd.read_csv('gender_submission.csv')
result_df = pd.read_csv('result.csv',index_col=0)
s = 0

a = result_df['PassengerId'].values
b = auth_df['PassengerId'].values
c = [c for c in b if c not in a][0]
result_df = pd.concat([result_df,auth_df[auth_df.PassengerId == c]],axis=0)

result_df.reset_index(drop=True,inplace=True)
result_df.sort_values(by='PassengerId',inplace=True)
result_df.reset_index(drop=True,inplace=True)

result_df.loc[auth_df.PassengerId == c,'Survived'] = 1
for i,j in zip(result_df['Survived'].values, auth_df['Survived'].values):
    if i == j:
        s += 1
print(s)
precession = float(s/len(auth_df['Survived']))
print(precession)
```

精度得到为`0.9330143540669856` 





























