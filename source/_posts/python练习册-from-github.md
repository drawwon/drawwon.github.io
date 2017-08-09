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

# 第0015题

纯文本文件 city.txt为城市信息, 里面的内容（包括花括号）如下所示：
>    {
>    "1" : "上海",
>    "2" : "北京",
>    "3" : "成都"
>    }
>    请将上述内容写到 city.xls 文件中，如下图所示：

![city.xls](http://i.imgur.com/rOHbUzg.png)



## 解题思路

主要方法同上题相似：

1. 使用`json`包的`json.loads()`读入数据
2. 使用`xlwt`，打开workbook，通过`xlwt.add_sheet()`添加新的子表格，通过`for k,v in sorted(data,key= lambda d:d[0])`得到经过排序后的key和value值，并通过`xlrd`的`write`方法写入表格
   ps.如果想输出在字典或者是list当中的中文，可以使用`json.dumps(list, ensure_ascii=False)`进行输出

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/25 20:42

import xlwt,json



def excel_write(txtfile, csvfile):
    with open(txtfile) as f:
        data = json.loads(f.read().encode('gbk'))
    cs = xlwt.Workbook()
    shet = cs.add_sheet('student')
    row = 0
    col = 0
    for i,j in data.items():
        shet.write(row,col,i)
        shet.write(row,col+1,j)
        row += 1
        col = 0
    cs.save(csvfile)

if __name__ == '__main__':
    excel_write('a.txt','student.xls')

```

# 第0016题

 纯文本文件 numbers.txt, 里面的内容（包括方括号）如下所示：

```
[
	[1, 82, 65535], 
	[20, 90, 13],
	[26, 809, 1024]
]
```

请将上述内容写到 numbers.xls 文件中，如下图所示：

![numbers.xls](http://i.imgur.com/iuz0Pbv.png)

## 解题思路

1. 与上题类似，先使用`json`包的`load`方法导入数据
2. 使用`xlwt`包对数据写入xls文件中，在建立表格的时候，需要设置表格覆盖：`wb.add_sheet('num',cell_overwrite_ok=True)`

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/5/25 21:28

import xlwt,json
def read_txt_to_xlsfile(txtfile,xlsfile):
    with open(txtfile) as f:
        data = json.loads(f.read().encode('utf-8'))

    wb = xlwt.Workbook()
    sheet = wb.add_sheet('num',cell_overwrite_ok=True)
    row = col = 0
    print(data)
    for i in data:
        for j in i:
            sheet.write(row,col,j)
            col = col+1
        row = row+1
        col = 0
    wb.save(xlsfile)

if __name__ == '__main__':
    read_txt_to_xlsfile('number.txt','number.xls')
```

# 第0017题

将 第 0014 题中的 student.xls 文件中的内容写到 student.xml 文件中，如下所示：

> ```python
> <?xml version="1.0" encoding="UTF-8"?>
> <root>
> <students>
> <!-- 
> 	学生信息表
> 	"id" : [名字, 数学, 语文, 英文]
> -->
> {
> 	"1" : ["张三", 150, 120, 100],
> 	"2" : ["李四", 90, 99, 95],
> 	"3" : ["王五", 60, 66, 68]
> }
> </students>
> </root>
> ```

## 解题思路

1. 要将xls文件写入到xml文件中，首先要将数据读取出来，使用`xlrd`模块的`xlrd.open_workbook`方法打开xls文件，然后`ws = wb.sheet_by_index[0]`找到工作表，然后通过有序字典存储学生信息

   ````python
   table = OrderDict()
   for i in range(ws.nrows) :
   	key = ws.row_values(i)[0]
   	value = ws.row_values(i)[1:]
   	table[key] = value
   ````

2. 打开`xml`文件，用`with open('students.xml','w') as f：`打开

3. 要写xml文件要用到`etree`模块，

   * 首先建立根节点`root=etree.Element("root")`，
   * 然后以root为根节点建立树`e_root = ElementTree(root)`，建立子节点students`e_students = etree.subElement(root,'students')`，
   * 写students子节点的内容`e_students.text = '\n'+json.dumps(table, indent=4 , ensure_ascii=False)`，
   * 然后添加注释comment`e_students.append(etree.Comment('\n    学生信息表\n    "id" : [名字，数学，语文，英语]\n'))`，
   * 最后写入etree的unicode元素，`f.write(('<?xml version="1.0" encoding="UTF-8"?>'+etree.tounicode(e_root.getroot())))`



## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/6/27 14:59
import xlrd,json
from lxml import etree
from collections import OrderedDict

def xls2xml(xls_filename):
    with xlrd.open_workbook(xls_filename) as wb:
        ws = wb.sheet_by_index(0)
    table = OrderedDict()
    for i in range(ws.nrows):
        key = int(ws.row_values(i)[0])
        value = str(ws.row_values(i)[1:])
        table[key] = value
    with open("student.xml",'w') as f:
        root = etree.Element("root")
        e_root = etree.ElementTree(root)
        e_students = etree.SubElement(root,'students')
        e_students.text = '\n'+json.dumps(table,indent=4,ensure_ascii=False)+'\n'
        e_students.append(etree.Comment('\n    学生信息表\n    "id" : [名字，数学，语文，英语]\n'))
        f.write(('<?xml version="1.0" encoding="UTF-8"?>'+etree.tounicode(e_root.getroot())))
if __name__ == '__main__':
    xls2xml('student.xls')
    print 'done'
```

# 第0018题

将 第 0015 题中的 city.xls 文件中的内容写到 city.xml 文件中，如下所示：

> ``` python
> <?xmlversion="1.0" encoding="UTF-8"?>
> <root>
> <citys>
> <!-- 
> 	城市信息
> -->
> {
> 	"1" : "上海",
> 	"2" : "北京",
> 	"3" : "成都"
> }
> </citys>
> </root>
> ```

## 解题思路

1. 方法类似于0017题，首先将xls文件通过`xlrd`读出来，放在有序字典中
2. 然后通过`xml.dom.minidom`模块建立`Document`，然后创建元素root`root = xml.createElement('root')`，然后建立子节点，最后写入xml文件中

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/6/10 17:09
import xlrd,json
from xml.dom import minidom


# def list2dict(list_name):
#     dic = {}
#     for list_element in list_name:
#         dic[list_element[0]] = list_element[1:]
#     return dic

def creat_and_write_xml(filename,row_data):
    xml = minidom.Document()
    root = xml.createElement('root')
    xml.appendChild(root)
    city = xml.createElement('city')
    root.appendChild(city)
    city.appendChild(xml.createComment("城市信息"))
    row_data = json.dumps(row_data,ensure_ascii=False,indent=1)
    text = xml.createTextNode(row_data.encode('utf-8'))

    city.appendChild(text)
    f = open(filename,'wb')
    f.write(xml.toprettyxml())
    f.close()



if __name__ == '__main__':
    data = xlrd.open_workbook('city.xls')
    table = data.sheet_by_index(0)
    row_data = {}
    # res=[]
    # for i in range(table.nrows):
    #     for j in range(table.ncols):
    #         if isinstance(table.cell(i,j).value,unicode):
    #             a = table.cell(i,j).value.encode('gb2312')
    #             # print table.cell(i,j).value
    #         elif isinstance(table.cell(i,j).value,float) or isinstance(table.cell(i,j).value, int):
    #             a = unicode(table.cell(i,j).value).decode('utf-8').encode('gb2312')
    #             # print table.cell(i, j).value
    #
    #         # table.cell(i, j).value = str(table.cell(i, j).value).decode('utf-8').encode('gb2312')
    #         res.append(a)
    #     res.append("|")
    # # print res
    # res_string = ' '.join(res).split("|")
    # res_string.pop(-1)
    # print res_string,'11111111112'
    # for i in range(len(res_string)):
    #     row_data[i+1] = res_string[i][1:]
    # print row_data
    for i in range(table.nrows):
        print ''.join(table.row_values(i)[1:])
        row_data[i+1] = ''.join(table.row_values(i)[1:])
    filename = 'city.xml'
    creat_and_write_xml(filename, row_data)
```

# 第0019题

将 第 0016 题中的 numbers.xls 文件中的内容写到 numbers.xml 文件中，如下所示：

>  ```xml
>  <?xml version="1.0" encoding="UTF-8"?>
>  <root>
>  <numbers>
>  <!-- 
>  	数字信息
>  -->
>
>  [
>  	[1, 82, 65535],
>  	[20, 90, 13],
>  	[26, 809, 1024]
>  ]
>
>  </numbers>
>  </root>
>  ```

## 解题思路

1. 整体思路与0018题类似，用`xlrd`文件读取xls文件内容
2. 用`xml.dom.minidom`创建`Document`对象，然后通过创建名为root的element`xml.createElement('root')`，然后通过`xml.appendChild(root)`把root添加为xml文件的根节点，创建并添加number节点，添加`comment`注释节点并添加为子节点，添加文本节点并添加为子节点，最终用`topreetyxml`写入xml

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/6/10 17:09
import xlrd,json
from xml.dom import minidom

def creat_and_write_xml(filename,row_data):
    xml = minidom.Document()
    root = xml.createElement('root')
    xml.appendChild(root)
    number = xml.createElement('number')
    root.appendChild(number)
    number.appendChild(xml.createComment("城市信息"))
    row_data = json.dumps(row_data,ensure_ascii=False)

    text = xml.createTextNode(row_data.encode('utf-8'))

    number.appendChild(text)
    f = open(filename,'wb')
    f.write(xml.toprettyxml())
    f.close()



if __name__ == '__main__':
    data = xlrd.open_workbook('number.xls')
    table = data.sheet_by_index(0)
    row_data = {}
    for i in range(table.nrows):
        row_data[i+1] = table.row_values(i)[1:]
    filename = 'number.xml'
    creat_and_write_xml(filename, row_data)
```

# 第0020题

 [登陆中国联通网上营业厅](http://iservice.10010.com/index_.html) 后选择「自助服务」 --> 「详单查询」，然后选择你要查询的时间段，点击「查询」按钮，查询结果页面的最下方，点击「导出」，就会生成类似于 2014年10月01日～2014年10月31日通话详单.xls 文件。写代码，对每月通话时间做个统计。

## 解题思路

1. 导出的文件是一个xls文件，我们使用`xlrd`模块读入内容

2. 统计数据并通过`plt.bar`画直方图，第一个参数为横坐标，第二个参数为纵坐标，<font color="red">要想plt显示中文标注</font>，需要：

   ```python
   plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
   plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
   ```

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/6/27 16:50

import xlrd,re,pprint
from collections import OrderedDict
import matplotlib.pyplot as plt
import numpy as np
import seaborn
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
wb = xlrd.open_workbook('2017-6.xls')
ws = wb.sheet_by_index(0)


def time2second(time):
    second_pattern = u'([0-9]+)秒'
    minute_pattern = u'([0-9]+)分'
    minute = re.findall(minute_pattern, time)
    second = re.findall(second_pattern, time)
    # print minute,second
    if minute:
        return int(minute[0]) * 60 + int(second[0])
    else:
        if second:
            return int(second[0])
        else:
            return 0




data=[]
for i in range(ws.nrows):
    data.append(ws.row_values(i))
data.pop(0)
call_num = OrderedDict()
call_time = OrderedDict()
month = '2017-06-'
day_range = range(1,31)
for i,item in enumerate(day_range):
    if item < 10:
        day_range[i] = '0'+str(item)
    else:
        day_range[i] = str(i)
date_range = [ month + day + " " for day in day_range]
for date in date_range:
    call_num[date] = 0
    call_time[date] = 0
for row in range(len(data)):
    row_value = data[row]
    time = time2second(row_value[3])
    for element in row_value:
        for date in date_range:
            if re.match(date,element):
                # print element
                call_num[date] = call_num[date] + 1
                call_time[date] = call_time[date] + time
# print call_num
# print call_time
num = []
time = []
for i in call_num.iteritems():
    num.append(i[1])
    time.append(i[0])
print num
print np.arange(len(num))
plt.bar(np.arange(len(num)),num)
plt.xticks(range(len(num)))
plt.xlabel(u'6月通话时间')
for i, v in enumerate(num):
    plt.text(i-0.35,v+0.2, str(v), color='blue', fontweight='bold')
plt.show()
```

# 第0021题

通常，登陆某个网站或者 APP，需要使用用户名和密码。密码是如何加密后存储起来的呢？请使用 Python 对密码加密。

## 解题思路

1. 要想加密，可以使用`hashlib.sha256`库，使用`os.random(8)`生成一个长度为8位的salt，让密码与salt一起进行哈希，进行哈希的函数是`hmac.HMAC`
2. 判定输入的密码是不是正确，只需要将新接受到的密码与原先的salt一起进行一次hash看是否等于之前的hash结果

## 源代码

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/6/28 11:00

from hashlib import sha256
from hmac import HMAC
import os

def hash_password(password, salt = None):
    if isinstance(password, unicode):
        password = password.encode('UTF-8')
    if salt is None:
        salt = os.urandom(8)
    result = HMAC(password, salt, sha256).digest()
    return result,salt

def authen_password(result, new_password, salt):
    return hash_password(new_password,salt)[0] == result

if __name__ == '__main__':
    password = raw_input('please input the password: ')
    result,salt = hash_password(password)
    print result
    new_password = raw_input('please input the password again: ')
    print authen_password(result,password,salt)
```

# 第0022题

 iPhone 6、iPhone 6 Plus 早已上市开卖。请查看你写得 第 0005 题的代码是否可以复用。

## 解题思路

1. 整体思路与0005题类似，利用`PIL.Image.resize`函数对图片进行重塑大小

## 源代码

```python
#!/usr/bin/env python
# -*- coding: gbk -*-
# @Time    : 2017/6/28 13:53

import os
from PIL import Image
def resize(filename,new_name):
    pic = Image.open(filename)
    out = pic.resize((1000,800),Image.ANTIALIAS)
    out.save(new_name,quality=100)

list_dir = os.walk(r'C:\Users\jeffrey\Desktop\python exercise\python练习册\22\pic')
for root, dirs, files in list_dir:
    for f in files:
        a = os.path.join(root, f)
        print a
        new_name = os.path.join(root,'new_1'+f)
        print new_name
        resize(a,new_name)
```

# 第0023题

使用 Python 的 Web 框架，做一个 Web 版本 留言簿 应用。

[阅读资料：Python 有哪些 Web 框架](http://v2ex.com/t/151643#reply53)

![留言簿参考](http://i.imgur.com/VIyCZ0i.jpg)

## 解题思路

1. 使用的是flask框架，参照网上的示例，先在app文件夹下建立`__init__.py`，在文件中写入如下内容：

   ```python
   from flask import FLASK
   from flask_mongoengine import MongoEngine

   app = FLASK(__name__)
   app.config.from_object("config")
   db = MongoEngine(app)

   import views,models
   ```

   其中的`models.py`定义了Todo类，包含内容，时间，和状态三个属性，如下所示:

   ```python
   from . import db
   import datetime
   from flask_mongoengine.wtf import model_form
   ```


   class Todo(db.Document):
       content = db.StringField(required=True, max_length=20)
       time = db.DateTimeField(default=datetime.datetime.now())
       status = db.IntField(default=0)

   TodoForm = model_form(Todo)
   ```

   其中`views.py`定义了每个页面的函数，如下：

   ```python
   from . import app
   from flask import render_template, request
   from models import Todo, TodoForm


   @app.route('/')
   def index():
       form = TodoForm()
       todos = Todo.objects.order_by('-time')
       return render_template("index.html", todos=todos, form=form)


   @app.route('/add', methods=['POST', ])
   def add():
       form = TodoForm(request.form)
       if form.validate():
           content = form.content.data
           todo = Todo(content=content)
           todo.save()
       todos = Todo.objects.order_by('-time')
       return render_template("index.html", todos=todos, form=form)

   @app.route('/done/<string:todo_id>')
   def done(todo_id):
       form = TodoForm()
       todo = Todo.objects.get_or_404(id=todo_id)
       todo.status = 1
       todo.save()
       todos = Todo.objects.all()
       return render_template('index.html', todos=todos, form=form)

   @app.route('/undone/<string:todo_id>')
   def undone(todo_id):
       form = TodoForm()
       todo = Todo.objects.get_or_404(id=todo_id)
       todo.status = 0
       todo.save()
       todos = Todo.objects.all()
       return render_template("index.html", todos=todos,form=form)

   @app.route('/delete/<string:todo_id>')
   def delete(todo_id):
       form = TodoForm()
       todo = Todo.objects.get_or_404(id=todo_id)
       todo.delete()
       todos = Todo.objects.all()
       return render_template('index.html', todos=todos,form=form)

   @app.errorhandler(404)
   def not_found(e):
       return render_template('404.html'),404
   ```

   ​

   **其中`index.html`文件是放在`app/templates`文件夹下的网页模板文件**

   **所有关于`index.html`文件的静态文件（如js和css文件）均放在`app/statics`下面**

2. 在`index.html`文件中写入网页模板如下：
   如果要用到循环：大括号加百分号的形式，`{ % for error in form.error.content % }`
   要用到某个变量：双大括号，`{ { } } t.content }}`

   ```html
   { % extends "base.html" % } { % block content % } <!--继承base.html-->
   <head>
       <style type="text/css">
           td{text-align: center}
           .content_td{width: 100px}
           .time_td{width: 300px}
           .done_td{width: 100px}
       </style>
   </head>
   <form class="input-form" action="/add" method="post">   <!--输入框，记录输入的内容-->
       { { } } form.hidden_tag() }}
       { { } } form.content(class="form-control") }}
       <span class="input-btn">
           <button class="btn-primary" type="submit">Add</button>  <!--提交按钮-->
       </span>
   </form>
   { % for error in form.errors.content % }
   <div class="flash alert"><span>{ { } } error }}</span></div>
   { % endfor % }
   <div>
       <h2>Todo List</h2> 
       { % if todos % }
       <table class="table" style="margin: 0 auto">
           <thead>
               <tr>
                   <td class="content_td">Content</td>
                   <td class="time_td">Time</td>
                   <td class="done_td">Operation</td>
               </tr>
           </thead>
           <tbody>
               { % for t in todos % }
               <tr>
                   <td class="content_td">{ { } } t.content }}</td>
                   <td class="time_td">{ { } } t.time.strftime(' %m-%d %H:%M') }}</td>
                   <td class="done_td">
                       { % if t.status == 0 % }
                       <a href="/done/{ { } } t.id }}" class="btn btn-primary" style="color: blue">Done</a> 
                       { % else % }
                       <a href="/undone/{ { } } t.id }}" class="btn btn-primary" style="color: red">Undone</a> 
                       { % endif % }
                       <a href="/delete/{ { } } t.id }}" class="delete btn">Delete</a>
                   </td>
               </tr>
               { % endfor % }
           </tbody>
       </table>
       { % else % }
           <h3 style="color: red">NO Todos, please add things</h3>
       { % endif % }
   </div>
   { % endblock % }
   ```

   **而`index.html`文件继承于`base.html`文件如下：**

   ```html
   <!DOCTYPE html>
   <html>
   <head lang="en">
       <meta charset="UTF-8">
       <style type="text/css">
           *{text-align: center}
           td{line-height: 30px}
           
       </style>
       <title>to_do</title>
       <link href="{ { } } url_for('static',filename='bootstrap.css') }}" rel="stylesheet" type="text/css"/>
       <link href="{ { } } url_for('static',filename='index.css') }}" rel="stylesheet" type="text/css"/>
   </head>
   <body>
   <div class="container">
       <div class="page-header">
           <h1>my-flask-todo</h1>
       </div>
       <div class="row">
           <div class="col-lg-10">
              { % block content % }
              { % endblock % }
           </div>
       </div>
   </div>

   <footer class="footer">
       <div class="container">
           <p class="text-muted">Copyright © drawon 2015</p>
       </div>
   </footer>
   </body>
   </html>
   ```

3. 在`my_to_do/app`的`my_to_do`文件夹下，写配置文件`config.py`

   ```python
   SECRET_KEY = "never tell you"
   MONGODB_SETTINGS = {'DB': 'todo_db'}
   WTF_CSRF_ENABLED = False
   ```

4. 在`my_to_do/app`的`my_to_do`文件夹下，写管理文件`manage.py`，通过这个py文件启动flask：

   ```python
   # -*- coding: utf-8 -*-

   from flask.ext.script import Manager, Server
   from app import app
   from app.models import Todo

   manager = Manager(app)                     #定义Manager对象

   manager.add_command("runserver",
                       Server(host='0.0.0.0',
                              port=5000,
                              use_debugger=True)) #通过add_command命令添加网页启动命令 runserver 

   @manager.command    # 添加新的命令save_todo
   def save_todo():
   todo = Todo(content="my first todo")
   todo.save()
   if name == 'main':
   	manager.run()

   ```

5. 在命令行运行 `python manage.py runserver`即可开启网页

## 源代码

具体请查看[github](https://github.com/drawwon/show-me-the-code/tree/master/23)
