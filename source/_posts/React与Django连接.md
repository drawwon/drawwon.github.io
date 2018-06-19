---
title: React与Django连接
mathjax: true
date: 2018-06-09 14:32:56
tags: [React,Django]
category: [网页]
---

React构建好了前端网页，那么后端该如何使用这个前端网页呢，就需要用到下面介绍的方法

## Django

首先处理Django方面的问题

<!--more-->

* 安装virtualenv的管理包virtualenvwrapper`，`pip install virtualenvwrapper`. 
* 创建virtualenv，`mkvirtualenv name-of-virtual-env `
* 创建Django项目，`django-admin startproject nameOfProject `
* 建立app，`django-admin startapp mynewapp `
* 把*mynewapp*加入到*settings.py*中

## React

首先安装nodejs和npm，然后：

* 安装`create-react-app`包`create-react-app `
* 建立一个新的前端app，`create-react-app name-of-project`
* 把这个React app拷贝到Django目录下
* 修改`package.json`，添加`  "homepage": "." `
* `npm start`调试前端目录
* 直到效果完全ok之后打包前端文件`npm run build`得到一个build文件夹

## Django settings修改

然后是修改Django *settings.py*文件，

```python
#更改模板文件夹
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATES = [
  {
    ...
    'DIRS': [
      os.path.join(BASE_DIR, 'build')
    ],
    ...
  }
]
#更改静态文件夹
STATICFILES_DIRS = [
  os.path.join(BASE_DIR, 'build/static'),
]
```

然后再url中配置好url就可以run server进行访问了

