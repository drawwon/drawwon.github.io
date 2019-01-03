---
title: vscode设置及插件同步
date: 2018-05-25 18:16:36
tags: [工具]
category: [编程学习,工具]
---

# vscode同步设置&扩展插件

首先安装同步插件： [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)  

 <!--more-->

第二步：进入你的github如图：

 **打开设置选项：**

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-5-25/26703030.jpg)

 

**新建一个token：**

![img](https://images2015.cnblogs.com/blog/717286/201704/717286-20170425110217694-265826573.png)

如图：

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-5-25/1344863.jpg)

 **记住这个token值**

转到vscode

 按shift+alt +u  在弹出窗里输入你的token,然后等下会生成syncSummary.txt文件在窗口中打开这样就算成功了。

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-5-25/99811178.jpg)

syncSummary.txt这个文件里有个gist值或者到用户设置文件中查看gist的值，这个值用来你再另一台电脑上来下载你的设置，在设置中可以找到这个git的值

![img](C:\Users\jeffrey\AppData\Local\Temp\1527243805172.png)

 

**下载你的设置方法为：打开vscode——按alt+shift+d  在弹出窗里输入你的gist值，等待片刻便同步成功。**

 

 

**如果要重置同步设置：按ctrl+p  输入  '>sync'**  

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/18-5-25/82132308.jpg)

 

   **就可以重新配置你的token来同步了**