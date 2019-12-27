---
title: jwt简介
mathjax: true
date: 2019-12-22 23:53:56
tags: [jwt,java]
category: [java]
---

### 什么是JWT

jwt全称是JSON Web Tokens，是一个开放标准，它能够独立定义一个用json对象进行安全的多方信息传输，信息可以被验证和可信因为它拥有数字签名。jwt可以用加密算法(如HMAC)或者公钥私钥（RSA/ECDSA）进行签名。

<!--more-->

### JWT原理

传统的身份认证使用cookies或者session进行，用户向服务器发送账号密码，服务器验证后，在session中存储用户相关信息，服务端向客户端返回session_id，写入用户cookie；之后的每一次请求，用户都会通过cookie将session_id传回服务端，服务端收到session_id，验证是否存在于保存的数据中，以此验证用户身份。

这种方法存在弊端，就是扩展性问题。单机的时候没有问题，当使用服务器集群，每一台机器都要能够共享session数据。

JWT 的原理是，服务器认证以后，生成一个 JSON 对象，发回给用户，就像下面这样。

> ```javascript
> {
>   "姓名": "张三",
>   "角色": "管理员",
>   "到期时间": "2018年7月1日0点0分"
> }
> ```

以后，用户与服务端通信的时候，都要发回这个 JSON 对象。服务器完全只靠这个对象认定用户身份。为了防止用户篡改数据，服务器在生成这个对象的时候，会加上签名（详见后文）。

服务器就不保存任何 session 数据了，也就是说，服务器变成无状态了，从而比较容易实现扩展。

### JWT数据结构

jwt一般来说是一个很长的字符串，由三部分组成，中间由(`.`)分隔：

```
xxxxx.yyyyy.zzzzz
```

JWT的三部分分别是：

1. Header(头部)
2. Payload(负载)
3. Signature(签名)

#### 1.Header

header部分是一个json对象，描述JWT的元信息，一般来说包含两个部分，token的类型（一般来说是JWT）和签名算法，示意如下：

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

之后，这段json被Base64编码后，作为JWT的第一部分

#### 2. Payload

第二部分是payload，包含各种声明，包含三种声明：注册声明，公开声明，私有声明

* 注册声明：包含以下七种

iss (issuer)：签发人

exp (expiration time)：过期时间

sub (subject)：主题

aud (audience)：受众

nbf (Not Before)：生效时间

iat (Issued At)：签发时间

jti (JWT ID)：编号

* 公开声明：可以在 [IANA JSON Web Token Registry](https://www.iana.org/assignments/jwt/jwt.xhtml)中注册相关声明，以避免冲突

* 私有声明：订制的信息分享字段

  ```javascript
  {
    "sub": "1234567890",
    "name": "John Doe",
    "admin": true
  }
  ```

注意，JWT默认是不加密的，所有人都可以读到，因此不要将私密信息放在payload中

#### 3. Signature

创建签名，需要有编码过的header信息，payload信息和秘钥信息，以及特定的加密算法，如下：

```
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```

签名的目的是验证信息，保证信息不被更改，如果是用的公钥私钥的形式，还可以验证信息的发送方是否为生命的发送方

### JWT如何工作

在用户认证中，当用户成功登陆，服务端创建一个JSON Web Token并返回。当用户再次请求时，用户发送JWT信息，可以放在cookie中，不过这样无法跨域，放在头部的Authorization字段中，这样是可以跨域的

```
Authorization: Bearer <token>
```

