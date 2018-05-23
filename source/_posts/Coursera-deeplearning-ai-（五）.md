---
title: Coursera-deeplearning-ai-（五）
date: 2018-05-16 16:44:44
tags: [deeplearning,机器学习,深度学习]
category: [机器学习]
---

这篇博文主要讲的是关于deeplearning.ai的第五门课程的内容，《Sequence Models》

<!--more-->

## Week one

### 循环神经网络

循环神经网络的主要应用：语音识别，音乐生成，感觉分类，DNA序列分析，机器翻译，视频行为识别，人名的识别

#### 常用的符号

* X：输入数据
* $x^{(i)<t>}$：第i个输入样本序列中的第t个值
* $T_x^{(i)}$：第i个输入样本的长度
* y：目标数据
* $x^{(i)<t>}$：第i个输出序列中的第t个值

#### 单词的表示

首先准备好一个字典，每个词一个one-hot向量，把出现的标记为1，没有出现的标记为0，如果遇到字典中不存在的单词，我们建立一个unknown的词，标记为unknown

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-16/44734504.jpg)

#### 为什么不用标准神经网络

标准神经网络将单词的表示输入一个网络，然后再输出一个y的向量，但是

* 每个句子的长度不同，因此输入的x和输出的y的长度在变化
* 标准神经网络不会分享他们之间学到的特征信息

因此标准神经网络不适合于这个问题

#### 循环神经网络

先输入一个$x^{<1>}$，输出$y^{<1>}$和$a^{<1>}$；然后输入$x^{<2>}$，通过$a^{<1>}$的信息和$x^{<2>}$的信息共同输出$y^{<2>}$和$a^{<2>}$，后面的步骤相似，由之前的所有信息得到当前的输出y，右边是循环神经网络的另一种表示方式，不过在这门课当中我们用左边的表示方式，通常会构造一个$a^{<0>}$，一般构造为0向量

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/51333298.jpg)

但是这样的循环神经网络有个缺点就是只利用了前面的信息，而没有利用后面的信息，比如在判断人名的情况下，我们要判断下图中的Teddy是不是一个人名，我们如果用循环神经网络只能利用前面的信息，下面两个图的判断结果应该相同，解决这个问题的方法是之后会讲解的双向循环神经网络(Bidirectional RNN) BRNN

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/5379891.jpg)

循环神经网络中$a^{<t>}$和$y^{<t>}$的计算方法如下，$w_{a\_}$如果和a相乘的时候就是$w_{aa}$，和x相乘的时候就是$w_{ax}$，注意这里所有层是共享的同一组参数。上下两个激活函数可以不同，一般来说$g_1$是tanh（偶尔也可以是Relu），$g_2$根据任务不同一般是sigmoid或softmax
$$
\begin{align*}
a^{<t>} &= g_1(w_{aa}a^{<t-1>} + w_{ax}x^{<t>}+b_a)\\
y^{<t>} &= g_2(w_{ya}a^{<t>} +b_y)
\end{align*}
$$
上面的公式可以通过矩阵进行简化，用$w_a$表示$[w_{aa}| w_{ax}]$的横排并列，用$[a^{<t-1>},x^{<t>}]$表示$a^{<t-1>}$ 与$x^{<t>}$的纵向stack，最后公式简化为下图右边的第一个和左边的最下面那个，即
$$
\begin{align*}
a^{<t>} &= g(w_{a}[a^{<t-1>} ,x^{<t>}]+b_a)\\
y^{<t>} &= g(w_{y}a^{<t>} +b_y)
\end{align*}
$$
![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/15290928.jpg)

### 循环神经网络的反向传播

循环神经网络的反向传播用到的损失函数就是逻辑回归中的交叉熵损失函数

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/60395486.jpg)

### 不同类型的循环神经网络

现在为止学到的循环神经网络的输入输出的大小是一样的，也存在一些不一样的情况，比如机器翻译中原句和目标句的长度可能就不一样

我们通过输入输出的数量的不同，进行划分，下图左边的是many-to-many RNN，并且输入数量等于输出的，比如之前的人名识别，中间是many-to-one RNN，比如情感分类，一大段话只需要输出一个情感值，也存在one-to-one的情况，不过很少见

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/56231645.jpg)

还有one-to-many结构，比如音乐生成，给个数字生成一段音乐，还有many-to-many的输入输出长度不同的情况，比如机器翻译的应用

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/1550175.jpg)

总结来说，RNN的不同结构有以下几种

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/65701426.jpg)

### 语言建模和序列生成

给定一句话：“cats average 15 hours of sleep a day”，首先你要对这句话进行标记

比如你用一个字典标注，这个字典包含10000个词，你此时还要生成两个额外的词，一个是`<EOS>`，表示end of sentence，句子的结束标志，还有一个是`<UNK>`，表示unkonwn words，未知单词

标记完之后你开始计算每个单词出现的概率，然后计算第二个单词在第一个单词出现的概率，计算第三个单词在第一、二个单词出现的概率，一直到最后一个单词

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/78581883.jpg)

### 采样新序列

我们之前计算每个$y^{<t>}$是通过选择最大的概率，但是在这里介绍一个新的方法，是通过随机采样作为下一个循环神经网络的输入，直到采样到`<UNK>`的时候结束

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/72354364.jpg)

除了以单词作为字典，还可以用字母作为字典，可以处理位置单词的情况，但是这种方法计算量更大，用得很少

![](http://ooi9t4tvk.bkt.clouddn.com/18-5-17/86894239.jpg)

### 梯度消失

RNN不擅长捕捉长期依赖关系，比如下图中的was和were和前面的cat和cats的搭配关系，如果中间隔了太多内容，那么他们之间的关系是很弱的

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/16533303.jpg)

除了梯度消失以外还有梯度爆炸的问题，还有梯度爆炸的问题，这只需要进行梯度裁剪即可(gradient clapping)，将超过某个值的梯度按比例缩小后再减

### Gated Recurrent Unit

选通循环单元(Gated Recurrent Unint)能够很大程度上地改善循环神经网络无法学习长期依赖关系和梯度消失这两个问题。

我们先来看看普通的RNN unit，用$x^{<t>}$和$a^{<t-1>}$计算出$a^{<t>}$，然后经过softmax计算出$\hat y^{<t>}$，过程如下图所示

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/32330611.jpg)

我们再来看看Gated Recurrent  Unit，首先引入一个C表示memory cell，引入一个$\Gamma$表示选通的值（gated），每次是否更新C的值由选通信号来决定，$\Gamma=1$则改变memory cell，$\Gamma=0$则不改变，我们用sigmoid函数来表示$\Gamma$，因为sigmoid函数的值大多数都在0和1附近，那么一个GRU单元的定义如下：

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/4804980.jpg)

我我们把公式整理一下：
$$
\begin{align*}
\tilde C&=\tanh(W_c[c^{<t-1>},x^{<t>}]+b_c)\\
\Gamma_u&=\sigma(W_u[c^{<t-1>},x^{<t>}]+b_u)\\
c^{<t>}&=\Gamma_u*\tilde c^{<t>}+(1-\Gamma_u) c^{<t-1>}
\end{align*}
$$
其中$\tilde C$表示C的更新值，$\Gamma_u$表示选通函数，有时候我们会再加上一个选通函数$\Gamma_r$，整个GRU的定义如下：
$$
\begin{align*}
\tilde C&=\tanh(W_c[\Gamma_r* c^{<t-1>},x^{<t>}]+b_c)\\
\Gamma_u&=\sigma(W_u[c^{<t-1>},x^{<t>}]+b_u)\\
\Gamma_r&=\sigma(W_r[c^{<t-1>},x^{<t>}]+b_r)\\
c^{<t>}&=\Gamma_u*\tilde c^{<t>}+(1-\Gamma_u) c^{<t-1>}
\end{align*}
$$

### LSTM

LSTM全称是(long short term memory)，长短期记忆

LSTM是GRU的更一般化的形式，其引入了另外两个选通参数$\Gamma_f$（forget）和$\Gamma_o$（output），还有这里的$\Gamma_u$表示的是update

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/68356717.jpg)

我们来看一个图示的LSTM单元

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/51003024.jpg)

### 双向循环神经网络(Biderectional RNN)

目前为止，循环神经网络可以使用前面的信息，但是还不能使用之后的信息，要同时使用上下文信息，需要使用BRNN，双向循环神经网络

下图是一个4层的双向循环神经网络，不光有向前传播的，还有向后传播的，这样就可以同时利用前后文的信息，这个图中是没有循环部分的。标准双向循环神经网络有个缺点就是要整句话的信息才可以进行判断，在一些语音识别之类的任务的时候需要用的是更加复杂的BRNN。BRNN的结构如下图

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/7023899.jpg)

### 深层RNN

利用RNN,GRU,LSTM,BRNN综合形成一个深度循环神经网络

我们现在用方括号来代表所在的layer，比如现在有一个三层的RNN，来看看$a^{[2]<3>}$是怎么计算的，它既有左边的值，又有下面的值，一起算出$a^{[2]<3>}$，一般来说3层的RNN已经非常深了（因为计算量非常大），通常上面得到的y还可以通过几层普通的神经网络来获得，这样可以使模型更加复杂

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-17/29850041.jpg)

## Week 2

### 词嵌入(Word Embedding)

嵌入是一个数学概念，表示单射的，结构保持的映射。

词嵌入(Word Embedding)并不是要把单词进行镶嵌，而是把单词嵌入到另一个空间中，要做到单射和结构保持，重点关注的是映射。词嵌入主要是在NLP当中将单词映射成由实数构成的向量上。

最简单的词表达方式就是用一个one-hot向量表示，在你的字典中标出存在的位置。这种方法存在的缺陷就是同类的词汇之间的距离不一定很近，比如apple和orange之间的距离可能是很远的，但是他们都属于水果，这种深层的关系没有被挖掘

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-19/58344691.jpg)

那么我们需要对词当中的特征进行表达，这就是word embedding，比如我们可以从下面这几个词里面学到大约300维度的特征，包括性别，是否与皇家有关等等，这就对每个词进行了特征表达，每个词都被镶嵌到一个300维的向量中，这样分类之后orange和apple的距离就很近了

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-19/34535407.jpg)

词镶嵌的可视化，是将高维的词镶嵌转换到2维，这个方法叫做t-SNE，可以看到，同类的词汇距离更近

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-19/22707995.jpg)

### 如何使用词嵌入

我们得到了词嵌入向量之后，使用循环神经网络进行判别，比如在人名识别的任务中，我们先用大量的没有标记的词汇来学习词嵌入的表达，然后用可能10000个词来进行训练，最后进行判别，这是一种典型的迁移学习

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-19/66791396.jpg)

因此基于词嵌入的方法，一共分为三步，第一步用大量数据学习word embedding，第二步迁移到一个数据量较小的任务上，如果这个迁移之后的任务的数据量足够大，那么我们就还需要对迁移之后的数据来改变词嵌入，一般来说不用改变

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-19/19745785.jpg)

### 词嵌入的属性

类比问题，我们提出一个问题，man-woman，相当于king-？，那么这个问号是什么呢。我们用之前学到的词嵌入来进行表达两两词嵌入向量的距离。我们发现$e_{man}$和$e_{woman}$之间的距离和$e_{king}$与$e_{quene}$之间的距离基本相等，因此可以认为man-woman等价于king-quene的关系。

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/50237387.jpg)

类比问题的做法是"?"代表的词计算出来，用$e_{man}-e_{woman}=e_{king}-e_?$表示，那就是要找到词w，$arg\max_wsim(e_w,w_{king}-e_{man}+e_{woman})$

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/64676010.jpg)

最常用的相似性度量方式是Cosine similarity，定义为$sim(u,v)=\frac{u^Tv}{||u||_2||v||_2}$，当然也可以用欧氏距离，但是cos相似度用的更多

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/28409899.jpg)

### 嵌入矩阵

你进行了word embedding的学习之后，最后的输出是一个嵌入矩阵，这个矩阵就是每个单词一列，所有单词组合得到的矩阵，如下图，乘以一个原本的one-hot的字典类型的表示之后，就可以得到这个单词的嵌入向量，但是实际中，我们只需要去查找这个embedding的向量，而不是做一个很高纬度的乘法

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/41118185.jpg)

### 如何进行word embedding的学习

一开始进行word embedding方面的研究的时候，模型比较复杂，但是后来人们发现简单的模型的效果也很好。我们在这里先讲一些复杂的模型，然后简化他们，因为复杂的模型更容易让你理解为什么他们会有效。

还是以“I want a glass of orange __”这句单词预测的句子为例，你先把所有的one-hot向量通过embedding matrix E 变成一个embedding vector，然后把他们stacking到一起，输入一个神经网络，最后经过一个softmax单元，输出概率最高的单词，当然你也可以只使用之前的四个单词，删除最开始的I和want

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/78543171.jpg)

除了用之前的四个单词，你还可以使用左右各四个单词，也可以用之前的一个单词，也可以用最近的一个单词等等

### Word2Vec

利用上一节中提到的方法，给定一个词作为context，一个词为target，通过一个embedding matrix，相乘之后经过一个softmax层，得到一个估计y，训练这一过程，来得到embedding matrix的参数

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/2208149.jpg)

主要有两种思想：一种是CBOW方法，是根据上下文来预测当前词语的概率，且上下文所有的词对当前词出现概率的影响的权重是一样的，因此叫continuous bag-of-words模型。如在袋子中取词，取出数量足够的词就可以了，至于取出的先后顺序是无关紧要的。 

Skip-gram刚好相反：根据当前词语来预测上下文的概率。

实际使用这个方法的时候有两个比较大的缺陷：

1. 计算量很大，计算概率时的分母求和的内容非常多，这就导致计算很复杂，这个问题在这后会用Negtive sampling解决
2. 如果使用sample方法，那么文中出现的很多的那些无意义的连词出现的概率会比较大，比如the,a,and之类的，这个问题通过huffman 树来解决

Huffuman树是通过每次选择最小的两个节点合并成一颗新的树，然后不断往上，直到合并完所有节点，我们来看个例子

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/18041198.jpg)

有了Huffman树，我们再将Huffman编码应用到机器学习中，最初Huffman编码用于编码传输，比如现在你要传一段由6个单词组成的文章（文章长度未知，可能是几十个单词，几百个单词都有可能），那么你需要$2^3$个编码来编码传输，这有两个问题，第一个问题是现在存在编码的浪费，二是不同概率的单词所用的编码是一样的，我们希望经常出现的单词应该编码长度短，不常出现的应该编码长度长，一次综合来取得最短共同长度，举个例子

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/41842953.jpg)

### 负采样

上一章节中计算p(t|c)的计算复杂度很高，因此我们在这一章中引入了负采样的方法，负采样就是先选一个context，然后选择一个真正的target，把他的y标记成1，然后选择k个负样本（也就是不是context的上下文的那种单词），然后把他们输入一个sigmoid函数，计算k+1个概率，因此大大减少了计算复杂度

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/81675963.jpg)

### Glove word vectors

Glove全称：Global Vectors for Word Representation ，是以两个单词i,j互相在对方的上下文（比如前后10个单词之内）中出现的次数来表示的，如果两个次数越接近，两个单词就越相近

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/69857317.jpg)

我们需要优化以下的目标，为了避免出现log0的情况，我们引入一个权重项，在$x_{ij}=0$的时候，让权重也等于0

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/74370111.jpg)

### Word embedding应用1——情感分类

如果我有一个word embedding的矩阵，我有一句话之后，就可以算出每个单词的word embedding 向量，然后对其平均或者求和来通过一个softmax单元，得到评分为1-5的概率，但这样有个缺点，如左下角的句子所示，没有考虑上下文文本的关系，左下角这个句子有三个good，分类器很可能认为是一个正面评论

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/82511465.jpg)

为了利用上下文信息，需要使用RNN进行分类，是一个many-to-one的结构

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-20/7972513.jpg)

## Week Three

### 序列到序列的模型

我们有一句法语需要翻译，首先我们将法语输入一个RNN（比如LSTM单元），编码之后，再经过一个解码的RNN单元，把每次输出的单词作为下一个单元的输入，直到解码结束。事实证明，只要你拥有足够的训练数据（法语到英文的转换内容），你的系统可以表现的很好

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/66666382.jpg)

在图像标注的问题当中，也需要类似的办法。比如给定一张图像，然后给一句话对其进行描述，需要对新的图像同样进行描述的任务就称为图像标注。先用一个CNN对图像进行编码，比如一个AlexNet，然后将这个得到的编码输入一个RNN，输出一句描述。

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/28729637.jpg)

### 选择可能性最大的句子

我们在进行机器翻译的时候，不是每次选择一个出现概率最大的词语，而是选择出现那一整句话最大概率的情况，也就是所有单词联合概率最大的情况。

比如我们看看下面这个例子，假如我们 现在已经选了两个单词"Jane is"，然后你现在要选第三个单词，可能going在英语中出现的概率更大，但是going这一句并没有上面那一整句的翻译效果好，因此我们要选择一整句出现概率大的情况

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/22639407.jpg)

因此此时要引入beam search algorithm

### beam search algorithm

加入你要找到最大的联合概率，那么你每一步都要评估你字典那么多个概率，比如你字典中有10000个单词，如果你要翻译为1个长度为10的句子，那么你就要计算$10000^{10}$这个多个概率，从中选择最大的。

beam search的思想就是每次你只选择n个最大的概率向后计算，比如你现在beam=3，那么你每次只选择概率最大的3个短语向后计算，如下图，第一个单词概率最大的3个是"in, jane, sptember"，然后你以$\hat y^{<1>}$分别是"in, jane, sptember"，向后计算第二个单词，选出集中概率最大的三个，比如现在是"in september, jane is, jane visits"，然后再以这三个向后计算第三个单词，直到最后一个

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/80515032.jpg)

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/61749994.jpg)

### 细化beam search

length normalization是一种可以让beam search表现得更好的方法

一个很靠后的单词，是前面所有条件概率的乘积，那么越靠后这个概率可能越小，为了使计算机不会因为float值的存储长度限制而损失精度，一般用log函数进行表示

此外，长度越长，明显概率越小，为了使得最后的结果不是一堆长度很短的内容，我们使用长度对其归一化，也可以是长度的某个指数

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/5599276.jpg)

### beam search的错误分析

在做机器翻译的时候，出现错误你需要去看看是beam search的错误还是RNN的错误

此时只需要比较RNN和beam search 两者的概率，如果RNN输出的概率大于beam search的概率，就是beam search的错误；反之则是RNN的错误。然后比较很多例子的错误来源，看哪个错误占得比例大， 就是哪个的主要错误。

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/90034694.jpg)

### Bleu score

机器翻译与图片识别不一样，图片识别往往只有一个最终结果，但机器翻译有时候会存在好几句的翻译效果是一样好的情况，那么如何评价你翻译的好坏呢？这个时候就要引入Bleu score

首先我们看看单个单词程度的精度评价，原本的精度评价方式是在原句中存在且在翻译结果中也存在的单词的出现次数除以目标句子的总长，但下面这个时候这个评价指标就会失效。我们对其进行修正，用目标句和参考句中都出现的单词，其在参考句中出现次数的最大值，除以结果句的长度

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/57338958.jpg)

但是我们有时候不光是需要一个单词的精度，还要看看相邻单词的次数，此时的方法如下，对所有二元组，用其在所有参考句中出现的次数之和，除以目标句中出现的次数之和

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-21/29439686.jpg)

同样你还可以计算出三元组，四元组等等的结果，把他们加起来再放到e的指数上面，作为一个评估指标

### 注意力模型

处理翻译问题的过程中，不论是对于人或者机器，如果句子过长，那么你很难去记住一个句子，然后把他们全部翻译出来。正确的处理方式应该是先看一部分，然后翻译一部分，直到翻译完所有内容。

我们以翻译法语到英语为例，假如你正在翻译"jane visite l'Afrique en septembre"，那么你翻译的第一个结果$s^{<1>}$到底需要关注哪些单词呢？我们在这里计算出一个注意力权重系数，$\alpha^{<t,t^\prime>}$表示在生成第t个翻译内容的单词时，需要对原文的$t^\prime$那个单词关注多少

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/88175104.jpg)

计算attention model 的方法，是先在下面用一个双向RNN，上面一个单向RNN，对每个词计算出注意力权重系数，然后加起来作为上面的单向RNN的输入。当然真正计算的时候还要加一个softmax单元，保证每一个注意力权重系数小于1

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/92447051.jpg)

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/30477278.jpg)

### 语音识别

语音识别就是把一段音频数据转换成对应的文字，这个问题可以使用注意力模型。

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/13099425.jpg)

同时，由于输出可能远大于输入，我们需要对输出的结果进行删减，方法是删除所有细小停顿，然后拼凑成一个个单词，这里用到的损失函数叫做CTC cost

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/49198460.jpg)

语音识别需要大量的训练数据，一般来说学术论文需要几千个小时的数据，商业系统需要100000小时数据

### 触发词检测

标记一段数据，出现触发词的下一个标记标记为1，直到结束标记为0

![](http://drawon-blog.oss-cn-beijing.aliyuncs.com/18-5-22/54173363.jpg)







