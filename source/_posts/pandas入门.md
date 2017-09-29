---
title: pandas入门
date: 2017-09-24 16:54:21
tags: [数据分析,pandas,python] 
category: [编程学习]

---

pandas当中最重要的部分就是pandas提供的dataframe类型，可以用来保存任何形式的数据，保存之后的结果类似于二维表的形式

初始化一个dataFrame，可以read_csv从csv文件获取，也可以通过如下代码：

```python
import pandas as pd
df = pd.DataFrame(data, index, columns)
```

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
7. `df.dort_values(by='B')`
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

对于nan数据的处理有两种方法，分别是`dropnan`和`fillnan`

1. `df1.dropnan(how='any')`：删除所有值为nan的行
2. `df1.fillnan(value=5)`：将所有nan的值填充为5

查找所有的nan，`pd.isnull(df1)`

## 对数据进行统计操作

1. `df.mean()`：默认求取的是每列的值，得到一个行向量
2. `df.mean(1)`：按行求平均值，得到一个列向量
3. `df.apply(lambda:x:x.max()-x.min())`：apply应用一个函数到

## DataFrame拼接

将list连接成DataFrame或者**增加列**，concat

```python
df = pd.DataFrame(np.random.randn(10, 4))
pieces = [df[:3], df[3:7], df[7:]]
pd.concat(pieces)
```

将两个DataFrame按值连接在一起，merge

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

