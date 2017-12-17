---
title: Django项目学习
date: 2017-12-13 19:32:03
tags: [网页,Django]
category: [编程学习,网页制作]
---

本文主要来自于mooc公开课Django课程

### 首先创建一个Django的虚拟环境：

`pip install virtualenv`，然后使用`virtualenv 虚拟环境名`建立一个虚拟环境，在windows下面的激活方法是

```
cd django_virtual
cd Script
activate
```

在linux下只需要将最后一步换位source activate

### 建立Django项目

在PyCharm建立程序时，直接选择Django程序，选择解释器为virtualenv建立的django环境，即可建立django项目

<img src="http://ooi9t4tvk.bkt.clouddn.com/17-12-13/90225758.jpg" style="zoom:50%">

![]()

项目建立之后，我们得到了如下的目录结构，紫色的被标记为了templet目录，这样就能智能提示，如果你想要在import的时候不需要加入绝对路径，那么就可以`mark as source root`

![](http://ooi9t4tvk.bkt.clouddn.com/17-12-13/70910990.jpg)

接下来我们先尝试运行该项目，点击run，运行这个Django项目，可以看到运行在了本机的8000端口，点击该地址即可访问：

![](http://ooi9t4tvk.bkt.clouddn.com/17-12-13/88013332.jpg)

如果要配置监听所有ip，那么我们需要通过`run-Edit configurations`，将监听端口改为0.0.0.0

<img src="http://ooi9t4tvk.bkt.clouddn.com/17-12-13/5597585.jpg" style="zoom:40%">

### Navicat使用

安装好Navicat之后，打开软件，建立连接，之后建立表，设计表的字段，设计完之后按`ctrl+s`保存，之后就可以插入数据条目，这就是简单的使用方法，具体使用会在之后用到的时候详细介绍。

### Django目录结构

首先看看之前提到的建立django之后的目录结构，windows使用`tree \F .`得到如下结构，linux中使用`apt-get install tree`，然后`tree .即可得到`：

```
├mooc_web
  │  manage.py
  ├─mooc_web
  │  │  settings.py
  │  │  urls.py
  │  │  wsgi.py
  │  │  __init__.py
  └─templates
```

* templetes文件夹主要放html文件
* 主文件夹下面有settings.py，以及manage.py
* 我们需要建立static文件夹，用于存放css和js文件，以及主要的图片文件
* 建立log文件夹，用于存放日志
* 建立media文件夹，用于存放用户上传的文件
* 建立apps文件夹，用于存放各个app

### 建立app

通过pycharm当中的`tools-run manage.py task`，此时可以在shell中执行Django命令：

```
startapp message
```

此时就有了一个名为message的文件夹，将其拖入apps文件夹，自动生成了一个`__init__.py`文件，这样就让apps变成一个可以导入的包，为了方便导入，那么我们需要将apps文件夹remark成source root，这样每次引用的时候就不需要import apps.message.view 而是可以直接 import message.view

这样在pycharm中引用变得方便了，但是在使用命令行运行的时候就会出错，此时我们需要在settings.py中将apps加入到**根搜索路径**（BASE_DIR）中

```
├── apps
│   ├── __init__.py
│   └── message
│       ├── admin.py
│       ├── apps.py
│       ├── __init__.py
│       ├── migrations
│       │   └── __init__.py
│       ├── models.py
│       ├── tests.py
│       └── views.py
├── db.sqlite3
├── log
├── manage.py
├── media
├── mooc_web
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── static
└── templates
```

### 使用模板

将html模板放入template文件夹，在static文件夹中建立css文件夹，并放入style.css文件

### settings配置

#### 更改数据库配置

因为Django默认用的是sqlite数据库，我们要改成mysql数据库，打开项目的settings.py，找到DATABASES，将其中的：

* ENGINE改为`django.db.backends.mysql`
* NAME改为Navicat中看到的`testDjango`
* USER改为数据库的user名，我这里是root
* PASSWORD改为数据库的password，我这里也是root
* HOST改为localhost，也就是127.0.0.1

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'testDjango',
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '127.0.0.1'
    }
}
```
####migration生成数据表
通过`tools-Run manage.py Task`来连接数据库，首先需要安装mysqlclient，用`pip install mysqlclient`安装：

```
> makemigrations   # 用于生成一个基于你对模型改变的迁移，在这里就是数据库类型从sqlite迁移到mysql
> migrate		  # 用于应用改变	
```

此时Django自动生成了一大堆数据库表，在Navicat中可以看到表的名称：

![](http://ooi9t4tvk.bkt.clouddn.com/17-12-14/11540528.jpg)

此时可以点击run运行整个系统，可以在127.0.0.1:8000上访问该网址

#### 配置static文件夹地址

但是此时的style.css无法被找到，我们要在settings.py中配置一下static文件夹的地址，因为`STATICFILES_DIRS` 可能不止一个，所以用list的形式进行赋值，其中BASE_DIR是项目文件的根目录：

```
STATICFILES_DIRS = [
    os.path.join(BASE_DIR,'static')
]
```

### urls.py配置和views.py函数

在urls.py中添加新的页面，页面的处理函数要在`apps.message.views.py` 中新增，首先我们在`view.py` 中构造如下函数，直接return render的模板，其中request参数是Django的请求，每个views函数都得有：

```
def getform(request):
    return render(request, template_name='course-comment.html')
```

### 项目配置流程

![](http://ooi9t4tvk.bkt.clouddn.com/17-12-14/89792661.jpg)



整体来说，先设置数据库和STATICFILES_DIRS，之后这一块不再动，主要就是views.py写后端逻辑，urls.py写页面地址url配置

### Django orm 模型设计

普通的数据库调用方法，连接（connect），生成cursor，excute sql语句，cursor.fetchall( )

orm就是把一个表映射成一个类，比如要找出name只需要调用`book.name` 

下面我们开始使用orm进行设计数据库：

找到message下面的models.py文件，在其中定义一个UserMessage类，用于存放我们需要的数据，所有model都要继承models.Model类：

```python
class UserMessage(models.Model):
    name = models.CharField(max_length=20, verbose_name='用户名')
    email = models.EmailField(verbose_name='邮箱')
    address = models.CharField(max_length=100, verbose_name='地址')
    message = models.CharField(max_length=500, verbose_name='留言信箱')

    class Meta:
        verbose_name = '用户留言信息'
```

其中每一个字段都定义一个类型，常用的有CharField，EmailField，DateTimeField, IntergerField, ForeignKey, IPAddressField, FileField, ImageField

其中max_length表示最大长度，verbose_name表示别名.

自己定义的model还有一个内部类Meta，用于存放所有不是Field的字段，比如排序的顺序，数据表的名称等等

#### 应用模型的改变

点击`Tools-Run manage.py`，执行命令，发现找不到message这个model，所有我们要去settings.py中`INSTALLED_APPS`加入'app.message'

再次执行

```
> makemigrations message
> migragate message
```

#### 对数据表进行增删改查

##### 查找数据

先引入model对象，`from apps.message.models import UserMessage` ，利用model对象的objects方法，对数据进行操作

```
all_message = UserMessage.objects.all()
filterd_data = UserMessage.objects.filter(name='jeffrey',address='beijing')
```

这里的all就是取出所有值，filter就是取出特定条件的值

##### 增加数据

定义一个新的对象，并对其各个field赋值

```
user_message = UserMessage()
user_message.name = 'a'
user_message.message = 'a@a.com'
user_message.message = 'aaaaa'
user_message.save()
```

这样每次访问form页面的时候都可以存入一条记录

还可以通过页面的表单提交增加新的数据，request的POST属性中，以字典的形式存储了表单中提交的值，可以用python的get方法获取这些值，get的第二个参数为获取不到时候的默认值：

```python
if request.method == 'POST':
    name = request.POST.get('name','')
    email = request.POST.get('email', '')
    message = request.POST.get('message', '')
    
    user_message = UserMessage()
    user_message.name = 'a'
    user_message.email = 'a@a.com'
    user_message.message = 'aaaaa'
    user_message.save()

```

##### 删除数据

直接先查找到对象，然后用delete方法就可以删除对象

```python
all_message = UserMessage.objects.fileter(name='bob')
all_message.delete()
```

### 显示数据库中的数据到页面

在view.py中，我们可以先取出数据，然后在render的时候，把需要传入的参数以一个dict的形式，传递给context，这样我们就可以在html文件中进行调用

```python
def getform(request):
    message = None
    all_message = UserMessage.objects.filter(name='boobytest')
    if all_message:
    message = all_message[0]
    return render(request, template_name='course-comment.html',context={'message':message,})
```

在HTML文件中调用参数的方法是两个大括号`{{ parameter }}`，input就输入在value里面，textarea就输入在两个标签之间：

```html
<input id="email" type="email" value={{ message.email }} name="email" placeholder="请输入邮箱地址"/>
<textarea id="message" name="message"  placeholder="请输入你的建议">{{ message.message }}</textarea>
```

### 在HTML文件中使用python逻辑

在HTML文件中，使用python逻辑的方法是大括号加百分号，`{% python expression %}`

```html
<input id="name" type="text" value="{% if not message.name == 'boobytest' %}
boobyhastest{% else %}booby no test
{% endif %}" name="name" class="error" placeholder="请输入您的姓名"/>
```

比如在HTML中使用if和else的方法如上，当然if a==b 也可以使用 ifequal a b代替，取前五位也可以使用`message.name|split:'2'`

Django提供了很多内置的方法，具体可以查看[Django template built-in tags](https://docs.djangoproject.com/en/2.0/ref/templates/builtins/)

### 使用别名关联url和HTML

url在配置过程中可能会改变，因此我们需要为url设置一个不变的名字供HTML调用

在url.py中：

```python
url(r'^form/$', getform,name='form')
```

在comment.html中：

```html
<form action="{% url 'form' %}" method="post" class="smart-green">
```

注意，在url配置中一定要加上`/$` 表示以`/`结尾，不然再进行正则匹配的时候可能会匹配到别的网页


























