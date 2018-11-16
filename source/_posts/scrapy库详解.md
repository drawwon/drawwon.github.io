---
title: scrapy库详解
date: 2017-08-13 22:37:17
tags: [scrapy,爬虫,python]
category: [编程学习]
---

`scrapy`是一个完整的爬虫框架，一共有5个部分组成和2个中间部分，最主要的是一下五个部分：

1. ENGINE
2. SCHEDULER
3. ITEM PIPELINES
4. SPIDERS
5. DOWNLOADER

<!--more-->

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-14/88536273.jpg)

用户主要编写spider和item pipelines，其余三个模块是事先写好的，不需要修改

可以通过修改downloader middleware中间键来对engine，scheduler和Downloader进行配置

scrapy通过命令行运行

```
scrapy command [options] [args]
```

scrapy有6个常用命令

1. **startproject**：创建一个新的工程
2. **genspider**：创建一个爬虫
3. settings：获得爬虫配置信息
4. **crawl**：运行一个爬虫
5. list：列出工程中所有爬虫
6. shell：启动url调试命令行

建立一个scrapy工程的方法

```
scrapy startproject python123demo
```

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/17-8-14/62349910.jpg)

建立完成之后可以看到的文件夹下产生了一个名为python123的文件，进入该文件可以看到一个`scrapy.cfg`的文件，这是一个部署scrapy的配置文件

```
│ scrapy.cfg
│
└─python123demo
    │  items.py
    │  middlewares.py
    │  pipelines.py
    │  settings.py
    │  __init__.py
    │
    └─spiders
            __init__.py
```

文件树目录如下， 在windows中通过`tree /F python123demo`查看



使用如下命令生成名为demo的爬虫，爬取的网页为python123.io

`scrapy genspider demo python123.io`

产生的demo.py如下

```python
import scrapy


class DemoSpider(scrapy.Spider):
    name = 'demo'
    allowed_domains = ['python123.io']
    start_urls = ['http://python123.io/']

    def parse(self, response):
        pass
```



scrapy的**request**类里面有一下几个方法：

1. .url：request对应的请求url地址
2. .method：对应的请求方法，'GET','POST'等等
3. .headers：字典类型的请求头
4. .body：请求内容主体，字符串类型
5. .meta：用户添加的扩展信息，在scrapy内部模块间传递信息使用
6. .copy()：复制该请求



**Rsponse**类7个常用方法：

1. .url：response对应的url地址
2. .status：状态码，默认是200
3. .headers：response头部信息
4. .body:response对应的内容信息，字符串类型
5. .flags：一组标记
6. request：产生Response类型对应的request对象
7. .copy():复制该响应




## 实例

爬取股票数据

### 步骤一

```shell
scrapy startproject BaiduStocks
cd BaiduStocks
scrapy genspider stocks baidu.com
```

### 步骤二

修改spider文件夹下的stocks.py文件

```python
import scrapy
import re

class StocksSpider(scrapy.Spider):
    name = 'stocks'
    start_urls = ['http://quote.eastmoney.com/stocklist.html']

    def parse(self, response):
        for href in response.css('a::attr(href)').extract():
            try:
                stock = re.findall(r"[s][hz]\d{6}", href)[0]
                url = 'https://gupiao.baidu.com/stock/' + stock + '.html'
                yield scrapy.Request(url, callback=self.parse_stock)
            except:
                continue

    def parser_stock(self,response):
        infodict = {}
        stockInfo = response.css('.stock-bets')
        name = stockInfo.css('.bets-name').extract()[0]
        keyList = stockInfo.css('dt').extract()
        ValueList = stockInfo.css('dd').extract()
        for i in range(len(keyList)):
            key = re.findall(r'>.*</dt>',keyList[i])[0][1:-5]
            try:
                val = re.findall(r'\d+\.?.*</dd>',ValueList[i])[0][0:-5]
            except:
                val = '--'
            infodict[key] = val
            # infodict['股票名称'] = name
        infoDict.update(
            {'股票名称': re.findall('\s.*\(', name)[0].split()[0] + \
                        re.findall('\>.*\<', name)[0][1:-1]})
        yield infodict
```

通过东方财富网获得stock的代码，然后同过百度股票爬取信息，其中parse和perser_stock函数都通过yield变成生成器

### 第三步

更改pipeline.py，用于数据处理，定义一个新的处理数据的类称为BaiduStockInfoPipeline，定义open_spider，close_spider，以及process_item三个函数

```python
class BaiduStockInfoPipeline(object):
    def open_spider(self,spider):
        self.f = open('BaiduStockInfo.txt','w')

    def close_spider(self,spider):
        self.f.close()

    def process_item(self,item,spider):
        try:
            line = str(dict(item)) + '\n'
            self.f.write(line)
        except:
            pass
        return item
```

### 第四步

修改settings.py，把ITEM_PIPELINES里面用到的类改为自己定义的BaiduStockInfoPipeline：

```python
ITEM_PIPELINES = {
   'BaiduStocks.pipelines.BaiduStockInfoPipeline': 300,
}
```






