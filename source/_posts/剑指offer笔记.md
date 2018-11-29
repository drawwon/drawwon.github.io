---
title: 剑指offer笔记
mathjax: true
date: 2018-11-20 10:15:11
tags: [算法]
category: [算法]
---

离春招开始的时间已经不久了，因此最近开始在工作之余看看剑指offer这本书，了解更多关于算法相关的知识。

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

#### 面试题1：赋值运算符函数

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

#### 面试题3：查找数组中的重复的数字

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



