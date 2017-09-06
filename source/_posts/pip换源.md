---
title: pip换源
date: 2017-09-06 21:54:00
tags: [pip]
category: [软件配置]

---



在windows文件管理器中输入`%APPDATA%`，进入到一个文件夹，新建名为pip的文件夹，然后在其中新建pip.ini文件，输入

```
[global]
timeout = 6000
index-url = https://pypi.douban.com/simple
trusted-host = pypi.douban.com
```

转换为豆瓣源

或者输入

```
[global]
index-url = https://mirrors.xjtu.edu.cn/pypi/web/simple/
```

转换为西安交大源

