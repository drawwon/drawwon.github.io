---
title: docker常用命令
mathjax: true
date: 2018-09-09 11:55:11
tags:
category:

---

从docker hub下载一个image

```sh
docker pull name:version
```

运行一个docker，开启其bash

```sh
docker run -it ubuntu:18.04 bash
```

其中`-i`表示交互式，`-t`表示建立一个虚拟的terminal

继续运行一个已经退出的docker

```sh
docker start  `docker ps -q -l` # restart it in the background
docker attach `docker ps -q -l` # reattach the terminal & stdin
```

### `exec` 命令

#### -i -t 参数

`docker exec` 后边可以跟多个参数，这里主要说明 `-i` `-t` 参数。

只用 `-i` 参数时，由于没有分配伪终端，界面没有我们熟悉的 Linux 命令提示符，但命令执行结果仍然可以返回。

当 `-i` `-t` 参数一起使用时，则可以看到我们熟悉的 Linux 命令提示符。

```
$ docker run -dit ubuntu
69d137adef7a8a689cbcb059e94da5489d3cddd240ff675c640c8d96e84fe1f6

$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
69d137adef7a        ubuntu:latest       "/bin/bash"         18 seconds ago      Up 17 seconds                           zealous_swirles

$ docker exec -i 69d1 bash
ls
bin
boot
dev
...

$ docker exec -it 69d1 bash
root@69d137adef7a:/#
```

如果从这个 stdin 中 exit，不会导致容器的停止。这就是为什么推荐大家使用 `docker exec` 的原因。

更多参数说明请使用 `docker exec --help` 查看。



**DOCKER 给运行中的容器添加映射端口**

**方法1**

**1、获得容器IP**

将container_name 换成实际环境中的容器名

```
docker inspect `container_name` | grep IPAddress
```

**2、 iptable转发端口**

将容器的8000端口映射到docker主机的8001端口

复制代码代码如下:

iptables -t nat -A  DOCKER -p tcp --dport 8001 -j DNAT --to-destination 172.17.0.19:8000

**方法2**

1.提交一个运行中的容器为镜像

```
docker commit containerid foo/live
```

2.运行镜像并添加端口

```
docker run -d -p 8000:80 foo/live /bin/bash
```

以上就是本文的全部内容，希望对大家的学习有所帮助，也希望大家多多支持脚本之家。