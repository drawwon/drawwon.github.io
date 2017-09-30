---
title: scrapy爬取知乎问题实战
date: 2017-09-18 08:59:38
tags: [python,scrapy,爬虫]
category: [编程练习,爬虫]


首先,需要理解cookies的含义，是存储在浏览器中的内容，在本地存储任意键值对，第一次访问时服务器返回一个id存储到本地cookie中，第二次访问将cookies一起发送到服务器中
---

![](http://ooi9t4tvk.bkt.clouddn.com/17-9-18/23468729.jpg)

常见http状态码

| code    | 说明          |
| ------- | ----------- |
| 200     | 请求成功        |
| 301/302 | 永久重定向/临时重定向 |
| 403     | 没有权限访问      |
| 404     | 没有对应的资源     |
| 500     | 服务器错误       |
| 503     | 服务器停机或正在维护  |

 要爬取知乎内容首先需要进行登录，在本文中我们主要介绍2种登录方式，第一种是通过requests的session保存cookies进行登录，第二种是通过`scrapy`修改`start_requests`函数进行登录

<!--more-->

## requests进行登录

在utils中新建`zhihu_login.py`，实例化一个session对象，设置其cookies对象为`cookiesjar`库中的`LWPCookieJar`对象，设置requests库需要用到的headrs（从浏览器中进行拷贝），

```python
session = requests.session()
session.cookies = cookiejar.LWPCookieJar(filename='zhihu_cookies.txt')
headers = {
        'User-Agent':'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36',
        'Origin':'https://www.zhihu.com',
        'Accept-Language':'zh-CN,zh;q=0.8,en;q=0.6',
        'Host':'www.zhihu.com',
        'Referer':'https://www.zhihu.com/'
}
```

接下来，我们要寻找登录发送数据的页面，首先打开`zhihu.com`退出之前的登录，来到一个登录页面，在登陆页面中使用手机号码登录，此时需要**发送一个错误的信息给页面**，以找到post数据的网页（如果输入正确的账号密码就直接登录成功了，一大堆网页请求就找不到我们需要的网页了）

![](http://ooi9t4tvk.bkt.clouddn.com/17-9-19/72348150.jpg)

![](http://ooi9t4tvk.bkt.clouddn.com/17-9-19/12704910.jpg)

找到了需要post的网页，发现post的数据有`_xsrf`,`passoword`,`phone_num`，另外一个`captcha_type`没有用，加了之后反而无法访问（不知道为什么）

```python
def zhihu_login(account, password):
    if re.match('1\d{10}', account):
        phone_post_url = 'https://www.zhihu.com/login/phone_num'
        post_data={
            '_xsrf':get_xsrf(),
            'phone_num':account,
            'password':password,
            # 'captcha_type':'cn'
        }
        # session_response = session.post(phone_post_url, data=post_data, headers=header)
        # print(session_response.text)
        # result_list = re.findall('"msg": "(.*?)"',session_response.text)[0]
        # print(result_list.encode('utf8').decode('unicode-escape'))
        # try:
        #     login_page = session.post(phone_post_url, data=post_data, headers=headers)
        #     print('不要验证码,login_code:{}'.format(login_page.status_code))
        # except:
        post_data['captcha'] = get_captcha()
        login_page = session.post(phone_post_url, data=post_data, headers=headers)
        result_list = re.findall('"msg": "(.*?)"', login_page.text)[0]
        print(result_list.encode('utf8').decode('unicode-escape'))
        session.cookies.save()
        print('保存成功')

```

在这里我们一开始没有使用验证码，发现只要是爬虫登录都会被识别到，所以我们编写了一个用于生成验证码的代码：

```python
def get_captcha():
    t = str(int(time.time()*1000))
    captcha_url = 'https://www.zhihu.com/captcha.gif?r=' + t + "&type=login"
    r = session.get(captcha_url, headers=headers)
    with open('captcha.jpg','wb') as f:
        f.write(r.content)
    try:
        im = Image.open('captcha.jpg')
        im.show()
        im.close()
    except:
        print('wrong')
    captcha = input('请输入验证码:')
    return captcha
```

保存完cookies，我们尝试使用这个cookies再次登录

```python
def get_again():
    try:
        session.cookies.load(ignore_discard=True)
        print('cookies加载成功\n')
    except:
        print('cookies加载失败')
    response = session.get('https://www.zhihu.com',headers=headers)
    # response.encoding = response.apparent_encoding
    with open('my_zhihu_login.html','wb') as f:
        f.write(response.text.encode('utf8'))
        print('保存页面成功')
```

查看这个页面发现不停地刷新，暂时还没有找到办法

### scrapy模拟登陆知乎

首先生成一个新的spider，名字为zhihu

在class zhihu中定义headers等信息，重写`start_requests`函数

```python
def start_requests(self):
     return [scrapy.Request('https://www.zhihu.com/#signin',headers=self.headers, callback=self.login)]
```

在`start_requests`里面返回一个新的Request，其回调函数设置为一个新的login函数如下：

```python
def login(self,response):
  # print(response.text)
  # a = '<input type="hidden" name="_xsrf" value="36424865b408db8c3f976a1a676cad60"/>'
  match_obj = re.match('.*name="_xsrf" value="(.*?)"', response.text, re.DOTALL)
  if match_obj:
    _xsrf = match_obj.group(1)
    post_data = {
      '_xsrf': _xsrf,
      'phone_num': 'xxxxxxxxxxx',
      'password': 'xxxxxxx',
      'captcha':''
    }
    t = str(int(time.time() * 1000))
    captcha_url = 'https://www.zhihu.com/captcha.gif?r=' + t + "&type=login"
    return [scrapy.Request(url=captcha_url,
                           meta={'post_data':post_data},
                           headers=self.headers,
                           callback=self.get_captcha_login)]

  else:
    raise EOFError
```

