---
title: 鸟哥的Linux私房菜
date: 2017-08-03 17:33:34
tags: [Linux]
category: [编程学习]

---

Linux一个最重要的思维方式就是：一切的电脑硬件都是文件，比如硬盘一般在`/dev/hda`，而鼠标一般在`/dev/mouse`，所有配置的更改都是通过更改文件完成的

<!--more-->

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

### 更换Linux安装源

请使用root权限进行以下操作。

Ubuntu 的软件源配置文件是 /etc/apt/sources.list

选择你的ubuntu版本，以wily为例，查看系统版本可以通过`lsb_release -a`出来的code查看：

```
deb http://mirrors.xjtu.edu.cn/ubuntu/ wily main multiverse restricted universe
deb http://mirrors.xjtu.edu.cn/ubuntu/ wily-backports main multiverse restricted universe
deb http://mirrors.xjtu.edu.cn/ubuntu/ wily-proposed main multiverse restricted universe
deb http://mirrors.xjtu.edu.cn/ubuntu/ wily-security main multiverse restricted universe
deb http://mirrors.xjtu.edu.cn/ubuntu/ wily-updates main multiverse restricted universe
deb-src http://mirrors.xjtu.edu.cn/ubuntu/ wily main multiverse restricted universe
deb-src http://mirrors.xjtu.edu.cn/ubuntu/ wily-backports main multiverse restricted universe
deb-src http://mirrors.xjtu.edu.cn/ubuntu/ wily-proposed main multiverse restricted universe
deb-src http://mirrors.xjtu.edu.cn/ubuntu/ wily-security main multiverse restricted universe
deb-src http://mirrors.xjtu.edu.cn/ubuntu/ wily-updates main multiverse restricted universe
```

如果你使用的是wily以外的版本，将上述每一行的wily改为对应的发行版即可。

### 主题美化

ubuntu自带的主题简直不敢恭维，这里博主将它美化了一番，心情瞬间都好了一大截，码代码也会飞起！！先放一张我美化后的效果。

桌面和终端效果如下：

![桌面](https://ww4.sinaimg.cn/large/006tNbRwgy1feqx3t7l3yj311x0lbn8m.jpg)

#### unity-tweak-tool

调整 Unity 桌面环境，还是推荐使用Unity Tweak Tool，这是一个非常好用的 Unity 图形化管理工具，可以修改工作区数量、热区等。

```shell
sudo apt-get install unity-tweak-tool
```

安装完后界面如下： 

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-10/3219101.jpg)

#### Flatabulous主题

Flatabulous主题是一款ubuntu下扁平化主题，也是我试过众多主题中最喜欢的一个！最终效果如上述图所示。

执行以下命令安装Flatabulous主题：

```shell
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install flatabulous-theme
```

该主题有配套的图标，安装方式如下：

```
sudo add-apt-repository ppa:noobslab/icons
sudo apt-get update
sudo apt-get install ultra-flat-icons
```

安装完成后，打开unity-tweak-tool软件，修改主题和图标：

进入Theme，修改为Flatabulous

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-10/66962627.jpg)

在此界面下进入Icons栏，修改为Ultra-flat:

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-10/18289134.jpg)

到这里主题和图标都变为扁平化主题Flatabulous，看起来比较美观了，当然，还需要修改一些细节，例如终端的配色以及样式。

如果找不到主题就先注销重新登录就行了



#### 终端

终端采用zsh和oh-my-zsh，既美观又简单易用，主要是能提高你的逼格！！！

首先，安装zsh：

```
sudo apt-get install zsh11
```

接下来我们需要下载 oh-my-zsh 项目来帮我们配置 zsh，采用wget安装 

这里需要先安装[Git](http://lib.csdn.net/base/git)，而且要以管理员权限运行

`sudo apt-get install git`

`sudo wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`

所以这时的zsh 基本已经配置完成,你需要一行命令就可以切换到 zsh 模式，终端下输入以下命令

```
chsh -s /usr/local/bin/zsh11
```

最后，修改以下配色，会让你的终端样式看起来更舒服，在终端任意地方右键，进入配置文件(profile)->外观配置(profile Preferences)，弹出如下界面，进入colors一栏：

![配置](https://ww3.sinaimg.cn/large/006tNc79gw1fbkgfzl9e5j30go0bhgmk.jpg)

其中，文字和背景采用系统主题，透明度设为10%，下面的palette样式采用Tango，这样一通设置后，效果如下：

![终端](https://ww4.sinaimg.cn/large/006tNc79gw1fbkgfv3pu2j30ke0cyq37.jpg)

打开`~/.zshrc`，修改主题配置如下：

`ZSH_THEME="agnoster"`

`source ~/.zshrc`之后生效，此时有乱码，需要下载power字体

```shell
# clone
git clone https://github.com/powerline/fonts.git
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

然后打开terminal的preference选项，将字体设置为ubuntu powerline

此时所有的文件显示颜色都是灰色的，因此我们要安装

首先安装 [Git](http://lib.csdn.net/base/git)：`sudo apt-get install git-core`

然后要设一下 [solarized theme for GNU ls](https://github.com/seebi/dircolors-solarized)，不然在 Terminal 下 ls 啥的都灰蒙蒙的，也不舒服：

```
git clone git://github.com/seebi/dircolors-solarized.git
```

dircolor-solarized 有几个配色，你可以去项目那看看说明，我自己用的是 dark256：

```
cp ~/dircolors-solarized/dircolors.256dark ~/.dircolors
eval 'dircolors .dircolors'
```

设置 Terminal 支持 256 色，`vim .zsh` 并添加 `export TERM=xterm-256color`，这样 dircolors for GNU ls 算设置完成了。

接下来下载 Solarized 的 Gnome-Terminal 配色：

```
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git
```

`cd gnome-terminal-colors-solarized` 到该目录下运行配色脚本：`./set_dark.sh` 或`./set_light.sh`，这就算搞定了。



#### 字体

ubuntu自带的字体不太好看，所以采用文泉译微米黑字体替代，效果会比较好，毕竟是国产字体！

```
sudo apt-get install fonts-wqy-microhei11
```

然后通过unity-tweak-tool来替换字体：

![替换字体](https://ww2.sinaimg.cn/large/006tNc79gw1fbkgfy0a7ij30oh0i375e.jpg)

到此，主题已经比较桑心悦目了，接下来推荐一些常用的软件，提高你的工作效率！



### 常用软件安装

#### 安装搜狗输入法

首先从搜狗官网下载适用于ubuntu的输入法，执行`sudo dpkg -i sogoupinyin_2.1.0.0082_amd64.deb`安装，发现报错，这个时候进行修复安装，执行`sudo apt-get  install  -f` ，在运行一遍安装命令，` sudo dpkg -i sogoupinyin_2.0.0.0078_amd64.deb`，注销之后在系统输入法选项中选择fcit输入，就可以切换输入法了

#### 安装shadowsocks

用PIP安装很简单，

```
sudo apt-get update
sudo apt-get install python-pip
sudo apt-get install python-setuptools m2crypto

```

接着安装shadowsocks

```
pip install shadowsocks
```

如果是ubuntu16.04 直接 (16.04 里可以直接用apt 而不用 apt-get 这是一项改进）

```
sudo apt install shadowsocks
```

然后启动shadowsocks

```shell
sslocal -c /etc/shadowsocks.json
```

首先是安装polipo：

```
sudo apt-get install polipo
```

接着修改polipo的配置文件`/etc/polipo/config`：

```
logSyslog = true
logFile = /var/log/polipo/polipo.log

proxyAddress = "0.0.0.0"

socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5

chunkHighMark = 50331648
objectHighMark = 16384

serverMaxSlots = 64
serverSlots = 16
serverSlots1 = 32
```

重启polipo服务：

```
sudo /etc/init.d/polipo restart
```

为终端配置http代理：

```
export http_proxy="http://127.0.0.1:8123/"
```

接着测试下能否翻墙：

```
curl ip.gs
```

如果有响应，则全局代理配置成功。

#### 设置别名

bash中有一个很好的东西，就是别名alias. Linux用户修改~/.bashrc，Mac用户修改~/.bash_profile文件，增加如下设置

````
alias proxy="http_proxy=http://localhost:8123"
````

然后Linux用户执行`source ~/.bashrc`，注意在bash中执行上述命令只是本次有效，要一直生效需要修改~/.bashrc文件

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

### 使用man page

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

### 使用info page

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

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-4/62278292.jpg)

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
| 目录       | 应放置的文件内容                                 |
| -------- | :--------------------------------------- |
| `/bin`   | 系统中有很多放执行文件的目录，但是/bin比较特殊，因为/bin放置的是在单用户模式下还能被操作的命令/在/bin下面的命令可以被root和一般用户使用，主要有cat，chmod，chown，date，mv，mkdir，cp，bash等常用的命令 |
| `/boot`  | 这个目录主要在放置开机会使用到的文件，包括Linux内核文件以及开机菜单与开机所需配置文件等，Linux kernel 常用的文件名为vmlinuz，如果使用grub这个引导装在程序，还会存在`/boot/grub`这个目录 |
| `/dev`   | 在linux系统上，任何设备与接口设备都是以文件的形式存在于这个目录的，你只要通过访问这个目录下的某个文件，就等于访问某个设备。比较重要的文件有`/dev/null`，`/dev/zero`，`/dev/ tty`，`/dev/ lp*`，`/dev/hd*`,`/dev/sd*` |
| `/etc`   | 系统主要的配置文件几乎都放置在这个目录中，例如人员的账户密码文件 ，各种服务的起始文件等。一般来说，这个目录下的个文件属性是可以让一般用户查阅的，但是只有root有修改权限，FHS建议不要放置可执行文件（binary）在这个目录红，比较重要的文件有`/etc/inittab`，`/etc/init.d`，`/etc/modprobe.conf`，`/etc/X11`，`/etc/fstab`，`/etc/sysconfig`等。另外，其下还有几个比较重要的目录：1. `etc/init.d`：所有服务的默认启动脚本都是放在这里的，例如要启动或者关闭iptables的话，`/etc/init.d/iptables start`，`/etc/init.d/iptables stop`。2.`etc/xinetd.d`：这就是所谓的superdaemon管理的各项服务的配置文件目录。3. `/etc/X11`：与X window相关的各种配置文件都在这里，尤其是xorg.conf这个XServer的配置文件 |
| `/home`  | 这是系统默认的用户主文件夹（home dictionary）。在你创建一个一般用户账号时，默认的用户主文件夹都会规范到这里来。比较重要的是，主文件夹有两种代号，～：代表目前这个用户的主文件夹，～dmtsai：则代表dmtsai的主文件夹 |
| `/lib`   | 系统的函数库非常多，而/lib库放置的则是在开机时会用到的函数库，以及在/bin或/sbin下面的命令会调用的函数库而已。尤其重要的是`/lib/modules/`这个目录，该目录会防止内核相关的模块（驱动程序） |
| `/media` | 放置可删除的设备，包括软盘，光盘dvd都放在这里                 |
| `/mnt`   | 暂时挂在某些额外设备，简易房知道这么目录中                    |
| `/opt`   | 这是给第三方软件放置的目录，不过还是习惯放置于`/usr/local`之中    |
| `/root`  | 系统管理员root的主文件夹                           |
| `/sbin`  | /sbin中包含了开机、修复、还原系统所需的命令。                |
| `/srv`   | srv可以看做service的缩写，是一些网络服务启动后，这些服务所需取用的数据目录，如www服务或者是ftp服务 |
| `/tmp`   | 让一般用户或者是正在执行的程序暂时放置文件的地方                 |

除了上述目录，Linux中还有一些目录需要了解：
| 目录          | 放置内容                                     |
| ----------- | ---------------------------------------- |
| /lost+found | 放置系统发生错误时丢失的片段                           |
| /proc       | 本身是一个虚拟文件系统，所有文件都在内存中，主要是 系统内核、进程、外部设备的状态及网络状态等。重要文件有/proc/cpuinfo，proc/dma，/proc/interrupts，/proc/ioports，/proc/net/* |
| /sys        | 与/proc很像，记录内核先关信息，包括目前已加载的内核模块与内核监测到的硬件设备信息等等 |

/usr目录是Linux中重要的一个目录，其是Unix software resource的缩写，所有软件都会放到该目录下，其重要的文件夹如下

| 目录         | 放置的文件内容                             |
| ---------- | ----------------------------------- |
| /usr/X11R6 | x widow的放置目录                        |
| /usr/bin   | 大多用户可以使用的命令都在这里                     |
| /usr/local | 系统管理员在本集下载的第三方软件                    |
| usr/sbin   | 非系统正常运行所要的系统命令，比如网络服务器的服务命令         |
| /usr/share | 放置共享文件                              |
| /usr/src   | 源码一般放在这里，比如Linux的源码放在/usr/src/Linux |

/var主要放置缓存以及一些日志文件

### 查看Linux内核版本

主要有两条命令可以查看Linux的版本

```shell
$ uname -a
$ lsb_release -a
```

## Linux目录管理

### 目录相关操作

* cd命令：change dictionary

```shell
cd ～  #打开用户主目录
cd -  #打开上一个打开的目录
```

* pwd命令：显示当前文件夹，Print Working Dictionary
* mkdir命令：make dictionary，创建文件夹
* rmdir：删除空目录， [-p]连同上级的空文件夹一起删除

### 执行文件路径变量：$PATH

打印出文件路径变量：

```shell
echo $PATH
```

这个路径变量由一堆目录组成，每个目录中间永冒号来隔开

要想把一个新的路径加入PATH

```shell
PATH="$PATH":/dictionary_you_want_to_add
```

### 文件目录相关操作

* ls：查看文件与目录，ls列出来的蓝色字体的是文件夹，绿底蓝字的表示others拥有write权限的文件夹
* cp：复制文件，复制文件夹时要加-r，若目标文件已存在，覆盖式先询问是否进行操作加-i
* mv：移动文件或用于重命名
* rm：删除文件，-i询问是否删除，-f强制删除，-r递归删除文件夹
* basename：取得该文件的目录名/文件名
* dirname：取得上层目录名

### 文件内容查阅

* cat：从第一行开始显示文件内容
* tac：从最后一行开始显示文件内容，tac是cat的倒写形式
* nl：显示的时候顺便输出行号，是numberline的缩写
* more：一页一页的显示文件内容
* less：与more类似，但是比more刚好的是，它可以向前翻页
* head：只看头几行
* tail：只看结尾几行
* od：以二进制方式读取文件内容
* touch：创建新文件或者修改文件时间（atime（access）：访问时间，ctime（status）：状态改变时间，mtime（modified）：内容修改时间）

### 文件目录的默认权限与隐藏权限

* umask：查看默认建立文件的权限，显示的四位数字的后三位表示被拿掉的权限，比如显示0022，表示权限为rwxr-x
* lsattr：显示文件的隐藏属性
* chattr：改变文件的隐藏属性，+i表示不可以被改变，移动或删除

查看文件类型的操作命令：file

### 命令与文件查询

* which：寻找可执行文放在哪里（在$PATH的路径下找）
* whereis：利用系统的数据库查找特定文件
* locate：-i忽略大小写，-r可以接正则表达式的形式，从系统的数据库/var/lib/mlocate中查找数据，这个数据库每天更新一次，可以通过updatedb进行手动更新
* find：直接在硬盘上查找文件

## Linux文件系统

每个文件有inode和block以及superblock三块

`inode`用来存放文件的属性以及文件数据所在的block号码

`block`用来存放实际的文件内容，若数据太大，则会占用多个block

`superblock`：记录文件的整体信息，包括inode/block 的总量，使用量，剩余量，以及文件系统的格式与相关信息等

`df`：display the amount of disk space available，展示挂载磁盘的可用空间

`dumpe2fs`：dump ext2/ext3/ext4 filesystem information

### 磁盘与目录容量

`df`：列出文件系统的整体磁盘使用量，-h：以人们比较容易阅读的GB，MB，KB等单位进行显示

`du`：评估文件系统磁盘使用量，在不加参数时默认列出的是当前目录的磁盘使用量

### 连接文件：ln

有两种连接方式，分别是硬连接（hard link，也称实际连接），和符号链接

#### 硬连接

实际上就是多个文件名指向同一个inode，这种连接方式不支持**跨文件系统**的连接，也**不能连接到目录**，因为如果连接到目录，会使得目录下属的所有文件都产生连接，复杂度过高

#### symbolic link（符号连接）

创建一个独立的文件，这个文件让数据的读取指向它连接的那个文件的文件名，symbolic可以和Windows的快捷方式划等号，唯一的不同是在你修改链接文件时，源文件也会随之改变

执行连接操作的指令是

```shell
ln source destination # 硬连接
ln -s source destination # 符号连接
```

## 磁盘操作

* 磁盘分区管理：`fdisk`，然后按m查看命令帮助，以便进行分区或者是删除新增分区
* 磁盘格式化：`mkfs`：make file system，具体的使用方法是`mkfs [-t 文件系统格式] 设备文件名`
* 更加详细的磁盘格式化命令：`mke2fs [-b block大小] [-i inode大小] [-L 卷标] [-cj] 设备`，-c检查磁盘错误，-j表示ext3格式
* 磁盘检验：`fsck`，一般只有在系统出现极大问题时才使用这个命令，正常使用系统时使用这个命令会破坏系统文件
* 挂载硬盘：`mount`，-a挂载所有为挂载的磁盘
* 卸载：umount
* 修改卷标：e2label

### 设置开机挂载

在`/etc/fstab`里设置，根目录/必须最先被挂载

### 挂载镜像文件

比如你要挂载centos5.2的安装镜像到/mnt/centos_dvd这个文件夹，可以使用如下命令

`linuxmount -o loop /root/centos5.2_x86_64.iso /mnt/centos_dvd`

### 创建无内容的大型文件

使用dd命令，`if`表示input file，`of`表示output file，`bs`表示block size，count表示有多少个block

```
dd if=/dev/zero of=/home/loopdev bs=1M count=512
```

### 交换空间swap

分出一块单独的硬盘之后，或者使用dd命令得到一个文件之后，格式化，使用mkswap命令将文件格式化为swap格式，可以使用swapon命令建立swap

## 文件压缩与打包

文件压缩常有两种形式，第一种是通过压缩为0的bit，第二种是通过压缩诸如100个1连在一起的情况

常用的压缩命令有

* `gizp`：默认模式是进行压缩文件，-d解压文件，-v表示冗长模式打印出所有信息
* `tar`
  压缩： tar -jcvf 新建的文件名 需要打包的文件
  解压缩： tar -jxvf 文件名 -C 欲解压缩的目录

### dump文件系统备份

dunp：对系统进行备份的命令

从备份的文件进行恢复：restore

### 光盘写入工具

mkisofs：新建镜像文件

cdrecord：光盘刻录工具

## vim编辑器

vi常用移动快捷键，如果想要进行多次移动，例如向下移动30行，只需要输入`30j`

| 快捷键                  | 移动光标方法             |
| -------------------- | ------------------ |
| h或左箭头($\leftarrow$)  | 向左移动一个字符           |
| l或右箭头($\rightarrow$) | 向右移动一个字符           |
| j或下箭头($\downarrow$)  | 向下移动一个字符           |
| k或上箭头($\uparrow$)    | 向上移动一个箭头           |
| `ctrl+f`（front的意思）   | 向上翻动一页             |
| `ctrl+b`(blow的意思)    | 向下翻动一页             |
| `ctrl+d`（down的意思）    | 向下移动半页             |
| `ctrl+u`（up的意思）      | 向上移动半页             |
| +                    | 移动到非空格符的下一行        |
| -                    | 移动到非空格符的上一行        |
| n+空格                 | 向右移动这一行的n个字符       |
| 0或者home              | 移动到这一行最前面          |
| $或end                | 移动到这一行的结束          |
| H（Head）              | 移动到这个屏幕上方那一行的第一个字符 |
| M（Middle）            | 移动到屏幕中央那一行         |
| L（Last）              | 以调动到屏幕最下方那一行       |
| G                    | 移动到这个文件的最后一行       |
| nG                   | n为数字，移动到这个文件的第n行   |
| gg                   | 移动到文件的第一行          |
| n+回车                 | 向下移动n行             |

查找、替换快捷键：

| /word                 | 下下搜索word字符串                              |
| --------------------- | ---------------------------------------- |
| ？word                 | 向上搜索word字符串                              |
| n                     | 查找下一个                                    |
| N                     | 查找上一个                                    |
| :n1,n2s/word1/word2/g | 在n1到n2之间查找word1字符串并替换为word2，s/表示开头start，/g表示结尾 |
| ：1，$s/word1/word2/g   | 从第一行到最后一行查找字符串word1并替换为word2             |
| :1,$s/word1/word2/gc  | 从第一行到最后一行查找字符串word1并替换为word2，替换前提示，c表示confirm |

删除复制和粘贴

| x，X           | x向后删除一个字符，X向前删除一个字符     |
| ------------- | ----------------------- |
| nx            | n为数字，连续向后删除n个字符         |
| dd            | 删除光标所在那一行               |
| ndd           | 删除光标所在行的下n行             |
| d1G           | 删除光标坐在到第一行的所有数据         |
| dG            | 删除光标所在到最后一行的数据          |
| d$            | 删除光标所在处到该行的最后一个字符       |
| d0            | `删除光标所在处到改行的最前面一个字符     |
| yy            | 复制光标所在行                 |
| nyy           | 复制光标坐在的向下n行             |
| y1G           | 复制光标所在行到第一行             |
| yG            | 复制光标所在行到最后一行            |
| y0            | 复制光标所在地方到该行行首           |
| y$            | 复制光标所在位置到该行末            |
| p，P           | p将已复制数据在下一行粘贴，P表示粘贴在上一行 |
| u             | 复原前一个操作                 |
| `ctrl+r`或者`.` | 重复上一个操作                 |

模式切换：

| i，I  | i从目前光标所在处插入，I在目前行的第一个非空字符处开始插入           |
| ---- | ---------------------------------------- |
| a，A  | a从光标所在处下一个字符开始插入，A从光标所在行最后一个字符处插入        |
| o，O  | o从光标所在处下一行开始插入，O从光标所在处上一行插入              |
| r，R  | r替换光标所在的哪一个字符一次，R一只替换光标所在的文字，直到按下`Esc`为止 |

命令行模式

| ：w                    | 将数据写入硬盘（保存）            |
| --------------------- | ---------------------- |
| ：w！                   | 强制保存                   |
| ：q                    | 退出vi                   |
| ：q！                   | 强制退出vi（不保存）            |
| ：wq                   | 保存并退出                  |
| ZZ                    | 文件没变动则直接离开，变动过则保存后离开   |
| ：w [filename]         | 将编辑的数据保存成另一个文件         |
| ：r [filename]         | 将filename的内容加到光标所在地的后面 |
| ：n1，n2  w  [filename] | 将n1到n2行的内容保存成新文件       |
| ：！command             | 暂时离开vi执行command        |
| set nu                | 显示行号                   |
| set nonu              | 隐藏行号                   |

在操作时按下`ctrl+z`可以使得vim临时在后台运行，用vim打开文件时，vim会自动在当前文件夹创建一个swp文件，用于记录用户对文件的操作，用于在系统一场崩溃或者是断电时对文件进行恢复，再次打开文件时会提示进行恢复或者是删除swp文件，按r进行恢复，按a或者q退出操作，按d删除暂存文件

### 块选择

块选择，类似于sublime里面的多行选择，按下`ctrl+v`进入快选择，选择好之后按y进行复制

### 多文件同时编辑

vim 后面接多个文件的名字，然后`：n`编辑下一个文件，`：N`编辑上一个文件，`：files`列出目前这个vim打开的所有文件

### 多窗口功能

在vim命令行模式下输入：sp，split的缩写，可以打开在新窗口中当前文件，split [filename]在新窗口打开新的文件

利用`ctrl+w+`$\uparrow$进入上面的窗口，`ctrl+w+`$\downarrow$进入下面的窗口

## bash和shell

shell：能够操作应用程序的接口都称之为shell

alias：设置命令别名，使用方法：alias new_com,man="old"

echo：用于显示变量，在变量名之前要加上$

### 变量

设置变量：直接用等号连接，不能加空格，变量名只能是英文字母或者数字，且开头不能是数字

变量如果需要增加内容：如PATH=$PATH:/home/bin

大写字符一般为系统变量，自己设置的字符一般用小写表示

特殊字符要转义，比如引号和空格号

取消变量的方法为：unset 变量名

### 环境变量

环境变量存储在env当中，可以直接在bash中输入env进行查看

其中的random是用于显示一个0~32767的随机数的，如果你想要一个0-9的随机数，可以使用`declare -i number=$RANDOM*10/32768;echo $number`

用set可以查看所有变量

export：将自定义变量引入环境变量，环境变量=全局变量，自定义变量=局部变量

查看当前系统支持的语系：locale -a

### 来自键盘的变量、数组与声明：read、array、declare

要读取来自键盘的变量，使用read： -p 后面可以接提示符，-t后面可以接等待的秒数

declare：声明变量类型，declare [-aixr] variable，-a设置成array，-i设置为integer，-x与export功能相同，把变量设置为环境变量，-r设置为只读类型，不能变更或unset

变量数组的设置：var[1]="var 1"，读取的时候，需要通过echo ${var[1]}，注意是\$加上大括号

### ulimit

ulimit可以限制用户使用的内存大小，cpu时间以及同时打开的文件数量等等

### 更改、删除变量

使用“${PATH#/usr/bin}”来删除变量内容，一个#表示删除符号替换文字的最短的哪一个（非贪婪匹配），两个##表示符合替换文字的最长的哪一个（贪婪匹配）

从后面开始删除是“${PATH%:*/bin}”，同样一个%是非贪婪的删除，两个%是贪婪删除，%后面的内容是正则表达式

替换字符串：${PATH/old/new}，一个`/`表示替换第一个旧字符串，两个`/`表示全部替换

如果变量不存在则替换：`a=${username:-root}`，:-root的意思就是如果username不存在那么就把a赋值为root，`：`的作用就是在username如果一开始就被赋值为空字符串的时候也可以用root替换

### 设置命令别名

alias：用法，`alias lm=“ls -l|more”`

取消别名：`unalias xxx`

### 历史命令

使用history可以列出历史命令

使用`！command`可以执行历史记录里面以command开头的命令

使用`！！`执行上一条命令

使用`！65`，执行历史记录里面的第65条指令

### 设置终端机

stty -a：表示set tty，-a列出所有的内容

`^`表示`ctrl`的意思

eof：表示end of file

erase：向后删除字符

intr：interrupt，终端

kill：删除目前命令行上的所有文字

quit：发出一个退出信号给正在运行的程序

susp：推送一个terminal stop信号给正在运行的程序

此外，我们还可以通过set来查看其他设置，`$-`这个变量包含了所有的set设置值

### 标注输入输出流

1. 标准输入stdin：代码为0，使用`<`或`<<`
2. 标准输出stdout：代码为1，使用`>`或`>>`
3. 标准错误输出：代码为2，使用`2>`或者`2>>`

输出标准输出和错误输出到同一个文件：`find /home -name .bashrc > list 2>&1`

`<<`的作用是利用右侧的控制字，直到输入右侧的控制字之后自动退出输入，且文件中不会有右侧控制字那一行

### 多命令同时执行

`；`执行两个没有相关性的命令

`cmd1&&cmd2`：若cmd1执行完毕且正确执行就继续执行cmd2

`cmd1||cmd2`：若cmd1执行正确则cmd2不执行，若cmd1执行错误则执行cmd2

管道命令

`|`：接受stdout的信息

### 选取命令cut，grep

cut：类似于Python中的split，-d后接用于分离的字符串，-f表示去除第几个

grep：分析一行的信息，如果该行有我们需要寻找的信息，那么就将该行拿出来`grep [-acinv]  '查找的字符串' filename`

### 排序命令

`sort [-fbmnrtuk] [file or stdin]`：对文件或者stdin进行排序

`uniq`：重复的数据只显示一个，类似与Python的set

wc：字数统计

双向重定向命令：tee，既输出到屏幕，又输出到文件

### 字符转换命令

tr（translate or delete characters）：-d删除文字，-s替换文字

col：-x将tab换成对等的空格键，-b文字内有反斜杠`/`时，仅显示反斜杠后接的那个字符

join：将两个文件中有相同数据的一行放到一起

paste：直接将两个文件粘到一起，且中间以[tab]隔开

expand：将tab转换为空格键

split：切割，将文件分割成多个大小相等的文件

xargs：在不支持管道命令的命令中提供参数

## 正则表达式

正则表达式依照不同的严谨度分为基础正则表达式与扩展正则表达式

### 基础正则表达式

| 符号           | 含义                                       |
| ------------ | ---------------------------------------- |
| `[:alnum:]`  | 英文大小写字母及数字，`[a-z]`、`[A-Z]`、[0-9](alpha，number) |
| `[:alpha:]`  | 大小写英文字母                                  |
| `[:blank:]`  | 空格键与tab键                                 |
| `[:cntrl:]`  | 键盘上面的控制键位，包括CR,TF,TAB,DEL等               |
| `[:digit:]`  | 数字，[0-9]                                 |
| `[:graph:]`  | 除了空格键和[TAB]键的其他所有按键                      |
| `[:lower:]`  | 小写字母，[a-z]                               |
| `[:upper:]`  | 大写字母，[A-Z]                               |
| `[:print:]`  | 任何可以被打印出来的字符                             |
| `[:punct:]`  | 标点符号(punctuation symbol)                 |
| `[:space:]`  | 任何会产生空白的字符，包括空白键[TAB]CR等                 |
| `[:xdigit:]` | 十六进制的数字类型                                |

[^]表示取反，

^是行首，

$表示行尾，

*出现任意次，

`\{m,n\}`出现m到n次(注意`{}`要进行转义)，

[abc]，从abc当中选一个

[^list]：选取除了list以外的字符串

### 扩展正则表达式

| 字符   | 意义                                       |
| ---- | ---------------------------------------- |
| +    | 重复一次及多次                                  |
|      | 零个或一个                                    |
|      | 用or的方法进行查找                               |
| （）   | 找出组字符串,比如查找good和glad，可以用`egrep -n 'g(oo|la)d' test.txt`进行查找 |
| （）+  | 多个重复组的判断，比如查找A12121212c，可以用`egrep -n 'A(12)+c'` |

### 文件格式化打印

使用的是printf，用法如下：

```shell
printf '%10s\t %5i\t %s\t \8.2f' $(cat test.txt)
```

### 数据处理工具awk

用法

```shell
awk '条件类型1{动作1} 条件类型2{动作二}……'
```

比如要取出last里面的第一列和第三列

```shell
last -n 5 | awk 'print $1 "\t" $3'
```

### 文件比较工具

`diff  a b`，得到的是左边文件a与右边文件b的差别

cmp：以字节进行比较

patch：`diff a b> ab.patch`得到一个补丁文件，用于存放新旧文件的不同，用`patch -pN < patch_file`更新，用`patch -R -pN < patch_file`还原

## shell script

终于到了shell script这一个章节了，shell script是程序化脚本











