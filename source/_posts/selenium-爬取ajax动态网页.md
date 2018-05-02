---
title: selenium 爬取ajax动态网页
date: 2018-04-16 13:07:26
tags: [python,爬虫]
category: [编程练习,python]
---

最近有一个爬取教育部数据库的任务，一开始用了requests库，能获取到网页验证码什么的，但是各种的ajax动态加载太麻烦了，最后想到了用selenium进行爬取

初始化webdriver，用chrome进行爬取，此时需要下载chrome的驱动，[下载地址](http://chromedriver.storage.googleapis.com/index.html)

```python
url1 = 'https://isisn.nsfc.gov.cn/egrantindex/funcindex/prjsearch-list'
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select

browser = webdriver.Chrome()
browser.get(url1)
```

接下来填充网页内容，因为有ajax动态加载的部分，我们填入一部分之后需要等待一会，用time.sleep(0.5)等0.5秒就行了

```python
browser.find_element_by_name('subjectCode').click()
browser.find_element_by_name('subjectCode').send_keys('F030203')
time.sleep(0.5)
browser.find_element_by_name('subjectCode').send_keys(Keys.RETURN)
```

然后对下拉选择的内容用Select对象进行选择

```python
s1 = Select(browser.find_element_by_id('f_grantCode'))
s1.select_by_index(1)
s2 = Select(browser.find_element_by_id('f_year'))
s2.select_by_value('2017')
```

用pytesseract进行验证码识别，在安装pytesseract之后，还要安装Tesseract-OCR这个程序，在安装完成之后，只需要    一句`code = pytesseract.image_to_string(im)`就可以进行验证码识别，这样识别的精度并不高，因此我们需要用try ，except来catch意外

```python
import pytesseract

def get_captcha(browser):
    browser.get_screenshot_as_file('screenshot.jpg')
    element = browser.find_element_by_id('img_checkcode')
    left = int(element.location['x'])
    top = int(element.location['y'])
    right = int(element.location['x'] + element.size['width'])
    bottom = int(element.location['y'] + element.size['height'])
    im = Image.open('screenshot.jpg')
    im = im.crop((left, top, right, bottom))
    im.save('screenshot.jpg')
    im = Image.open('screenshot.jpg')
    pytesseract.pytesseract.tesseract_cmd = 'C:\\Program Files (x86)\\Tesseract-OCR\\tesseract'
    code = pytesseract.image_to_string(im)
    return code
```

输入验证码，并保存网页。

```python
code = get_captcha(browser)
print(code)
browser.find_element_by_id('f_checkcode').send_keys(code)
browser.find_element_by_id('searchBt').click()
with open('my.html','w',encoding='utf-8') as f:
    f.write(browser.page_source)
```

如果验证失败，一直输入直到成功

```python
while True:
    try:
        if browser.find_element_by_id('f_checkcode'):
            code = get_captcha(browser)
            browser.find_element_by_id('f_checkcode').clear()
            browser.find_element_by_id('f_checkcode').send_keys(code)
            browser.find_element_by_id('searchBt').click()
    except:
        break
```

进入搜索结果之后需要点击下一页，直到最后一页，此时用到的方法就是通过看next button上面的class，直到class变成disable就可以停止了，用正则表达式，正则表达式搜不到的时候返回是None，但是好像返回的是字符串类型的None，判断是应该是 while re.search(xxx) is None

```python
def click_next_page():
    code = get_captcha(browser)
    browser.find_element_by_id('checkCode').send_keys(code)
    browser.find_element_by_css_selector('.ui-icon.ui-icon-seek-next').click()

while re.search('ui-state-disabled',browser.find_element_by_id('next_t_TopBarMnt').get_attribute("class")) is None:
    click_next_page()
```

然后把所有网页的内容用beautifulsoup进行解析就行了 

```python
soup = BeautifulSoup(browser.page_source,'lxml')
```

