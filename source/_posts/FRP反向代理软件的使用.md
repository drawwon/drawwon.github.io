---
title: FRP反向代理软件的使用（转）
date: 2018-05-31 12:25:29
tags: [Linux]
category: [Linux]
---

对于没有公网 `IP` 的内网用户来说，远程管理或在外网访问内网机器上的服务是一个问题。通常解决方案就是用内网穿透工具将内网的服务穿透到公网中，便于远程管理和在外部访问。内网穿透的工具很多，之前也介绍过 [Ngrok](https://www.hi-linux.com/posts/29097.html)[、Localtunnel](https://www.hi-linux.com/posts/24471.html)。

今天给大家介绍另一款好用内网穿透工具 `FRP`，`FRP` 全名：Fast Reverse Proxy。`FRP` 是一个使用 `Go` 语言开发的高性能的反向代理应用，可以帮助您轻松地进行内网穿透，对外网提供服务。`FRP` 支持 `TCP`、`UDP`、`HTTP`、`HTTPS`等协议类型，并且支持 `Web` 服务根据域名进行路由转发。

FRP 项目地址：<https://github.com/fatedier/frp>

**FRP 的作用**

- 利用处于内网或防火墙后的机器，对外网环境提供 `HTTP` 或 `HTTPS` 服务。
- 对于 `HTTP`, `HTTPS` 服务支持基于域名的虚拟主机，支持自定义域名绑定，使多个域名可以共用一个 80 端口。
- 利用处于内网或防火墙后的机器，对外网环境提供 `TCP` 和 `UDP` 服务，例如在家里通过 `SSH` 访问处于公司内网环境内的主机。

**FRP 架构**

[![img](https://www.hi-linux.com/img/linux/frp-architecture.png)](https://www.hi-linux.com/img/linux/frp-architecture.png)

### FRP 安装

`FRP` 采用 `Go` 语言开发，支持 `Windows`、`Linux`、`MacOS`、`ARM`等多平台部署。`FRP` 安装非常容易，只需下载对应系统平台的软件包，并解压就可用了。

这里以 `Linux` 为例，为了方便管理我们把解压后的目录重命名为 frp ：

```
$ wget https://github.com/fatedier/frp/releases/download/v0.15.1/frp_0.15.1_linux_amd64.tar.gz
$ tar xzvf frp_0.15.1_linux_amd64.tar.gz
$ mv frp_0.15.1_linux_amd64 frp
```

更多平台的软件包下载地址：<https://github.com/fatedier/frp/releases>

### FRP 配置

#### FRP 服务端配置

配置 `FRP` 服务端的前提条件是需要一台具有公网 `IP` 的设备，得益于 `FRP` 是 `Go` 语言开发的，具有良好的跨平台特性。你可以在 `Windows`、`Linux`、`MacOS`、`ARM`等几乎任何可联网设备上部署。

这里以 `Linux` 为例，`FRP` 默认给出两个服务端配置文件，一个是简版的 frps.ini，另一个是完整版本 frps_full.ini。

我们先来看看简版的 frps.ini，通过这个配置可以快速的搭建起一个 FRP 服务端。

```
$ cat frps.ini

[common]
bind_port = 7000
```

> - 默认配置中监听的是 7000 端口，可根据自己实际情况修改。

启动 FRP 服务端

```
$ ./frps -c ./frps.ini
2018/01/25 10:52:45 [I] [service.go:96] frps tcp listen on 0.0.0.0:7000
2018/01/25 10:52:45 [I] [main.go:112] Start frps success
2018/01/25 10:52:45 [I] [main.go:114] PrivilegeMode is enabled, you should pay more attention to security issues
```

通过上面简单的两步就可以成功启动一个监听在 7000 端口的 `FRP` 服务端。

#### FRP 客户端配置

和 FRP 服务端类似，`FRP` 默认也给出两个客户端配置文件，一个是简版的 frpc.ini，另一个是完整版本 frpc_full.ini。

这里同样以简版的 frpc.ini 文件为例，假设 FRP 服务端所在服务器的公网 `IP` 为 4.3.2.1。

```
$ vim frpc.ini

[common]
# server_addr 为 FRP 服务端的公网 IP 
server_addr = 4.3.2.1
# server_port 为 FRP 服务端监听的端口 
server_port = 7000
```

启动 FRP 客户端

```
$ ./frpc -c ./frpc.ini
2018/01/25 11:15:49 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 11:15:49 [I] [proxy_manager.go:294] proxy added: []
2018/01/25 11:15:49 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 11:15:49 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 11:15:49 [I] [control.go:240] [83775d7388b8e7d9] login to server success, get run id [83775d7388b8e7d9], server udp port [0]
```

这样就可以成功在 `FRP` 服务端上成功建立一个客户端连接，当然现在还并不能对外提供任何内网机器上的服务，因为我们并还没有在 `FRP` 服务端注册任何内网服务的端口。

### FRP 使用实例

下面我们就来看几个常用的例子，通过这些例子来了解下 FRP 是如何实现内网服务穿透的。

#### 通过 TCP 访问内网机器

这里以访问 `SSH` 服务为例， 修改 FRP 客户端配置文件 frpc.ini 文件并增加如下内容：

```
$ cat frpc.ini

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

启动 FRP 客户端

```
$ ./frpc -c ./frpc.ini
2018/01/25 12:21:23 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 12:21:23 [I] [proxy_manager.go:294] proxy added: [ssh]
2018/01/25 12:21:23 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 12:21:23 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 12:21:23 [I] [control.go:240] [3b468a55191341cb] login to server success, get run id [3b468a55191341cb], server udp port [0]
2018/01/25 12:21:23 [I] [control.go:165] [3b468a55191341cb] [ssh] start proxy success
```

这样就在 `FRP` 服务端上成功注册了一个端口为 6000 的服务，接下来我们就可以通过这个端口访问内网机器上 `SSH` 服务，假设用户名为 mike：

```
$ ssh -oPort=6000 mike@4.3.2.1
```

#### 通过自定义域名访问部署于内网的 Web 服务

有时需要在公有网络通过域名访问我们在本地环境搭建的 `Web` 服务，但是由于本地环境机器并没有公网 `IP`，无法将域名直接解析到本地的机器。

现在通过 `FRP` 就可以很容易实现这一功能，这里以 `HTTP` 服务为例：首先修改 `FRP` 服务端配置文件，通过 `vhost_http_port` 参数来设置 `HTTP` 访问端口，这里将 `HTTP` 访问端口设为 8080。

```
$ vim frps.ini
[common]
bind_port = 7000
vhost_http_port = 8080
```

启动 FRP 服务端

```
$ ./frps -c ./frps.ini
2018/01/25 13:33:26 [I] [service.go:96] frps tcp listen on 0.0.0.0:7000
2018/01/25 13:33:26 [I] [service.go:125] http service listen on 0.0.0.0:8080
2018/01/25 13:33:26 [I] [main.go:112] Start frps success
2018/01/25 13:33:26 [I] [main.go:114] PrivilegeMode is enabled, you should pay more attention to security issues
```

其次我们在修改 `FRP` 客户端配置文件并增加如下内容：

```
$ vim frpc.ini

[web]
type = http
local_port = 80
custom_domains = mike.hi-linux.com
```

这里通过 `local_port` 和 `custom_domains` 参数来设置本地机器上 `Web` 服务对应的端口和自定义的域名，这里我们分别设置端口为 80，对应域名为 `mike.hi-linux.com`。

启动 FRP 客户端

```
$ ./frpc -c ./frpc.ini
2018/01/25 13:56:11 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 13:56:11 [I] [proxy_manager.go:294] proxy added: [web ssh]
2018/01/25 13:56:11 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 13:56:11 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 13:56:11 [I] [control.go:240] [296fe9e31a551e07] login to server success, get run id [296fe9e31a551e07], server udp port [0]
2018/01/25 13:56:11 [I] [control.go:165] [296fe9e31a551e07] [web] start proxy success
2018/01/25 13:56:11 [I] [control.go:165] [296fe9e31a551e07] [ssh] start proxy success
```

最后将 `mike.hi-linux.com` 的域名 A 记录解析到 `FRP` 服务器的公网 `IP` 上，现在便可以通过 `http://mike.hi-linux.com:8080` 这个 `URL`访问到处于内网机器上对应的 `Web` 服务。

> - `HTTPS` 服务配置方法类似，只需将 `vhost_http_port` 替换为 `vhost_https_port`， type 设置为 `https` 即可。

##### 通过密码保护你的 Web 服务

由于所有客户端共用一个 `FRP` 服务端的 `HTTP` 服务端口，任何知道你的域名和 `URL` 的人都能访问到你部署在内网的 `Web` 服务，但是在某些场景下需要确保只有限定的用户才能访问。

`FRP` 支持通过 HTTP Basic Auth 来保护你的 `Web` 服务，使用户需要通过用户名和密码才能访问到你的服务。需要实现此功能主要需要在 `FRP` 客户端的配置文件中添加用户名和密码的设置。

```
$ vim frpc.ini

[web]
type = http
local_port = 80
custom_domains = mike.hi-linux.com
# 设置认证的用户名
http_user = abc
# 设置认证的密码
http_pwd = abc
```

这时访问 `http://mike.hi-linux.com:8080` 这个 URL 时就需要输入配置的用户名和密码才能访问。

> - 该功能目前仅限于 HTTP 类型的代理。

##### 给 Web 服务增加自定义二级域名

在多人同时使用一个 `FRP` 服务端实现 `Web` 服务时，通过自定义二级域名的方式来使用会更加方便。

通过在 `FRP` 服务端的配置文件中配置 `subdomain_host`参数就可以启用该特性。之后在 `FRP` 客户端的 http、https 类型的代理中可以不配置 `custom_domains`，而是配置一个 `subdomain` 参数。

然后只需要将 `*.{subdomain_host}` 解析到 `FRP` 服务端所在服务器。之后用户可以通过 `subdomain` 自行指定自己的 `Web` 服务所需要使用的二级域名，并通过 `{subdomain}.{subdomain_host}` 来访问自己的 `Web` 服务。

首先我们在 `FRP` 服务端配置 `subdomain_host` 参数：

```
$ vim frps.ini
[common]
subdomain_host = hi-linux.com
```

其次在 `FRP` 客户端配置文件配置 `subdomain` 参数：

```
$ vim frpc.ini
[web]
type = http
local_port = 80
subdomain = test
```

然后将泛域名 *.hi-linux.com 解析到 `FRP` 服务端所在服务器的公网 `IP` 地址。FRP 服务端 和 FRP 客户端都启动成功后，通过 `test.hi-linux.com` 就可以访问到内网的 `Web` 服务。

> - 同一个 `HTTP` 或 `HTTPS` 类型的代理中 `custom_domains` 和 `subdomain` 可以同时配置。
> - 需要注意的是如果 `FPR` 服务端配置了 `subdomain_host`，则 `custom_domains` 中不能是属于 `subdomain_host` 的子域名或者泛域名。

##### 修改 Host Header

通常情况下 `FRP` 不会修改转发的任何数据。但有一些后端服务会根据 `HTTP` 请求 `header` 中的 host 字段来展现不同的网站，例如 `Nginx` 的虚拟主机服务，启用 host-header 的修改功能可以动态修改 `HTTP` 请求中的 host 字段。

实现此功能只需要在 FRP 客户端配置文件中定义 `host_header_rewrite` 参数。

```
$ vim frpc.ini
[web]
type = http
local_port = 80
custom_domains = test.hi-linux.com
host_header_rewrite = dev.hi-linux.com
```

原来 `HTTP` 请求中的 host 字段 `test.hi-linux.com` 转发到后端服务时会被替换为 `dev.hi-linux.com`。

> - 该功能仅限于 HTTP 类型的代理。

##### URL 路由

`FRP` 支持根据请求的 `URL` 路径路由转发到不同的后端服务。要实现这个功能可通过 `FRP` 客户端配置文件中的 `locations` 字段来指定。

```
$ vim frpc.ini

[web01]
type = http
local_port = 80
custom_domains = web.hi-linux.com
locations = /

[web02]
type = http
local_port = 81
custom_domains = web.hi-linux.com
locations = /news,/about
```

按照上述的示例配置后，`web.hi-linux.com` 这个域名下所有以 /news 以及 /about 作为前缀的 `URL` 请求都会被转发到后端 web02 所在的后端服务，其余的请求会被转发到 web01 所在的后端服务。

> - 目前仅支持最大前缀匹配，之后会考虑支持正则匹配。

#### 通过 UDP 访问内网机器

`DNS` 查询请求通常使用 `UDP` 协议，`FRP` 支持对内网 `UDP` 服务的穿透，配置方式和 `TCP` 基本一致。这里以转发到 Google 的 `DNS` 查询服务器 8.8.8.8 的 `UDP` 端口为例。

首先修改 FRP 客户端配置文件，并增加如下内容：

```
$ vim frpc.ini
[dns]
type = udp
local_ip = 8.8.8.8
local_port = 53
remote_port = 6001
```

> - 要转发到内网 DNS 服务器只需把 `local_ip` 改成对应 IP 即可。

其次重新启动 `FRP` 客户端：

```
$ ./frpc -c ./frpc.ini
2018/01/25 14:54:17 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 14:54:17 [I] [proxy_manager.go:294] proxy added: [ssh web dns]
2018/01/25 14:54:17 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 14:54:17 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 14:54:17 [I] [control.go:240] [33e1de8a771112a6] login to server success, get run id [33e1de8a771112a6], server udp port [0]
2018/01/25 14:54:17 [I] [control.go:165] [33e1de8a771112a6] [ssh] start proxy success
2018/01/25 14:54:17 [I] [control.go:165] [33e1de8a771112a6] [web] start proxy success
2018/01/25 14:54:17 [I] [control.go:165] [33e1de8a771112a6] [dns] start proxy success
```

最后通过 `dig` 命令测试 `UDP` 包转发是否成功，预期会返回 `www.google.com` 域名的解析结果：

```
$ dig @4.3.2.1 -p 6001 www.google.com
...

;; QUESTION SECTION:
;www.google.com.			IN	A

;; ANSWER SECTION:
www.google.com.		79	IN	A	69.63.184.30

...
```

#### 转发 Unix 域套接字

通过 `TCP` 端口访问内网的 `Unix` 域套接字，这里以和本地机器上的 Docker Daemon 通信为例。

首先修改 `FRP` 客户端配置文件，并增加如下内容：

```
$ vim frpc.ini
[unix_domain_socket]
type = tcp
remote_port = 6002
plugin = unix_domain_socket
plugin_unix_path = /var/run/docker.sock
```

这里主要是使用 `plugin` 和 `plugin_unix_path` 两个参数启用了 `unix_domain_socket` 插件和配置对应的套接字路径。

其次重新启动 `FRP` 客户端：

```
$ ./frpc -c ./frpc.ini

2018/01/25 15:09:33 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 15:09:33 [I] [proxy_manager.go:294] proxy added: [ssh web dns unix_domain_socket]
2018/01/25 15:09:33 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 15:09:33 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 15:09:33 [I] [control.go:240] [f6424f0deb8b6ff7] login to server success, get run id [f6424f0deb8b6ff7], server udp port [0]
2018/01/25 15:09:33 [I] [control.go:165] [f6424f0deb8b6ff7] [ssh] start proxy success
2018/01/25 15:09:33 [I] [control.go:165] [f6424f0deb8b6ff7] [web] start proxy success
2018/01/25 15:09:33 [I] [control.go:165] [f6424f0deb8b6ff7] [dns] start proxy success
2018/01/25 15:09:33 [I] [control.go:165] [f6424f0deb8b6ff7] [unix_domain_socket] start proxy success
```

最后通过 `curl` 命令查看 `Docker` 版本信息进行测试：

```
$ curl http://4.3.2.1:6002/version

{"Platform":{"Name":""},"Components":[{"Name":"Engine","Version":"17.12.0-ce","Details":{"ApiVersion":"1.35","Arch":"amd64","BuildTime":"2017-12-27T20:12:29.000000000+00:00","Experimental":"true","GitCommit":"c97c6d6","GoVersion":"go1.9.2","KernelVersion":"4.9.60-linuxkit-aufs","MinAPIVersion":"1.12","Os":"linux"}}],"Version":"17.12.0-ce","ApiVersion":"1.35","MinAPIVersion":"1.12","GitCommit":"c97c6d6","GoVersion":"go1.9.2","Os":"linux","Arch":"amd64","KernelVersion":"4.9.60-linuxkit-aufs","Experimental":true,"BuildTime":"2017-12-27T20:12:29.000000000+00:00"}
```

> - `FRP` 从 1.5 版本开始支持客户端热加载配置文件，并不用每次都重启客户端程序。具体方法在后文 `FRP` 客户端热加载配置文件部分讲解。

### FRP 高级进阶

#### 给 FRP 服务端增加一个 Dashboard

通过 `Dashboard` 可以方便的查看 `FRP` 的状态以及代理统计信息展示，要使用这个功能首先需要在 `FRP` 服务端配置文件中指定 `Dashboard` 服务使用的端口：

```
$ vim frps.ini

[common]

# 指定 Dashboard 的监听的 IP 地址
dashboard_addr = 0.0.0.0

# 指定 Dashboard 的监听的端口
dashboard_port = 7500

# 指定访问 Dashboard 的用户名
dashboard_user = admin

# 指定访问 Dashboard 的端口
dashboard_pwd = admin
```

其次重新启动 FRP 服务端：

```
$ ./frps -c ./frps.ini

2018/01/25 16:39:29 [I] [service.go:96] frps tcp listen on 0.0.0.0:7000
2018/01/25 16:39:29 [I] [service.go:125] http service listen on 0.0.0.0:8080
2018/01/25 16:39:29 [I] [service.go:164] Dashboard listen on 0.0.0.0:7500
2018/01/25 16:39:29 [I] [main.go:112] Start frps success
2018/01/25 16:39:29 [I] [main.go:114] PrivilegeMode is enabled, you should pay more attention to security issues
```

最后通过 `http://[server_addr]:7500` 访问 Dashboard 界面，用户名密码默认都为 admin。

[![img](https://www.hi-linux.com/img/linux/frp1.png)](https://www.hi-linux.com/img/linux/frp1.png)

[![img](https://www.hi-linux.com/img/linux/frp2.png)](https://www.hi-linux.com/img/linux/frp2.png)

#### 给 FRP 服务端加上身份验证

默认情况下只要知道 `FRP` 服务端开放的端口，任意 `FRP` 客户端都可以随意在服务端上注册端口映射，这样对于在公网上的 `FRP` 服务来说显然不太安全。`FRP` 提供了身份验证机制来提高 `FRP` 服务端的安全性。要启用这一特性也很简单，只需在 `FRP`服务端和 `FRP` 客户端的 common 配置中启用 `privilege_token` 参数就行。

```
[common]
privilege_token = 12345678
```

启用这一特性后，只有 `FRP` 服务端和 `FRP` 客户端的 common 配置中的 `privilege_token` 参数一致身份验证才会通过，`FRP` 客户端才能成功在 `FRP` 服务端注册端口映射。否则就会注册失败，出现类似下面的错误：

```
2018/01/25 17:29:27 [I] [proxy_manager.go:284] proxy removed: []
2018/01/25 17:29:27 [I] [proxy_manager.go:294] proxy added: [ssh web dns unix_domain_socket]
2018/01/25 17:29:27 [I] [proxy_manager.go:317] visitor removed: []
2018/01/25 17:29:27 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 17:29:27 [E] [control.go:230] authorization failed
2018/01/25 17:29:27 [W] [control.go:109] login to server failed: authorization failed
authorization failed
```

> 需要注意的是 `FRP` 客户端所在机器和 `FRP` 服务端所在机器的时间相差不能超过 15 分钟，因为时间戳会被用于加密验证中，防止报文被劫持后被其他人利用。这个超时时间可以在配置文件中通过 `authentication_timeout` 这个参数来修改，单位为秒，默认值为 900，即 15 分钟。如果修改为 0，则 `FRP` 服务端将不对身份验证报文的时间戳进行超时校验。

#### FRP 客户端热加载配置文件

当修改了 `FRP` 客户端中的配置文件，从 0.15 版本开始可以通过 `frpc reload` 命令来动态加载配置文件，通常会在 10 秒内完成代理的更新。

启用此功能需要在 `FRP` 客户端配置文件中启用 admin 端口，用于提供 `API` 服务。配置如下：

```
$ vim frpc.ini

[common]
admin_addr = 127.0.0.1
admin_port = 7400
```

重启 `FRP` 客户端，以后就可通过热加载方式进行 `FRP` 客户端配置变更了。

```
$ ./frpc -c ./frpc.ini
2018/01/25 18:04:25 [I] [proxy_manager.go:326] visitor added: []
2018/01/25 18:04:25 [I] [control.go:240] [3653b9a878f8acc7] login to server success, get run id [3653b9a878f8acc7], server udp port [0]
2018/01/25 18:04:25 [I] [service.go:49] admin server listen on 127.0.0.1:7400
2018/01/25 18:04:25 [I] [control.go:165] [3653b9a878f8acc7] [ssh] start proxy success
2018/01/25 18:04:25 [I] [control.go:165] [3653b9a878f8acc7] [web] start proxy success
2018/01/25 18:04:25 [I] [control.go:165] [3653b9a878f8acc7] [dns] start proxy success
2018/01/25 18:04:25 [I] [control.go:165] [3653b9a878f8acc7] [unix_domain_socket] start proxy success

$ ./frpc reload -c ./frpc.ini
reload success
```

等待一段时间后客户端会根据新的配置文件创建、更新、删除代理。

> - 需要注意的是 [common] 中的参数除了 start 外目前无法被修改。

启用 `admin_addr` 后，还可以通过 `frpc status -c ./frpc.ini` 命令在 FRP 客户端很方便的查看当前代理状态信息。

```
$ ./frpc status -c ./frpc.ini

Proxy Status...
TCP
Name                Status   LocalAddr     Plugin              RemoteAddr           Error
ssh                 running  127.0.0.1:22                      4.3.2.1:6000
unix_domain_socket  running                unix_domain_socket  4.3.2.1:6002

UDP
Name  Status   LocalAddr   Plugin  RemoteAddr           Error
dns   running  8.8.8.8:53          4.3.2.1:6001

HTTP
Name  Status   LocalAddr     Plugin  RemoteAddr              Error
web   running  127.0.0.1:80          mike.hi-linux.com:8080
```

#### 给 FRP 服务端增加端口白名单

为了防止 `FRP` 端口被滥用，`FRP` 提供了指定允许哪些端口被分配的功能。可通过 `FRP` 服务端的配置文件中 `privilege_allow_ports`参数来指定：

```
$ vim frps.ini

[common]
privilege_allow_ports = 2000-3000,3001,3003,4000-5000
```

> `privilege_allow_ports` 可以配置允许使用的某个指定端口或者是一个范围内的所有端口，以 , 分隔，指定的范围以 - 分隔。

当使用不允许的端口注册时，就会注册失败。出现类似以下错误：

```
$ ./frpc status -c ./frpc.ini
Proxy Status...
TCP
Name                Status       LocalAddr     Plugin              RemoteAddr            Error
ssh                 start error  127.0.0.1:22                      4.3.2.1:60000  port not allowed
unix_domain_socket  start error                unix_domain_socket  4.3.2.1:60002  port not allowed
```

#### 启用 TCP 多路复用

从 v0.10.0 版本开始，客户端和服务器端之间的连接支持多路复用，不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 `FRP` 可以承载更高的并发数。

该功能默认启用，如需关闭可以在 `FRP` 服务端配置文件和 `FRP` 客户端配置文件中配置，该配置项在服务端和客户端必须一致：

```
# frps.ini 和 frpc.ini 中
[common]
tcp_mux = false
```

#### FRP 底层通信启用 KCP 协议

FRP 从 v0.12.0 版本开始，底层通信协议支持选择 `KCP` 协议，在弱网络环境下传输效率会提升明显，但是会有一些额外的流量消耗。

要开启 `KCP` 协议支持，首先要在 `FRP` 服务端配置文件中启用 `KCP` 协议支持：

```
$ vim frps.ini
[common]
bind_port = 7000
# 指定一个 UDP 端口用于接收客户端请求 KCP 绑定的是 UDP 端口，可以和 bind_port 一样
kcp_bind_port = 7000
```

其次是在 `FRP` 客户端配置文件指定需要使用的协议类型，目前只支持 `TCP` 和 `KCP`。其它代理配置不需要变更：

```
$ vim  frpc.ini
[common]
server_addr = 4.3.2.1
# server_port 指定为 FRP 服务端里 kcp_bind_port 指定的端口
server_port = 7000
# 指定需要使用的协议类型，默认类型为 TCP
protocol = kcp
```

> - 需要注意开放相关机器上的 UDP 端口的访问权限。

#### 给 FRP 服务端配置连接池

默认情况下，当用户请求建立连接后，`FRP` 服务端才会请求 `FRP` 客户端主动与后端服务建立一个连接。

当为指定的 `FRP` 服务端启用连接池功能后，`FRP` 会预先和后端服务建立起指定数量的连接，每次接收到用户请求后，会从连接池中取出一个连接和用户连接关联起来，避免了等待与后端服务建立连接以及 `FRP` 客户端 和 `FRP` 服务端之间传递控制信息的时间。

首先需要在 `FRP` 服务端配置文件中设置每个代理可以创建的连接池上限，避免大量资源占用，客户端设置超过此配置后会被调整到当前值：

```
$ vim frps.ini
[common]
max_pool_count = 5
```

其次在 `FRP` 客户端配置文件中为客户端启用连接池，指定预创建连接的数量：

```
$ vim frpc.ini
[common]
pool_count = 1
```

> - 此功能比较适合有大量短连接请求时开启。

#### 加密与压缩

如果公司内网防火墙对外网访问进行了流量识别与屏蔽，例如禁止了 `SSH` 协议等，可通过设置 use_encryption = true，将 `FRP` 客户端 与 `FRP` 服务端之间的通信内容加密传输，将会有效防止流量被拦截。

如果传输的报文长度较长，通过设置 use_compression = true 对传输内容进行压缩，可以有效减小 `FRP` 客户端 与 `FRP` 服务端之间的网络流量，来加快流量转发速度，但是会额外消耗一些 CPU 资源。

这两个功能默认是不开启的，需要在 `FRP` 客户端配置文件中通过配置来为指定的代理启用加密与压缩的功能，压缩算法使用的是 snappy。

```
$ vim frpc.ini

[ssh]
type = tcp
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true
```

#### 通过 FRP 客户端代理其它内网机器访问外网

`FRP` 客户端内置了 `http_proxy` 和 `socks5` 插件，通过这两个插件可以使其它内网机器通过 `FPR` 客户端的的网络访问互联网。

要启用此功能，首先需要在 `FRP` 客户端配置文件中启用相关插件，这里以 `http_proxy` 插件为例：

```
$ vim frpc.ini

[common]
server_addr = 4.3.2.1
server_port = 7000

[http_proxy]
type = tcp
remote_port = 6000
plugin = http_proxy
```

其次将需要通过这个代理访问外网的内部机器的代理地址设置为 4.3.2.1:6000，这样就可以通过 FRP 客户端机器的网络访问互联网了。

> - `http_proxy` 插件也支持认证机制，如果需要启用认证可通过配置参数 `plugin_http_user` 和 `plugin_http_passwd` 启用。
> - 如需启用 `Socks5` 代理，只需将 plugin 的值更换为 socks5 即可。

#### 通过代理连接 FRP 服务端

在只能通过代理访问外网的环境内，`FRP` 客户端支持通过 `HTTP_PROXY` 参数来配置代理和 `FRP` 服务端进行通信。要使用此功能可以通过设置系统环境变量 `HTTP_PROXY` 或者通过在 `FRP` 客户端的配置文件中设置 `http_proxy` 参数来使用此功能。

```
$ vim frpc.ini

[common]
server_addr = 4.3.2.1
server_port = 7000
protocol = tcp
http_proxy = http://user:pwd@4.3.2.2:8080
```

> - 仅在 `protocol = tcp` 时生效，暂时不支持 kcp 协议。

#### 安全地暴露内网服务

对于一些比较敏感的服务如果直接暴露于公网上将会存在安全隐患，`FRP` 也提供了一种安全的转发方式 `STCP`。使用 `STCP`(secret tcp) 类型的代理可以避免让任何人都能访问到穿透到公网的内网服务，要使用 `STCP` 模式访问者需要单独运行另外一个 `FRP` 客户端。

下面就以创建一个只有自己能访问到的 `SSH` 服务代理为例，`FRP` 服务端和其它的部署步骤相同，主要区别是在 `FRP` 客户端上。

首先配置 `FRP` 客户端，和常规 `TCP` 转发不同的是这里不需要指定远程端口。

```
$ vim frpc.ini
[common]
server_addr = 4.3.2.1
server_port = 7000

[secret_ssh]
type = stcp
# 只有 sk 一致的用户才能访问到此服务
sk = abcdefg
local_ip = 127.0.0.1
local_port = 22
```

其次在要访问这个服务的机器上启动另外一个 `FRP` 客户端，配置如下：

```
$ vim frpc.ini
[common]
server_addr = 4.3.2.1
server_port = 7000

[secret_ssh_visitor]
type = stcp
# STCP 的访问者
role = visitor
# 要访问的 STCP 代理的名字，和前面定义的相同。
server_name = secret_ssh
# 和前面定义的要一致
sk = abcdefg
# 绑定本地端口用于访问 ssh 服务
bind_addr = 127.0.0.1
bind_port = 6005
```

最后在本机启动一个 `FRP` 客户端，这样就可以通过本机 6005 端口对内网机器 `SSH` 服务进行访问，假设用户名为 mike：

```
$ ./frpc -c ./frpc.ini
2018/01/26 15:03:24 [I] [proxy_manager.go:284] proxy removed: []
2018/01/26 15:03:24 [I] [proxy_manager.go:294] proxy added: []
2018/01/26 15:03:24 [I] [proxy_manager.go:317] visitor removed: []
2018/01/26 15:03:24 [I] [proxy_manager.go:326] visitor added: [secret_ssh_visitor]
2018/01/26 15:03:24 [I] [control.go:240] [60d2af2f68196537] login to server success, get run id [60d2af2f68196537], server udp port [0]
2018/01/26 15:03:24 [I] [proxy_manager.go:235] [60d2af2f68196537] try to start visitor [secret_ssh_visitor]
2018/01/26 15:03:24 [I] [proxy_manager.go:243] [secret_ssh_visitor] start visitor success

$ ssh -oPort=6005 mike@127.0.0.1
```

#### 点对点内网穿透

在传输大量数据时如果都经过服务器中转的话，这样会对服务器端带宽压力比较大。`FRP` 提供了一种新的代理类型 `XTCP`来解决这个问题，`XTCP` 模式下可以在传输大量数据时让流量不经过服务器中转。

使用方式同 `STCP` 类似，需要在传输数据的两端都部署上 `FRP` 客户端上用于建立直接的连接。

首先在 `FRP` 服务端配置上增加一个 `UDP` 端口用于支持该类型的客户端:

```
$ vim frps.ini
bind_udp_port = 7001
```

其次配置 `FRP` 客户端，和常规 `TCP` 转发不同的是这里不需要指定远程端口。

```
$ vim frpc.ini

[common]
server_addr = 4.3.2.1
server_port = 7000

[p2p_ssh]
type = xtcp
# 只有 sk 一致的用户才能访问到此服务
sk = abcdefg
local_ip = 127.0.0.1
local_port = 22
```

然后在要访问这个服务的机器上启动另外一个 `FRP` 客户端，配置如下：

```
$ vim frpc.ini
[common]
server_addr = 4.3.2.1
server_port = 7000

[p2p_ssh_visitor]
type = xtcp
# XTCP 的访问者
role = visitor
# 要访问的 XTCP 代理的名字
server_name = p2p_ssh
sk = abcdefg
# 绑定本地端口用于访问 ssh 服务
bind_addr = 127.0.0.1
bind_port = 6006
```

最后在本机启动一个 FRP 客户端，这样就可以通过本机 6006 端口对内网机器 SSH 服务进行访问，假设用户名为 mike：

```
$ ./frpc -c ./frpc.ini

2018/01/26 16:01:52 [I] [proxy_manager.go:326] visitor added: [p2p_ssh_visitor secret_ssh_visitor]
2018/01/26 16:01:52 [I] [control.go:240] [7c7e06878e11cc3c] login to server success, get run id [7c7e06878e11cc3c], server udp port [7001]
2018/01/26 16:01:52 [I] [proxy_manager.go:235] [7c7e06878e11cc3c] try to start visitor [p2p_ssh_visitor]
2018/01/26 16:01:52 [I] [proxy_manager.go:243] [p2p_ssh_visitor] start visitor success
2018/01/26 16:01:52 [I] [proxy_manager.go:235] [7c7e06878e11cc3c] try to start visitor [secret_ssh_visitor]
2018/01/26 16:01:52 [I] [proxy_manager.go:243] [secret_ssh_visitor] start visitor success

$ ssh -oPort=6006 mike@127.0.0.1
```

> - 目前 `XTCP` 模式还处于开发的初级阶段，并不能穿透所有类型的 `NAT` 设备，所以穿透成功率较低。穿透失败时可以尝试 `STCP` 的方式。

### FRP 管理

`FRP` 的部署安装比较简单，项目官方也没有提供相应的管理脚本。不过好在开源项目总是有网友热心提供部署和管理脚本。如果你觉得手动部署太麻烦，还可以使用下面的一键安装脚本。

项目地址：<https://github.com/clangcn/onekey-install-shell/>

#### 下载一键部署脚本

```
$ wget --no-check-certificate https://raw.githubusercontent.com/clangcn/onekey-install-shell/master/frps/install-frps.sh -O ./install-frps.sh
$ chmod 700 ./install-frps.sh
```

#### 安装 FRP 服务端

这个一键部署脚本比较好用，为了提高国内用户下载安装包速度还提供了阿里云节点的安装源。整个脚本使用起来也比较简单，对一些常用的 `FRP` 服务端配置参数都做了交互式选择让用户可以方便的根据自己实际情况进行选择。脚本比较贴心的一点是对默认的公网地址进行了检测，省去了手动输入的麻烦。

```
$ ./install-frps.sh install

Please select frps download url:
[1].aliyun (default)
[2].github
Enter your choice (1, 2 or exit. default [aliyun]):
---------------------------------------
Your select: aliyun
---------------------------------------
Loading network version for frps, please wait...
frps Latest release file frp_0.15.1_linux_amd64.tar.gz
Loading You Server IP, please wait...
You Server IP:12.34.56.78
Please input your server setting:

Please input frps bind_port [1-65535](Default Server Port: 5443):7000
frps bind_port: 7000

Please input frps vhost_http_port [1-65535](Default vhost_http_port: 80):8080
frps vhost_http_port: 8080

Please input frps vhost_https_port [1-65535](Default vhost_https_port: 443):
frps vhost_https_port: 443

Please input frps dashboard_port [1-65535](Default dashboard_port: 6443):7500
frps dashboard_port: 7500

Please input dashboard_user (Default: admin):
frps dashboard_user: admin

Please input dashboard_pwd (Default: IY0p1bOg):admin
frps dashboard_pwd: admin

Please input privilege_token (Default: 9BqswPpd1R0TfGR5):mike
frps privilege_token: mike

Please input frps max_pool_count [1-200]
(Default max_pool_count: 50):
frps max_pool_count: 50

##### Please select log_level #####
1: info (default)
2: warn
3: error
4: debug
#####################################################
Enter your choice (1, 2, 3, 4 or exit. default [1]):
log_level: info

Please input frps log_max_days [1-30]
(Default log_max_days: 3 day):
frps log_max_days: 3

##### Please select log_file #####
1: enable (default)
2: disable
#####################################################
Enter your choice (1, 2 or exit. default [1]):
log_file: enable

##### Please select tcp_mux #####
1: enable (default)
2: disable
#####################################################
Enter your choice (1, 2 or exit. default [1]):
tcp_mux: true

##### Please select kcp support #####
1: enable (default)
2: disable
#####################################################
Enter your choice (1, 2 or exit. default [1]):
kcp support: true

============== Check your input ==============
You Server IP      : 12.34.56.78
Bind port          : 7000
kcp support        : true
vhost http port    : 8080
vhost https port   : 443
Dashboard port     : 7500
Dashboard user     : admin
Dashboard password : admin
Privilege token    : mike
tcp_mux            : true
Max Pool count     : 50
Log level          : info
Log max days       : 3
Log file           : enable
==============================================

Press any key to start...or Press Ctrl+c to cancel

frps install path:/usr/local/frps
config file for frps ... done
download frps ... done
download /etc/init.d/frps... done
setting frps boot... done

+--------------------------------------------------+
|        Manager for Frps, Written by Clang        |
+--------------------------------------------------+
| Intro: http://koolshare.cn/thread-65379-1-1.html |
+--------------------------------------------------+

Starting Frps(0.15.1)... done
Frps (pid 3325)is running.

+---------------------------------------------------------+
|        frps for Linux Server, Written by Clang          |
+---------------------------------------------------------+
|     A tool to auto-compile & install frps on Linux      |
+---------------------------------------------------------+
|    Intro: http://koolshare.cn/thread-65379-1-1.html     |
+---------------------------------------------------------+


Congratulations, frps install completed!
==============================================
You Server IP      : 12.34.56.78
Bind port          : 7000
KCP support        : true
vhost http port    : 8080
vhost https port   : 443
Dashboard port     : 7500
Privilege token    : mike
tcp_mux            : true
Max Pool count     : 50
Log level          : info
Log max days       : 3
Log file           : enable
==============================================
frps Dashboard     : http://12.34.56.78:7500/
Dashboard user     : admin
Dashboard password : admin
==============================================
```

#### 配置 FRP 服务端

```
$ ./install-frps.sh config
```

#### 更新 FRP 服务端

```
$ ./install-frps.sh update
```

#### 卸载 FRP 服务端

```
$ ./install-frps.sh uninstall
```

#### FRP 服务端日常管理

`FRP` 服务端安装完成后，一键部署脚本还提供了一个日常管理 `FRP` 服务端的管理脚本来进行日常的启动、重启、停止等操作，非常的方便。

```
Usage: /etc/init.d/frps {start|stop|restart|status|config|version}
```

### 参考文档

[http://www.google.com](http://www.google.com/)
<https://github.com/fatedier/frp>
<http://koolshare.cn/thread-65379-1-1.html>