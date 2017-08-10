---
title: 用python控制同步hexo脚本
date: 2017-08-10 20:21:43
tags: [python] [os.system]
category: [编程练习]

---

之前一直在windows下面写hexo博客，但是每次同步需要运行一大堆指令，于是想到用python 写一个脚本来自动同步，用到了os.chdir，因为直接`os.system('cd xxx')`会自动返回当前路径。

具体程序如下：

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/8/10 19:42

import os
os.chdir((ur'E:\项目\blog'))
os.system('hexo d \-g')
os.system(ur'git add .')
os.system("git commit -m 'Updated'")
os.system('git push origin source')
print 'done'
```

