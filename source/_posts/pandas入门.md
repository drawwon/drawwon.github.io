---
title: pandas入门
date: 2017-09-24 16:54:21
tags: [数据分析,pandas,python] 
category: [编程学习]

---

pandas当中最重要的部分就是pandas提供的dataframe和series类型，可以用来保存任何形式的数据，保存之后的结果类似于二维表的形式

### Series

series有两个重要的参数是values和index

```
In [76]: obj = pd.Series([4,5,6,7])

In [77]: obj
Out[77]:
0    4
1    5
2    6
3    7
dtype: int64

In [78]: obj.index
Out[78]: RangeIndex(start=0, stop=4, step=1)

In [79]: obj.values
Out[79]: array([4, 5, 6, 7], dtype=int64)
```

Series本身和索引都有一个index属性，<font color='red'>**pandas有一个重要特征就是其iloc选择时是后包含的**，比如df[:4,1]是指的0,1,2,3,4行的第1列</font>

```
In [81]: obj.name = 'population'

In [82]: obj.index.name = 'state'

In [83]: obj
Out[83]:
state
0    4
1    5
2    6
3    7
Name: population, dtype: int64
```

### DataFrame

DataFrame是一个表格型数据结构，同时有行索引和列索引，列的索引被称为columns，行索引被称为index

DataFrame的值仍然存储在values属性里面

更换列的顺序只需要在创建dataframe的时候指定columns的值

其columns和index也可以分别指定名字

### index

index对象是不可更改的

reindex方法可以改变原先index的顺序，不过值也会跟着变，相当于换行的顺序，其中的columns参数可以重新索引列，其中的method可以指定对于不存在的index的插值方法，ffill或pad表示向前填充，bfill和backfill表示向后填充

### drop

drop用于删除某些行或某些列，删除index行的时候只需要传入index，删除列的时候要传入columns的名字和axis=1

### applymap和apply

apply可以应用函数到dataframe上，applymap可以应用函数到元素集级别上

```
In [8]: df = pd.DataFrame(np.arange(0,1,0.1).reshape(2,5))

In [9]: df
Out[9]:
     0    1    2    3    4
0  0.0  0.1  0.2  0.3  0.4
1  0.5  0.6  0.7  0.8  0.9

In [12]: df.applymap(format)
Out[12]:
          0         1         2         3         4
0  0.000000  0.100000  0.200000  0.300000  0.400000
1  0.500000  0.600000  0.700000  0.800000  0.900000
```



### 排序

1. sort_index：按照索引排序，传入axis=1则按columns进行排序，传入by参数则按照某列的值进行排序
2. order：对Series进行排序



### 描述和汇总统计

| 方法                                       | 说明                    |
| ---------------------------------------- | --------------------- |
| count                                    | 非NA的值的数量              |
| decribe                                  | 统计性描述，包括max，min，mena等 |
| max，min                                  | 最大最小值                 |
| argmax, argmin                           | 获取到最大最小值的索引位置（整数）     |
| quantile                                 | 计算样本的分位数              |
| sum                                      | 总和                    |
| median                                   | 中位数                   |
| mad                                      | 平均绝对离差                |
| var、std                                  | 方差、标准差                |
| skew                                     | 三阶矩（样本的偏度）            |
| kurt                                     | 四阶矩（样本的峰度）            |
| cumsum                                   | 累积和                   |
| cummin,cummax                            | 样本的累计最大值和累积最小值        |
| cumprod（cum表示cumulative累积的，prod表示product乘积） | 样本的累计积                |
| diff                                     | 一阶差分                  |
| pct_change                               | 计算百分数变化（比如股票涨跌计算）     |

初始化一个dataFrame，可以read_csv从csv文件获取，也可以通过如下代码：

```python
import pandas as pd
df = pd.DataFrame(data, index, columns)
```
<!--more-->
其中data是numpy中提供的数组或者是字典，index表示每行最左边用于索引的列，columns表示每一列的名称

要取出DataFrame的值，只需要df.column_name，用`.`加上列的名字就可以了



## 查看数据

通过

1. `df.head`：查看前五行数据，
2. `df.columns`：查看列名
3. `df.values`：查看矩阵的值
4. `df.describe()`：查看矩阵的统计描述，包括值的个数，平均值，标准差，最大最小值等等
5. `df.T`：转置矩阵
6. `df.sort_index(axis=1, ascending=False)`：通过列的大小值比较进行排序，axis=0时按照行的大小值进行排序
7. `df.sort_values(by='B')`
8. `df.A`或者`df['A']`：选取某一列的值
9. `df[0:3]`：通过行号选取某几行的值
10. `df['20101010':'20101030']`：通过索引选取某些行的值
11. `df.loc[data[0]]`：通过索引进行选取，**表示的是loc**
12. `df.iloc[1:3,1:4]`：通过位置进行选取
13. `df.iloc[[1,3,4],[0,2]]`：通过位置跳跃式选取，**表示的是int loc，通过正数进行索引**
14. `df[df.A > 0]`：条件选择

## 处理丢失数据

首先复制并修改一下df的索引和columns

` df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])`

这样因为第E列是没有赋值的所以全部为NAN

对于nan数据的处理有两种方法，分别是`dropna`和`fillna`

1. `df1.dropnan(how='any')`：删除所有值为nan的行
2. `df1.fillnan(value=5)`：将所有nan的值填充为5，可以用字典的形式指定每一列的填充值

查找所有的nan，`pd.isnull(df1)`或者是`pd.notnull(df)`

## 对数据进行统计操作

1. `df.mean()`：默认求取的是每列的值，得到一个行向量
2. `df.mean(1)`：按行求平均值，得到一个列向量
3. `df.apply(lambda:x:x.max()-x.min())`：apply应用一个函数到

## DataFrame拼接

**增加行**：append，**增加列**：assign，`df.assign(age=[1,2,3])`

**将list连接成DataFrame**或者**增加列**，concat，参数为axes，指定按行合并还是按列合并；参数key，按行合并时可以建立层次化索引，按列合并时作为列的名称。ignore_index=true，可以让合并之后的index是行号而没有重复。

```python
df = pd.DataFrame(np.random.randn(10, 4))
pieces = [df[:3], df[3:7], df[7:]]
pd.concat(pieces)
```

将两个DataFrame按值连接在一起（数据库风格的合并），merge，参数为on，表示按那一列进行合并，默认的how参数为Inner，即内连接，如果要保留所有的值，可以将how设置为outer（外连接时等同于join）

```python
left = pd.DataFrame({'key': ['foo', 'foo'], 'lval': [1, 2]})
right = pd.DataFrame({'key': ['foo', 'foo'], 'rval': [4, 5]})
In [79]: left
Out[79]: 
   key  lval
0  foo     1
1  foo     2
In [80]: right
Out[80]: 
   key  rval
0  foo     4
1  foo     5
In [81]: pd.merge(left, right, on='key')
Out[81]: 
   key  lval  rval
0  foo     1     4
1  foo     1     5
2  foo     2     4
3  foo     2     5
```

将两个DataFrame按行连接在一起，Append

```python
df = pd.DataFrame(np.random.randn(8, 4), columns=['A','B','C','D'])
s = df.iloc[3]
df.append(s, ignore_index=True)
```

按条件分组，groupby

```
df.groupby('A').sum()
```

### 对数据进行分类

```
 df = pd.DataFrame({"id":[1,2,3,4,5,6], "raw_grade":['a', 'b', 'b', 'a', 'a', 'e']})
 df["grade"] = df["raw_grade"].astype("category")
```

对分类重命名：`Series.cat.categories`

```
df["grade"].cat.categories = ["very good", "good", "very bad"]
```

## 正则表达式条件判定

```python
operating_system = np.where(cframe['a'].str.contains('Windows'),'Windows','Not Windows')
```

这里用`np.where`和`DataFrame.str.contains('')`来进行判定一个字符串是否包含windows，如果包含则将其改为windows，否则将其改为'not windows'

## 数据规整

### stack和unstack

`stack`：将行旋转为列

`unstack`：将列旋转为行，默认进行的是最内层的一列

```python
>>> data=DataFrame(np.arange(6).reshape((2,3)),index=['ohio','colorado'],columns=['one','two','three'])
>>> data
          one  two  three
ohio        0    1      2
colorado    3    4      5
>>> data.index.name='state'
>>> data.columns.name='number'
>>> data
number    one  two  three
state                    
ohio        0    1      2
colorado    3    4      5
>>> data.stack()
state     number
ohio      one       0
          two       1
          three     2
colorado  one       3
          two       4
          three     5
#将列转化为行，得到一个Series
#对于一个层次化索引的Series，可以用unstack将其重排为一个DataFrame
```

```python
result.unstack(0)
state   ohio  colorado
number                
one        0         3
two        1         4
three      2         5
>>> result.unstack('state')
state   ohio  colorado
number                
one        0         3
two        1         4
three      2         5
```

### pivot_table：数据透视表

比如在电影打分里面，想得到男女对不同电影的打分，可以使用以下的函数

```
mean_ratings = data.pivot_table('rating', index='title', columns='gender', aggfunc='mean')
```

## 数据类型转换

`df.astype(int)`：将所有数据转换为int类型

## 数据排序

`argsort`：直接将值改为排序后的标号

```python
Africa/Cairo                      20
Africa/Casablanca                 21
Africa/Ceuta                      92
Africa/Johannesburg               87
Africa/Lusaka                     53
# 右边得出的是他们经过排序之后的序号
```
通过`take`函数可以取出以`argsort`为index的数据

##将多个文件里面的数据连接在一起

用一个循环，每次用`read_csv`或者是`read_table`函数读出一个dataframe，然后append到一个空list里面，最后通过`pd.concat(frame,ignore_index=True)`连接成一个大的dataframe

```
years = range(1880,2011)
frame = []
for year in years:
    filename = 'yob{}.txt'.format(year)
    df = pd.read_csv(filename,names=['name','sex','births'])
    frame.append(df)
data = pd.concat(frame,ignore_index=True)
data.to_csv('birth_data.csv')
```

## 多列索引重新排序

swaplevel：交换索引
sortlevel：索引排序

set_index：和stack很像，将列值变成索引

reset_index：和unstack很像，将多级索引编程列值

## 数据读入

读入方法

1. `read_csv`：用于读取csv，默认分隔符为逗号，需要修改默认分隔符用seperator参数，指定列名用header，无列名时用header=None，无index用index=None
2. `read_table`：读取txt文件，默认分隔符'\t'，如果分隔符不止一个\t的空格，那么用seperator='\s+'
3. `read_fwf`：fixed-width file，读取定宽文件，也就是没有分隔符
4. `read_clipboard`：读取剪贴板中的数据，在将网页转换为表格时很有用


* 如果只想读入前n行，可以使用nrows参数，指定读入的行数

读入json的方法：

```python
import json
#将json读入为python对象-字典
result = json.loads(obj)
#将python对象转化为json
asjson = json.dumps(result)
```

## 将长格式转换为宽格式

pivot函数：第一个参数表示行索引的列，第二个参数表示列索引的列

## 移除重复数据

duplicated()：返回一个布尔型变量

drop_duplicates：移除重复行的DataFrame，默认保留第一个出现的值，如果要保存最后一个应该传入take_last=True

## 对某列传入一个函数

map

## 重命名轴索引

rename：得到原始的轴索引的转换版（比如首字母大写或者是全大写）

```
data.rename(index=str.title，columns=str.upper)
```

## 值分区

pd.cut(data, [0, 5, 15, 20], right=False)：将数据按照[0,5),[5,15),[15,20)进行划分

pd.qcut（data，4）将数据按分位数等分为4份

## 随机重排

np.random.permutation(x)：若x是一个整数，那么返回打乱的np.arange(x)，然后通过df.take随机选出这若干行；若x是一个数组，那么返回一个打乱的数组的copy

```
r = np.random.permutation(len(df))[:5]
df_r = df.take(r)
```

## 计算哑变量

get_dummies

## Series字符串处理

series.str.xxx

其中包含了一大堆字符串处理函数，比如：contains，findall

也可以使用map和正则表达式来完成


































