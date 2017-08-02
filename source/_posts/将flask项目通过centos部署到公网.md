---
title: 将flask项目通过centos部署到公网
date: 2017-08-02 14:09:47
tags: [flask]
category: [编程学习]

---

**基本的部署方式是通过Flaks + WSGI + Nginx**

首先通过远程连接到服务器

<!--more-->

```shell
ssh root@远程服务器ip  -p 远程服务器端口
```

输入密码之后进入远程服务器的操作

## 首先安装pip

获取`get-pip.py`文件

```shell
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
```

执行安装：

```shell
python get-pip.py
```

## 安装virtualenv

因为不同的项目可能需要不同的安装包的版本，所以我们往往不是直接在系统中安装Python的各种包，而是通过`virtualenv`建立虚拟的Python环境

首先通过pip安装virtualenv

```shell
pip install virtual
```

然后创建一个项目文件夹

```shell
mkdir my_web_app
cd my_web_app
```

在my_web_app文件夹中创建虚拟环境：

```shell
virtualenv venv
```

开启虚拟环境：

```shell
source ./venv/bin/activate
```

 *如果需要关闭虚拟环境*：`deactivate`

此时你的命令行在最前面多了一个`(venv)`的标志，证明你已经进入了虚拟环境

## 安装依赖库

要使用Flask框架写网页，就需要安装一系列跟Flask相关的库，此时可以使用`pip`命令的通过文件进行安装：

先建立一个requirements.txt，在其中写上需要安装的库的名称和版本号(版本号可以不写，默认安装最新版本)

```shell
$touch requirements.txt
$vim requirements.txt
```

在其中写入以下内容：

```python
Flask==0.10.1
Flask-Login==0.2.11
Flask-Mail==0.9.1
Flask-Moment==0.4.0
Flask-PageDown==0.1.5
Flask-SQLAlchemy==2.0
Flask-Script==2.0.5
Flask-WTF==0.10.2
Flask-Cache==0.13.1
Flask-Restless==0.15.0
Flask-Uploads==0.1.3
Jinja2==2.7.3
Mako==1.0.0
Markdown==2.5.1
MarkupSafe==0.23
SQLAlchemy==0.9.8
WTForms==2.0.1
Werkzeug==0.9.6
html5lib==1.0b3
itsdangerous==0.24
six==1.8.0
awesome-slugify==1.6
```

然后通过`pip`进行批量安装：

```
pip install -r requirements.txt
```

然后我们需要安装uSWGI，主要用于部署Flask项目：

```shell
pip install uSWGI
```

## 上传项目文件

项目文件的组织结构如下：

```
root/wz/
└── my_flask  
│   ├── logs
│   └── venv  //虚拟目录
│   │   ├── bin
│   │   │         ├── activate
│   │   │         ├── easy_install
│   │   │         ├── gunicorn
│   │   │         ├── pip
│   │   │         └── python
│   │   ├── include
│   │   │          └── python2.7 -> /usr/include/python2.7
│   │   ├── lib
│   │   │         └── python2.7
│   │   ├── local
│   │   │         ├── bin -> /home/shenye/shenyefuli/bin
│   │   │         ├── include -> /home/shenye/shenyefuli/include
│   │   │         └── lib -> /home/shenye/shenyefuli/lib
│   └── app  //Flask 程序目录
│   │           └──  __init__.py //这是程序包文件。这个目录下还有其它的文件此处略过
│   ├── manage.py   
│   ├── requirements.txt             
```

在app文件夹下的`__init__.py`文件进行修改，我们使用一个最简单的程序进行演示：

```python
from flask import Flask
 
app = Flask(__name__)
 
@app.route("/")
def hello():
    return "Hello World!"
```

然后在app的上一级文件夹建立`manage.py`文件用于运行程序

```python
from flask_script import Manager,Server
from app import app


manager = Manager(app)
manager.add_command('runserver',Server(host='0.0.0.0',port=5000,use_debugger=True))


if __name__ == '__main__':
    manager.run()
```

此时如果我们使用命令：

```shell
python manage.py runserver
```

已经可以运行在本地 `http://127.0.0.1:5000`

### 接下来开始配置uWSGI

uWSGI有两种启动方式，在这里我们选了通过配置文件启动的方法

在项目目录中新建config.ini，写入如下内容：

```
[uwsgi]

# uwsgi 启动时所使用的地址与端口
http = 0.0.0.0:8000

# 指向网站目录
chdir = /root/wz

home = /root/wz/venv

# python 启动程序文件
wsgi-file = manage.py

# python 程序内用以启动的 application 变量名
callable = app

# 处理器数
processes = 4

# 线程数
threads = 2

```

这里的8000就是我们外网访问时服务器监听的地址，由于我的路由器是搭在一个路由器下面的，此时我们需要登录路由器的设置界面设置端口转发：

![](http://ooi9t4tvk.bkt.clouddn.com/17-8-2/21096261.jpg)

填写内网ip地址和本地端口，以及需要映射到外网的端口，在项目中，我们把本地的8000端口映射为外网的6000端口

配置好端口之后，输入命令直接运行uWSGI：

```shell
uwsgi config.ini
```

到此为止，我们已经可以通过`服务器公网ip:6000`访问你的Flask应用

### 安装 Supervisor

[Supervisor|[http://supervisord.org/configuration.html](http://supervisord.org/configuration.html)]可以同时启动多个应用，最重要的是，当某个应用Crash的时候，他可以自动重启该应用，保证可用性。

```
sudo apt-get install supervisor
```

Supervisor 的全局的配置文件位置在：

```
/etc/supervisor/supervisor.conf
```

正常情况下我们并不需要去对其作出任何的改动，只需要添加一个新的 *.conf 文件放在

```
/etc/supervisor/conf.d/
```

下就可以，那么我们就新建立一个用于启动 my_flask 项目的 uwsgi 的 supervisor 配置 (命名为：my_flask_supervisor.conf)：

```
[program:my_flask]
# 启动命令入口
command=/home/www/my_flask/venv/bin/uwsgi /home/www/my_flask/config.ini

# 命令程序所在目录
directory=/home/www/my_flask
#运行命令的用户名
user=root
        
autostart=true
autorestart=true
#日志地址
stdout_logfile=/home/www/my_flask/logs/uwsgi_supervisor.log        
```

#### 启动服务

```
sudo service supervisor start
```

#### 终止服务

```
sudo service supervisor stop
```

## 安装 Nginx

[Nginx|[http://nginx.com/](http://nginx.com/)]是轻量级、性能强、占用资源少，能很好的处理高并发的反向代理软件。

```
sudo apt-get install nginx
```

### 配置 Nginx

Ubuntu 上配置 Nginx 也是很简单，不要去改动默认的 nginx.conf 只需要将

```
/ext/nginx/sites-available/default
```

文件替换掉就可以了。

新建一个 default 文件:

```
    server {
      listen  80;
      server_name XXX.XXX.XXX; #公网地址
    
      location / {
        include      uwsgi_params;
        uwsgi_pass   127.0.0.1:8001;  # 指向uwsgi 所应用的内部地址,所有请求将转发给uwsgi 处理
        uwsgi_param UWSGI_PYHOME /home/www/my_flask/venv; # 指向虚拟环境目录
        uwsgi_param UWSGI_CHDIR  /home/www/my_flask; # 指向网站根目录
        uwsgi_param UWSGI_SCRIPT manage:app; # 指定启动程序
      }
    }
```

将default配置文件替换掉就大功告成了！
还有，更改配置还需要记得重启一下nginx:

```
sudo service nginx restart
```



