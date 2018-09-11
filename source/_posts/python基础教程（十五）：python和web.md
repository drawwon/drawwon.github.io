---
title: python基础教程（十五）：Python和Web
date: 2017-04-20 16:23:09
tags: [python]
category: [编程学习]

---

## 屏幕抓取

想要抓取网页信息，可以用urllib和正则表达式做到：
<!--more-->
```python
from urllib import urlopen
import re

p = re.compile('<h3><a .*?><a .*? href="(.*?)">(.*?)</a>')
text = urlopen('http://python.org/community/jobs').read()
for url, name in p.findall(text):
    print '%s (%s)'%(name, url)
```

正则表达式的模式相对固定，下面我们介绍Tidy和XHTML解析

### Tidy和XHTML解析

XHTML是HTML最新的方言，是XML的一种形式。

### tidy 是什么

tidy是用来修复不规范且有些随意的HTML文档的工具。

### XHTML和HTML区别

xhtml对显示关闭更加严格

