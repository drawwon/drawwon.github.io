---
title: windows开机启动程序
mathjax: true
date: 2018-12-17 21:13:20
tags: [python]
category: [python]
---

如果要让某个程序开机启动，可以直接放入开始文件夹中，打开开始文件夹的方法是，运行-`shell:startup`即可

但是如果某个程序需要通过命令行加上参数运行怎么办呢，这个时候可以用python通过pyinstaller打包成exe文件再放入开始文件夹。

```python
# 保存成start_frp.py
import subprocess
# startupinfo的作用是不显示可视化窗口
startupinfo = subprocess.STARTUPINFO()
startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
subprocess.Popen([r"C:\Users\Jeffrey\OneDrive - sei.xjtu.edu.cn\python exercise\frp_0.22.0_windows_amd64\frpc.exe",
                  "-c", r"C:\Users\Jeffrey\OneDrive - sei.xjtu.edu.cn\python exercise\frp_0.22.0_windows_amd64\frpc.ini"],startupinfo=startupinfo).wait()
```

用`pyinstaller start_frp.py -F -w`，`-F`是只生成一个可执行文件，`-w`是不提供可视化输入输出，这样得到`/dist/start_frp.exe`，直接放入开始文件夹就行了

