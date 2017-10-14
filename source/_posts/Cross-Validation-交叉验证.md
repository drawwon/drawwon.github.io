---
title: Cross Validation 交叉验证
date: 2017-10-10 14:13:33
tags: [交叉验证,机器学习]
category: [机器学习]
---

传统的$F-measure$或平衡的$F-score$ (F1 score)是精度和召回的调和平均值：

$$F_1 = 2 \frac{precision*recall}{precision + recall} $$ 

## 交叉验证

cross validation大概的意思是：对于原始数据我们要将其一部分分为train_data，一部分分为test_data。train_data用于训练，test_data用于测试准确率。在test_data上测试的结果叫做validation_error。将一个算法作用于一个原始数据，我们不可能只做出随机的划分一次train和test_data，然后得到一个validation_error，就作为衡量这个算法好坏的标准。因为这样存在偶然性。我们必须好多次的随机的划分train_data和test_data，分别在其上面算出各自的validation_error。这样就有一组validation_error，根据这一组validation_error，就可以较好的准确的衡量算法的好坏。

cross validation是在数据量有限的情况下的非常好的一个evaluate performance的方法。而对原始数据划分出train data和test data的方法有很多种，这也就造成了cross validation的方法有很多种。



## 带乱序的

使用下面的公式可以进行5折交叉验证，`cross_val_score`函数是进行交叉验证并计算出Validation_score的，但是其中的cross validation并没有打乱原始数据的顺序，所以使用`Kfold`函数构建cv变量，传递给`cross_val_score`的cv参数，其中scoring参数可以指定计算准确率的方式

```python
#Validation function
n_folds = 5

def rmsle_cv(model):
    kf = KFold(n_folds, shuffle=True, random_state=42).get_n_splits(train.values)
    rmse= np.sqrt(-cross_val_score(model, train.values, y_train, scoring="neg_mean_squared_error", cv = kf))
    return(rmse)
```



