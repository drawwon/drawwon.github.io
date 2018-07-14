---
title: flask快速入门
date: 2017-07-15 21:54:48
tags: [flask]
category: [编程学习]

---

Flask是一个开源的易配置的web框架，基于Python进行书写

<!--more-->

在[flask 快速入门中](http://docs.jinkan.org/docs/flask/quickstart.html#a-minimal-application)，我们参照实例中的代码进行书写

1. **首先我们建立一个app对象**

   ```python
   from flask import Flask
   app = Flask(__name__)
   ```

2. 然后我们就可以使用`app.route("/route")`这个装饰器书写每个页面的函数，如果需要在路由路径中使用变量，可以用`<converter:parameter>`的形式，用尖括号把变量扩起来

   ```python
   @app.route("/")
   def root():
       return "root page"

   @app.route("/hello")
   def hello_world():
       return "hello world page"

   @app.route("/user/<username>")
   def user_name_page(username):
       return "user name is %s"%username

   @app.route("/user/<int:user_id>")
   def user_id_page(user_id):
       return "user %d" % user_id
   ```

3. **url重定向问题**
   当访问一个地址`@app.route("/projects/")`的时候，当我们输入的地址**没有斜杠时**，浏览器会**自动补全斜线**
   当访问一个地址`@app.route("/project")`的时候，当我们输入的地址没有斜杠时可以正确到达要访问的地址，当输入的地址有斜杠时，会发生一个404 not found的错误

4. **构造URL**
   既然我们可以自定义网页的路由地址，那么我们能否使用某个函数来自动生成一个复杂的地址呢？答案是肯定的，使用**`url_for()`**函数就可以构造复杂的路由地址。

   ```python
   from flask import Flask
   @app.route("/")
   def index():
       return "flasker"

   @app.route("/login")
   def login():
       pass

   @app.route("/hello")
   def hello():
       return "hello world"

   @app.route("/user/<username>")
   def profile(username):
       return "user name is %s"%username

   with app.test_request_context():
       print url_for('index')
       print url_for('login')
       print url_for('login', next='/')
       print url_for('profile',username='John Doe')
   ```

   这里用到了`app.test_request_context()`方法，主要是用于在python shell中对flask代码进行调试，也就是不出现如下的代码

   ```python
    * Debugger is active!
    * Debugger pin code: 197-159-436
    * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
   ```

5. **HTTP方法**
      HTTP有多种访问url的方法，使用route装饰器传入methods参数可以改变访问方式

      ```python
      @app.route('/login',methods=['GET','POST'])
      def login():
          if request.method = 'post':
              do_the_login()
          else:
              show_the_login_form()
      ```

      > 下面简单介绍一下http方法：
      >
      > * GET：浏览器告知服务器：获取页面上的信息并发给我
      > * HEAD：获取页面的HEAD信息并发给我
      > * POST：浏览器告知服务项，想在url上面发布新信息。服务器保证数据已存储且只存储了一次，是html发送数据到服务器的方法
      > * PUT：类似于post，但是存储过程触发了多次。这种请求允许浏览器与服务器之间的系统可以安全的第二次接受请求，而不破坏其他东西
      > * DELETE：删除给定位置的信息
      > * OPTIONS：给客户端提供一个迅速的方法弄清楚这个URL支持哪些http方法

6. **静态文件**
      即使是动态web也需要静态文件，通常是CSS和JavaScript文件。flask可以通过在包所在目录中新建一个名为`static`的文件夹，在应用中通过`/static`即可访问
      可以通过如下方法给静态文件生成URL，使用特殊的`static`端点名

      ```python
      url_for('static',filename='style.css')
      ```

      这个文件应该存储在文件系统中的`static/style.css` 

7. **模板渲染**

      python配备了一个`jinja2`模块用于生成html文件
      可以使用flask包中的`render_template()`方法来渲染模板，方法如下：

      ```python
      from flask import render_template

      @app.route('/hello/')
      @app.route('/hello/<username>')
      def hello(name=None):
          return render_template('hello.html',name=name)
      ```
      此时flask会在templates文件夹下面查找`hello.html`文件

8. **请求对象**


      要获取http的访问方法，要用到flask里面的request库中的method方法

      ```python
      from flask import request
    
      @app.route('/login',methods=['POST','PUT'])
      def login():
      	error = None
          if request.method == 'POST':
          	if valid_login(request.form['username'],reuqest.form['password']):
              	return log_the_user_in(request.form['username'])
          else:
          	error = 'invalid username/password'
      ```

9. **文件上传**

   用flask上传文件，只需要在HTML表单中设置`enctype="mutipart/form-data"`属性

   已上传文件放在临时文件夹或者内存中，当然也可以通过`save（）`方法对其进行访问：

   ```python
   from flask import request

   @app.route('/upload', methods=['GET','POST'])
   def upload_file():
       if request.method == 'POST':
           f = request.files['the_file']
           f.save('/var/www/uploads/uploaded_file.txt')
       ...
   ```

   如果你想知道文件上传之前的文件名是什么，你可以使用`filename`属性，不过这个属性可以伪造，因此并不值得信任，`secure_filename()`是值得信任的文件名获取函数

   ```python
   from flask import request
   from werkzeug import secure_filename

   @app.route('/upload', methods=['GET','POST'])
   def upload_file():
       if request.method == 'POST':
   		f = request.files['the_file']
           f.save('/var/www/uploads' + secure_filename(f.filename))
   ```

   10. **Cookies**

     如果在想访问网页中的cookies，可以使用`cookies`属性：

     ```python
     from flask import request

     @app.route('/')
     def index():
         username = request.cookies.get('username')
     ```

     如果想要设置网页中的cookies，可以使用`set_cookie`对cookies进行存储

     ```Python
     from flask import make_response

     @app.route('/')
     def index():
         resp = make_response(render_template(...))
         resp.set_cookie('username', 'the username')
         return resp
     ```

   11. **重定向和错误**

       可以使用`redirect`函数把用户重定向到另一个地方，用`abort`函数来放弃请求并返回错误代码：

       ```Python
       from flask import abort, redirect, url_for

       @app.route('/')
       def index():
           return redirect(url_for('login'))

       @app.route('/login')
       def login():
           abort(401)
           this_is never_executed()
       ```

       这个例子展现了从主页重定向到一个401页面的过程

   12. **响应**
       返回值应该是一个状态码，假如有如下视图：

       ```python
       @app.errorhandler(404)
       def not_found(error):
           return render_template('error.html'),404
       ```

       只需要把值传递给`make_response()`，获取结果对象并修改，然后再返回：

       ```python
       @app.errorhandler(404)
       def not_found(error):
       	resp = make_response(render_template('error.html'),404)
           resp.headers['x-something'] = 'a value'
           return resp
       ```

   13. 会话

       除了请求对象以为，还有一个`session`对象，允许在不同请求间存储特定用户的信息。是基于cookies实现的，不过在cookies上面进行了密钥签证，用户可以查看你的cookies，但是如果不知道密钥的话是无法修改的

       要使用`session`对象，需要设置一个密钥，方法如下：

       ```python
       import os
       from flask import Flask, request, session, redirect, url_for, flash, escape
       app = Flask(__name__)

       @app.route('/')
       def index():
           if 'username' in session:
               return 'log in as %s' % escape(session['username'])
           else:
               return 'you are not logged in'

       @app.route('/login',methods=['POST','GET'])
       def login():
           if request.method == 'POST':
               session['username'] = request.form['username']
               return redirect(url_for('index'))
           return '''<form action="" method="post">
                     <p><input type=text name=username>
                     <p><input type=submit value=login>
                     </form>
           '''

       @app.route('/logout')
       def logout():
           session.pop('username',None)
           return redirect(url_for('index'))

       app.secret_key = os.urandom(24)
       ```

   14. **消息闪现**
       使用`flash()`可以闪现一条消息，要操作消息本身请使用`get_flashed_messages()`

   15. **日志记录**
       flask有自带的日志记录系统，使用方法如下：

       ```python
       app.logger.debug('a value for debuging')
       app.logger.warning('warning occurred',42)
       app.logger.error('an error occured')
       ```

   16. **整合wsgi中间件**
       wsgi是指网络服务器网关接口，主要用于描述一个网页服务器如何与网页应用交互，使用方法如下：

       ```python
       from werkzeug.contrib.fixers import LighttpdCGIRootFix
       app.wsgi_app = LighttpdCGIRootFix(app.wsgi_app)
       ```

   17. **在自己主机上托管网页**
       17.1 **安装Apache**
       首先安装apache（阿帕奇），这个软件主要是用于部署网页，下载方法如下：
       ①登录[apache下载网站](http://httpd.apache.org/download.cgi)，找到如下的for windows的软件![](http://ooi9t4tvk.bkt.clouddn.com/17-7-23/17988963.jpg)

       ②选择下图中的任意一个第三方平台进行下载，会得到一个压缩包![](http://ooi9t4tvk.bkt.clouddn.com/17-7-23/7561754.jpg)

![](http://ooi9t4tvk.bkt.clouddn.com/17-7-23/10893416.jpg)

​	解压压缩包得到名为apache的文件夹，首先要修改`/Apache24/conf/htttpd.conf`，将其中`Define SRVROOT "/Apache24"`改为其现在的路径`Define SRVROOT "D:/program files/Apache24"`，

再把`Listen 80`改为`Listen 88`（因为80端口可能已经被占用）；

**然后**，我们需要修改`/Apache24/conf/extra/thhpd-ssl.conf`以及`/Apache24/conf/extra/thhpd-ssl.conf`文件中的`Listen 443`改成`Listen 444`（因为443端口路被cmd占用）

​	通过cmd进入`Apache24/bin`，输入`httpd.exe -k install -n apache`，这条指令的意思就是安装httpd.exe程序为Windows服务，名称为apache，之后你就可以通过`ApacheMonitor.exe`直接打开或者关闭Apache。

​	③为了验证Apache是否安装成功，我们需要在打开Apache服务的时候，访问127.0.0.1，如果看到如下界面，表示安装成功：

![](http://ooi9t4tvk.bkt.clouddn.com/17-7-23/36787268.jpg)















