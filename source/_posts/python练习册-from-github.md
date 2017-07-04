---
title: python练习册 from github
date: 2017-05-09 19:22:26
tags: [python]
category: [编程练习]
---

# **第 0001 题：**

<!--more-->

**做为 Apple Store App 独立开发者，你要搞限时促销，为你的应用生成激活码**（或者优惠券），使用 Python 如何生成 200 个激活码（或者优惠券）？

## **解决思路**

1. 首先，我们想到要编写一个200大小的循环，放置一个new_active的激活码生成函数 

2. new_active函数：既然要随机，那么我们就要有random模块，import random模块进来，主要使用的是random.choice 函数，从大写字母，小写字母以及数字当中选择

3. 大写字母:`string.upper`，小写字母：`string.lower`，数字`range(0,10)`，但是前两个是`string`类型的`list`，`range`是<font color = "red" >`int`</font>类型，在后面<font color='red'>`"".join(list)`</font>的时候就无法拼接，所以我们用了`[str(i) for i in range(0,10) ]`，这样就保证了在最后可以把生成的字符串拼接起来

   ```python
   import random
   import string
   import pprint
   # from random import *
   def new_activation(n):
       choice_list = list(string.lowercase) + list(string.uppercase) + [str(i) for i in range(0,10)]
       string_temp = []
       for i in xrange(n):
           temp_string = random.choice(choice_list)
           string_temp.append(temp_string)
       string_temp = "".join(string_temp)
       return string_temp

   activa_list = []
   for i in range(2):
       activa_list.append(new_activation(110))

   pprint.pprint(activa_list)
   ```

# **第 0002 题**：

将 0001 题生成的 200 个激活码（或者优惠券）保存到 **MySQL** 关系型数据库中。 

## **解决思路**

1. MySql教程详见[mysql教程](http://drawon.site/2017/05/11/%E6%95%B0%E6%8D%AE%E5%BA%93%E5%9F%BA%E7%A1%80%E6%95%99%E7%A8%8B/)
2. 安装数据库，仅需要安装SQL sever即可
3. 使用SQlite3包，连接只需要`conn = sqlite3.connect('xx.db')`，然后建立cursor，`cursor = conn.cursor`,之后就可以建立数据表，然后存储数据了
4. 建表的sql命令，

```python
sql = '''CREATE TABLE `activate`(\
         `ID` integer PRIMARY KEY NOT NULL,\               # integer表示自增
         `ACTIVATE_CODE` char(20) NOT NULL )'''
```

5. 存储的命令

```python
sql1 = "INSERT INTO ACTIVATE (ACTIVATE_CODE) VALUES ('%s')"%activate_list[i]
```

其中`activate_list[i]`表示每次需要存储的激活码的值

**详细代码**

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/11 18:27
from activate import new_activation
import os
import sqlite3
activate_list = []
for i in range(100):
    activate_list.append(new_activation(20))
if os.path.exists('./active.db'):
    os.remove('./active.db')
conn = sqlite3.connect('./active.db')
cursor = conn.cursor()
sql = '''CREATE TABLE `activate`(\
         `ID` integer PRIMARY KEY NOT NULL,\
         `ACTIVATE_CODE` char(20) NOT NULL )'''
cursor.execute(sql)
conn.commit()


try:
    for i in range(100):
        sql1 = "INSERT INTO ACTIVATE (ACTIVATE_CODE) VALUES ('%s')"%activate_list[i]
        print sql1
        cursor.execute(sql1)
except Exception as e:
    raise e
finally:
    sql2 = 'select * from activate'
    cursor.execute(sql2)
    print cursor.fetchall()
    conn.commit()
    cursor.close()
    conn.close()
```

# **第 0003 题**：

**第 0003 题：**将 0001 题生成的 200 个激活码（或者优惠券）保存到 **Redis** 非关系型数据库中。 

## **解决思路**

1. ridis非关系型数据库就是一个简化的关系型数据库，没有建表这些复杂的操作

2. 连接数据库的函数

   ```python
   r = redis.Redis(host='localhost',port=6379,db=0)
   ```

3. 利用`r.set('列名',数据值)`存储数据，用`r.get('列名')`获取数据值

**完整代码 **

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/11 18:27
from activate import new_activation
import redis
activate_list = []
for i in range(100):
    activate_list.append(new_activation(20))
r = redis.Redis(host='localhost',port=6379,db=0)
r.set('activate',activate_list)
print r.get('activate')
```

# 第0004题

任一个英文的纯文本文件，统计其中的单词出现的个数。

## 解题思路

1. 首先要分离出每一个单词，主要用到`re`模块和`string.punctuation`，这样就可以从文本中用`punctuation`分离开来
2. 其次要统计单词个数，就要去重，最简单的去重方式就是利用`set`

**具体代码**

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/11 22:21
import re
from string import punctuation
with open(raw_input('filename:')) as f:
    text = f.read()
    punctuation = punctuation+' '
    pat = '[%s]+' % punctuation
    word = re.split(pat,text)
    print word
    print len(set(word))
```

# 第0005题

你有一个目录，装了很多照片，把它们的尺寸变成都不大于 iPhone5 分辨率的大小。

## 解题思路

1. 引用`PIL`(python image library)的`Image`包，其中的`resize`方法，可以调整图片大小
2. `os.walk`方法返回一个元组迭代器，然后用`for root, dirs, files in list_dir:`可以得到根目录，目录名和文件名

```python
import os
from PIL import Image
def resize(filename,new_name):
    pic = Image.open(filename)
    out = pic.resize((100,200),Image.ANTIALIAS)
    out.save(new_name,quality=100)

list_dir = os.walk(r'C:\Users\jeffrey\Desktop\python exercise\python练习册\5\pic')
for root, dirs, files in list_dir:
    for f in files:
        a = os.path.join(root, f)
        print a
        new_name = os.path.join(root,'new_1'+f)
        print new_name
        resize(a,new_name)
```

# **第 0006 题：**

你有一个目录，放了你一个月的日记，都是 txt，为了避免分词的问题，假设内容都是英文，请统计出你认为每篇日记最重要的词。

## 解题思路

1. 引用第0004题的方法，可以分离单词，然后遍历单词，就可以得到每个单词的出现次数

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/12 20:24
import re
from string import punctuation
with open('a.txt') as f:
    text = f.read()
    punctuation = punctuation+' '
    pat = '[%s]+' % punctuation
    word = re.split(pat,text)
    w = {}
    for w1 in word:
        count = 0
        for w2 in word:
            if w1 == w2:
                count += 1
        w[w1]=count
    print w
    cou = 0
    for key,value in w.iteritems():
        if value > cou:
            cou = value
            key_temp = key
print key_temp
```

# 第 0007 题：

有个目录，里面是你自己写过的程序，统计一下你写过多少行代码。包括空行和注释，但是要分别列出来。

## 解题思路

1.有目录的问题，一定会用到`os.walk`函数,使用方法如下

```python
list_dir = os.walk(raw_input("dictionary name:"))
for root, dirs, files in list_dir:
	for f in files:
        with open(os.path.join(root,f))
```

**<font color='red'>注意</font>，这里只需要`join(root，f)`就可以得到所有文件的地址**



具体代码

```python
#!/usr/bin/env python
# -*- coding: gbk -*-
# @Time    : 2017/5/14 18:31
import os

if __name__ == '__main__':
    list_dir = os.walk(raw_input("dictionary name:"))
    pat = '\n'
    code_num = 0
    annotation_num = 0
    for root, dirs, files in list_dir:
        for f in files:
            file_name = os.path.join(root,f)
            with open(file_name) as ff:
                text = ff.read()
                sentence = text.split(pat)
                for line in sentence:
                    if line.strip().startswith('#') or line.strip() == '':
                        annotation_num = annotation_num + 1
                    else:
                        code_num += 1
    print annotation_num
    print code_num


```

# 第0008题：

一个HTML文件，找出里面的**正文**。

## 解题思路

1. 先要获取网页内容，`urlib2.open('www.baidu.com').read()`
2. 要想解析网页，想到网页解析器，在网上查到可以利用`readability`模块的`Document` ，找出正文的话就用`get_content`函数就可以了

### 源码：

```python
import urllib2
from readability import Document
html = urllib2.urlopen('https://github.com/drawwon/show-me-the-code')#(raw_input('please input the file name:'))
text = html.read()
doc = Document(text)
print doc.content()
```

# 第0009题：

一个HTML文件，找出里面的**链接**。

## 解题思路

1. 获取网页内容，`urlib2.open('www.baidu.com').read()`
2. 找出连接，只要用`re`模块匹配`(http://.+)`，`re.findall(pat,text)`就找到了

### 源码：

```python
import re
import urllib2
from readability import Document
html = urllib2.urlopen('https://github.com/drawwon/show-me-the-code')#(raw_input('please input the file name:'))
text = html.read()
pat = re.compile('"(http.+?)"')
links = re.findall(pat, text)
print links
```

# 第0010题

使用 Python 生成类似于下图中的**字母验证码图片**

![字母验证码](http://i.imgur.com/aVhbegV.jpg)

## 解题思路

1. 要处理图片，肯定用到`PIL`(Python Image Library)

2. 首先用`pil.Image.new('RGB',(width,height),0xffff)`新建一张空白图片

3. 从字母(`string.letters`)和数字`''.join([str(i) for i in range(10)])`里面随机选值，用到`random.choice`

4. 要画图就要用到`ImageDraw.Draw(pic)`

5. 然后从三个随机的颜色中选一个来填满图片，`draw.point(xy,fill=random.choice(color1))`

6. 然后字母随机取颜色并画上，`draw.text(xy,text,fill,font=font))`，其中字体是`ImageFont.truetype("arial.ttf",80)`

7. 要得到模糊图片，用`PIL`当中的`filter`函数进行高斯滤波，参数为`ImageFilter.BLUR`

   ​

   效果

   ![](http://ooi9t4tvk.bkt.clouddn.com/17-5-19/17092919-file_1495191243805_2e7f.jpg)

### 源码

```python
from __future__ import division
import string
import random
from PIL import ImageDraw
from PIL import Image,ImageFont,ImageFilter
l = []
num = 4
for j in range(num):
    l.append(random.choice(string.letters+''.join([str(i) for i in range(10)])))
pic = Image.new('RGB',(500,200),0xffff)
draw = ImageDraw.Draw(pic)
color2 = ['purple','green','brown']
color1 = ['BurlyWood','DarkGray','DarkOliveGreen']
width, height = pic.size
for i in range(width+1):
    for j in range(height+1):
        draw.point(xy=(i,j),fill=random.choice(color1))
font = ImageFont.truetype("arial.ttf", 100)
for i in range(len(l)):
    x = i*width/num+5
    c = random.choice(color2)
    draw.text(xy=(x,50),text=l[i],fill=c,font=font)

pic = pic.filter(ImageFilter.BLUR)
pic.show()
pic.save('a.jpg')
```

# **第 0011 题**

敏感词文本文件 filtered_words.txt，里面的内容为以下内容，当用户输入敏感词语时，则打印出 Freedom，否则打印出 Human Rights。`北京 程序员 公务员 领导 牛比 牛逼 你娘 你妈 love sex jiangge`

## 解题思路

1. `while 1`的循环，如果在列表里打印freedom，否则打印Human rights

### 源代码

```python
b_list = ['北京','程序员','公务员','领导','牛比','牛逼','你娘','你妈','love','sex','jiangge']
while 1:
    a = raw_input('请输入词汇:')
    if a in b_list:
        print 'freedom'
    else:
        print 'human 中国'
```

# **第 0012 题**

敏感词文本文件 filtered_words.txt，里面的内容 和 0011题一样，当用户输入敏感词语，则用 星号 * 替换，例如当用户输入「北京是个好城市」，则变成「**是个好城市」。

## 解题思路

1. 一个txt文件读入之后是ascii的编码，是不能用于正则表达式的，从其他编码到unicode需要`decode`，而从unicode到utf-8之类的编码需要encode，因为系统认为unicode是通用编码，其他编码都是通过通用编码再编码得到的

2. 打开文件的时候，可以用`codecs.open`指定编码格式

   ```python
    with codecs.open(filename,'r','utf-8') as f:
    text = f.read
   ```

3.  正则表达式匹配的时候，最好都变成unicode编码来匹配

4. 要匹配多个关键词的时候，可以用for 一个一个的匹配

### 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/19 18:59
import codecs
import re
import chardet
b_list = ['北京','程序员','公务员','领导','牛比','牛逼','你娘','你妈','love','sex','jiangge']
# with codecs.open('a.txt','r','utf-8') as f:
#     text =  f.read()
#     print text
text = open('a.txt').read().decode('utf-8')
pat_f = ''
for i in b_list:
    pat_f = pat_f + '[' + i + ']' + '+'
# pat_f = pat_f.encode('utf-8', 'unicode')
# b = re.findall(u'(北京)+', text)
pat_f = pat_f.decode('utf-8')
print type(pat_f)
print type(text)
for i in b_list:
    pat = str('('+ i +')' + '+').decode('utf-8')
    text = re.sub(u'%s'%pat, u'*'*(len(pat)-3), unicode(text))
# a = re.sub(pat_f, '*', text)
# print a
print text
# print ''.join(b).encode('utf-8','gbk')
```

# 第0013题

用 Python 写一个爬图片的程序，爬 [这个链接里的日本妹子图片 :-)](http://tieba.baidu.com/p/2166231880)

## 解题思路

1. 用`urllib2.urlopen('***.com').read()`打开网页获得网页内容
2. `(r'src="(http[s]?://.+?\.jp[e]?g)"')` 正则表达式，提取图片
3. 用`urllib.urlretrieve`下载图片文件，其中的链接需要去重复，用`set`就可以去重了

### 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/20 14:11
import re,os
import urllib2,urllib,socket
from PIL import Image

text = urllib2.urlopen('https://www.zhihu.com/question/23535321').read()
pat = re.compile(r'src="(http[s]?://.+?\.(jp[e]?g|png))"')
# pat2 = re.compile(r'src="(.+?\.png)"')
links = re.findall(pat, text)
socket.setdefaulttimeout(10)
print links
links = set(links)
# links2 = re.findall(pat2, text)
# print len(links2)
if not os.path.exists(r'.\pic'):
    os.makedirs(r'.\pic')
for i,p in enumerate(links):
    try:
        # print p[0]
        urllib.urlretrieve(p[0],r'.\pic\%s.jpg'%i)
        print '%s.jpg is downloading'%i
    except:
        print '%s.jpg download fail' % i
        pass
```

# 第0014题

纯文本文件 student.txt为学生信息, 里面的内容（包括花括号）如下所示：

> ```
> {
> 	"1":["张三",150,120,100],
> 	"2":["李四",90,99,95],
> 	"3":["王五",60,66,68]
> }
> ```

请将上述内容写到 student.xls 文件中，如下图所示：

![](http://ooi9t4tvk.bkt.clouddn.com/17-5-25/96708619.jpg)

## 解题思路

1. txt文件是json格式，那我们那就引入`json`包，用`json.loads()`函数将txt转换为一个列表
2. 要把列表写到excel中，要用到`xlwt`包，先用`excel = wlwt.workbook()`新建一个工作簿，然后用`sheet = excel.add_sheet()`加入一个sheet，然后用`sheet.write(row,col, text)`写入内容，最后`excel.save(filename)`保存xls
3. 要遍历一个字典的key和value，用到`for k,v in dict.items()`
4. 字典排序`sorted(dict.items, key = lambda: x:x[0])`，其中x是指前面要排序内容中的每一个元素

### 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/25 15:42

import csv,json,xlwt

def read_json(filename):
    return json.loads(open(filename).read().encode('gbk'))

def write_to_csv(data,filename):

    dw = xlwt.Workbook()
    ws = dw.add_sheet("student",cell_overwrite_ok=True)
    row = 0
    col = 0
    print(data.items())
    for k,v in sorted(data.items(), key=lambda d:d[0]):
        ws.write(row, col, k)
        for i in v:
            col = col+1
            ws.write(row,col,i)
        row+=1
        col=0
    dw.save(filename)

write_to_csv(read_json('a.txt'),'student.csv')
```











































