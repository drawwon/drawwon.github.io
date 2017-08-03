---
title: git教程
date: 2017-04-18 15:08:16
category: [编程学习]
tags: [git]
---



## 命令总结

<!--more-->

### 本地git命令

感觉git常用的几个：add\commit\checkout\merge\reset\push\pull，其他的都没怎么用

git add filename

git commit -m "message"

### github命令

`$ ssh-keygen -t rsa -C "youremail@example.com"`



## git 是什么

Git是目前世界上最先进的分布式版本控制系统，简而言之，可以用作回滚文件版本，把你在过程中的任何版本都保留下来。


## 分布式和集中式的区别

集中式：干活之前先从中央服务器获得文件的最新版本，干完活再推送给中央服务器，必须要联网（网速限制了其使用的效果）

分布式：每个人电脑上有一个完整的版本库，中央服务器只是用来交换大家的修改

## 安装git

### Linux上安装git：

```shell
$ git
 The program 'git' is currently not installed. You can install it by typing:
sudo apt-get install git
```

### Mac OS X上面安装git

Xcode里面自带了git，因此你只需要从App Store安装Xcode即可

### WINDOWS 安装git


Windows下要使用很多Linux/Unix的工具时，需要Cygwin这样的模拟环境，Git也一样。Cygwin的安装和配置都比较复杂，就不建议你折腾了。不过，有高人已经把模拟环境和Git都打包好了，名叫msysgit，只需要下载一个单独的exe安装程序，其他什么也不用装，绝对好用。

msysgit是Windows版的Git，从[https://git-for-windows.github.io](https://git-for-windows.github.io/)下载（网速慢的同学请移步[国内镜像](https://pan.baidu.com/s/1kU5OCOB#list/path=%2Fpub%2Fgit)），然后按默认选项安装即可。安装完成后，在开始菜单里找到“Git”->“Git Bash”，蹦出一个类似命令行窗口的东西，就说明Git安装成功！

安装完成之后，设置git的名字和email地址，用于在网络上区分用户

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

## 创建版本库
版本库又称为仓库，英文名为：repository，可以理解成一个目录，这个目录下任何文件的更改删除都能被git跟踪，任何时候都可以将其还原

### 创建一个版本库

选择一个合适的地方创建一个空目录：

```shell
$ mkdir learngit
$ cd learngit
$ pwd
/Users/michael/learngit
```

<font color=#ff0000>pwd</font>：用于显示当前所在目录的命令

<font color=#ff0000>使用windows系统是，请确保文件路径中没有中文</font>

初始化git
​```shell
$ git init 
```

此时你的文件夹中应该出现一个.git隐藏文件，如果要显示该隐藏文件，输入如下命令：

​``` shell
$ ls -a
```

其中<font color="red">ls</font>的意思是list，列出


## 把文件添加到版本库

首先这里再明确一下，所有的版本控制系统，其实只能跟踪文本文件的改动，比如TXT文件，网页，所有的程序代码等等，Git也不例外。版本控制系统可以告诉你每次的改动，比如在第5行加了一个单词“Linux”，在第8行删了一个单词“Windows”。而图片、视频这些二进制文件，虽然也能由版本控制系统管理，但没法跟踪文件的变化，只能把二进制文件每次改动串起来，<font color="red">也就是只知道图片从100KB改成了120KB，但到底改了啥，版本控制系统不知道</font>，也没法知道。同样，<font color="red">word的改动也不能被跟踪。</font>

注意：不能用windows自带的记事本来编写文件，因为其UTF-8的标准有问题（在文本最前面加了一段十六进制字符）

现在我们先建立一个readme.txt 文件，内容如下

```
Git is a version control system.
Git is free software.
```

### 把一个文件放到git只需要两部

1. 用<font color="red">`git add`</font>指令把文件添加到仓库
```shell
$ git add readme.txt
```

没有任何显示表示提交成功

2. 用<font color="red">`git commit`</font>指令告诉git，把文件提交到仓库

```shell
$ git commit -m "wrote a redme file"
[master (root-commit) cb926e7] wrote a readme file
 1 file changed, 2 insertions(+)
 create mode 100644 readme.txt
```

简单解释一下`git commit`命令，`-m`后面输入的是本次提交的说明，可以输入任意内容，当然最好是有意义的，这样你就能从历史记录里方便地找到改动记录



## 查看文件的各个版本

我们现在修改readme.txt为如下内容:

```
Git is a distributed version control system.
Git is free software.
```

现在运行`git status`可以看到文件已经modified，但是还没有添加：

```
$ git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#    modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
```

接下来，我们使用`git diff`查看文件的具体变化：

```
$ git diff readme.txt 
diff --git a/readme.txt b/readme.txt
index 46d49bf..9247db6 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,2 @@
-Git is a version control system.
+Git is a distributed version control system.
 Git is free software.
```

git diff 顾名思义就是 difference

接下来，我们将提交文件，`git add`

```shell
$ git add readme.txt
```

在执行`git commit`之前，我们先运行`git status`看看当前仓库状态

```shell
$ git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       modified:   readme.txt
#
```

`git status`告诉我们，readme.txt文件将要被提交，接下来，我们是用`git commit`提交文件

```shell
$ git commit -m "add distributed"
[master ea34578] add distributed
 1 file changed, 1 insertion(+), 1 deletion(-)
```

接下来，我们再用`git status`查看当前仓库的状态

```shell
$ git status
# On branch master
nothing to commit (working directory clean)
```



## 版本回退

现在已经学会了如何修改文件，那么我们再试着做一次，修改readme.txt文件内容如下：

```
Git is a distributed version control system.
Git is free software distributed under the GPL.
```

然后用`git status`查看git状态，然后用`git diff`查看修改的内容，最终用`git add`和`git commit`提交修改

```shell
$ git add readme.txt
$ git commit -m "append GPL"
[master 3628164] append GPL
 1 file changed, 1 insertion(+), 1 deletion(-)
```

一旦出现错误，这样，我们就可以从最近的一个`commit`开始恢复

现在，我们回顾一下readme.txt文件一共有几个版本被提交到Git仓库里了：

版本1：wrote a readme file

```
Git is a version control system.
Git is free software.

```

版本2：add distributed

```
Git is a distributed version control system.
Git is free software.

```

版本3：append GPL

```
Git is a distributed version control system.
Git is free software distributed under the GPL.
```

用`git log`命令，我们可以查看从最近到最远的提交日志，我们可以看到3次提交，最近的一次是`append GPL`，上一次是`add distributed`，最早的一次是`wrote a readme file`。如果嫌输出信息太多，看得眼花缭乱的，可以试试加上`--pretty=oneline`参数：

首先，Git必须知道当前版本是哪个版本，在Git中，用`HEAD`表示当前版本，也就是最新的提交`3628164...882e1e0`（注意我的提交ID和你的肯定不一样），上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个`^`比较容易数不过来，所以写成`HEAD~100`。

运行：

```shell
$ git reset --hard HEAD^
HEAD is now at ea34578 add distributed
```

hard指令的具体含义我们会在后面说明

此时看到，已经回到了上一个版本，但是我们会发现，最新的那个版本不见了。

为了找到最新的版本，我们应该向上找到那个版本号c82373d096fbc635b12d4cd，然后

```shell
$ git reset --hard c82373
HEAD is now at c82373 add distributed
```

版本号不用全部填写，只要写一部分就可以了

但是，如果我们已经关闭了串口怎么办，这个时候，我们就需要`git reflog`，找到之前的命令

```shell
$ git reflog
ea34578 HEAD@{0}: reset: moving to HEAD^
3628164 HEAD@{1}: commit: append GPL
ea34578 HEAD@{2}: commit: add distributed
cb926e7 HEAD@{3}: commit (initial): wrote a readme file
```

这样，我们看到第二行的id，我们就可以回滚了



### 小结：

* `HEAD`用来指定会退的版本，`git reset --hard commit_id`用来回退
* 可以用git log 查看历史版本
* 用git relog 查看历史命令，以回退历史版本

## 工作区和暂存区

### 工作区

工作区就是我们之前创建的git文件夹

### 版本库

工作区当中有一个隐藏的`.git`文件，称为版本库，git版本库中保存了stage暂存区，和git自动创建的第一个分支`master`，以及指向`master`的一个指针叫`head`

`git add`命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行`git commit`就可以一次性把暂存区的所有修改提交到分支。

Git管理的是修改，比如你的文件修改后->add->第二次修改->commit，那么此时系统中保留的是你第一次修改的内容，可以用`git diff HEAD -- readme.txt`命令查看当前Git中的文件和最新的文件的区别

## 撤销修改

用命令`git reset HEAD file`可以把暂存区的修改撤销掉（unstage），重新放回工作区：

场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令`git checkout -- file`。

场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令`git reset HEAD file`，就回到了场景1，第二步按场景1操作。

## 删除文件

一般情况下，你通常直接在文件管理器中把没用的文件删了，或者用`rm`命令删了：

```
$ rm test.txt
```

现在，你可以用`git rm test.txt`来删除git中的文件，要么你可以用`git checkout -- test.txt`来恢复文件

## 使用github

第1步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有`id_rsa`和`id_rsa.pub`这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：

```
$ ssh-keygen -t rsa -C "youremail@example.com"
```

如果一切顺利的话，可以在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是SSH Key的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人。

第2步：登陆GitHub，打开“Account settings”，“SSH Keys”页面：然后，

点“Add SSH Key”，填上任意Title，在Key文本框里粘贴`id_rsa.pub`文件的内容：

![](http://ooi9t4tvk.bkt.clouddn.com/githhubpage.png)



## 添加远程库

首先，登陆GitHub，然后，在右上角找到“Create a new repo”按钮，创建一个新的仓库：

![](http://ooi9t4tvk.bkt.clouddn.com/new-repository.png)

在本地的`git`仓库下运行命令：

```shell
$ git remote add origin git@github.com:drawwon/learngit.git
```

请千万注意，把上面的`drawwon`替换成你自己的GitHub账户名，否则，你在本地关联的就是我的远程库，关联没有问题，但是你以后推送是推不上去的，因为你的SSH Key公钥不在我的账户列表中。

<font color="red">注意</font>：此时如果失败，可能是因为你创建库的时候添加了readme文件，那么本地文件就少一个readme.md，因此我们要先从远程pull下来才行，

```shell
git pull origin master --allow-unrelated-histories
```

最后的`--allow-unrelated-histories`：是因为github不允许两个没有建立连接的库进行通信

再次push

```shell
$ git push -u origin master
```

-u：与远程库的master分支连接起来，在以后推送时简化命令

从现在开始，只需要在本地使用如下命令，即可push到github

```shell
$ git push origin master
```

### 命令小结

要关联一个远程库，使用命令`git remote add origin git@github.com:drawwon/repo-name.git`；

关联后，使用命令`git push -u origin master`第一次推送master分支的所有内容；

此后，每次本地提交后，只要有必要，就可以使用命令`git push origin master`推送最新修改；

## 从远程库克隆

要使用github开发最好的方式就是先在远程创建一个repository，勾选添加readme文件，然后`git clone`远程库

```
$ git clone git@github.com:drawwon/learngit.git
```

或者

```
$ git clone https://github.com/drawwon/leargit.git
```

但是通过原生git的方式最快

## 分支管理

### 创建分支

首先，我们传建一个dev分支，并切换到dev分支：

```
$ git checkout -b dev
Switched to a new branch 'dev'
```

`git checkout`命令加上`-b`参数表示创建并切换，相当于以下两条命令：

```
$ git branch dev
$ git checkout dev
Switched to branch 'dev'
```

我们修改readme.txt并提交：

```
$ git add readme.txt 
$ git commit -m "branch test"
[dev fec145a] branch test
 1 file changed, 1 insertion(+)
```

先在切换回master分支：

``` 
git checkout master
```

可以看到我们之前增加的内容不见了

现在，我们把dev分支的成果合并到master上面：

``` 
git merge <name>  #合并分支到当前分支上面
```

如果需要有历史版本的merge，那么请使用--no-ff

```
 git merge --no-ff -m "merge with no-ff" dev 
```

