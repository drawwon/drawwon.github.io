---
title: Ubuntu彻底删除软件包
mathjax: true
date: 2018-08-22 23:58:16
tags: [Ubuntu,Linux]
category: [Linux,Ubuntu]
---

在删除apt安装的软件过程中，如果直接用apt remove，那么只是删除了软件本身，但是没有删除相关的配置，要删除相关的配置，就要用apt purge

<!--more-->

**下面是详细的apt相关的卸载方法**

apt-get的卸载相关的命令有remove/purge/autoremove/clean/autoclean等。具体来说：

**apt-get purge / apt-get --purge remove** 
删除已安装包（不保留配置文件)。 
如软件包a，依赖软件包b，则执行该命令会删除a，而且不保留配置文件

**apt-get autoremove** 
删除为了满足依赖而安装的，但现在不再需要的软件包（包括已安装包），保留配置文件。

**apt-get remove** 
删除已安装的软件包（保留配置文件），不会删除依赖软件包，且保留配置文件。

**apt-get autoclean** 
APT的底层包是dpkg, 而dpkg 安装Package时, 会将 *.deb 放在 /var/cache/apt/archives/中，apt-get autoclean 只会删除 /var/cache/apt/archives/ 已经过期的deb。

**apt-get clean** 
使用 apt-get clean 会将 /var/cache/apt/archives/ 的 所有 deb 删掉，可以理解为 rm /var/cache/apt/archives/*.deb。

------

那么如何彻底卸载软件呢？ 
具体来说可以运行如下命令：

```
# 删除软件及其配置文件
apt-get --purge remove <package>
# 删除没用的依赖包
apt-get autoremove <package>
# 此时dpkg的列表中有“rc”状态的软件包，可以执行如下命令做最后清理：
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P123456
```

当然如果要删除暂存的软件安装包，也可以再使用clean命令