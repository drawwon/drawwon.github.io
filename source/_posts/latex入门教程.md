---
title: latex入门教程
date: 2017-08-08 22:32:14
tags: [latex]
category: [论文]

---

最近几天改论文，因为information science 只提供latex模板，所以突击学习了一下latex

latex的编辑软件主要用到的是ctxt，安装地址

链接：http://pan.baidu.com/s/1o8BNpHK 密码：vv9y

一路点击下一步就可以了

然后安装插文献的软件jabref，安装地址

链接：http://pan.baidu.com/s/1c2mzkWw 密码：2q7p



打开Elsevier提供的latex模板文件`elsarticle-template-num.tex`就可以开始编辑了、

首先确认你要用的模板类型及版面大小，Elsevier一共提供了2种文件类型，一种是preprint就是默认提交给elsevier的格式，review是增加了行间距的格式，有3种版面大小设置，1p，3p和5p，通过`\documentclass[preview,3p,12pt]{elsarticle}`进行设置

接下来设置需要的参考文献的格式类型，我们在文中用到的是[1-4]这种压缩的格式，用的是数字，所以设置成

```latex
\biboptions{numbers,sort&compress}
```



接下来开始写文章

整体来说，latex有点类似于html的语法，文章从`\begin{document}`开始，到`\end{document}`结束

我们按照提示填入`\title{}`，`\author[1]{chao shen}`,`\author[2]{zhao wang}`,`\address[1]{xi'an jiaotong university}`

然后填入摘要，关键字等等`\begin{abstract}…………\end{abstract}`,`\begin{keyword}…………\end{keyword}`

下面就开始写正式章节了

一级标题应该用 `\section{Introduction}`这样的形式

二级标题用`\subsection{xxx}`

三级标题用`\subsubsection{xxx}`

四级标题没有定义，应该用`\paragraph{(1)Detection Performance Comparison}`

## 参考文献

参考文献直接用jabref插入，在jabref中选好文件之后，点击右上角的推送到winedt，winedt的路径要先选一下，在首选项，外部程序里面找到`D:\program files\CTEX\WinEdt\WinEdt.exe`，选择之后确认。

建立bib文件，每一条搜索之后铜鼓google导出bib，复制粘贴就加入了一条记录，记得要把库文件保存到个tex文件同一个文件夹，然后在tex文件中指定参考文件`\bibliographystyle{elsarticle-num}`，`\bibliography{ref}`

在推送之前，一定要先编译纯粹的latex，然后编译bib，再编译latex，再编译bib之后才能推送，不然文献会是`？` 

编译无法通过的时候可以加入`\usepackage{epstopdf}`

然后每次选中几条，鼠标放到tex文件中需要插入的地方，直接点击推送到winedt就行了

插入url时要用到如下包`\usepackage{url}`

![](http://ooi9t4tvk.bkt.clouddn.com/17-8-10/8740980.jpg)

## 插入图片

我们要插入的方式是一行插入多张图片，使用下述的程序段

使用前要先声明用了如下包：`\usepackage{subfigure}`

```latex
%
\begin{figure}[t]
\noindent
\centering
\subfigure[]{
\includegraphics[width=.3\textwidth]{6-1.eps}
}
\subfigure[]{
\includegraphics[width=.3\textwidth]{6-2.eps}
}
\subfigure[]{
\includegraphics[width=.3\textwidth]{6-3.eps}
}
\caption{EER curves against different user sizes:(a) nearest neighbor (Mahalanobis), (b) One-class support vector machine, (c) Mahalanobis (normed).}
\label{Figure 6}
\end{figure}
%
```

## 插入表格

latex绘制表格比较麻烦，因此我们用网站进行绘制：[table generator](http://www.tablesgenerator.com/latex_tables)

在网站上绘制好之后，我们使用`compress whitespace`然后点击`scale`缩放到跟纸张一样大

之后直接粘贴到我们的文件中就行了，要声明用到如下包：

```latex
\usepackage{multirow}
\usepackage{booktabs,graphicx}
```

如果某条线要加粗，需要把`hline`替换为`\Xhline{1.2pt}`

