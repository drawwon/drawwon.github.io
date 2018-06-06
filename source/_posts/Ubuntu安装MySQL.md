---
title: Ubuntu安装MySQL
date: 2018-06-05 16:54:53
tags: [Ubuntu,Linux]
category: [Linux]
---

首先执行下面三条命令：

```sh
sudo apt-get install mysql-server
sudo apt install mysql-client
sudo apt install libmysqlclient-dev123
```

<!--more-->　　

安装成功后可以通过下面的命令测试是否安装成功：

```sh
sudo netstat -tap | grep mysql1
```

出现信息证明安装成功

　可以通过如下命令进入mysql服务：

```sh
mysql -uroot -p你的密码
```

### 没有提示输入密码的情况

当在ubuntu中执行命令sudo apt-get install mysql-server5.1安装的时候居然没有提示我输入mysql的密码之类的信息，但是当安装好之后再终端中直接输入mysql的时候又能直接进入mysql中，为了解决ubuntu中mysql密码初始化的方法有一下两种：

1. 打开/etc/mysql/debian.cnf文件，在这个文件中有系统默认给我们分配的用户名和密码，通过这个密码就可以直接对mysql进行操作了。但是一般这个密码都比较怪，很长很长。
2. 当进入mysql之后修改mysql的密码：这个方法比较好，具体的操作如下用命令：`set password for 'root'@'localhost' = password('yourpass')`;当修改之后就可应正常对mysql进行操作了。

### 安装成功依然无法访问的情况

现在设置mysql允许远程访问，首先编辑文件`/etc/mysql/mysql.conf.d/mysqld.cnf`：

```sh
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```

注释掉bind-address = 127.0.0.1

保存退出，执行授权命令

```sh
grant all on *.* to root@'%' identified by '你的密码' with grant option;
flush privileges;
```

重启mysql

```sh
service mysql restart
```

之后用python访问mysql，需要安装`mysqlclient`，直接用`pip`安装一直报错，但是用conda安装即可

```sh
conda install mysqlclient
```