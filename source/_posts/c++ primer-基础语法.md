---
title: c++ primer 基础语法
date: 2018-04-10 20:10:25
tags: [c++]
category: [编程学习]
---

最近看了看c++基础语法，记录如下

<!--more-->

感觉windows下面visual studio的代码提示不是很好用，还是用了熟悉的intelligJ的IDE——clion

安装clion之后安装MinGW，就可以开始编程了

## 基础语法

### 标准输入输出流

cin和cout用于输入输出，需要包含iostream头文件，并using namespace std;

可以用多个输入输出符号进行连续输出或者输入

cin连续输入的分隔符号是：空格、tab或换行符

格式是

```c++
#include <iostream>
using namespace std;
int main(){
  cout << a << "字符串" << b;
}
```

### 循环及条件语句

while，for，if与c语言基本相同，没有什么说的

输入不定量的数据：while(cin >> value)，这样实现的原因是cin输入正常的时候，判定为true，没有值的时候判定为false

## 第二章：内置类型

### int和unsigned int

如果unsigned int表示一个负数的话，应该是取其补码（因为负数在计算机中是以补码的形式存储的），按unsigned int来计算值（无符号位），当然有一个简单的办法，比如你是32位机器，那么-1的表示形式就是$2^{32}-1$，-32的表示形式就是$2^{32}-32$

int 类型的第一位是符号位，0表示正数，1表示负数

### string

string在c++中一个要用双引号：""

单引号表示char： ''

多个字符串如果紧邻且中间仅用空格、缩进和换行符分隔，那么他们就是一个字符串

```c++
int main(int argc, char *argv[]){
    cout<< "my name is"
           "jeffrey"<< endl;
    return 0;
}
```

### 转义字符

在反斜杠"\"后面紧跟着1个，2个或3个八进制字符

### 指定字面值的类型

```c++
L'A'  //宽字符型，wchar_t
u8'hi!'  //utf-8字符
3.1315L  //long double
1E-3F   //单精度浮点数，float E-3表示10的-3次方，小写的e效果一样
42ULL   //Unsigned long long
```

### 变量赋值方法

c++有四种变量赋值方法：

```c++
int a = 0;
int b = {0};
int c{0};
int d(0);
```

上面四个方法分别对应把abcd赋值为0，花括号的赋值方法叫做**列表初始化**，但是这种方法有个问题就是如果存在精度损失的情况下，编译器会报错。

```c++
long double ld=3.1424234;
int a{ld}, b{ld};  //报错，因为列表初始化不允许存在精度损失
int a(ld), b(ld);  //不报错，但存在精度损失
```

变量赋值**不能使用连等号**

```c++
int a=b=0;  //错误！！！
int a=0, b=0;
```

### 作用域

用两个冒号表示作用域，左边表示作用域，右边表示变量或函数名

比如常见的std::cout

全局作用域就是两个冒号，左边没有值，

```
a = 5
int main(int argc, char *argv[]){
    cout << ::a;
}
```

### 引用和指针

1. 引用
   引用必须要初始化（定义的时候必须赋值），赋值为另一个已经定义好的变量，这样两个变量就相当于是同一个变量，只是名字不同而已

2. 指针
   空指针是指向某个对象，可以初始化为空指针nullptr或null或0

   ```c++
   int *p1=nullptr
   ```

   指针必须指向相同类型的元素，void类型的指针可以指向任何元素

### const限定符

const用于定义一个无法改变的常数，在初始化的时候必须要赋值

声明变量用extern，如果想定义一个大家都能用的const值，那么在定义的时候必须同时用到external和const关键字

```c++
extern const int butSize = 512;
//在别的文件中用到这个值只需要声明一下
extern const int butSize;
```

#### const指针

常量指针因为值不能变，所以必须初始化

```c++
const int number=0;
const int *const num = &number;
```

顶层const：指针本身是一个常量，如`int *const p = a;`

底层const：指针所指向的是一个常量，如`const int a =1;const int *p=a;`

### 类型别名

使用关键字typedef进行别名定义：

```c++
typedef double wages; //定义weges是double的别名
```

或者别名声明进行定义using：

```c++
using wagees = double;
```

### auto类型说明符

auto可以自动识别数值类型，但是定义的时候必须初始化：

```c++
auto item = value1 + value2;
```

### decl类型指示符

decl类型指示符是用于得到某个对象或变量的类型，来定义别的变量

```c++
const int i =0;
decltype(ci) x=0;
```

### 标准库类型string

用string之前要声明，`using std::string`

初始化方法有直接初始化和拷贝初始化两种，不使用等号的就是直接初始化

```c++
using std::string
string s1;
string s2 = s1;
string s3 = "hiya";   //拷贝初始化
string s4(10,'c');   //直接初始化
```

string的输入是以第一个不为空白的地方开始，到下一个空白符的地方结束

* 判断string为空：string.empty()，为空返回true，否则返回false


* 读入一行：getline(string, line)函数，从string读入，读入之后放在line中
* 返回string长度：string.size()
* string比较: `==`或者是`!=`，两个字符串如果a是b的子串，那么b>a，如果ab有很多不同，那么他们的大小是按照第一个不相同的字符的比较来的

c++的string也可以直接相加，但是区别是不能把两个都用双引号扩起来的字面值相加，相加的至少有一个是string类型：

```c++
string s1 = "hello";
string s2 = "world";
string s3 = s1 + ", " + s2;   //正确，因为s1和s2都是string类型
string s3 = "hello" + ", "    //错误，两个字面值不能直接相加
```

#### 字符串处理函数

包含在cctype头文件中

| isalnum():是字母或数字时为真       |
| ------------------------- |
| isalpha()：是字母为真           |
| iscntrl()：是控制字符为真         |
| isdigit()：是数字为真           |
| issupper()：大写字母为真         |
| ispunct():是符号位真           |
| isprint()：可打印时为真          |
| isgraph()：不为空格且可打印时为真     |
| tolower()，toupper()：大小写转换 |

#### 对字符串进行迭代

使用范围for对字符串迭代

```c++
for (auto c : str)
  cout << c <<endl;
```

使用范围for对字符串的值进行改变，每个c都定义为引用，改变c的时候就改变了原来的字符串

```c++
for (auto &c : str)
  c = topper(c)
```

#### 使用下标访问字符串

与python类似，c++也可以用下标访问string，开头为str[0]，结尾为str[str.size()-1]，要注意，str.size()的返回类型并不是int，而是`string::size_type`，因此定义index的时候要用到decltype()

```c++
string word = "hello world";
for (decltype(word.size()) index=0; (index != word.size()) && (!isspace(word[index])); ++index) {
  word[index] = toupper(word[index]);
}
cout << word << endl;
```

### 容器vector

要想使用vector就要包含vector头文件`#include <vector>`

vector有点像python里面的list，什么都可以放进去，vector基本可以容纳所有对象，但是引用不是对象，所以vector无法存放引用

初始化vector只需要`vector<type> i`就可以了，大体来说有以下几种初始化方法

| `vector<T> V1`:空vector，用于存放T             |
| ---------------------------------------- |
| `vector<t> v2(v1)`：将v1赋值给v2              |
| `vecto<T> v3(n,val)`：v3包含n个val           |
| `vector<T> v4(n)`：包含n个重复执行值初始化的对象        |
| `vector<T> v5{a,b,c...}`： v5包含初始值个数的元素，每个元素在初始化阶段被赋值 |
| `vector<T> v5={a,b,c...}` ：等价于v5         |

注意：用圆括号的时候是用来构建vector的元素个数的，用花括号是用来表示初始值的

```c++
vector<int> v1{10};  //只有一个值为10
vector<int> v1(10);  //有10个初值为0的值
```

### 向vector中添加元素

使用push_back方法，类似于python list的append方法，每次放在最后

```c++
vector<int> a;
for (int i = 0; i < 100; ++i) {
  a.push_back(i);
}
```

访问vector的方法和访问string基本一致，用方括号加索引，vector也有size, empty,等等函数，也可以直接比较

将输入的字符串大写并输出，注意toupper之后返回一个int类型，不能直接用to_string方法，那样会让结果是ascii码的字符串类型，就是一串数字

```c++
int main(int argc, char *argv[]){
    vector<string> a;
    string temp;
    string temp_string="";
    while (cin >> temp){
        temp_string = "";
        for (auto tempc : temp)
            temp_string += toupper(tempc);
        a.push_back(temp_string);
    }

    for (auto i : a){
        cout << i <<endl;
    }
}
```

### 迭代器

迭代器有begin和end两种方法，分别指向第一个元素和**最后一个元素的下一个元素**，特殊地，空容器返回的begin和end是同一个迭代器

迭代器使用`==`或`!=`进行比较，用`++`向前移动一个位置，`+n`则移动n个位置，减法亦然，大小于符号用来比较同一个vector对象的两个迭代器，注意：两个迭代器可以做减法，但是不能做加法，加法只能加常数

比如迭代器访问一个string：

```c++
string a = "hello world";
for (auto i = a.begin();  i != a.end() ; i++) {
  *i = toupper(*i);
  cout << *i;
}
```

c++在for当中的判断都是用的`!=`，这可以使得在用迭代器和普通的for时候的形式一样，因此用不等于符号

#### 迭代器类型

包含普通迭代器和常量迭代器，普通迭代器可以读写，常量迭代器只能读

```c++
vector<int>::iterator it; //it能读写vector<int>元素
string::iterator it2;		//it2能读写string元素
vector<int>::const_iterator it3; //it3只能读vector<int>元素
```

c++11中引入两个新函数，cbegin和cend，是为了直接获得const_iterator的

#### 迭代器解引用

原始的解引用的方法是`(*it).function()`，c++引入了一种新的解引用的方法，用箭头运算符`it->function()`

### 数组

字符串数组初始化的时候，会在后面加一个'\0'结束符，但用`{}`的形式初始化的时候不会加

```c++
char a1[] = {'a','b','c'}; //没有加'\0'
char a2[] = {'a','b','c','\0'}; //手动加'\0'
char a3[] = "abc"; //自动加'\0'
```

有指针的数组，没有引用的数组，但是有数组的引用和数组的指针

```c++
int *p[10]; //含有10个整型指针的数组
int (*p)[10] = &arr;  //p指向含有10个整数的数组
int (&p)[10] = arr;//p引用一个含有10个整数的数组
```

数组也通过下标访问

#### 指针和数组

书组合指针联系紧密，对数组取地址则得到该元素的指针

```c++
string num[] = {"one","two","three"};
string *p = &num[0];
string *p2 = num;  //等价于前一句
```

指针也可以像数组一样进行加减整数的运算

注意指针的数组和数组的指针的区别

```c++
int *ip[4]; //整型指针的数组
int (*ip)[4]; //指向含有4个整数的数组
```

#### c风格的字符串

c风格的字符串定义方式是`char *str = "abcd"`，如果要用string赋值给c类型的字符串，用`.c_str()`函数

```c++
string s = "abcd";
char *str = s.c_str();
```

#### 用数组初始化vector

定义一个数组，用begin和end函数对vector进行初始化

```c++
int int_arr[] = {0,1,2,3};
vector<int> ivec(begin(int_arr),end(int_arr));
```

### 多维数组

严格来说c++当中没有多维数组，所谓的多维数组就是数组的数组

#### 用范围for遍历多维数组

第一层循环要用引用，第二层循环直接auto，因为第一层循环如果不用引用的话，第一层就被自动转换成了指针，第二层再遍历就不合法了

```c++
for (auto &row : ia)
  for (auto &col : row)
```

## 运算符

大多数运算符和c当中的顺序没有明显差异，只记录一些比较生疏的运算符

`?:` 运算符，用于选择运算，条件运算符的优先级非常低，如果在输出语句中包含，就不会执行

```c++
final_grade = (grade > 90) ? "high grade" : (grade < 60) ? "fail" : "pass";
cout << ( (grade < 60) ? "fail" : "pass"); //输出fail或pass
cout <<  (grade < 60) ? "fail" : "pass";	//输出1或0，即(grade<60)的结果
cout << grade < 60 ? "fail" : "pass";		//错误，因为想当与cout<<grade;cout < 60
```

### 位运算符

| 位运算符     |
| -------- |
| ~：位求反    |
| <<：左移    |
| `>>` ：右移 |
| &：位与     |
| ^：位异或    |
| \|：位或    |

### 逗号运算符

逗号运算符通常放在for循环中，用以同时执行两个内容

```c++
for(vector<int>::size_type ix=0; ix!=ivec.size(); ++ix,--cnt)
```

### 显示类型转换

static_cast,dynamic_cast, const_cast, reinterpret_cast其中一种

任何明确定义的类型转换，只要不是底层const都可以用static_cast

```c++
double slope = static_cast<double>(j) / i ;强制类型转换以便执行浮点数除法
```

dynamic_cast用于转换底层cosnt，将常量转换为非常量

```c++
const char *pc;
char *p = const_cast<char*>(pc)
```

reinterpret_cast用于对象底层的转换，比如char和int的转换

```c++
int *ip;
char *pc = reinterpret_cast<char*>(ip);
```

## 语句

大多数语句在c语言中已经学过，这里不多赘述，只详细讨论部分不熟悉的语句

if else语句用于条件判断

switch case语句也主要用于条件判断，记住switch语句要有break，不然就按顺序执行（不论条件是否满足都会往下执行），比如：

```c++
switch(ch){
  case 'a':
    ++acnt;
  case 'e':
    ++ecnt;
  case 'i':
    ++icnt;
  case 'o':
    ++ocnt;
}
```

如果输入的ch为e，此时++ecnt之后，没有break，接下来的++icnt和++ocnt都会被执行

没有可以匹配的时候，就匹配default标签

while和for语句用于循环，for比较特殊的就是范围for

do while语句是先执行，后判断

### 跳转语句

c++有四种跳转语句：break，continue，goto，return

break用于跳出最近的循环

continue用于循环中的当前迭代，并立即开始下一次迭代

go to是直接跳到某一句，尽量不要用go to

### try语句和异常处理

异常处理包括throw抛出异常和try catch处理异常

#### throw

直接throw 后面加上异常的内容

```c++
if (item1.isbn() != item2.isbn()){
  throw runtime_error("data should refer to same ISBN");
}
```

#### try catch语句

用try尝试，多个catch抓住不同类型的错误，错误类型可以搜索c++标准异常

```c++
while (cin >> item1 >> item2){
  try{
    // 执行的语句
  }
  catch (runtime_error err){
    cout<<  err.what() <<endl;
  }
}
```

## 函数

这里只介绍不熟悉的函数重载

同一个作用域内几个函数，名字相同但形参不同，称为重载，编译器通过参数类型确定你调用的是哪个函数

## 类

定义头文件的时候，用ifdef或者ifndef确保变量没有定义，然后用`#define`定义头文件变量`变量名_H`， 形式如下

```c++
#ifndef SALE_DATA_H
#define SALE_DATA_H
#include <string.h>
struct Sales_data{
  std::string bookNo;
  unsigned units_sold=0;
  double revenue=0.0;
}
```

定义类当中的函数的时候，有时候会用到常量函数，就是在函数的名字后面添加一个const关键字，常量函数：

* 如果尝试去改变这个类的成员变量，就会产生一个编译器错误；然而，在这个函数中读取一个类变量是允许的，但是不允许写一个类变量
* 还有一种理解就是对普通函数加一个this指针，而常量函数的this指针就是`const *this`， 比如定义一个`int Foo::Bar(int random_arg)`就等同于定义一个`int Foo::Bar(Foo *this, int random_arg)`，使用这个函数`Foo f;f.Bar(4)`就等同于`Foo f;f.Bar(&f, 4)`，加了const在函数后面的话`int Foo::Bar(int random_arg) const`， 那么就可以理解为`int Foo::Bar(const Foo *this, int random_arg) const` ，在这种常量this指针的情况下，是不允许修改类成员变量的

在这一章节中，函数常常返回的是**引用**，**注意**：不能返回局部的引用变量，如果要返回引用，那么你的函数参数里面至少有一个引用类型

### 构造函数

构造函数用于类的初始化，在没有定义构造函数的时候，有一个默认的default构造函数，当你定义了新的构造函数的时候，默认的构造函数失效

`类名(参数类型1 参数名1,参数类型2, 参数2): 成员1(参数名1), 成员2(参数名2){}`， 构造函数的通用形式

```c++
struct Sale_data{
    Sale_data() = default; //默认构造函数
    Sale_data(const string &s):bookNo(s){};  //
    Sale_data(const string &s, unsigned n, double p):bookNo(s),units_sold(n),revenue(p*n){}
  	Sale_data(istream &is){
    	read(is, *this)
  	}
}
```

这里string以引用方式传递，是因为在c++中，string是被视为指针的

class和struct的区别：当你希望所有成员都是public的时候用struct，只要有想要变成private的成员的情况下，都用class

### 友元

允许其他类或函数，访问类的非公有成员

```c++
int main(int argc, char *argv[]){
    class Sale_data{
        friend Sale_data add(const int&);

    public:
        Sale_data add(const Sale_data &lhs, const Sale_data &rhs){
            Sale_data sum = lhs;
            sum.combine(rhs);
            return sum;
        };

    private:
        string bookNo;
        unsigned unints_sold=0;
        double revenue=0.0;

    };

}
```

类里面分public和private变量，public变量可以在类外访问，private变量不允许显式地访问，除非是想要进行访问的类是该类的友元，friend










