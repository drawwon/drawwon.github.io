---
title: 剑指offer笔记
mathjax: true
date: 2018-11-20 10:15:11
tags: [算法]
category: [算法]
---

离春招开始的时间已经不久了，因此最近开始在工作之余看看剑指offer这本书，了解更多关于算法相关的知识。

<!--more-->

### 第一章

#### c++

1. 对空类型求sizeof，结果是多少？
   答：答案是1，本来应该是0，但是声明实例的时候，必须在内存中占有一定的空间，占多少内存由编译器决定。在visual studio中，每个空类型实例占用1字节的空间

2. 如果添加构造函数和析构函数，再求sizeof的结果是多少？

   答：还是1，因为调用构造函数和析构函数只需要知道函数的地址即可，函数地址与类型相关，而与类型的实例无关，编译器不会因为这两个函数在实例内添加任何额外的信息。

3. 如果把析构函数标记为虚函数呢？

   答：c++中一旦出现虚函数，就会为该类型生成虚函数表，并在每个实例中添加一个指向虚函数表的指针。在32位机器上一个指针占用4字节，因此结果是4；在64位机器上一个指针占用8字节，因此结果是8.



给出下面代码的运行结果

```c++
class A{
    private:
    	int value;
    public:
    	A(int n){value=n};
    	A(A other){value=other.value}
    void Print(){
        std::cout<< value << std::endl;
    }
    int main(){
        A a = 10;
        A b = a;
        b.Print()
    }
}
```

结果是**编译错误**，原因是因为在第二个构造函数中，用了一个实例来初始化另外的实例，但是c++函数的值传递过程中，是需要复制参数为形参的，复制参数位形参的过程就需要调用构造函数，那就相当于在调用构造函数的过程中需要调用构造函数，因此陷入递归调用，编译报错。

要解决这种问题，我们可以使用引用参数传递，这样不会复制参数，就不会报错，构造函数修改为A(const A& other)

##### 面试题1：赋值运算符函数

定义如下类型，要求重写他的等号赋值运算符

```c++
class CMyString{
    public:
    	CMyString(char *pData=nullptr);
        CMyString(const CMyString& str);
        ~CMyString(void);
    private:
    	char* m_pData;
}
```

要考四个方面：

1. 只有返回一个引用才可以连续赋值，否则str1=str2=str3这种赋值将无法通过
2. 传入参数是否声明为引用，如果传入参数是引用就不用复制参数，这样能提高代码效率，如果不改变传入实例的状态，应该在传入的引用参数之前加入const
3. 是否释放自身内存，如果在分配新内存之前释放自身空间，则程序将出现内存泄漏
4. 判断传入的参数和当前的实例是不是同一个实例，如果是同一个实例，不赋值，直接返回。如果不判断，在释放自身内存的时候，就把赋值的对象给释放了。

经典解法：

```c++
CMyString& CMyString::operator=(const CMyString& str){
    if (this== &str){
        return *this;
    }
    delete []m_pData;
    m_pData = nullptr;
    
    m_pData = new char[strlen(str.m_pData)+1];//加1的原因是：strlen出来的结果是不带终止符号\0的结果，但是在c++中存储字符串需要存储结束符\0,因此+1
    strcpy(m_pData, str.m_pData);
    return *this;       
}
```

### 数据结构

常用的数据结构必须掌握：数组，字符串，链表，树，栈，队列

其中数组和字符串是两种最基本的数据结构

#### 数组

数组内存连续，因此可以在O(1)时间内读写任何元素，时间效率很高，因此可以用来实现简单的哈希表，数组下标设为哈希表的key，数组中的数字设为value，形成键值对。

数组空间效率不高，因为一旦你定义了数组，那么整个数组占用的内存空间就无法被利用，因此STL中定义了vector这种动态数组，一开始分配一个小空间，每次往里面添加元素，当空间不够的时候，新开辟一块内存空间，大小是原来的2倍，把数据拷贝过来，并释放原先的内存空间。

**数组与指针**

c/c++中，数组的名字也是一个指针，指向数组的第一个元素

```c++
int GetSize(int data[]){
    return sizeof(data);
}
int main(){
    int data1[] = {1,2,3,4,5};
    int size1 = sizeof(data1);
    cout << "size1:"<<size1<<endl;
    int *data2 = data1;
    int size2 = sizeof(data2);
    int size3 = GetSize(data1);
    cout << "size2:"<<size2<<endl;
    cout<< "size3:" <<size3<<endl;

}
```

上述结果为:

```c++
size1:20
size2:8
size3:8
```

因为数组每一个元素占4个字节，5个元素的数字就是20个字节

指针data2虽然指向数组data1，但是其本身还是个数组，因此sizeof(data2)结果是8（64位系统一个指针占8个字节，32位系统一个字节占4个字节）

在GetSize函数的情况中，data1通过参数传入函数，数组自动退化为指针，因此结果为一个指针的大小8；

##### 面试题3：查找数组中的重复的数字

1. 在一个长度为n的数组里的所有数字都在0到n-1的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复的次数。请找出数组中任意一个重复的数字。例如如果输入长度为7的数组{2,3,1,0,2,5,3},那么对应的输出是重复的数字2或者3。 

解答：解决这个问题最简单的方法就是先排序，然后从头到尾扫描数组，如果第i个值与第i+1个值相等则有重复，排序一个长度为n的数组的时间复杂度是O(nlogn)，下面是为什么排序算法的复杂度是O(nlogn)

> a1,a2,a3……an排序总共有n！总结果，（其中a1'<=a2'<=a3'……<=an'）所占的概率是1/n!，每进行一次比较，就是在这n！种结果中进行二分，接着选择一个二分结果进行下一次二分，直到找到想要的排序。排序算法能不能自顶向下构造出一棵决策树？因为我们讨论的是基于输入元素的比较排序，每一次比较的返回不是0就是1，这恰好可以作为决策树的一个决策将一个事件分成两个分支。比如冒泡排序时通过比较a1和a2两个数的大小可以把序列分成a1,a2……an与a2,a1……an（气泡a2上升一个身位）两种不同的结果，因此比较排序也可以构造决策树。根节点代表原始序列a1,a2,a3……an，所有叶子节点都是这个序列的重排（共有n!个，其中有一个就是我们排序的结果a1',a2',a3'……an'）。如果每次比较的结果都是等概率的话（恰好划分为概率空间相等的两个事件），那么二叉树就是高度平衡的，深度至少是log(n!)。又因为log(n!)的增长速度与 nlogn 相同,即 log(n!)=Θ(nlogn)，这就是通用排序算法的最低时间复杂度O(nlogn)的依据。
>
> 证明log(n!)=Θ(nlogn)等价于证明①、②
>
> ①log(n!)=O(nlogn)
> 显然n!<n^n，两边取对数就得到log(n!)<nlog(n)。
>
> ②log(n!)=Ω(nlogn)
> n!=n(n-1)(n-2)(n-3)…1，把前n/2个因子（都大于n/2）全部缩小到n/2，后n/2个因子全部舍去，得
> n!>(n/2)^(n/2)。两边取对数，log(n!)>(n/2)log(n/2)，后者即Ω(nlogn)。

第二个方法是利用一个哈希表，每扫描到一个数字，如果哈希表里面没有这个数字，就把他加入哈希表，如果已经有该数字，那么就找到了重复的数字，此方法的时间复杂度为O(n)，但是提高时间效率的方法是以一个O(n)大小的哈希表为代价的，再看看有没有空间复杂度为O(1)的算法

因为数字都在0~n-1范围内，如果数组中没有重复的数字，那么排序后i这个数字应该出现在第i个位置，从头到尾扫描数组，扫到第i个数字，比较当前数字m与下标i是否相等，是则扫描下一个数字，否则交换m个和第m个元素。

```python
def get_duplicate(lists):
    for i in range(len(lists)):
        while lists[i] != i:
            if lists[i] == lists[lists[i]]:
                return True
            a = lists[i]
            lists[i],lists[a] = lists[a], lists[i]
    return False

if __name__ == '__main__':
    print(get_duplicate([2,3,1,0,2,5,3]))
```

2. 在一个长度为n+1的数组里的所有数字都在1~n的范围内，所以数组中至少有一个数字是重复的。请找出数组中任意一个重复的数字，但是**不能修改输入的数组**。例如，如果输入长度为8的数组{2,3,5,4,3,2,6,7}，那么对应的输出是重复的数字2或者3。

   解答：与上一题很像，但是题目要求不能修改数组，因此不能用上一题最后一个方法。同样这道题可以用一个大小为n的辅助空间。

   接下来尝试使用避免O(n)辅助空间的方法，那就是二分法。既然所有数字都在1~n之间，如果有重复的数字，那么这个重复数字要么在1~n/2之间，或者在(n+1)/2~n之间。判断在哪个区间的方法就是判断区间中数字的数量和区间长度，如果数量小于区间长度，那么证明重复值不在当前区间，反之则反之，判断数字的数量的方法就是遍历一遍数组。这样不停地分下去，直到区间的start和end相等的时候，如果这个值出现的次数还是>1，那么这个值就是重复的值。

   二分查找有个问题就是：不一定能找到所有重复的数字，比如{2,2,3,4}这样一个数组，二分之后1,2之间值的个数是2，不会认为这个区间有重复

```python
# 方法1
# 用O(n)的辅助数组
# def get_duplicate_num(l):
#     l1 = [0 for _ in range(len(l))]
#     for i in l:
#         l1[i] += 1
#         if l1[i] > 1:
#             return i
#     return False


# 方法2： 二分查找
def get_duplicate_num(l):
    start = 1
    end = len(l)-1
    while start <= end:
        middle = (end-start)/2 + start
        if middle %1 !=0:
            middle = int(middle) + 1
        else:
            middle = int(middle)
        count = computeCount(l,start,middle)
        if start == end:
            if count > 1:
                return start
            else:
                break
        if count > middle - start + 1:
            end = middle
        else:
            start = middle + 1
    return False

def computeCount(l,start,end):
    count = 0
    for i in l:
        if start <= i <= end:
            count += 1
    return count

if __name__ == '__main__':
    print(get_duplicate_num([2,3,5,4,2,6,7]))
```

#### 面试题4：二维数组中的查找

>在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。
>
>请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

我们一开始的想法很可能是，按顺序遍历数组，如果当前数字比目标数字小，那么目标数字应该在当前数字的右边或者下面，如果比当前数字小，应该在目标的左边或上面，如果我们从第一个值开始，发现比目标数字小，从这里选择右边还是下面便成了一个难题。

这道题目的关键是：从右上角的数字开始比较，因为右上角这个数字，比它大就往下，比它小就往左，这样不会存在分歧的路径，题目就变得简单了

```python
def getNumFromArray(l, num):
    if not l:
        return False
    row = 0
    column = len(l[0])-1
    while row < len(l) and column >= 0:
       if num > l[row][column]:
           row += 1
       elif num < l[row][column]:
           column -= 1
       else:
           return True
    return False

if __name__ == '__main__':
    print(getNumFromArray([[1,2,8,9],[2,4,9,12],[4,7,10,13],[6,8,11,15]],2))
```

#### 字符串

在c++中，字符串是以`\0`结束的，因此如果复制一个长度为10的字符串，需要初始化一个长度为11的char数组

```c++
char str[11];
strcpy(str,"0123456789")
```

#### 面试题5：替换空格

>  请实现一个函数，把字符串中的每个空格替换成"%20"。例如输入“We are happy.”，则输出“We%20are%20happy.”。　

在网络编程中，如果URL参数中含有特殊字符，如空格、'#'等，可能导致服务器端无法获得正确的参数值。我们需要将这些特殊符号转换成服务器可以识别的字符。转换的规则是在'%'后面跟上ASCII码的两位十六进制的表示。比如空格的ASCII码是32，即十六进制的0x20，因此空格被替换成"%20"。再比如'#'的ASCII码为35，即十六进制的0x23，它在URL中被替换为"%23"。

在python中实现这个问题的方法可以直接调用replace或者是用一个新的字符串，如果当前字符串等于空格，则加`%20`否则加上当前值，但这样会使用一个O(n)的辅助字符串

```python
def replaceBlank(string):
    # return string.replace(' ','%20')
    result = ''
    for i in string:
        if i==' ':
            result+='%20'
        else:
            result+=i
    return result

if __name__ == '__main__':
    print(replaceBlank("we are family"))
```

在C++当中解决这个问题的方法是：用两个index，先遍历字符串算出空格的数量，求出字符串长度和更改之后的字符串长度，p1指向原始数据的结束字符，p2指向替换之后数据的结束字符，p1每次往前走一格，p2每次复制p1当前值并同时往前走一格，如果遇到空格则p2加入`%20`三个字符，而p1往前走一格，直到p1和p2相等或p1为0。

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/20181127111133.png)

```c++
public static void ReplaceBlank(char[] target, int maxLength)
{
    if (target == null || maxLength <= 0)
    {
        return;
    }

    // originalLength 为字符串target的实际长度
    int originalLength = 0;
    int blankCount = 0;
    int i = 0;

    while (target[i] != '\0')
    {
        originalLength++;
        // 计算空格数量
        if (target[i] == ' ')
        {
            blankCount++;
        }
        i++;
    }

    // newLength 为把空格替换成'%20'之后的长度
    int newLength = originalLength + 2 * blankCount;
    if (newLength > maxLength)
    {
        return;
    }

    // 设置两个指针，一个指向原始字符串的末尾，另一个指向替换之后的字符串的末尾
    int indexOfOriginal = originalLength;
    int indexOfNew = newLength;

    while (indexOfOriginal >= 0 && indexOfNew >= 0)
    {
        if (target[indexOfOriginal] == ' ')
        {
            target[indexOfNew--] = '0';
            target[indexOfNew--] = '2';
            target[indexOfNew--] = '%';
        }
        else
        {
            target[indexOfNew--] = target[indexOfOriginal];
        }

        indexOfOriginal--;
    }
}

```

这道题给我们的启发：如果合并两个字符串或者是数组的时候，从前往后合并往往会需要复制很多次，那么我们可以从后往前合并。

#### 链表

链表是面试中最常出现的数据结构。

链表的空间是用到的时候再分配的，因此空间效率比数组要高。

单向链表的定义如下：

```c++
struct ListNode{
    int m_nValue;
    ListNode* m_pNext;
}
```

在链表后面添加一个元素的方法如下：

```c++
void addToTail(ListNode** pHead, int value){
    ListNode* pNew = new ListNode();
    pNew->m_nValue = value;
    PNew->m_pnext = nullptr;
    if(*pHead==nullptr){
        *head = pNew;
    }
    else{
        ListNode* pNode = *pHead;
        while(pNode->m_pNext!=nullptr){
            pNode = pNode->m_pNext;
        }
        pNode->m_pnext = pNew;
    }
}
```

**注意**：上面函数的第一个参数，用的是指针的指针，其原因是当pHead为nullptr的时候，要改变pHead的指向，如果传递一个指针的话，只能改变指针指向的对象的值，而不是直接改变他指的地址。

在链表中找到并删除某个元素：

```c++
void RemoveNode(ListNode** pHead, int value){
    if(pHead==nullptr || *pHead==nullptr){
        return;
    }
    ListNode* pToBeDeleted = nullptr;
    if ((*pHead)->mvalue==value){
    	pToBeDeleted=*pHead;
        *pHead=(*pHead)->m_pNext;
    }
    else{
        ListNode* pNode = *pHead;
        while(pNode->m_pNext != nullptr && pNode->m_pNext->m_value!=value){
            pNode = pNode->m_pNext;
        }
        if(pNode->m_pNext!=nullptr && pNode->m_pNext->mvalue==value){
            pToBeDeleted = pNode->m_pNext;
            pNode->m_pNext = pToBeDeleted->m_pNext;
        }
    }
    
    if(pToBeDeleted!=nullptr){
        delete pToBeDeleted;
        pTobeDeleted = nullptr;
    }
}
```

##### 面试题6：链表从尾到头打印

> 输入一个链表的头结点，从尾到头反过来打印出每个节点的值

链表的定义如下

```c++
struct ListNode{
    int m_nKey;
    ListNode* m_pN
}
```

思路：通常来说，链表只能从前到后访问，如果要从后往前打印，那么我们可以利用堆栈，每遍历一个链表节点，我们将他的值放在栈中，因为栈是后进先出的特性，最后将所有元素出栈，打印即可。

```c++
void PrintReverseList(ListNode *pHead){
    std::stack<*ListNode> nodes;
    ListNode* pNode = pHead;
    while(pNode != nullptr){
        nodes.push(pNode);
        pNode = pNode->m_pNext;
    }
    while(!nodes.empty()){
        pNode = nodes.top();
        printf('%d\t',pNode->m_nValue);
        nodes.pop();
    }
}
```

既然用到了堆栈，那么就自然想到了递归，因为递归调用本质就是使用堆栈，递归的链表反转打印方法如下

```c++
void PrintReverseList(ListNode *pHead){
    if(pHead!=nullptr){
        if(pHead->next!=nullptr){
            PrintReverseList(pHead->next);
        }
        printf('%d\t',pHead->m_nValue);
    }
}
```

##### 链表反转

链表反转和上面的思路基本一样，就是递归

```c++
ListNode* ReverseList(ListNode* pHead) {
    if(pHead==nullptr||pHead->next==nullptr){
        return pHead;
    }

    ListNode *newHead = ReverseList(pHead->next);
    pHead->next->next = pHead;
    pHead->next=nullptr;
    return newHead;

}
```

解释：翻转 [head, n1, n2, n3, ...]，等于先翻转 [n1, n2, n3, ...] ，再把 head 放到最后
head.next 就是 [n1, n2, n3, ...]，翻转就是 reverseList(head.next)，结果是 [..., n3, n2, n1]，注意 head.next 现在仍然指向 n1，也就是最后
所以，next_node = head.next 等于 next_node 赋值为 n1，也就是末尾的结点
然后 next_node.next = head，就是构造 [..., n3, n2, n1, head]
head.next = None，就是把 head 指向 n1 去掉，就翻转了

#### 树

树是实际编程中常用的数据结构。它的逻辑很简单：除根节点外的所有节点都只有一个父节点，根节点没有父节点；除叶子节点外的所有节点都有一个或多个子节点，叶子节点没有子节点。父节点和子节点通过指针连接。

因为树的操作涉及大量的指针操作，因此关于树的面试题难度较大。

面试中提到的树大部分是二叉树。二叉树是一种特殊的树结构，每个节点最多只能有两个子节点。二叉树中最重要的操作就是遍历：

* 前序遍历：先访问根节点，再访问左子节点，最后访问右子节点
* 中序遍历：先访问左子节点，再访问根节点，最后访问右子节点
* 后序遍历，先访问左子节点，再访问右子节点，最后访问根节点

这个前中后都是相对于根节点来说的，前就是先遍历跟节点，中就是根节点在中间，后就是根节点在最后。

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/20181206152439.png)

如上的二叉树，我们对其进行上述三种遍历：

* 前序遍历：10,6,4,8,14,12,16
* 中序遍历：4,6,8,10,12,14,16
* 后序遍历：4,8,6,12,16,14,10

这3种遍历，都有递归和循环两种方法，递归实现比循环简洁，要求**3种遍历的6种实现方法都要掌握**。

二叉树有很多特例，**二叉搜索树**就是其中之一。二叉搜索树中左子节点总是小于等于根节点，右子节点总是大于等于根节点。这就可以在O(logn)的时间内根据数值找到一颗二叉搜索树的一个节点，

二叉树还有两个特例是，**堆**和**红黑树**。

堆分为最大堆和最小堆，最大队中根节点的值最大。最大堆中根节点的值最大，最小堆中根节点的值最小。有很多需要找到最大最小值的问题可以用堆来解决。

红黑树是把树中的节点定义为红黑两种颜色，并通过规则确保从根节点到叶节点的最长路径的长度不超过最短路径的两倍。

##### 面试题7：重建二叉树

> 输入某二叉树的前序遍历和中序遍历的结果，请重建出该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。例如输入前序遍历序列{1,2,4,7,3,5,6,8}和中序遍历序列{4,7,2,1,5,3,8,6}，则重建二叉树并返回。

先理一下这道题的思路，有两个重要信息：①前序遍历的第一个值必然是根节点；②中序遍历中，根节点左边的值必然是左子树，根节点右边的值必然是右子树。那么只要给定一个前序遍历和中序遍历，我们就可以找到他的根节点和左右子树，这样只要递归下去，就能构建出整棵树。

```c++
#include <iostream>
using namespace std;

BinaryTreeNode* Construct(int* preorder, int* inorder, int length){
    if(preorder== nullptr|| inorder== nullptr|| length <=0){
        return nullptr;
    }
    return ConstructCore(preorder, preorder+length-1, inorder, inorder+length-1);
}
BinaryTreeNode* ConstructCore(int* StartPreorder, int* EndPreorder, int* StartInorder, int* EndInorder){
    //前序遍历的第一个值是根节点
    int rootValue = *StartPreorder;
    BinaryTreeNode* root = new BinaryTreeNode();
    root->mValue = rootValue;
    root->left = nullptr;
    root->right = nullptr;
    if(StartPreorder == EndPreorder){
        if(StartInorder==EndInorder && *StartPreorder==*StartInorder){
            return root;
        } else{
            throw runtime_error("invalid input");
        }
    }
    //在中序遍历中找到根节点的值
    int* rootInorder = StartInorder;
    while (rootInorder<=EndInorder && *rootInorder!=rootValue){
        ++rootInorder;
    }
    if (rootInorder==EndInorder && *rootInorder!=rootValue){
        throw runtime_error("invalid input");
    }
    int leftLength = rootInorder - StartInorder;
    int* leftPreorderEnd = StartPreorder + leftLength;
    if (leftLength > 0){
        root->left = ConstructCore(StartPreorder+1,leftPreorderEnd, StartInorder, rootInorder-1)
    }
    if (leftLength < EndPreorder - StartPreorder){
        root->right = ConstructCore(leftPreorderEnd+1,EndPreorder,rootInorder+1,EndInorder);
    }
}

```

下面是python版本的代码：

```python

class Solution:
    # 返回构造的TreeNode根节点
    def reConstruct(self, pre_t, tin_t):
        rootValue = pre_t[0]
        root = TreeNode(rootValue)
        if len(pre_t) == 1:
            if len(pre_t) == 1 and len(tin_t) == 1:
                return root
            else:
                return None
        i = 0
        for v in tin_t:
            if v == rootValue:
                break
            else:
                i += 1
        if v != rootValue:
            return None
        if i > 0:
            root.left = self.reConstruct(pre_t[1:i+1], tin_t[:i])
        if len(pre_t)-1 > i:
            root.right = self.reConstruct(pre_t[i + 1:], tin_t[i + 1:])
        return root

    def reConstructBinaryTree(self, pre, tin):
        # write code here
        if len(pre) == 0 or len(tin) == 0:
            return
        else:
            return self.reConstruct(pre, tin)
```

##### 面试题8：二叉树的下一个节点

>给定一棵二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针。

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/20181211162225.png)

思路：这道题就是一个分情况讨论的方法：

1. 如果一个节点有右子树，那么右子树的最左下子树就是下一个节点
   如上图：b的下一个节点就是其右子树e的最左子节点h
2. 如果一个节点没有右子树，但它本身是其父节点的左子树，那么下一个节点就应该是它的父节点
   如上图：h的下一个节点是e
3. 如果一个节点没有右子树，且是父节点的右子节点，那么就一直向上遍历，直到找到一个节点的父节点的左子节点是自己，那么就返回这个父节点，如果遍历到根节点还是空，那么就返回空
   如上图：i没有右子树，且不是父节点的左子节点，i的下一个节点就要向上搜索，找到e，e不是b的左子节点，继续向上，找到b，b是a的左子节点，因此返回b的父节点a



下面是python版本的实现

```python
class Solution:
    def GetNext(self, pNode):
        if not pNode:
            return pNode
        if pNode.right:
            newNode = pNode.right
            while newNode.left:
                newNode = newNode.left
            return newNode
        if pNode.next:
            while pNode.next and pNode.next.left != pNode:
                pNode = pNode.next
            if pNode.next:
                return pNode.next
            return None
```

以下是c++版本

```c++
/*
struct TreeLinkNode {
    int val;
    struct TreeLinkNode *left;
    struct TreeLinkNode *right;
    struct TreeLinkNode *next;
    TreeLinkNode(int x) :val(x), left(NULL), right(NULL), next(NULL) {
        
    }
};
*/
class Solution {
public:
    TreeLinkNode* GetNext(TreeLinkNode* pNode)
    {
     if(pNode==nullptr){
         return nullptr;
     }
        if(pNode->right!=nullptr){
            TreeLinkNode* newNode = pNode->right;
            while(newNode->left){
                newNode=newNode->left;
            }
            return newNode;
        }
        else if(pNode->next!=nullptr){
            while(pNode->next!=nullptr and pNode->next->left!=pNode){
                pNode=pNode->next;
            }
            if(pNode->next!=nullptr){
                return pNode->next;
            }
        }
        return nullptr;
    }
};
```

#### 栈和队列

栈是一个非常常见的数据结构，在计算机中管饭使用。比如操作系统给每个线程创建一个栈来存储函数调用时各个函数的参数，返回地址及临时变量等。

栈的特点是后进先出，最后被push的元素或第一个被弹出（pop）。

队列的特点是先进先出。

##### 面试题9：用两个栈实现队列

> 用两个栈实现一个队列，队列的声明如下，请实现他的两个函数appendTail和deleteHead，分别完成在对未插入节点和在队列头部删除节点的功能

```c++
template <typename T> class CQueue{
    public:
    	CqueueI(void);
        ~CqueueI(void);
    	
    	void appendTail(const T& node);
    	T deleteHead();
    private:
    	stack<T> stack1;
    	stack<T> stack2;

};
```

思路：两个栈实现一个队列，先把元素全部压入一个栈，在要删除队首元素的时候，将元素全部出栈，然后顺序压入另一个栈，再pop掉最上面一个元素，也就是最先入栈的元素，就删除了头部。加入尾部就直接压入第一个栈就行了。只要第二个栈不为空，我们就从第二个栈中pop，否则将第一个栈全部压入第二个栈。

```c++
template <typename T>  void CQueue<T>::appendTail(const T& node){
    stack1.push(node);
}
```

```c++
template <typename T>  void CQueue<T>::deleteHead(){
    if(stack2.size()<=0){
        while(stack1.size()>0){
            T& data = stack1.top;
            stack1.pop();
            stack2.push(data);
        }
    }
    if(stack2.size()==0){
        throw new exception("queue is empty");
    }
    T head = stack2.top();
    stack2.pop();
    return head
}
```

下面是python的实现：

```python
# -*- coding:utf-8 -*-
class Solution:
    def __init__(self):
        self.stack1=[]
        self.stack2=[]
    def push(self, node):
        self.stack1.append(node)
        # write code here
    def pop(self):
        if len(self.stack2)==0:
            while len(self.stack1)>0:
                self.stack2.append(self.stack1.pop())
        return self.stack2.pop()
        # return xx
```

#### 算法与数据结构

很多算法都可以使用递归和循环两种方法，递归实现比较简洁，但是性能不如基于循环的实现方法。

排序和查找是面试时考察的重点。准备时应该重点掌握**二分查找，归并排序，快速排序**，做到能随时能正确、完整地写出它们的代码。

如果面试题要求在二维数组上搜搜路径（比如迷宫或者棋盘），我们可以尝试回溯法。回溯法很适合用递归的代码实现。如果面试官规定不允许使用递归，那么就需要用栈来模拟递归。

如果面试题是求某个问题的最优解，并且该问题可以分为多个子问题，那么我们可以使用动态规划。再用自上而下的递归思路去自动分析动态规划问题的时候，我们会发现子问题之间存在重叠的更小的子问题。为了避免不必要的重复计算，我们用自下而上的循环代码来实现，就是**把子问题的最优解先算出来并用数组（一般是一维或者二维数组）保存下来**，接下来基于子问题的解计算大问题的解。

如果告诉面试官动态规划的思路之后，免死关提醒说分解子问题的时候是不是存在某个特殊的选择，采用特殊选择一定能得到最优解，那么意味着这道题可能可以用贪婪算法。

#### 递归和循环

如果需要重复多次计算相同的问题，则通常可以选择用递归或循环两种算法。递归就是在函数的内部调用这个函数自身。循环是通过设置初值和种植条件，在一个范围内重复运算。

##### 面试题10：斐波那契数列

> 求斐波那契数列的第n项

斐波那契数列定义如下：
$$
F_0=0\\
F_1 =1\\
F_{(n)}=F_{(n-1)}+F_{(n-2)}
$$
这是一个使用递归的直观例子，得到的代码如下：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Fibonacci(self, n):
        # write code here
        if n<=0:
            return 0
        if n==1:
            return 1
        else:
            return self.Fibonacci(n-1)+self.Fibonacci(n-2)
```

但是，在这里使用递归有很大的问题，那就是会进行大量的重复计算，比如我们要得到$f(10)$，首先要计算$f(9)$和$f(8)$，要得到$f(9)$又要得到$f(8)$和$f(7)$，这里，$f(8)$就已经重复了，往后还有很多这样的重复，如图所示

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/20181213145206.png)

因此，斐波那契数量的正确做法应该是循环，如下所示：

```python
# -*- coding:utf-8 -*-
class Solution:
    def Fibonacci(self, n):
        # write code here
        if n<=0:
            return 0
        if n==1:
            return 1
        else:
            a = 0
            b = 1
            fn = 0
            for i in range(2,n+1):
                fn = a+b
                a = b
                b = fn
            return fn
```

##### 青蛙跳台阶

> 一只青蛙，一次可以跳上一级台阶，也可以跳上两级台阶，那么跳上n级台阶一共有多少种方法。

解析：因为青蛙最后一步，要么跳2级，要么跳1级，那么$f(n)=f(n-1)+f(n-2)$，这样一来，这其实就是一个斐波那契数列问题

程序：python版本

```python
# -*- coding:utf-8 -*-
class Solution:
    def jumpFloor(self, number):
        # write code here
        if number==1:
            return 1
        if number==2:
            return 2
        else:
            a = 0
            b = 1
            fn = 0
            for i in range(2,number+2):
                fn = a+b
                a = b
                b = fn
            return fn
```

c++版本

```c++
class Solution {
public:
    int jumpFloor(int number) {
        if(number==1){
            return 1;
            }
        if(number==2){
            return 2;
        }
        else{
            int f0 = 0;
            int f1 = 1;
            int fn = 0;
            for(int i=1;i<=number;++i){
                fn = f0+f1;
                f0 = f1;
                f1 = fn;
            }
            return fn;
        }
    }
};
```

##### 变态青蛙跳台阶

一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶总共有多少种跳法。

解析：我们考虑一下n级台阶的时候有多少种跳法，第一步有n种跳法：跳1级、跳2级、到跳n级。跳1级，剩下n-1级，则剩下跳法是f(n-1)；跳2级，剩下n-2级，则剩下跳法是f(n-2)，所以$f(n)=f(n-1)+f(n-2)+...+f(1)+1$。同理可以推出$f(n-1)=f(n-2)+f(n-3)+...+f(1)+1$，因此$f(n)=f(n-1)+f(n-1)=2*f(n-1)=2*2*f(n-2)=...=2^{n-1}f(1)=2^{n-1}$

所以，直接返回$2^{n-1}$即可

```c++
#include <math.h>
class Solution {
public:
    int jumpFloorII(int number) {
        return pow(2,number-1);
    }
};
```

##### 矩阵覆盖问题

> 用一个2\*1的小矩形，横着或者竖着覆盖一个更大的矩形，请问用8个2\*1的小矩形无重复的覆盖一个2\*8的大矩形，总共有多少种方法？

![](https://github-blog-1255346696.cos.ap-beijing.myqcloud.com/pics/20181213153628.png)

分析：如果我将第一个矩形竖着放，那么就剩下2\*7个矩形，如果我将第一个矩形横着放，那么横着放的矩形下面一定是一个横着放的矩形，那么就剩下2\*7个矩形，也就是$f(8)=f(7)+f(6)$，可以看出，这依然是一个斐波那契数列问题。

```c++
class Solution {
public:
    int rectCover(int number) {
        if(number==1){
            return 1;
        }
        if(number==2){
            return 2;
        }
        else{
            int f0=0;
            int f1=1;
            int fn=0;
            for(int i=2;i<=number+1;++i){
                fn = f0+f1;
                f0 = f1;
                f1 = fn;
            }
            return fn;
        }
    }
};
```

#### 查找和排序

查找和排序是程序设计中经常用到的算法。查找比较简单，不外乎**顺序查找，二分查找，哈希表查找和二叉排序查找**。哈希表最主要的有点事能够在O(1)时间内找到某个元素，但是需要额外空间来实现哈希表。二叉排序树查找算法对应的数据结构是二叉搜索树。

排序比较复杂，通常要求比较**插入排序，冒泡排序，归并排序，快速排序**等不同算法的优劣。要求应试者对各种排序算法烂熟于胸，能够从额外空间小号，平均时间复杂度和最差时间复杂度等方面去分析他们的优劣。很多面试官要求应聘者写出**快速排序**的代码。

快速排序的关键在于现在数组中选择一个数字，接下来把数组中的数字分为两部分，比选择的数字小的数字移到数组左边，比选择大的数字移到数组右边。



