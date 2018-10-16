---
title: 在服务器部署Jupyter Notebook
mathjax: true
date: 2018-09-25 16:52:09
tags: [编程工具]
category: [编程工具]
---

在服务器安装Jupyter后：
 1、生成配置文件`$jupyter notebook --generate-config`
 2、终端输入`ipython`,生成密码

~~~python
In [1]: from notebook.auth import passwd
In [2]: passwd()
Enter password: 
Verify password: 
Out[2]: 'sha1:XXX……XXX'````

3、`vim /root/.jupyter`修改配置。
```
c.NotebookApp.ip='127.0.0.1'
c.NotebookApp.password = u'sha1:XXX……XXX#填入步骤2的密文的）'
c.NotebookApp.notebook_dir = u'/home/py'#设置文件的存放目录
c.NotebookApp.open_browser = False# 禁止在运行ipython的同时弹出
c.NotebookApp.port =8888 #也可以指定其他端口
```

4、启动Jupyter，终端输入：
`jupyter notebook --config=/root/.jupyter/jupyter_notebook_config.py`
或是直接`nohup jupyter notebook &`
或是直接`nohup jupyter lab &`



5、本地链接服务器Jupyter，解决服务器防火墙设置的问题，本地建立一个ssh通道，在本地终端输入：
` ssh user@address -L 127.0.0.1:1234:127.0.0.1:8888` 
user=服务器用户名
address=通道名
完成后，在浏览器输入
`http://127.0.0.1:1234/`输入步骤2自己设置的密码即可访问。

6、ssh连接Linux，想关闭终端后，后台台还可以运行程序  可以使用nohup命令：
```
nohup jupyter notebook --config=/root/.jupyter/jupyter_notebook_config.py
```
tips：
阿里云可能会出现socket.error: [Errno 99] Cannot assign requested address错误，是因为阿里云的安全策略，没有开启服务器端口，防火墙问题，如果实在想知道，给我留言，手把手教学。不过可以通过上面的的教程
设置配置文件，通过ssh转接。
~~~

转自：https://www.jianshu.com/p/362e0200f421

