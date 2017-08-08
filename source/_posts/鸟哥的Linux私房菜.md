---
title: 鸟哥的Linux私房菜
date: 2017-08-03 17:33:34
tags: [Linux]
category: [编程学习]

---

Linux一个最重要的思维方式就是：一切的电脑硬件都是文件，比如硬盘一般在`/dev/hda`，而鼠标一般在`/dev/mouse`，所有配置的更改都是通过更改文件完成的

## 安装Ubuntu16.04

学习Ubuntu当然需要先安装一个原生的Ubuntu，在vmware中的Ubuntu始终还是有些问题，从[西安交大镜像源](http://mirrors.xjtu.edu.cn/ubuntu-releases/16.04.2/ubuntu-16.04.2-desktop-amd64.iso)下载安装文件`ubuntu-16.04.2-desktop-amd64.iso` 

在Windows系统中，首先为Ubuntu分出一定大小的磁盘空间，我们使用win7自带的管理工具：右键我的电脑，点击管理->磁盘管理->选择一个还有剩余空间的磁盘->选择压缩卷->输入需要的磁盘空间大小，因为只是用于学习Linux以及一些简单的开发，我们选择磁盘大小为50GB，不需要分配磁盘符

![](https://support.microsoft.com/Library/Images/2499084.png)

接下来，制作u盘启动盘，使用一个内存大于2gb的u盘，使用`win32diskimager`软件进行u盘的刻录，刻录时会清空u盘内容，请提前备份u盘

制作完成之后重启电脑，按F12或者F10进入BIOS，选择启动顺序为u盘启动，保存并退出BIOS，进入Ubuntu的安装界面

选择语言，选择地区之后，选择之后安装ubuntu更新，安装方式选择其他，对50G硬盘进行划分，首先划分出45G挂载`/`目录，然后选择4G作为swap分区，然后选择500M挂载`/boot`分区，boot分区主要是用于Linux的启动引导

等待安装完成，重启系统进入了Linux系统的引导界面，但是此时并没有Windows的引导，因此我们需要登录Linux系统执行如下命令找到Windows的引导：

```shell
    4  sudo updata-grub
```

同时，我们看到Windows的启动项在最后面，我们需要设置默认的启动顺序是Windows，然后是Linux，因此我们打开`/boot/grub/grub.conf`进行顺序修改，将其中的defalut启动项设置为4（第一个为0，后面依次加1）

```shell
cd /boot/grub/
vim grub.conf
```

至此，我们完成了Linux的安装，接下来安装部分Linux常用软件

## Linux常用软件安装及优化

### 系统清理篇

#### 系统更新

安装完系统之后，需要更新一些补丁。Ctrl+Alt+T调出终端，执行一下代码：

```
sudo apt-get update 
sudo apt-get upgrade
```

#### 卸载libreOffice

libreoffice事ubuntu自带的开源office软件，体验效果不如windows上的office，于是选择用WPS来替代（wps的安装后面会提到）

```
sudo apt-get remove libreoffice-common  
```

#### 删除Amazon的链接

```
sudo apt-get remove unity-webapps-common 
```

#### 删除不常用的软件

```
sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot 
sudo apt-get remove gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install  

sudo apt-get remove onboard deja-dup 
```

做完上面这些，系统应该干净了，下面我们来安装一些必要的软件。

### 常用软件安装

#### 安装搜狗输入法

首先从搜狗官网下载适用于ubuntu的输入法，执行`sudo dpkg -i sogoupinyin_2.1.0.0082_amd64.deb`安装，发现报错，这个时候进行修复安装，执行`sudo apt-get  install  -f` ，在运行一遍安装命令，` sudo dpkg -i sogoupinyin_2.0.0.0078_amd64.deb`，注销之后在系统输入法选项中选择fcit输入，就可以切换输入法了

#### chrome安装

打开终端，

输入`   sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/`，

然后继续输入`wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -`，

再更新apt-get，`sudo apt-get update`，

再执行`sudo apt-get install google-chrome-stable`，

下载完成后输入`/usr/bin/google-chrome-stable`即可打开chrome

####  Pycharm安装

从官网下载压缩包，(1)到官网下载安装包

(2)到下载目录下进行解压

```shell
$ cd Downloads/
$ tar xfz pycharm-*.tar.gz
```

​      (3)运行解压后的文件夹中的bin目录下的pycharm.sh文件

```shell
$ cd pycharm-community-3.4.1/bin/
$ ./pycharm.sh
```

#### 安装typora

按照官网教程安装，不详细说明

## 使用帮助文档

Linux的指令都是command + option + parameter1 + parameter2的模式

#### 使用man page

在遇到我们不知道怎么用的指令的时候，可以求助于man page，man是manual的简称，以为操作说明，比如我们输入`man date `，系统就弹出对于date这个指令的解释，其中有一个“DATE（1）”，括号里面的1表示命令的类型，比如1表示用户在shell环境中可以在操作的命令或可执行文件，2表示用户内核可调用的函数与工具等等，一共有9个类

|  代号  | 代表内容                                     |
| :--: | :--------------------------------------- |
|  1   | 普通的命令─在shell中执行的命令                       |
|  2   | 系统调用─关于核心函数的文档                           |
|  3   | 库调用─libc函数的使用手册页，如printf,fread           |
|  4   | 特殊文件─关于/dev目录中的文件的信息                     |
|  5   | 文件格式─/etc/passwd和其他文件的详细格式               |
|  6   | 游戏：给游戏留的,由各个游戏自己定义                       |
|  7   | 宏命令包─对Linux文件系统、使用手册页等的说明。还有一些变量,比如向environ这种全局变量在这里就有说明 |
|  8   | 系统管理─根操作员操作的使用手册页，这些命令只能由root使用,如ifconfig |
|  9   | 核心例程─关于Linux操作系统内核源例程或者内核模块技术指标的文档       |

man page一般由以下几个部分组成：

| 代号          | 内容说明                        |
| :---------- | :-------------------------- |
| NAME        | 简短的命令、数据名称说明                |
| SYNOPSIS    | 简短的命令执行语法（syntax）介绍         |
| DESCRIPTION | **较为完整的说明，这部分最好仔细看看**       |
| OPTIONS     | 针对SYNOPSIS部分中，有列举的所有可用的选项说明 |
| FILES       | 这个程序或数据所使用或参考或连接到的某些文件      |
| SEE ALSO    | 这个命令或数据有相关的其他说明             |
| EXAMPLE     | 一些可以参考的范例                   |
| BUGS        | 相关的错误                       |

<font color="red">**通常查询一个命令的方法如下**</font>

1. 先查看NAME部分，了解这个指令的含义
2. 再仔细看一下DESCRIPTION，这个部分会提到很多相关的资料和用法，从这个地方可以学到很多小细节
3. 如果你已经对这个命令很熟悉了，那么主要查询的就是OPTIONS的部分，可以知道每个选项的意义
4. 最后看一眼SEE ALSO
5. 某些内容还会列举FILES供使用者参考

输入`/`就可以进行向下字符串查找，按n可以查询下一个，按N查询上一个，`?string`进行向上字符串查找，空格键向下翻一页，[home]去往第一页，[end]去往最后一页，[page up]向上一页，[page down]向下一页，按q就可以离开当前页面

#### 使用info page

info和man用途差不多，都是用来查询某个指令的用法，但是info类似于网页超链接的形式，跳转到各个具体的节点页面下，每个页面称之为一个节点

使用info时有如下快捷键：

| 按键          | 主要内容                   |
| :---------- | :--------------------- |
| 空格键         | 向下翻一页                  |
| [page down] | 向下翻一页                  |
| [page up]   | 向上翻一页                  |
| [tab]       | 在节点之间移动                |
| [enter]     | 当光标在节点之上时，按下enter进入该节点 |
| B           | 移动光标到该info界面中第一个节点处    |
| E           | 移动光标至最后一个节点处           |
| N           | 前往下一个节点                |
| P           | 前往上一个节点                |
| U           | 向前移动一层                 |
| S（/）        | 在info page中进行查询        |
| H           | 显示求助菜单                 |
| ？           | 命令一览表                  |
| Q           | 结束这次的info page         |

## Linux文件属性

使用`ls -al`列出文件的信息，看到文件属性这一列一共有10个字母，第一个字母表示文件类型，1-3表示文件所有者的权限，4-6表示用户所属用户组的权限，7-9表示其他人对此文件的权限

![](http://ooi9t4tvk.bkt.clouddn.com/17-8-4/62278292.jpg)

第一个字符表示对是这个文件是“目录、文件或链接文件等”“

1. `[d]`表示目录
2. `[-]`表示文件
3. `[|]`表示连接文件(linkfile)
4. `[b]`表示可供存储的接口设备
5. `[c]`表示设备文件里面的串行端口设备，例如键盘鼠标等

接下来的字符每3个一组，`r`代表可读，`w`代表可写，`x`代表可执行，`-`表示没有权限

第二大列表示的是这个文件有多少个连接到这个文件的链接

第三大列表示的是文件的所属用户

第四大列表示的是文件所属的用户组

第五大列表示文件的大小，默认的单位是B

第六列为文件的创建日期或者是最近的修改日期

第七列为文件名，如果文件名以"."开头，那么这个文件就是隐藏文件

### 改变文件属性与权限

* chgrp：改变文件所属用户组
* chown：改变文件所有者
* chmod：改变文件的权限

上述三个指令的具体用法可以查看man page或者是--help，具体不赘述

### Linux目录配置

为了对Linux的文件系统能够更好的管理和利用，所有Linux系统都醉寻FHS标准（Filesystem Hierarchy Standard），主要目的是让用户可以了解到已安装软件通常放在那个目录下

其主要的规定如下：

`/`:与开机系统有关

`/usr`：与软件安装/执行有关

`/var`：与系统运作过程有关

FHS标准定义出根目录`/`应该含有如下子目录“

| 目录    | 应放置的文件内容                                 |
| ----- | ---------------------------------------- |
| /bin  | 系统中有很多放执行文件的目录，但是/bin比较特殊，因为/bin放置的是在单用户模式下还能被操作的命令/在/bin下面的命令可以被root和一般用户使用，主要有cat，chmod，chown，date，mv，mkdir，cp，bash等常用的命令 |
| /boot | 这个目录主要在放置开机会使用到的文件，包括Linux内核文件以及开机菜单与开机所需配置文件等，Linux kernel 常用的文件名为vmlinuz，如果使用grub这个引导装在程序，还会存在/boot/grub这个目录 |
| /dev  | 在linux系统上，任何设备与接口设备都是以文件的形式存在于这个目录的，你只要通过 |
|       |                                          |
|       |                                          |
|       |                                          |

|