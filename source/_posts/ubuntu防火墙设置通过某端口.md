---
title: ubuntu防火墙设置通过某端口
date: 2017-12-05 21:00:34
tags: [linux防火墙]
category: [linux]
---

在启动项里加入以下命令行，修改 `/etc/rc.local `

`` iptables -I INPUT -p tcp --dport 8888 -j ACCEPT` 