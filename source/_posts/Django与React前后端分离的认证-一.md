---
title: Django与React前后端分离的认证(一)
mathjax: true
date: 2018-06-17 10:37:52
tags: [Django,React]
category: [网页,编程学习]
---

难以想象如果一个Django应用没有用户认证，我们用一个简单的认证流程来解释一下Django和React的协作进行用户认证的过程。

<!--more-->

第一部分用JWT token认证创建一个简单的Django后端。第二部分展示如何创建React/Redux前端，第三部分介绍如何应用JWT去刷新token。

最终你可以看到一个以django为后端，react/redux为前端的小应用。

## 什么是JWT

json web token是一种无状态的认证方法。生成的token只保存在客户端。一个JWT token本身可能包含了用户名，邮箱或者用户权限。

JWT可以提供两种类型的token，一种是长期刷新的token（用于token过期之后的重新获取），一种是短期访问的token（用于调用API服务）

## 建立后端代码

首先用virtualenv建立新的环境，并安装相关库

```sh
$ mkdir backend/ && cd backend/
$ python3.6 -m venv env
$ source env/bin/activate
$ pip install coreapi django djangorestframework \
      djangorestframework-simplejwt
$ pip freeze > requirements.txt
$ django-admin startproject config .
```

安装的coreapi库用于自动生成api的模式，用于描述有什么资源可以用，urls是什么，支持什么操作，如何去展现结果。

[django-rest-framework-simplejwt](https://github.com/davesque/django-rest-framework-simplejwt) 库用于执行JWT认证

然后在`config/settings.py`中配置：

```python
INSTALLED_APPS = [
    ...
    'rest_framework',
]
# Rest Framework
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    ),
}
```

加入`rest_framework`到`INSTALLED_APPS`当中，用`IsAuthenticated`来保护所有的api访问权限，用`JWTAuthentication`和`SessionAuthentication`来保护认证的视图

修改`config/urls.py`：

```python
from django.conf.urls import url, include
from django.views import generic
from rest_framework.schemas import get_schema_view
from rest_framework_simplejwt.views import (TokenObtainPairView,TokenRefreshView,)

urlpatterns = [
    url(r'^$', generic.RedirectView.as_view(url='/api/', permanent=False)),
    url(r'^api/$', get_schema_view()),
    url(r'^api/auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^api/auth/token/obtain/$', TokenObtainPairView.as_view()),
    url(r'^api/auth/token/refresh/$', TokenRefreshView.as_view()),
]
```

这里使用了`get_schema_view`去是的api视图可用，`TokenObtainPairView` 和`TokenRefreshView` 完成JWT认证的作用

为了简单，我们把echo API部分直接放在`config/urls.py`中

```python
class MessageSerializer(serializers.Serializer):
    message = serializers.CharField()
class EchoView(views.APIView):
    def post(self, request, *args, **kwargs):
        serializer = MessageSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(
            serializer.data, status=status.HTTP_201_CREATED)
urlpatterns = [
    ...
    url(r'^api/echo/$', EchoView.as_view())
]
```

现在可以运行django代码

```sh
$ ./manage.py migrate
$ ./manage.py createsuperuser
$ ./manage.py runserver
```

