---
title: XML教程.md
date: 2017-06-10 20:20:09
tags: [XML]
category: [编程学习]

---

XML 指可扩展标记语言（e**X**tensible **M**arkup **L**anguage），被设计用来传输和存储数据。

# XML结构

<!--more-->

XML整体采用<font color='red'>“树形结构”</font>，从根开始，扩展到叶子节点。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend!</body>
</note>
```

第一行`<?xml version="1.0" encoding="UTF-8"?>`表示的是xml使用的版本和编码方式

第二行是`<note>`根元素

接下来的四行描述了4个子元素：to，from，heading，body

```xml
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend!</body>
```

最后一行定义根元素结果</note>

上述的结构可以看做Jani给Tove的一封便签

`XML`由根元素开始，向下扩展子元素，其关系为父子，同级之间的元素关系为同胞

# XML语法

1. 文档必须有根元素

2. XML 声明文件的可选部分，如果存在需要放在文档的第一行，如下所示：
   `<?xml version="1.0" encoding="utf-8"?>`

3. 所有XML都必须有开始和结束标签`<p>xxxxxx</p>`

4. XML标签对大小写敏感

5. XML的元素可以有属性值（名称/值的对），属性值必须加引号

   ```xml
   <note date="12/11/2007">
   <to>Tove</to>
   <from>Jani</from>
   </note>
   ```

6. `<`在xml文件中表示一个元素的开始，因此如果想使用小于符号时，应该利用**实体引用**来代替“<”字符

   ```xml
   <message>if salary &lt; 1000 then</message>
   ```

|    &lt    |   <   |     less than      |
| :-------: | :---: | :----------------: |
|  **&gt**  |   >   |  **grater than**   |
| **&amp**  | **&** |   **ampersand**    |
| **&apos** | **'** |   **apostrophe**   |
| **&quot** | **"** | **quotation mark** |

8. 在 XML 中编写注释的语法与 HTML 的语法很相似。
   `<!-- This is a comment -->`
9. HTML 会把多个连续的空格字符裁减（合并）为一个，但是XML中空格不会减少
10. 在 Windows 应用程序中，换行通常以一对字符来存储：回车符（CR）和换行符（LF）。XML 以 LF 存储换行。

# XML 元素

## XML 命名规则

XML 元素必须遵循以下命名规则：

- 名称可以包含字母、数字以及其他的字符
- 名称不能以数字或者标点符号开始
- 名称不能以字母 xml（或者 XML、Xml 等等）开始
- 名称不能包含空格

# XML 属性

`<file type="gif">computer.gif</file>`其中的`type="gif"`就是xml中元素的属性，属性必须添加**引号**

