---
title: hexo设置图片大小
mathjax: true
date: 2019-01-07 22:00:19
tags: [hexo]
category: [hexo]
---

在hexo中一般插入图片的方式为：

```
!(图片名称)[图片地址]
```

如果想要控制图片大小，可以用html的方式来插入图片

```
<img src="图片地址" width="50%" height="50%"  style="margin: 0 auto;"/>
```

其中后面的`style="margin:0 auto;"`用来控制图片的居中，图片大小有width和height控制，可以输入50%这样的比例，也可以直接输入大小200px这样的值