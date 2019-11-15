---
title: git参与开源项目的方法
mathjax: true
date: 2019-11-14 11:09:08
tags: [git]
category: [编程学习]
---

github上面有很多优秀的项目，如何参与其中的项目呢，其实github已经有了比较好的提示，经过搜索后总结如下。

<!--more-->

1. 首先是要寻找优秀的开源项目，通过github tredings 或者 stars 可以找到最近比较热门的项目

2. 找到项目之后，fork到自己的仓库，并且将fork后的项目clone到本地

3. 为了保证fork后的仓库和主仓库保持同步，需要添加一个remote地址

   先看看自己的本地地址有哪些：

   ```bash
   $ git remote -v
   > origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
   > origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
   ```

   然后把原始项目的地址添加到remote当中，取名为upstream

   ```bash
   $ git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
   ```

   最后确认一下是否添加成功

   ```bash
   $ git remote -v
   > origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
   > origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
   > upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (fetch)
   > upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)
   ```

4. 当你在本地项目对代码进行了大量修改后，为了与原项目代码同步，要fetch upstream

   ```bash
   $ git fetch upstream
   > remote: Counting objects: 75, done.
   > remote: Compressing objects: 100% (53/53), done.
   > remote: Total 62 (delta 27), reused 44 (delta 9)
   > Unpacking objects: 100% (62/62), done.
   > From https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY>  * [new branch]      master     -> upstream/master
   ```

   然后切换到master分支

   ```shell
   $ git checkout dev
   > Switched to branch 'dev'
   ```

   最后合并两个分支

   ```shell
   $ git merge upstream/dev
   > Updating a422352..5fdff0f
   > Fast-forward
   >  README                    |    9 -------
   >  README.md                 |    7 ++++++
   >  2 files changed, 7 insertions(+), 9 deletions(-)
   >  delete mode 100644 README
   >  create mode 100644 README.md
   ```

   合并之后再push到自己的项目就行了

   ```shell
   git push origin dev
   ```

5. 最后在你的github项目中点pull request，就会提交到对方的邮件列表中，对方同意合并就合并成功了

   