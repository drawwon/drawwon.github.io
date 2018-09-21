---
title: 用python控制同步hexo脚本
date: 2017-08-10 20:21:43
tags: [python]
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

然后将启动这个命令设置为简短的命令，类似于alias

Run the below command in a command prompt to alias **ls **to run the command **dir**. The **$\*** on the end are required so that any additional arguments are also passed to the **dir** command.****

1. `doskey ls=dir $* `

The problem with this is that all of your alias commands will be lost when you close the cmd session. To make them persist we need to create a batch file and add the entry to the windows registry.

Create a new folder in the windows directory called **bin** and create a new batch file inside it.

2. `C:\>mkdir c:\windows\binC:\>notepad.exe c:\windows\bin\doskey.bat `

Add your entries to the batch file in the below format.

3. `@echo offdoskey ls=dir $*doskey mv=move $*doskey cp=copy $*doskey cat=type $* `

Next, open up **regedit.exe** and add an entry to the batch file to make the doskey commands permanent for each cmd session.

4. `HKEY_CURRENT_USER\Software\Microsoft\Command Processor`

Add a new **String Value** called **AutoRun** and set the absolute path in the value of **c:\windows\bin\doskey.bat**.****

The **doskey.bat** file will now be executed before opening a new cmd session which will set all of your alias ready for you to use.