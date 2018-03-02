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

<!--more-->

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

安装好Navicat之后，打开软件，建立连接，之后建立表，设计表的字段，设计完之后按`ctrl+s`保存，之后就可以插入数据条目，这就是简单的使用方法，具体使用会在之后用到的时候详细介绍。[下载地址请点击]([http://pan.baidu.com/s/1pLNJOBD)

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

建立log文件夹用于存放日志，media用于存放用户的上传文件，建立static存放静态css和js文件

当app比较多的时候，就建立一个apps文件夹，将新建立的app拖进去

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

在urls.py中添加新的页面，页面的处理函数要在`apps-message-views.py` 中新增，首先我们在`view.py` 中构造如下函数，直接return render的模板，其中request参数是Django的请求，每个views函数都得有：

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
        verbose_name_plural = verbose_name
        ordering = '-id'  # 排序方式为反向的id
        db_table = 'my_table'  #设置table的名字
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

先引入model对象，`from apps.message.models import UserMessage` ，，利用model对象的objects方法，对数据进行操作

```python
all_message = UserMessage.objects.all()  #这个是可以循环的
for message in all_messages:
	print(message.name)

filterd_data = UserMessage.objects.filter(name='jeffrey',address='beijing')  #filter方法可以对数据进行过滤，中间的逗号表示多个条件，这里是取出的name为jeffrey，address为北京的值
for message in filterd_data:
	print(message.name)
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

在html文件中需要进行如下更改：

```
<form action="/form/" method="post" class="smart-green">
在action中填入网页地址
```

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

在HTML文件中调用参数的方法是两个大括号，input就输入在value里面，textarea就输入在两个标签之间：

```html
<input id="email" type="email" value={　{ message.email }　} name="email" placeholder="请输入邮箱地址"/>
<textarea id="message" name="message"  placeholder="请输入你的建议">{　{ message.message }　}</textarea>
```

### 在HTML文件中使用python逻辑

在HTML文件中，使用python逻辑的方法是大括号加百分号，`{　% python expression %　}`

if和end if成对出现

```html
<input id="name" type="text" value="{% if not message.name == 'boobytest' %}
boobyhastest{% else %}booby no test
{% endif %}" name="name" class="error" placeholder="请输入您的姓名"/>
```

比如在HTML中使用if和else的方法如上，当然if a==b 也可以使用 ifequal a b代替，取前五位也可以使用`message.name|split:'5'`

```html
{% ifequal a b%}  {% endif %}#用于表示等于
```



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

### url匹配

必须在url前面加上`^`，后面加上`/$`，这样不会匹配出错

## mooc开发实战

### app设计

![](http://ooi9t4tvk.bkt.clouddn.com/18-1-21/6996332.jpg)

### 新建虚拟环境

```shell
mkvirtualenv mooc
cd mooc/Script
activate
pip install Django mysqlclient
```

### 新建Django项目

通过pycharm建立Django项目，名字为MxOnline，首先在settings.py中更改数据库引擎

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mxonline',
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '127.0.0.1',
    }
}
```

通过`Tools-run manage.py task`来生成数据库的表

```
makemigrations
migragate
```

### 扩展user表

首先`startapp users`，在models当中，新建一个`UserProfile`，继承`django.contrib.auth.models.AbstractUser`，加入你需要的自定义字段，并定义好meta信息中的`verbose_name`

```python
from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.
class UserProfile(AbstractUser):
    nick_name = models.CharField(max_length=50,verbose_name='昵称',default='')
    birthday = models.DateField(verbose_name='生日',null=True,blank=True)
    gender = models.CharField(max_length=5,choices=(('male','男'),('female','女')),default='')
    address = models.CharField(max_length=100,default='')
    mobile = models.CharField(max_length=11, null=True, blank=True)
    image = models.ImageField(upload_to='image/%Y/%m',default='image/default.png')


    class Meta:
        verbose_name = '用户信息'
        verbose_name_plural = verbose_name
```

然后run manage.py，通过`makemigrations users`和`migragate users`生成新的user表，可能会报错，报错时只需要将之前生成的所有表删除后重新生成即可

### 循环引用

![](http://ooi9t4tvk.bkt.clouddn.com/18-1-23/18897780.jpg)

避免交叉引用，不然会出错，使用上层app引用下层app

![](http://ooi9t4tvk.bkt.clouddn.com/18-1-23/87606606.jpg)

### 加入邮件验证码和轮播图

```python
class EmailVerifyRecord(models.Model):
    code = models.CharField(max_length=20, verbose_name='验证码')
    email = models.EmailField(max_length=50, verbose_name= '邮箱')
    send_type = models.CharField(choices=(('register','注册'),('forget','找回密码')),max_length=10)
    send_time = models.DateTimeField(default=datetime.now) #记得去掉datetime.now的括号，不然只会记录class生成的时间
    class Meta:
        verbose_name = '邮箱验证码'
        verbose_name_plural = verbose_name

class Banner(models.Model):
    title = models.CharField(max_length=100, verbose_name='标题')
    image = models.ImageField(upload_to='banner/%Y/%m', verbose_name='轮播图')
    url = models.URLField(max_length=500, verbose_name='访问地址')
    index = models.IntegerField(default=100, verbose_name='顺序')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '轮播图'
        verbose_name_plural = verbose_name
```

### 课程model设计

```
Course -- 课程基本信息
Lesson -- 章节信息
Video -- 视频
CourseResource -- 课程资源
```

一共有上述四张表

```python
from django.db import models
from datetime import datetime

# Create your models here.
class Course(models.Model):
    name = models.CharField(max_length=50, verbose_name='课程名称')
    desc = models.CharField(max_length=300, verbose_name='课程描述')
    detail = models.TextField(verbose_name='课程详情')
    degree = models.CharField(choices=(('cj','初级'),('zj','中级'),('gj','高级')),verbose_name='课程难度',max_length=2)
    learn_time = models.IntegerField(default=0, verbose_name='学习时长(分钟数)')
    students = models.IntegerField(default=0, verbose_name='学习人数')
    fav = models.IntegerField(default=0, verbose_name='收藏人数')
    image = models.ImageField(upload_to='courses/%Y/%m', verbose_name='封面图', max_length=100)
    click_num = models.IntegerField(default=0, verbose_name='点击数')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name='课程'
        verbose_name_plural = verbose_name

class Lesson(models.Model):
    course = models.ForeignKey(Course, verbose_name='课程')
    name = models.CharField(max_length=100, verbose_name='章节名')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '章节'
        verbose_name_plural = verbose_name

class Video(models.Model):
    lesson = models.ForeignKey(Lesson, verbose_name='章节')
    name = models.CharField(max_length=100, verbose_name='视频名')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '视频'
        verbose_name_plural = verbose_name

class CourseResource(models.Model):
    course = models.ForeignKey(Course, verbose_name='课程')
    download = models.FileField(upload_to='courses/resource/%Y/%m',max_length=100)
    name = models.CharField(max_length=100, verbose_name='资源名称')
    add_time = models.DateTimeField(default=datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '课程资源'
        verbose_name_plural = verbose_name
```

### 添加organization的model

```
CourseOrg -- 课程机构基本信息
Teacher -- 教师基本信息
CityDict -- 城市信息
```

添加如下

```python
from django.db import models
from datetime import datetime

# Create your models here.

class CourseOrg(models.Model):
    city = models.ForeignKey(CityDict,verbose_name='所在城市')
    name = models.CharField(max_length=50,verbose_name='机构名称')
    desc = models.TextField(verbose_name='机构描述')
    click_nums = models.IntegerField(default=0, verbose_name='点击数')
    fav_nums =  models.IntegerField(default=0, verbose_name='收藏数')
    image = models.ImageField(upload_to='org/%Y/%m',verbose_name='封面图')
    address = models.CharField(max_length=150,verbose_name='地址')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '课程机构'
        verbose_name_plural = verbose_name

class CityDict(models.Model):
    name = models.CharField(max_length=20,verbose_name='城市')
    desc = models.CharField(max_length=200, verbose_name='描述')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '城市'
        verbose_name_plural = verbose_name

class Teacher(models.Model):
    org = models.ForeignKey(CourseOrg, verbose_name='所属机构')
    name = models.CharField(max_length=20,verbose_name='教师名')
    work_years = models.IntegerField(default=0, verbose_name='工作年限')
    work_company = models.CharField(max_length=50,verbose_name='就职公司')
    work_position = models.CharField(max_length=50,verbose_name='公司职位')
    points = models.CharField(max_length=50, verbose_name='教学特点')
    click_nums = models.IntegerField(default=0, verbose_name='点击数')
    fav_nums =  models.IntegerField(default=0, verbose_name='收藏数')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '教师'
        verbose_name_plural = verbose_name
```

### 添加operation的model

```
UserAsk -- 用户咨询
CourseComments -- 用户评论
UserFavorite -- 用户收藏
UserMessage -- 用户消息
UserCourse -- 用户学习的课程
```

添加如下：

```python
from django.db import models
from datetime import datetime
from users.models import UserProfile
from courses.models import Course
from organization.models import CourseOrg


# Create your models here.
class UserAsk(models.Model):
    name = models.CharField(max_length=20,verbose_name='姓名')
    mobile = models.CharField(max_length=11, verbose_name='手机')
    course_name = models.CharField(max_length=50,verbose_name='课程名称')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '用户咨询'
        verbose_name_plural = verbose_name

class CourseComments(models.Model):
    user = models.ForeignKey(UserProfile, verbose_name='用户')
    course = models.ForeignKey(Course, verbose_name='课程')
    comments = models.CharField(max_length=500,verbose_name='评论')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '课程评论'
        verbose_name_plural = verbose_name

class UserFavorite(models.Model):
    user = models.ForeignKey(UserProfile, verbose_name='用户')
    fav_id = models.IntegerField(default=0, verbose_name='数据id')
    fav_type = models.IntegerField(choices=((1,'课程'),(2,'课程机构'),(3,'讲师')),default=1,verbose_name='收藏类型')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '用户收藏'
        verbose_name_plural = verbose_name

class UserMessage(models.Model):
    user = models.IntegerField(default=0,verbose_name='接收用户')# 不用外键，因为有可能是发给所有人的消息，用0表示发送给所有人的消息,用int表示用户的id
    message = models.CharField(max_length=500, verbose_name='消息内容')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    has_read = models.BooleanField(default=False,verbose_name='是否已读')
    class Meta:
        verbose_name = '用户消息'
        verbose_name_plural = verbose_name

class UserCourse(models.Model):
    user = models.ForeignKey(UserProfile, verbose_name='用户')
    course = models.ForeignKey(Course, verbose_name='课程')
    add_time = models.DateTimeField(datetime.now, verbose_name='添加时间')
    class Meta:
        verbose_name = '用户课程'
        verbose_name_plural = verbose_name
```

### 将所有app放到同一个文件夹下面

建立new python package， 把所有的app放到apps这个包下面，注意选择不改相对引用，并mark apps为source root

将apps这个文件夹加入到settings当中

```python
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(BASE_DIR,'apps'))
```

### 建立后台管理系统

直接在run manage.py task中输入`createsuperuser`，输入用户名，邮箱和密码就可以登录

更改语言和时区：

```python
LANGUAGE_CODE = 'zh-hans'  #将语言改为中文
TIME_ZONE = 'Asia/Shanghai' #将时区改为上海
USE_TZ = False # 系统使用本地时间而不是utc时间
```

因为我们更改了admin的auth.user的model，因此需要注册user的model，在`users`库中的admin.py文件中注册：

```python
from users.models import UserProfile
# Register your models here.

class UserProfileAdmin(admin.ModelAdmin):  #userprofile的管理器
    pass

admin.site.register(UserProfile,UserProfileAdmin) #admin和model的关联注册
```

登录`http://127.0.0.1:8000/admin`就可以对用户进行修改

* pycharm全局搜索的快捷键是`ctrl+shift+f`

### 使用xadmin

使用xadmin，因为我安装的Django 2.0.1版本，所以需要安装专门的xadmin for Django2.0

```shell
pip install git+git://github.com/sshwsfc/xadmin.git@django2
```

在url.py中引入xadmin

```python
import xadmin
urlpatterns = [url(r'^xadmin/', xadmin.site.urls),]
```














