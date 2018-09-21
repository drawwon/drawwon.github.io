---
title: scrapy实战伯乐网文章爬虫
date: 2017-09-18 08:54:43
tags: [python,爬虫]
category: [编程练习]

---

# scrapy实战伯乐网爬虫

因为我们要对scrapy进行调试，所以我们建立一个main函数来达到调试的目的，以后每次调试只要debug这个main文件就行了

<!--more-->

```python
from scrapy.cmdline import execute
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

execute(["scrapy", 'crawl', 'jobbole'])
```

在spider文件夹中初始化爬虫之后，可以看到一个parse函数，这个是用来处理具体的网页内容的，可以用Xpath对网页源码进行解析，其中的`response`参数表示scrapy返回的网页

我们要爬取所有的文章，就要先找到所有文章的存放地点，我们将`class JobboleSpider`里面的`start_urls`改为`http://blog.jobbole.com/all-posts/`，这个页面存放了所有的posts内容

从第一页开始，每次爬取该页所有posts的链接，进入每一个链接进行处理，要处理一个链接，就是将这个链接`yield`出来，首先我们先编写在每一页中提取出所有posts的方法，在parse函数中，先找到所有存放posts文件的地方：通过chrome的元素选择快捷键（如下图所示），找到所有的存放posts文件的链接

```python
response_nodes = response.css('#archive .floated-thumb .post-thumb a')
```

![](http://ooi9t4tvk.bkt.clouddn.com/17-9-10/51186543.jpg)

然后我们在找到的response_nodes中进行循环，并找到其中的首页图片地址和post地址，并将posts地址yield出去，交给`scrapy.http.Request`处理：

```python
for response_node in response_nodes:
    post_url = response_node.css('::attr(href)').extract_first(default="")
    image_url = response_node.css('img::attr(src)').extract_first(default="")
    yield Request(url=post_url, meta={'front_image_url':image_url},
                  callback=self.parse_detail)
```

其中的回调函数是用于具体处理网页内容的函数，meta用于传送首页的图片地址，传送的形式是字典的形式

接下来编写解析下一页的方法：

通过找到下一页这个标签的地址，来进行下一页的访问，首先我们通过css选择器选择出下一页的标签，如果存在下一页，那么我们就将下一页`yield`到Request来处理，回调函数就是这个函数本身：

```python
#jobbole.py  parse
next_page_url = response.css('a[class="next page numbers"]::attr(href)').extract_first(default="")
        if next_page_url:
            yield Request(url=next_page_url, callback=self.parse)
```

接下来完成具体的parse_detail函数，用于具体解析每一页的posts内容的函数：

首先拿出来meta里面的内容，为了防止意外报错，我们使用字典的get函数，并将默认值设置为空

```python
front_image_url = response.meta.get('front_image_url','')
```

然后通过css或者是xpath解析器依次解析自己需要的内容



接下来需要通过`items.py`建立自己的item，这个item就是你最后想要保存下来的数据：

默认系统会自动帮你建立一个跟工程名字一样的类，继承的是`scrapy.Item`，如果你自己需要一个新的item的话，只需要按照相同的方法，在`item.py`中新建一个类，继承`scrapy.Item`，然后把你需要的字段一个个定义出来，定义的方法是`字段名 = scrapy.Field()`，具体代码如下：

```python
#items.py
class JobBoleArticleItem(scrapy.Item):
    head = scrapy.Field()
    post_time = scrapy.Field()
    url = scrapy.Field()
    url_id = scrapy.Field()
    front_image_url = scrapy.Field()
    front_image_path = scrapy.Field()
    vote_num = scrapy.Field()
    comment_num = scrapy.Field()
    collection_num = scrapy.Field()
    tags = scrapy.Field()
    content = scrapy.Field()
```

然后我们需要在爬虫文件中引入定义的item，在`parse_detail`中实例化item类，并将每一个字段都赋上从网页上解析出来的值，赋值方法是类似于字典的赋值方法：

```python
#jobbole.py
from ..items import JobBoleArticleItem
def parse_detail():
  article_item = JobBoleArticleItem()
  article_item['url'] = response.url
  article_item['head'] = head
  yield article_item
```

剩余字段的赋值方法跟上面这两个是一样的，最后把item实例yield出来，交给`pipelines`处理，我们定义了一个专门用于处理图片的pipeline，继承的是`scrapy.pipelines.images.ImagesPipeline`，重构其中的`item_completed`函数，参数`results`中的value表示的是在`settings.py`中设置的跟`image`相关的参数，取出其中的`path`，赋值给`item['front_image_path']`，最后`return item`即可：

```python
#pipelines.py
class articleImagePipeline(ImagesPipeline):
    def item_completed(self, results, item, info):
        for ok,value in results:
            image_file_path = value['path']
            item['front_image_path'] = os.path.abspath(image_file_path)
        return item
```

在`settings.py`中取消掉`ITEM_PIPELINES`的注释，并增加新的自己定义的`articleImagePipeline`，后面的数字表示进入pipelines的顺序，数字越小，越早进入。

此时设置好`IMAGES_URLS_FIELD`，`IMAGES_STORE`，这样就可以开始下载图片

```python
#settings.py
ITEM_PIPELINES = {
   'bole.pipelines.BolePipeline': 300,
    # 'scrapy.pipelines.images.ImagesPipeline': 1,
    'bole.pipelines.articleImagePipeline': 1
}
IMAGES_URLS_FIELD = 'front_image_url'
IMAGES_STORE = '../IMAGES'
```

最后还有把url进行hash成固定长度的过程，建立一个python包叫做`utils`，里面建立一个`common.py`，在其中建立`get_md5`函数，其中的url要以utf8传入，所以一开始要检测其是不是unicode，python3里面的str就是unicode：

```python
#common.py
def get_md5(url):
    if isinstance(url, str):
        url = url.encode('utf8')
    m = hashlib.md5()
    m.update(url)
    return m.hexdigest()
```



接下来解决数据保存的问题，在这里我们使用两种方式，分别是：json文件和mysql数据库保存

I. json的保存

json保存有两种方式，一种是自己写json，一种是利用`scrapy.exporter`提供的`JsonItemExporter`类

①自定义`json`文件，先用codecs打开json文件（这样打开不会有编码错误问题），然后重写`process_item`方法，将item先dumps为json，其中设置`ensure_ascii=False`以支持中文，最后写一个close_spider方法，关闭文件

```python
import codecs, json

class MyjsonPipelines(object):
    #自定义的json导出
    def __init__(self):
      #打开文件
        self.file = codecs.open('myarticle.json', mode='w', encoding='utf8')
        
    def process_item(self, item, spider):
      #写入数据
        line = json.dumps(dict(item),ensure_ascii=False)
        self.file.write(line)
        return item
      
    def spider_close(self,spider):
      #关闭文件
        self.file.close()
```

②利用scrapy提供的`JsonItemExporter`，先定义打开的文件以及exporter，重写处理数据的方法process_item，最后关闭spider

```python
from scrapy.exporters import JsonItemExporter
class jsonPipelines(JsonItemExporter):
    #调用scrapy提供的json exporter来导出json文件
    def __init__(self):
        self.file = open('article.json', 'wb')
        self.exporter = JsonItemExporter(self.file, encoding='utf8', ensure_ascii=False)
        self.exporter.start_exporting()
        
    def close_spider(self):
        self.exporter.finish_exporting()
        self.file.close()
        
    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item
```



II. 写入mysql

写入MySQL同样有两种方法，第一种是自己写函数同步写入，第二种是利用`twisted.enterprise`框架提供的`adbapi`异步写入，第二种写入的方法更快，但也更复杂

①利用MySQLdb，建立连接，数据库部分可以参考之前写的[数据库基础教程](http://drawon.site/2017/05/11/%E6%95%B0%E6%8D%AE%E5%BA%93%E5%9F%BA%E7%A1%80%E6%95%99%E7%A8%8B/)

```python
import MySQLdb
class MysqlPipeline(object):
    def __init__(self):
      #建立连接和cursor
        self.conn = MySQLdb.connect(host='127.0.0.1', user='root', password='123456',
                                    database='scrapy', 			
                                    port=3306,charset='utf8',use_unicode=True)
        self.cursor = self.conn.cursor()
        
    def process_item(self, item, spider):
      #数据插入的sql语句并执行和提交(excecute & commit)
        insert_sql = """
            INSERT INTO article (head, post_time, url, url_id) VALUES (%s,%s,%s,%s)
        """
        self.cursor.execute(insert_sql,(item['head'],item['post_time'],item['url'],item['url_id']))
        self.conn.commit()
```

②利用`twisted.enterprise`提供的`adbapi`插入数据到mysql，这里用到了一个`@classmethod`的方法，主要是用于初始化类之前，先进行一个操作的函数，比如在这里我们在初始化`twisted_mysql_pipelines`之前，先连接了数据库，我们将连接数据库的参数都放在了`settings.py`里面，要将其取出来要用到`def from_settings(cls, settings)`，第二个参数是一个字典类型，取值可以通过字典的方法来取。

```python
from twisted.enterprise import adbapi
class twisted_mysql_pipelines(object):
    def __init__(self, dbpool):
        self.dbpool = dbpool

    @classmethod
    def from_settings(cls, settings):
      #连接数据库，返回dbpool
        dbparm = dict(host=settings['MYSQL_HOST'],
                      user=settings['MYSQL_USER'],
                      password=settings['MYSQL_PASSWORD'],
                      database=settings['MYSQL_DBNAME'],
                      cursorclass = MySQLdb.cursors.DictCursor,
                      charset='utf8',
                      use_unicode=True)
        dbpool = adbapi.ConnectionPool('MySQLdb', **dbparm)#建立连接池
        return cls(dbpool)

    def process_item(self, item, spider):
        query = self.dbpool.runInteraction(self.do_insert, item)#开始异步插入数据
        query.addErrback(self.error_handler)#处理异常

    def error_handler(self, error):
      #异常处理函数
        print(error)

    def do_insert(self, cursor, item):
      #插入数据的sql语句
        insert_sql = """
                    INSERT INTO article (head, post_time, url, url_id) VALUES (%s,%s,%s,%s)
                """
        cursor.execute(insert_sql, (item['head'], item['post_time'], item['url'], item['url_id']))
```

#### itemloader

之前的item是直接用字典的形式进行赋值的，如果使用itemloader会使得整个css查询过程看起来更加简洁清晰，具体使用方法如下：

①先在`item.py`中新建一个`myItemLoader`类，继承`scrapy.loader.ItemLoader`，修改其默认的输出处理函数为`TakeFirst()`(因为默认输出时一个列表，所以我们需要从里面取第一个)

```
item.py
from scrapy.loader import ItemLoader
from scrapy.loader.processors import TakeFirst
class myItemLoader(ItemLoader):
    default_output_processor = TakeFirst()
```

②在`jobbole.py`中的`parse_detail`函数中实例化item_loader，并使用`add_css`和`add_value`方法，分别直接添加值或者是通过css寻找值，

```
jobbole.py
from ..items import myItemLoader
from ..items import JobBoleArticleItem
def parse_detail(self,response):
    item_loader = myItemLoader(item=JobBoleArticleItem(),response=response)
    item_loader.add_css('head', '.entry-header h1::text')
    item_loader.add_value('url', response.url)
    item_loader.add_value('url_id', get_md5(response.url))
    item_loader.add_css('post_time','.entry-meta-hide-on-mobile::text')
    item_loader.add_css('comment_num','a[href="#article-comment"] span::text')
    item_loader.add_css('vote_num','.vote-post-up h10::text')
    item_loader.add_css('collection_num','span.bookmark-btn::text')
    item_loader.add_css('tags','p.entry-meta-hide-on-mobile a::text')
    front_image_url = response.meta.get('front_image_url','')
    item_loader.add_value('front_image_url',front_image_url)
    article_item = item_loader.load_item()
```

③此时通过css找出来的是原始的数据，需要在`item.py`中写处理方法

```python
item.py
from scrapy.loader.processors import MapCompose,TakeFirst,Join
import re
def post_time_handle(value):
    time_pattern = re.compile(r'\d{4}/\d{2}/\d{2}')
    match = re.findall(time_pattern, value.strip())
    if match:
        print(match)
        post_time = match[0]
        return post_time

def get_nums(value):
    match_re = re.match(".*?(\d+).*", value)
    if match_re:
        nums = int(match_re.group(1))
    else:
        nums = 0
    return nums

def remove_comment_tags(value):
    #去掉tag中提取的评论
    if "评论" in value:
        return ""
    else:
        return value
```

④修改`item.py`中`JobBoleArticleItem`类的`input_processor`，使其等于`MapCompose(function)`，其中tags用到的`output_processor`是`scrapy.loader.processors.Join`，将各个值用逗号连接起来

```python
class JobBoleArticleItem(scrapy.Item):
    head = scrapy.Field(input_processor = MapCompose(lambda x:x+'jobbole'))
    post_time = scrapy.Field(input_processor=MapCompose(post_time_handle))
    url = scrapy.Field()
    url_id = scrapy.Field()
    front_image_url = scrapy.Field()
    front_image_path = scrapy.Field()
    vote_num = scrapy.Field(input_processor=MapCompose(get_nums))
    comment_num = scrapy.Field(input_processor=MapCompose(get_nums))
    collection_num = scrapy.Field(input_processor=MapCompose(get_nums))
    tags = scrapy.Field(input_processor=MapCompose(remove_comment_tags),
                        output_processor=Join(','))
    content = scrapy.Field()

```









## Xpath语法

- `article`:选取所有article元素的所有子节点
- `/article`：选取根元素article
- `article/a`：选取属于article的子元素（只能是子节点，不能是后辈节点）的a元素
- `//div`：选取所有div子元素（不论出现在文档任何地方）
- `article//div`：选取所有属于article元素后代的div元素
- `//@class`：选取所有名为class的属性
- `/article/div[1]`：选取属于article子元素的第一个div元素
- `/article/div[last()]`：属于article的最后一个div
- `/article/div[last()-1]`：倒数第二个
- `//div[@lang]`：拥有lang属性的div元素
- `//div[@lang='eng']`：选取所有lang属性为eng的div元素
- `/div/*`：div元素的所有子节点
- `//*`：选取所有元素
- `//div[@*]`：所有带有属性的div元素
- `/div/a | //div/p`：所有div元素的a或p元素
- `//sapn | //ul`：所有文档中的span和ul元素
- `article/div/p | //span`：所有属于article元素的div元素的p元素以及文档中所有span元素



用xpath进行提取的方法类似于beautifulsoup，但是xpath的提取速度更快，提取的例子如下：

1、我要提取页面中的title信息，通过F12打开网页控制，点击选择元素，点中需要爬取的部分，可以找到他的源码，右键复制xpath或者是自己写xpath进行爬取(要爬取内容的话在xpath后面要加上/xpath)，之后通过extract()提取为列表，选择第[0]个元素，但是此时有可能列表为空，**所以使用`extract_first(default=0)`，表示提取第一个元素如果为空则返回0**，写法如下：

```python
head_selector = response.xpath('//*[@class="entry-header"]/h1/text()')
head = head_selector.extract()[0]


post_time_selector = response.xpath('//p[@class="entry-meta-hide-on-mobile"]/text()')
time_pattern = re.compile(r'\d{4}/\d{2}/\d{2}')
```

//*：表示选取所有的任意元素

//p：选取所有的p元素

//p[@class="dd"]：表示选取所有类为dd的p标签

//p[contains(@class,"dd")]：选取类名包含dd的p元素





### CSS选择器

- `*`：选择所有节点
- `#container`：选择id为container的节点
- `.container`：选取所有class中包含container的节点 
- `li a`：选取所有li下面的所有a节点
- `ul + p`：选取ul后面的第一个p元素
- `div#container > ul `：选取id为container的div的第一个ul子元素 
- `ul ~ p`：选取与ul相邻的所有p元素
- `a[title]`：选择所有有title属性的a元素
- `a[href="http://jobbole.com"]`：选取所有href属性为`http://jobbole.com`的a元素
- `a[href*="jobbole"]`：选取所有href属性包含jobbole的a元素
- `a[href^="http"]`：选取所有href以http开头的a元素
- `a[href$=".jpg"]`：选取所有href以.jpg结尾的a元素
- `input[type=radio]:checked`：选择选中的radio元素
- `div:not(#container)`：选择id不是container的div属性
- `li:nth-child(3)`：选取第三个li元素
- `tr:nth-child(2n)`：选择第偶数个tr

pycharm单步调试的快捷键是`F8`















