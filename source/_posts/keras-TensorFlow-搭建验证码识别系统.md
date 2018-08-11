---
title: keras TensorFlow 搭建验证码识别系统
mathjax: true
date: 2018-08-11 17:48:08
tags: [深度学习]
category: [深度学习]
---

keras整体来说是一个非常简单易用的框架，搭建一个网络非常地快捷和方便，这篇博客主要是记录之前用keras搭建的一个cnn识别验证码的步骤。

<!--more-->

## 数据生成

首先用`ImageCaptcha`这个库来生成验证码，这里有两种生成的方式，一种是直接生成很多张，放在电脑中，然后每次读一部分进来进行训练，还有一种方式就是用生成器的方式来生成数据，然后用keras model的`fit_generator`方法进行训练。

```python
from captcha.image import ImageCaptcha
import matplotlib.pyplot as plt
import numpy as np
import random,os
import tensorflow as tf
%matplotlib inline
%config InlineBackend.figure_format = 'retina'
import keras
from keras import backend as K
from keras_tqdm import TQDMNotebookCallback


import string
characters = string.digits + string.ascii_uppercase
# print(characters)

width, height, n_len, n_class = 160, 80, 4, len(characters)


generator = ImageCaptcha(width=width, height=height)
# for i in range(1000):
#     random_str = ''.join([random.choice(characters) for j in range(4)])
#     img = generator.generate_image(random_str)
#     img.save('./pic/'+str(i) +'_'+ random_str + '.jpg')

imgs = []
labels =[]
temp = [[] for i in range(4)]

# 处理生成的数据，通过opencv的二值化和高斯模糊函数来去噪声
def deal_img(img):
#     img = load_img(path,grayscale=True)
    kernel = np.ones((3,1), np.uint8)
    img = img_to_array(img).astype(np.uint8)
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY) 
#     img= cv.bilateralFilter(img,9,75,75)
#     img = cv.Canny(img, 100, 200)
    blur = cv.GaussianBlur(img, (5, 5), 0)
    _, img = cv.threshold(blur, 0, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)
    img = cv.dilate(img, kernel, iterations=1)
    img = cv.erode(img, kernel, iterations=1)


    return img.reshape(height,width,1)

# 数据生成器，每次生成batch_size张图片
# 输出的y的格式是[144,1]
def gen(batch_size=32):
    while True:
        imgs=[]
        labels = []
        for i in range(batch_size):
            random_str = ''.join([random.choice(characters) for j in range(4)])
            img = generator.generate_image(random_str)
            img = deal_img(img)
            imgs.append(img)
            y=np.zeros((len(characters)*4))
            for i,char in enumerate(random_str):
                y[characters.find(char)+i*len(characters)] = 1
            labels.append(y)   
        train_x = np.array(imgs)
        train_y = np.array(labels)
        yield train_x, train_y
```

## 网络构建

构建一个类似于vgg16的网络

```python
from keras.preprocessing.image import img_to_array,load_img
import numpy as np
from keras.layers import *
from keras.models import Model
import cv2 as cv

# 构建类似于vgg16的网络结构
input_tensor = Input(shape=(height, width, 1))
x = input_tensor
for i in range(4):
    x = Conv2D(32*2**i, (3, 3), activation='relu')(x)
    x = Conv2D(32*2**i, (3, 3), activation='relu')(x)
    x = MaxPooling2D((2, 2))(x)

x = Flatten()(x)
x = Dropout(0.25)(x)
x = [Dense(n_class, activation='softmax', name='c%d'%(i+1))(x) for i in range(4)]
x = concatenate(x)
model = Model(inputs=input_tensor, outputs=x)
```

我们来看看模型的结构，画出模型结构图，在使用plot_model之前要先`pip install pydot-ng & apt install graphviz `

```python
from keras.utils import plot_model
plot_model(model, to_file='model.png')
model.summary()
```



![](http://ooi9t4tvk.bkt.clouddn.com/18-8-11/86737125.jpg)

```python
model.summary()
___________________________________________________________________________________
Layer (type)                    Output Shape         Param #     Connected to                    ================================================================================================
input_1 (InputLayer)            (None, 80, 160, 1)   0                                           
________________________________________________________________________________________________
conv2d_1 (Conv2D)               (None, 78, 158, 32)  320         input_1[0][0]                  
________________________________________________________________________________________________
conv2d_2 (Conv2D)               (None, 76, 156, 32)  9248        conv2d_1[0][0]                 
________________________________________________________________________________________________
max_pooling2d_1 (MaxPooling2D)  (None, 38, 78, 32)   0           conv2d_2[0][0]                 
________________________________________________________________________________________________
conv2d_3 (Conv2D)               (None, 36, 76, 64)   18496       max_pooling2d_1[0][0]           
________________________________________________________________________________________________
conv2d_4 (Conv2D)               (None, 34, 74, 64)   36928       conv2d_3[0][0]                 
________________________________________________________________________________________________
max_pooling2d_2 (MaxPooling2D)  (None, 17, 37, 64)   0           conv2d_4[0][0]                 
________________________________________________________________________________________________
conv2d_5 (Conv2D)               (None, 15, 35, 128)  73856       max_pooling2d_2[0][0]           
________________________________________________________________________________________________
conv2d_6 (Conv2D)               (None, 13, 33, 128)  147584      conv2d_5[0][0]                 
_______________________________________________________________________________________________
max_pooling2d_3 (MaxPooling2D)  (None, 6, 16, 128)   0           conv2d_6[0][0]                 
________________________________________________________________________________________________
conv2d_7 (Conv2D)               (None, 4, 14, 256)   295168      max_pooling2d_3[0][0]           
________________________________________________________________________________________________
conv2d_8 (Conv2D)               (None, 2, 12, 256)   590080      conv2d_7[0][0]                 
________________________________________________________________________________________________
max_pooling2d_4 (MaxPooling2D)  (None, 1, 6, 256)    0           conv2d_8[0][0]                 
________________________________________________________________________________________________
flatten_1 (Flatten)             (None, 1536)         0           max_pooling2d_4[0][0]           
________________________________________________________________________________________________
dropout_1 (Dropout)             (None, 1536)         0           flatten_1[0][0]                 
________________________________________________________________________________________________
c1 (Dense)                      (None, 36)           55332       dropout_1[0][0]                 
________________________________________________________________________________________________
c2 (Dense)                      (None, 36)           55332       dropout_1[0][0]                 
________________________________________________________________________________________________
c3 (Dense)                      (None, 36)           55332       dropout_1[0][0]                 
________________________________________________________________________________________________
c4 (Dense)                      (None, 36)           55332       dropout_1[0][0]                 ________________________________________________________________________________________________
concatenate_1 (Concatenate)     (None, 144)          0           c1[0][0]                       
                                                                 c2[0][0]                       
                                                                 c3[0][0]                       
                                                                 c4[0][0]                       
================================================================================================
Total params: 1,393,008
Trainable params: 1,393,008
Non-trainable params: 0
_______________________________________________________________________________________________
```

### 定义loss和acc

这里的loss不能用系统自带的几个loss和acc，因为我们这里是分4个字符的验证码，不是一个分对了就是对，而是四个都对了才是对

```python
tf_session = K.get_session()

def my_acc(y_true, y_pred):
    predict = tf.reshape(y_pred, [-1, n_len, len(characters)])
    max_idx_p = tf.argmax(predict, -1)
    max_idx_l = tf.argmax(tf.reshape(y_true, [-1,n_len, len(characters)]), -1)
    print(K.int_shape(max_idx_p))
    print(K.int_shape(max_idx_l))
    correct_pred = tf.reduce_all(tf.equal(max_idx_p, max_idx_l),axis=1)
    return tf.reduce_mean(tf.cast(correct_pred, tf.float32))

def my_loss(y_true, y_pred):
    loss = tf.zeros((1,))
    for i in range(n_len):
        a = tf.reshape(y_pred[:,i*36:(i+1)*36],shape=(-1,36))
        b = tf.reshape(y_true[:,i*36:(i+1)*36],shape=(-1,36))
        loss = tf.add(loss,tf.keras.losses.categorical_crossentropy(b,a))
    return loss
    

model.compile(loss = my_loss,
              optimizer='adam',
              metrics=[my_acc,'acc'])
checkpointer = keras.callbacks.ModelCheckpoint(filepath='output/weight.h5',#"output/weights.{epoch:02d}--{val_loss:.2f}-{val_my_acc:.4f}.hdf5", 
                               verbose=2, save_weights_only=True)
model.fit_generator(gen(32),steps_per_epoch=15000,epochs=1,verbose=1,validation_data=gen(100),validation_steps=1,callbacks=[checkpointer])

(None, 4)
(None, 4)
Epoch 1/1
15000/15000 [==============================] - 13561s 904ms/step - loss: 0.4114 - my_acc: 0.9086 - acc: 0.3406 - val_loss: 0.6470 - val_my_acc: 0.8500 - val_acc: 0.3700

Epoch 00001: saving model to output/weight.h5
```

至此，模型训练结束，你可以生成更多的数据来训练一次达到更高的模型精度

### 测试模型精度

```python
def decode_str(result):
    strings =[]
    for s in range(result.shape[0]):
        string = [characters[result[s,i*len(characters):(i+1)*len(characters)].argmax()] for i in range(n_len)]
        strings.append(string)
    return [''.join(string) for string in strings]

x,y = next(gen(1000))
true_label = decode_str(y)
score = model.evaluate(x,y,verbose=2)
result = model.predict(x,verbose=2)

#最后得出的精度值为93.3%
score
[0.3298118329048157, 0.933, 0.298]
```

