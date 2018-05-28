---
title: JavaScript教程
date: 2017-06-29 16:07:50
tags: [JavaScript]
category: [编程学习]
---

之前在慕课网上看了看JavaScript的教程，但是整个教程的内容不够详细，因此在廖雪峰官方网站看看关于js的教程，并重新学习和记录如下。

js用于在静态HTML页面上添加一些动态效果 ，网景公司的Brendan Eich这哥们在两周之内设计出了JavaScript语言 。为了让js称为全球标砖，欧洲计算机制造协会(European Computer Manufacturers Association)制定了js的标准，称为RCMAscript标准，最新版ECMAscript 6标准于2015年6月发布（简称ES6)。

## 快速入门

js代码一般放在`<head>`当中，由封闭的`<script>...</script>`包含起来

第二种是将js放在一个单独的js文件中，然后在head中声明该文件

```html
<head>
    <script src="/static/js/abc.js"></script>
</head>
```

有时候会看到定义js的类型，`<script type="text/javascript">`，但是实际上是没有必要的，因为默认的script的类型就是javascript

## 基础语法

每一句以分号(';')结束，语句块用大括号括起来

//表示注释，/\*...\*/也表示注释

### 数据类型和变量

#### Number

js不区分整数和浮点数，统一用Number表示

#### 字符串

字符串是以单引号或双引号引起来的任何文本，比如'abc'或者"xyz"。如果引号里面还有引号，那么就要用到转义字符`\`，ASCII字符可以用`\x##`表示，例如：

```js
'\x41'; // 完全等同于 'A'
```

还可以用`\u####`表示一个Unicode字符：

```js
'\u4e2d\u6587'; // 完全等同于 '中文'
```

多行字符串可以用反引号表示，也就是数字1左边那个键

```js
console.log(`多行
字符串
测试`);
```

多个字符串连接起来跟python一样用加号`+`就可以了，也可以跟shell脚本一样用变量名来代替，比如：

```js
var name = '小明';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
alert(message);
```

##### 操作字符串

获取字符串长度用`.length`，如果要获取slice，跟python的list方法一样，要注意，字符串本身是不可以变动的，对某个slice赋值不会改变本身：

```js
var s = 'Test';
s[0] = 'X';
alert(s); // s仍然为'Test'
```

还有一些函数用于操作字符串

* `toUpperCase()`：字符串变大写

* `toLowerCase()`：字符串变小写

* `indexOf()`：搜索指定字符串出现的位置，如果没找到则返回-1

  ```js
  var s = 'hello, world';
  s.indexOf('world'); // 返回7
  s.indexOf('World'); // 没有找到指定的子串，返回-1
  ```

* `substring()`：返回指定索引区间的子串，类似于python使用冒号的slice方法

  ```js
  var s = 'hello, world'
  s.substring(0, 5); // 从索引0开始到5（不包括5），返回'hello'
  s.substring(7); // 从索引7开始到结束，返回'world'
  ```

#### 布尔值

布尔值只有true和false两种，可以直接使用true，false来表示，也可以使用布尔运算来计算出来（比如大小比较或者与或非），js的与运算是&&，或运算是||，非运算是!

#### 比较运算符

大小比较与其他语言没有区别，但是js有个特殊的等于比较，两个等号"=="会自动转换类型之后再比较，而三个等号"==="不会自动转换类型，由于JavaScript这个设计缺陷，*不要*使用`==`比较，始终坚持使用`===`比较。

```javascript
false == 0; // true
false === 0; // false
```

还有一个问题就是NaN与任何值都不相等，包括他自己

```js
NaN === NaN; // false
```

唯一判断NaN的方法就是使用`isNaN()`函数

浮点数运算的相等比较中，由于浮点数运算会出现误差，因此计算机无法精确标识无限循环小数，要比较两个浮点数是否相等，智能计算他们之间的绝对值，看是否小于某个阈值

```js
1 / 3 === (1 - 2 / 3); // false
Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
```

#### null和undefined

null表示空值，与0和空字符串`''`都是不同的，null和undefined大致类似，大多数情况下都应该用`null`，`undefined`只有在判断函数参数是否传递的情况下有用

#### 数组

js的数组和python的list类似，可以包含任意类型的数据，例如：

```js
[1, 2, 3.14, 'Hello', null, true];
```

 另一种创建数组的方法是通过`Array()`函数实现

```js
new Array(1,2,3);// 创建了数组[1, 2, 3]
```

更建议直接使用方括号`[]`来建立数组，数组索引也和python类似，起始索引为0

```js
var arr = [1, 2, 3.14, 'Hello', null, true];
arr[0]; // 返回索引为0的元素，即1
arr[5]; // 返回索引为5的元素，即true
arr[6]; // 索引超出了范围，返回undefined
```

数组同样用length来获取长度，如果对array的length赋值的话会改变数组的内容，没有定义的内容全为undefined，如果变短则截断

```js
var arr = [1, 2, 3];
arr.length; // 3
arr.length = 6;
arr; // arr变为[1, 2, 3, undefined, undefined, undefined]
arr.length = 2;
arr; // arr变为[1, 2]
```

Array可以通过索引把对应的元素改为新的值

```js
var arr = ['A', 'B', 'C'];
arr[1] = 99;
arr; // arr现在变为['A', 99, 'C']
```

*请注意*，如果通过索引赋值时，索引超过了范围，同样会引起`Array`大小的变化：

```js
var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']
```

##### indexOf

Array也可以用indexOf来获取某个元素的位置

##### slice

`slice()`对应String的`substring()`方法，用于切片

##### push和pop

`push()`是在array末尾添加元素，`pop()`是把array最后一个元素返回出来

##### unshift和shift

`unshift()`：在array头部添加若干元素

`shift()`：将array的第一个元素删除掉并返回出来

unshift和shift相当于push和pop作用在array头部

```js
var arr = [1, 2];
arr.unshift('A', 'B'); // 返回Array新的长度: 4
arr; // ['A', 'B', 1, 2]
arr.shift(); // 'A'
arr; // ['B', 1, 2]
```

##### sort

对array进行排序

##### reverse

元素顺序反转

```js
var arr = ['one', 'two', 'three'];
arr.reverse(); 
arr; // ['three', 'two', 'one']
```

##### splice

`splice()`是array的万能方法，可以从指定索引删除若干元素，然后从该位置再添加若干元素

```js
var arr = ['Microsoft', 'Apple', 'Yahoo', 'AOL', 'Excite', 'Oracle'];
// 从索引2开始删除3个元素,然后再添加两个元素:
arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素 ['Yahoo', 'AOL', 'Excite']
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
// 只删除,不添加:
arr.splice(2, 2); // ['Google', 'Facebook']
arr; // ['Microsoft', 'Apple', 'Oracle']
// 只添加,不删除:
arr.splice(2, 0, 'Google', 'Facebook'); // 返回[],因为没有删除任何元素
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
```

##### concat

把两个array连接起来，并返回一个新的array

```js
var arr = ['A', 'B', 'C'];
var added = arr.concat([1, 2, 3]);
added; // ['A', 'B', 'C', 1, 2, 3]
```

##### join

join和python的join方法效果一样，使用方法如下

```js
var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A-B-C-1-2-3'
```

##### 多维数组

多维数组和python的list里面的list一样

```js
var arr = [[1, 2, 3], [400, 500, 600], '-'];
```

##### 取数组元素作为变量

取数组元素作为变量应该用`${array[i]}`这样的形式

```js
var arr = ['小明', '小红', '大军', '阿黄'];
console.log(`欢迎${arr[0]},${arr[1]},${arr[2]}和${arr[3]}同学`);//欢迎小明,小红,大军和阿黄同学
```

注意这里的\`号，不是单引号，单引号无法得到变量，全部视为字符串

#### 对象

js的对象是由一组键值对组成的字典，与python中的字典类型基本一样：

```js
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```

js对象的键都是字符串类型，值可以是任何类型，要获取一个对象的属性，就直接用`对象变量.属性名 `的方式：

```js
person.name; // 'Bob'
person.zipcode; // null
```

如果某个对象的key是字符串类型，访问的时候就只能跟python的字典一样，用`object['key']`来访问

```js
var xiaohong = {
    name: '小红',
    'middle-school': 'No.1 Middle School'
};
xiaohong['middle-school']; // 'No.1 Middle School'
xiaohong['name']; // '小红'
xiaohong.name; // '小红'
```

如果访问不存在的元素，那么返回的就是undefined

你可以随意给对象添加或者是删除属性，通过delete进行删除，还可以通过`in`来判断某个属性是否在某个对象中

```js
var xiaoming = {
    name: '小明'
};
xiaoming.age; // undefined
xiaoming.age = 18; // 新增一个age属性
xiaoming.age; // 18
delete xiaoming.age; // 删除age属性
xiaoming.age; // undefined
//用in来判断属性是否存在
var xiaoming = {
    name: '小明',
    birth: 1990,
};
'name' in xiaoming; // true
'grade' in xiaoming; // false
'toString' in xiaoming; // true
xiaoming.hasOwnProperty('name'); // true
xiaoming.hasOwnProperty('toString'); // false
```

但是用`in`判断有风险，因为如果是继承得到的属性也会被判断为自身的。要判断是否自身的属性， 应该用`hasOwnProperty()`方法： 

#### 变量

js的变量要以var定义，变量名是大小写英文、数字、`$`和`_`的组合 ，不能以数字开头

用等号对变量赋值，但一个变量只需要初始化一次

```js
var a = 123; // a的值是整数123
a = 'ABC'; // a变为字符串
```

#### strict模式

如果不用var进行初始化的话，那么变量将是全局变量，这会导致很严重的错误

ECMA为了修补js的这一严重缺陷，在后续退出了strict模式，如果不用var初始化变量将会报错，启用strict模式的方法是在js代码的第一行写上

```
'use strict';
```

### 条件判断

js用`if{...} else if{...}`的形式来进行条件判断，例如

```js
if (age >= 6) {
    console.log('teenager');
} else if (age >= 18) {
    console.log('adult');
} else {
    console.log('kid');
}
```

JavaScript把`null`、`undefined`、`0`、`NaN`和空字符串`''`视为`false`，其他值一概视为`true`，因此上述代码条件判断的结果是`true`。

 ### 循环

js的循环和c语言当中的是一样的

```js
var x = 0;
var i;
for (i=1; i<=10000; i++) {
    x = x + i;
}
x; // 50005000
```

`for`循环最常用的地方是利用索引来遍历数组：

```js
var arr = ['Apple', 'Google', 'Microsoft'];
var i, x;
for (i=0; i<arr.length; i++) {
    x = arr[i];
    console.log(x);
}
```

`for`也可以用break来退出

js当中的`for`也可以用python当中的`in`的形式：`for ... in`

```js
var o = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};
for (var key in o){
    console.log(key);// 'name', 'age', 'city'
    console.log(o.key);
}
```

要过滤掉对象继承的属性，用`hasOwnProperty()`来实现：

```js
var o = {
    name: 'Jack',
    age: 20,
    city: 'Beijing'
};
for (var key in o) {
    if (o.hasOwnProperty(key)) {
        console.log(key); // 'name', 'age', 'city'
    }
}
```

for in 数组的话，得到的是索引，因为数组的索引被视为属性

```js
var a = ['A', 'B', 'C'];
for (var i in a) {
    console.log(i); // '0', '1', '2'
    console.log(a[i]); // 'A', 'B', 'C'
}
```

### Map和Set

js中的Map相当于python中的字典，由键值对组成

初始化一个map需要一个二维数组或者是初始化为空map，用`set`添加键值对，用`has`确认是否含有某个键，用`get`取对应键的值

```js
var m = new Map(); // 空Map
m.set('Adam', 67); // 添加新的key-value
m.set('Bob', 59);
m.has('Adam'); // 是否存在key 'Adam': true
m.get('Adam'); // 67
m.delete('Adam'); // 删除key 'Adam'
m.get('Adam'); // undefined
```

`Set`就是python当中的集合，不允许重复

### iterable

因为`for in`语法不适用于Map和Set（因为他们不可以通过下标遍历），因此有了`for ... of`循环遍历

```js
var a = ['A', 'B', 'C'];
var s = new Set(['A', 'B', 'C']);
var m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
for (var x of a) { // 遍历Array
    console.log(x);
}
for (var x of s) { // 遍历Set
    console.log(x);
}
for (var x of m) { // 遍历Map
    console.log(x[0] + '=' + x[1]);
}
```

然而，更好的遍历方式是使用`iterable`内置的`forEach`方法，接收一个函数，每次迭代自动回调该函数

```js
var a = ['A', 'B', 'C'];
a.forEach(function (element, index, array) {
    // element: 指向当前元素的值
    // index: 指向当前索引
    // array: 指向Array对象本身
    console.log(element + ', index = ' + index);
});
//A, index = 0
//B, index = 1
//C, index = 2
```

`Set`与`Array`类似，但`Set`没有索引，因此回调函数的前两个参数都是元素本身：

 ```js
var s = new Set(['A', 'B', 'C']);
s.forEach(function (element, sameElement, set) {
    console.log(element);
});
 ```

`Map`的回调函数参数依次为`value`、`key`和`map`本身：

 ```js
var m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
m.forEach(function (value, key, map) {
    console.log(value);
});
 ```

## 函数

在js中，函数定义的方法如下

```js
function abs(x){
    if (x>0){
        return x;
    }
    else{
        return -x;
    }
}
```

如果没有return结果，那么函数的返回值是`undefined`

还有一种函数的定义方法是把函数赋值给一个变量名

```js
var abs = function (x){
    if (x>0){
        return x;
    }
    else{
        return -x;
    }
}
```

js允许传入任意个函数参数，如果比定义的多，只会调用定义的那个参数，如果比定义的少，那么会返回NaN

```js
abs(10); // 返回10
abs(-9); // 返回9
abs(10, 'blablabla'); // 返回10
abs(-9, 'haha', 'hehe', null); // 返回9
abs(); // 返回NaN
```

要避免收到`undefined`，可以对参数进行检查：

```js
function abs(x) {
    if (typeof x !== 'number') {
        throw 'Not a number';
    }
    if (x >= 0) {
        return x;
    } else {
        return -x;
    }
}
```

#### arguments

js本身还定义了一个参数是arguments，指向传入的所有参数，形式跟array一样：

```js
function foo(x) {
    console.log('x = ' + x); // 10
    for (var i=0; i<arguments.length; i++) {
        console.log('arg ' + i + ' = ' + arguments[i]); // 10, 20, 30
    }
}
foo(10, 20, 30);
//输出如下
//x = 10
//arg 0 = 10
//arg 1 = 20
//arg 2 = 30
```

#### rest

js还定义了rest参数，用于获取除了已定义参数之外的所有参数

```js
function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
}

foo(1, 2, 3, 4, 5);
// 结果:
// a = 1
// b = 2
// Array [ 3, 4, 5 ]

foo(1);
// 结果:
// a = 1
// b = undefined
// Array []
```

est参数只能写在最后，前面用`...`标识， 

### 函数作用域

函数内定义的是局部变量，不可以在函数外使用，跟其他编程语言规定是一样的

#### 变量提升

js的变量声明会提到最前面进行编译，但是变量赋值并不会提升

```js
function foo() {
    var x = 'Hello, ' + y;
    console.log(x);
    var y = 'Bob';
}

foo();
```

上面这段代码不报错，但是显示的是`Hello,undefined`

js引擎看到的是如下的结构

```js
function foo() {
    var y; // 提升变量y的申明，此时y为undefined
    var x = 'Hello, ' + y;
    console.log(x);
    y = 'Bob';
}
```

#### 全局作用域

js当中未定义在函数体中的变量都是全局变量，绑定在window这个对象上

```js
var course = 'Learn JavaScript';
alert(course); // 'Learn JavaScript'
alert(window.course); // 'Learn JavaScript'
```

#### 名字空间

全局变量会绑定到`window`上，不同js文件如果用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，减少冲突的好办法就是把所有的变量和函数全不绑定到一个全局变量中，如：

```js
// 唯一的全局变量MYAPP:
var MYAPP = {};

// 其他变量:
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

// 其他函数:
MYAPP.foo = function () {
    return 'foo';
};
```

#### 局部作用域

因为js的变量作用域是函数内部，因此类似于c++的for循环当中定义`i`的方法，在结束了for之后还是可以调用`i`的，如下：

```js
function foo() {
    for (var i=0; i<100; i++) {
        //
    }
    i += 100; // 仍然可以引用变量i
}
```

因此ES6引入了`let`关键字

```js
function foo() {
    var sum = 0;
    for (let i=0; i<100; i++) {
        sum += i;
    }
    // SyntaxError:
    i += 1;
}
```

#### 常量

ES6引入了`const`用于定义常量，常量无法修改

```js
const PI = 3.14;
PI = 3; // 某些浏览器不报错，但是无效果！
PI; // 3.14
```

#### 同时对多个变量赋值

ES6引入可以同时对多个变量赋值的机制，对多个变量赋值的时候，这些变量要用方括号`[]`引起来：

```js
var [x, y, z] = ['hello', 'JavaScript', 'ES6'];
```

解构赋值还可以忽略某些元素：

 ```js
let [, , z] = ['hello', 'JavaScript', 'ES6']; // 忽略前两个元素，只对z赋值第三个元素
z; // 'ES6'
 ```

如果需要从一个对象中取出若干属性，也可以使用解构赋值，便于快速获取对象的指定属性，在对对象进行解构赋值的时候，用大括号`{}`把变量扩起来：  

```js
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school'
};
var {name, age, passport} = person;
// name, age, passport分别被赋值为对应属性:
```

如果对应的属性不存在将会被定义为undefined，如果你要将某个变量拿出来赋给其他值，可以用冒号`:`

```js
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school'
};

// 把passport属性赋值给变量id:
let {name, passport:id} = person;
name; // '小明'
id; // 'G-12345678'
// 注意: passport不是变量，而是为了让变量id获得passport属性:
passport; // Uncaught ReferenceError: passport is not defined
```

解构赋值还可以使用默认值，这样就避免出现undefined的情况：

```js
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678'
};

// 如果person对象没有single属性，默认赋值为true:
var {name, single=true} = person;
name; // '小明'
single; // true
```

解构赋值在用于已经定义好的变量的时候，不能直接以`{}`开头，因为js会认为以`{`开头的内容是块元素，`=`不能对块元素赋值，解决办法是用小括号`()`括起来：

```js
// 声明变量:
var x, y;
// 解构赋值:
{x, y} = { name: '小明', x: 100, y: 200};
// 语法错误: Uncaught SyntaxError: Unexpected token =

({x, y} = { name: '小明', x: 100, y: 200}); //解决办法就是用小括号括起来
```

### 方法

在一个对象中绑定一个函数，称为这个对象的方法

```js
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};
```

这个`age()`就是一个方法，`this`就是类定义的this

只有`object.funciton()`这样的调用形式才能触发`this`

对于没有定义的this，在strict模式下指向undefined，在非strict模式下指向window

#### apply

`apply`用于显示地指定this，第一个参数就是需要绑定的`this`变量，第二个参数是`Array` ，调用形式是`function.apply(this, Array)`

```js
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空
```

另一个与`apply()`类似的方法是`call()`，唯一区别是：

- `apply()`把参数打包成`Array`再传入；
- `call()`把参数按顺序传入。

比如调用`Math.max(3, 5, 4)`，分别用`apply()`和`call()`实现如下：

```js
Math.max.apply(null, [3, 5, 4]); // 5
Math.max.call(null, 3, 5, 4); // 5
```

#### 方法

阅读: 141906

------

在一个对象中绑定函数，称为这个对象的方法。

在JavaScript中，对象的定义是这样的：

```
var xiaoming = {
    name: '小明',
    birth: 1990
};
```

但是，如果我们给`xiaoming`绑定一个函数，就可以做更多的事情。比如，写个`age()`方法，返回`xiaoming`的年龄：

```
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};

xiaoming.age; // function xiaoming.age()
xiaoming.age(); // 今年调用是25,明年调用就变成26了
```

绑定到对象上的函数称为方法，和普通函数也没啥区别，但是它在内部使用了一个`this`关键字，这个东东是什么？

在一个方法内部，`this`是一个特殊变量，它始终指向当前对象，也就是`xiaoming`这个变量。所以，`this.birth`可以拿到`xiaoming`的`birth`属性。

让我们拆开写：

```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25, 正常结果
getAge(); // NaN
```

单独调用函数`getAge()`怎么返回了`NaN`？*请注意*，我们已经进入到了JavaScript的一个大坑里。

JavaScript的函数内部如果调用了`this`，那么这个`this`到底指向谁？

答案是，视情况而定！

如果以对象的方法形式调用，比如`xiaoming.age()`，该函数的`this`指向被调用的对象，也就是`xiaoming`，这是符合我们预期的。

如果单独调用函数，比如`getAge()`，此时，该函数的`this`指向全局对象，也就是`window`。

坑爹啊！

更坑爹的是，如果这么写：

```
var fn = xiaoming.age; // 先拿到xiaoming的age函数
fn(); // NaN
```

也是不行的！要保证`this`指向正确，必须用`obj.xxx()`的形式调用！

由于这是一个巨大的设计错误，要想纠正可没那么简单。ECMA决定，在strict模式下让函数的`this`指向`undefined`，因此，在strict模式下，你会得到一个错误：

```
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};

var fn = xiaoming.age;
fn(); // Uncaught TypeError: Cannot read property 'birth' of undefined
```

这个决定只是让错误及时暴露出来，并没有解决`this`应该指向的正确位置。

有些时候，喜欢重构的你把方法重构了一下：

```
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - this.birth;
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // Uncaught TypeError: Cannot read property 'birth' of undefined
```

结果又报错了！原因是`this`指针只在`age`方法的函数内指向`xiaoming`，在函数内部定义的函数，`this`又指向`undefined`了！（在非strict模式下，它重新指向全局对象`window`！）

修复的办法也不是没有，我们用一个`that`变量首先捕获`this`：

```
'use strict';

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25
```

用`var that = this;`，你就可以放心地在方法内部定义其他函数，而不是把所有语句都堆到一个方法中。

### apply

虽然在一个独立的函数调用中，根据是否是strict模式，`this`指向`undefined`或`window`，不过，我们还是可以控制`this`的指向的！

要指定函数的`this`指向哪个对象，可以用函数本身的`apply`方法，它接收两个参数，第一个参数就是需要绑定的`this`变量，第二个参数是`Array`，表示函数本身的参数。

用`apply`修复`getAge()`调用：

```
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空
```

另一个与`apply()`类似的方法是`call()`，唯一区别是：

- `apply()`把参数打包成`Array`再传入；
- `call()`把参数按顺序传入。

比如调用`Math.max(3, 5, 4)`，分别用`apply()`和`call()`实现如下：

```
Math.max.apply(null, [3, 5, 4]); // 5
Math.max.call(null, 3, 5, 4); // 5
```

对普通函数调用，我们通常把`this`绑定为`null`。

#### 装饰器

利用`apply()`，我们还可以动态改变函数的行为。

JavaScript的所有对象都是动态的，即使内置的函数，我们也可以重新指向新的函数。

现在假定我们想统计一下代码一共调用了多少次`parseInt()`，可以把所有的调用都找出来，然后手动加上`count += 1`，不过这样做太傻了。最佳方案是用我们自己的函数替换掉默认的`parseInt()`：

```js
'use strict';

var count = 0;
var oldParseInt = parseInt; // 保存原函数

window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};

// 测试:
parseInt('10');
parseInt('20');
parseInt('30');
console.log('count = ' + count); // 3
```

### 高阶函数

js的最基础的高阶函数，就是把一个函数作为另一个函数的参数

```js
function add(x, y, f) {
    return f(x) + f(y);
}
add(-5, 6, Math.abs);//返回abs(5)+abs(6)
```

#### map/reduce

js的map/reduce和python的基本一样，只是调用方法略有区别，是`x.map(function)`

 ```js
var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
var results = arr.map(pow); // [1, 4, 9, 16, 25, 36, 49, 64, 81]
console.log(results);
 ```

 ```js
var arr = [1, 3, 5, 7, 9];
arr.reduce(function (x, y) {
    return x + y;
}); // 25
 ```

#### filter

用于把array的某些元素过滤掉

```js
var arr = [1, 2, 4, 5, 6, 9, 10, 15];
var r = arr.filter(function (x) {
    return x % 2 !== 0;
});
r; // [1, 5, 9, 15]
```

#### sort

sort方法用于排序

```js
// 看上去正常的结果:
['Google', 'Apple', 'Microsoft'].sort(); // ['Apple', 'Google', 'Microsoft'];

// apple排在了最后:根据ASCII码，小写字母a在大写字母之后
['Google', 'apple', 'Microsoft'].sort(); // ['Google', 'Microsoft", 'apple']

// 无法理解的结果: array的sort方法默认把所有元素转换换为string再排序
[10, 20, 1, 2].sort(); // [1, 10, 2, 20]
```

因为sort的这种默认的排序往往不能达到要求，因此需要自己定义sort当中的条件函数

```js
var arr = [10, 20, 1, 2];
arr.sort(function (x, y) {
    if (x < y) {
        return 1;
    }
    if (x > y) {
        return -1;
    }
    return 0;
}); // [20, 10, 2, 1]
```

返回1的时候表示要换位置，返回-1表示不换位置

### 闭包

闭包就是在一个函数内部再定义一个函数，执行函数的时候返回的不是值，而是函数

```js
//普通的求和函数
function sum(arr) {
    return arr.reduce(function (x, y) {
        return x + y;
    });
}

sum([1, 2, 3, 4, 5]); // 15
//闭包
function lazy_sum(arr) {
    var sum = function () {
        return arr.reduce(function (x, y) {
            return x + y;
        });
    }
    return sum;
}
```

### 匿名函数

创建一个函数并立即执行的方法称为匿名函数

```js
(function (x) { return x * x }) (3);//由于js语法限制，要用小括号括起来
```

### 箭头函数

ES6新增的一种函数

```js
x => x * x; 
```

上面的箭头函数相当于：

 ```js
function (x) {
    return x * x;
}
 ```

参数不止一个的时候要用括号括起来：

```js
// 两个参数:
(x, y) => x * x + y * y
// 无参数:
() => 3.14
// 可变参数:
(x, y, ...rest) => {
    var i, sum = x + y;
    for (i=0; i<rest.length; i++) {
        sum += rest[i];
    }
    return sum;
}
```

如果要返回一个对象，就要注意，如果是单表达式，这么写的话会报错：

 ```js
// SyntaxError:
x => { foo: x }
//因为和函数体的{ ... }有语法冲突，所以要改为：
x => ({ foo: x })
 ```

### 生成器

生成器和python当中的类似，用yield返回，用next访问

## 标准对象

js中所有都是对象，用`typeof`来查看对象类型

```js
typeof 123; // 'number'
typeof NaN; // 'number'
typeof 'str'; // 'string'
typeof true; // 'boolean'
typeof undefined; // 'undefined'
typeof Math.abs; // 'function'
typeof null; // 'object'
typeof []; // 'object'
typeof {}; // 'object'
```

### 包装对象

js提供包装对象，包装对象的关系就像java当中的`int`和`Intenger`的关系，`Intenger`这种包装对象要用`new`来创建，js当中的`number`、`boolean`和`string`都有包装对象 ，就是首字母大写，虽然包装对象看上去和原来的值一模一样，显示出来也是一模一样，但他们的类型已经变为`object`了！所以，包装对象和原始值用`===`比较会返回`false`： 

```js
var n = new Number(123); // 123,生成了新的包装类型
var b = new Boolean(true); // true,生成了新的包装类型
var s = new String('str'); // 'str',生成了新的包装类型

typeof new Number(123); // 'object'
new Number(123) === 123; // false
```

如果在使用`Number`、`Boolean`和`String`时，没有写`new` ，那么这三个函数就是类型转换函数

**注意**：

- 不要使用`new Number()`、`new Boolean()`、`new String()`创建包装对象；
- 用`parseInt()`或`parseFloat()`来转换任意类型到`number`；
- 用`String()`来转换任意类型到`string`，或者直接调用某个对象的`toString()`方法；
- 通常不必把任意类型转换为`boolean`再判断，因为可以直接写`if (myVar) {...}`；
- `typeof`操作符可以判断出`number`、`boolean`、`string`、`function`和`undefined`；
- 判断`Array`要使用`Array.isArray(arr)`；
- 判断`null`请使用`myVar === null`；
- 判断某个全局变量是否存在用`typeof window.myVar === 'undefined'`；
- 函数内部判断某个变量是否存在用`typeof myVar === 'undefined'`。

### Date

js中`Date`对象用于获取日期和时间：

```js
var now = new Date();
now; // Wed Jun 24 2015 19:49:22 GMT+0800 (CST)
now.getFullYear(); // 2015, 年份
now.getMonth(); // 5, 月份，注意月份范围是0~11，5表示六月
now.getDate(); // 24, 表示24号
now.getDay(); // 3, 表示星期三
now.getHours(); // 19, 24小时制
now.getMinutes(); // 49, 分钟
now.getSeconds(); // 22, 秒
now.getMilliseconds(); // 875, 毫秒数
now.getTime(); // 1435146562875, 以number形式表示的时间戳
```

如果要创建一个指定日期和时间的`Date`对象，可以用：

```js
var d = new Date(2015, 5, 19, 20, 15, 30, 123);
d; // Fri Jun 19 2015 20:15:30 GMT+0800 (CST)
```

**JavaScript的月份范围用整数表示是0~11，`0`表示一月，`1`表示二月……，所以要表示6月，我们传入的是`5`！ **

第二种创建一个指定日期和时间的方法是解析一个符合[ISO 8601](http://www.w3.org/TR/NOTE-datetime)格式的字符串：

```js
var d = Date.parse('2015-06-24T19:49:22.875+08:00');
d; // 1435146562875
```

但它返回的不是`Date`对象，而是一个时间戳。不过有时间戳就可以很容易地把它转换为一个`Date`：

```js
var d = new Date(1435146562875);
d; // Wed Jun 24 2015 19:49:22 GMT+0800 (CST)
d.getMonth(); // 5
```

#### 时区

浏览器可以把时间戳正确转换为本地时间

时间戳是个什么东西？时间戳是一个自增的整数，它表示从1970年1月1日零时整的GMT时区开始的那一刻，到现在的毫秒数。假设浏览器所在电脑的时间是准确的，那么世界上无论哪个时区的电脑，它们此刻产生的时间戳数字都是一样的，所以，时间戳可以精确地表示一个时刻，并且与时区无关。 

```js
var d = new Date(1435146562875);
d.toLocaleString(); // '2015/6/24 下午7:49:22'，本地时间（北京时区+8:00），显示的字符串与操作系统设定的格式有关
d.toUTCString(); // 'Wed, 24 Jun 2015 11:49:22 GMT'，UTC时间，与本地时间相差8小时
```

获取时间戳的方法如下：

```js
new Date().getTime()
```

### 正则表达式

js当中的正则表达式的写法和python是一样的，创建正则表达式的方法有两种

第一种是直接通过`/正则表达式/`写出来，第二种方式是通过`new RegExp('正则表达式')`创建一个RegExp对象 

`re.test(string)`方法用于判断正则表达式是否匹配，这个re就是一个正则表达式对象

```js
var re = /^\d{3}\-\d{3,8}$/;
re.test('010-12345'); // true
re.test('010-1234x'); // false
re.test('010 12345'); // false
```

#### 切分字符串

js切分字符串也是用`split()`实现的，用这则表达式可以通过任意形式切分

```js
//通过空格切分
'a b   c'.split(' '); // ['a', 'b', '', '', 'c']
//通过任意个空格切分
'a b   c'.split(/\s+/); // ['a', 'b', 'c']
//通过任意空格和逗号切分
'a,b, c  d'.split(/[\s\,]+/); // ['a', 'b', 'c', 'd']
```

#### 提取子串

js用`exec`提取子串，子串在正则表达式中用括号括起来

`exec()`方法在匹配成功后，会返回一个`Array`，第一个元素是正则表达式匹配到的整个字符串，后面的字符串表示匹配成功的子串。

 ```js
var re = /^(\d{3})-(\d{3,8})$/;
re.exec('010-12345'); // ['010-12345', '010', '12345']
re.exec('010 12345'); // null
 ```

同样`?`可以使得正则表达式进行非贪婪匹配

#### 全局搜索

js的正则表达式有几个特殊的标志，最常用的是`g`，表示全局匹配

```js
var r1 = /test/g;
// 等价于:
var r2 = new RegExp('test', 'g');
```

全局匹配可以多次执行`exec()`方法来搜索一个匹配的字符串。当我们指定`g`标志后，每次运行`exec()`，正则表达式本身会更新`lastIndex`属性，表示上次匹配到的最后索引：

```js
var s = 'JavaScript, VBScript, JScript and ECMAScript';
var re=/[a-zA-Z]+Script/g;

// 使用全局匹配:
re.exec(s); // ['JavaScript']
re.lastIndex; // 10

re.exec(s); // ['VBScript']
re.lastIndex; // 20
```

### JSON

JSON是JavaScript Object Notation的缩写，是一种数据存储格式

在JSON中，一共就这么几种数据类型：

- number：和JavaScript的`number`完全一致；
- boolean：就是JavaScript的`true`或`false`；
- string：就是JavaScript的`string`；
- null：就是JavaScript的`null`；
- array：就是JavaScript的`Array`表示方式——`[]`；
- object：就是JavaScript的`{ ... }`表示方式。

为了统一解析，JSON的字符串规定必须用双引号`""`，Object的键也必须用双引号`""`。 

可以用`JSON.stringify(object, attribute, format)`将对象变为`json`输出，第一个参数是对象名，第二个参数是属性名或者是转换函数，第三个参数用于控制格式（一般是有多少个空格）

```js
var xiaoming = {
    name: '小明',
    age: 14,
    gender: true,
    height: 1.65,
    grade: null,
    'middle-school': '\"W3C\" Middle School',
    skills: ['JavaScript', 'Java', 'Python', 'Lisp']
};
JSON.stringify(xiaoming, ['name', 'skills'], '  ');
```

结果：

```js
{
  "name": "小明",
  "skills": [
    "JavaScript",
    "Java",
    "Python",
    "Lisp"
  ]
}
```

如果第二个参数是转化函数

```js
function convert(key, value) {
    if (typeof value === 'string') {
        return value.toUpperCase();
    }
    return value;
}

JSON.stringify(xiaoming, convert, '  ');
```

上面的代码把所有属性值都变成大写：

 ```js
{
  "name": "小明",
  "age": 14,
  "gender": true,
  "height": 1.65,
  "grade": null,
  "middle-school": "\"W3C\" MIDDLE SCHOOL",
  "skills": [
    "JAVASCRIPT",
    "JAVA",
    "PYTHON",
    "LISP"
  ]
}
 ```

#### 反序列化

如果你拿到一个`JSON`字符串，可以用`JSON.parse()`将其转换为js对象

```js
JSON.parse('[1,2,3,true]'); // [1, 2, 3, true]
JSON.parse('{"name":"小明","age":14}'); // Object {name: '小明', age: 14}
JSON.parse('true'); // true
JSON.parse('123.45'); // 123.45
```

parse还可以加上一个处理函数

```js
var obj = JSON.parse('{"name":"小明","age":14}', function (key, value) {
    if (key === 'name') {
        return value + '同学';
    }
    return value;
});
console.log(JSON.stringify(obj)); // {name: '小明同学', age: 14}
```

## JS面向对象

JS没有class的概念，如果要进行继承要用`Object.create()`方法，实质就是将一个类的prototype指向另一个类

```js
var Student = {
    name: 'Robot',
    height: 1.2,
    run: function () {
        console.log(this.name + ' is running...');
    }
};

var xiaoming = {
    name: '小明'
};

xiaoming.__proto__ = Student;
```

在编写JavaScript代码时，不要直接用`obj.__proto__`去改变一个对象的原型。`Object.create()`方法可以传入一个原型对象，并创建一个基于该原型的新对象 

```js
// 原型对象:
var Student = {
    name: 'Robot',
    height: 1.2,
    run: function () {
        console.log(this.name + ' is running...');
    }
};

function createStudent(name) {
    // 基于Student原型创建一个新对象:
    var s = Object.create(Student);
    // 初始化新对象:
    s.name = name;
    return s;
}

var xiaoming = createStudent('小明');
xiaoming.run(); // 小明 is running...
```

#### 构造函数

`new`一个对象，就是构造函数，如果不写new，那么就是一个普通函数，返回的是undefined

```js
function Student(name) {
    this.name = name;
    this.hello = function () {
        alert('Hello, ' + this.name + '!');
    }
}
var xiaoming = new Student('小明');
xiaoming.name; // '小明'
xiaoming.hello(); // Hello, 小明!
```

新创建的xiaoming的原型链是：

```
xiaoming ----> Student.prototype ----> Object.prototype ----> null
```

### 原型继承

### class继承

原型继承章节比较难，之后会回过来看

ES6引入了class关键字，可以直接包含构造函数和定义在原型上的其他函数

```js
class Student {
    constructor(name) {
        this.name = name;
    }

    hello() {
        alert('Hello, ' + this.name + '!');
    }
}
```

有了class之后，直接用extends就可以继承，调用父类方法直接用`super`

```js
class PrimaryStudent extends Student {
    constructor(name, grade) {
        super(name); // 记得用super调用父类的构造方法!
        this.grade = grade;
    }

    myGrade() {
        alert('I am at grade ' + this.grade);
    }
}
```

 ## 浏览器

js可以获取浏览器对象并对其操作，`window`不光是全局作用域，还表示浏览器窗口，`window`对象有`innerWidth`和`innerHeight`属性 ，可以获取浏览器窗口的内部宽度和高度。内部宽高是指除去菜单栏、工具栏、边框等占位元素后，用于显示网页的净宽高。 

```js
console.log('window inner size: ' + window.innerWidth + ' x ' + window.innerHeight);
```

`navigator`通常包含的是浏览器信息，常用的属性包括：

- navigator.appName：浏览器名称；
- navigator.appVersion：浏览器版本；
- navigator.language：浏览器设置的语言；
- navigator.platform：操作系统类型；
- navigator.userAgent：浏览器设定的`User-Agent`字符串。

### 操作DOM

HTML文件被浏览器解析为一棵DOM（Document Object Model）树，要改变HTML的结构，就要用js来操作DOM

对DOM的操作主要有以下几种：

- 更新：更新该DOM节点的内容，相当于更新了该DOM节点表示的HTML的内容；
- 遍历：遍历该DOM节点下的子节点，以便进行进一步操作；
- 添加：在该DOM节点下新增一个子节点，相当于动态增加了一个HTML节点；
- 删除：将该节点从HTML中删除，相当于删掉了该DOM节点的内容以及它包含的所有子节点。

拿到DOM节点和之前用`selenium`写爬虫的方法基本是一致的，方法主要有`document.getElementById()`和`document.getElementsByTagName()`，以及CSS选择器`document.getElementsByClassName()` 

```js
// 返回ID为'test'的节点：
var test = document.getElementById('test');

// 先定位ID为'test-table'的节点，再返回其内部所有tr节点：
var trs = document.getElementById('test-table').getElementsByTagName('tr');

// 先定位ID为'test-div'的节点，再返回其内部所有class包含red的节点：
var reds = document.getElementById('test-div').getElementsByClassName('red');

// 获取节点test下的所有直属子节点:
var cs = test.children;

// 获取节点test下第一个、最后一个子节点：
var first = test.firstElementChild;
var last = test.lastElementChild;
```

还有一种是跟`scrapy`写爬虫的时候的`query`选择器差不多的语法

```js
// 通过querySelector获取ID为q1的节点：
var q1 = document.querySelector('#q1');

// 通过querySelectorAll获取q1节点内的符合条件的所有节点：
var ps = q1.querySelectorAll('div.highlighted > p');
```

#### 修改DOM

直接修改拿到的节点的innerHTML内容，这要把HTML的内容替换进去：

```js
// 获取<p id="p-id">...</p>
var p = document.getElementById('p-id');
// 设置文本为abc:
p.innerHTML = 'ABC'; // <p id="p-id">ABC</p>
```

还有一种是替换`innerText`或者`innerContent`，这样替换的只是html标签中间的文字内容，不能改变html内容

```js
// 获取<p id="p-id">...</p>
var p = document.getElementById('p-id');
// 设置文本:
p.innerText = '<script>alert("Hi")</script>';
// HTML被自动编码，无法设置一个<script>节点:
// <p id="p-id">&lt;script&gt;alert("Hi")&lt;/script&gt;</p>
```

两者的区别在于读取属性时，`innerText`不返回隐藏元素的文本，而`textContent`返回所有文本

还可以通过js修改css样式，直接对对象的`Object.style.xxx`进行修改

```js
// 获取<p id="p-id">...</p>
var p = document.getElementById('p-id');
// 设置CSS:
p.style.color = '#ff0000';
p.style.fontSize = '20px';
```

所有修改的css样式名称用驼峰命名法

#### 插入DOM

如果一个标签原本是空的，你直接修改它的`innerHTML`就相当于插入了一个DOM

如果不是空的，就需要用`appendChild`方法，将一个子节点加到父节点的最后一个节点

```html
<!-- HTML结构 -->
<p id="js">JavaScript</p>
<div id="list">
    <p id="java">Java</p>
    <p id="python">Python</p>
    <p id="scheme">Scheme</p>
</div>
```

把`<p id="js">JavaScript</p>`添加到`<div id="list">`的最后一项：

```JS
var
    js = document.getElementById('js'),
    list = document.getElementById('list');
list.appendChild(js);
```

现在，HTML结构变成了这样：

```html
<!-- HTML结构 -->
<div id="list">
    <p id="java">Java</p>
    <p id="python">Python</p>
    <p id="scheme">Scheme</p>
    <p id="js">JavaScript</p>
</div>
```

因为我们插入的`js`是从html中获取的，因此相当于把上面的节点append到了下面

当然你也可以通过`document.createElement('tag')`来建立某个标签，然后再`appendChild`

```js
var
    list = document.getElementById('list'),
    haskell = document.createElement('p');
haskell.id = 'haskell';
haskell.innerText = 'Haskell';
list.appendChild(haskell);
```

如果要插入到指定位置，那么就用`insertBefore`函数，用法是`父节点.insertBefore(新节点，参考节点)`，这样就把新节点插到了参考节点之前

```js
var
    list = document.getElementById('list'),
    ref = document.getElementById('python'),
    haskell = document.createElement('p');
haskell.id = 'haskell';
haskell.innerText = 'Haskell';
list.insertBefore(haskell, ref);
```

### 删除DOM

删除一个节点只需要得到父节点和本身，然后用`父节点.removechild(本身)`移除掉特定的节点

```js
// 拿到待删除节点:
var self = document.getElementById('to-be-removed');
// 拿到父节点:
var parent = self.parentElement;
// 删除:
var removed = parent.removeChild(self);
removed === self; // true
```

###js操作表单

js操作表单和操作DOM类似，因为表单本身也是DOM

HTML表单的输入控件主要有以下几种：

- 文本框，对应的`<input type="text">`，用于输入文本；
- 密码框，对应的`<input type="password">`，用于输入口令；
- 单选框，对应的`<input type="radio">`，用于选择一项；
- 复选框，对应的`<input type="checkbox">`，用于选择多项；
- 下拉框，对应的`<select>`，用于选择一项；
- 隐藏文本，对应的`<input type="hidden">`，用户不可见，但表单提交时会把隐藏文本发送到服务器。

先获取一个表单，然后直接对value赋值，就可以改变value的值

```js
// <input type="text" id="email">
var input = document.getElementById('email');
input.value; // '用户输入的值'
```

这种方式可以应用于`text`、`password`、`hidden`以及`select`。但是，对于单选框和复选框，应该用`checked`判断是否被勾上，也可以对他们设置值将其勾上：

 ```js
// <label><input type="radio" name="weekday" id="monday" value="1"> Monday</label>
// <label><input type="radio" name="weekday" id="tuesday" value="2"> Tuesday</label>
var mon = document.getElementById('monday');
var tue = document.getElementById('tuesday');
mon.value; // '1'
tue.value; // '2'
mon.checked; // true或者false
tue.checked; // true或者false
mon.checked = true; //勾上mon这个选项
 ```

#### HTML5控件

HTML5比标准的HTML多了几种控件，常用的有`date`、`datetime`、`datetime-local`、`color`等，它们都使用`<input>`标签 

```html
<input type="date" value="2015-07-01">
<input type="datetime-local" value="2015-07-01T02:03:04">
<input type="color" value="#ff0000">
```

#### 提交表单

js有两种方式提交表单，在提交的时候可以对form当中的值进行修改或者是判断是否符合规则

第一种是通过`<form>`元素的`submit()`方法进行提交

```js
<!-- HTML -->
<form id="test-form">
    <input type="text" name="test">
    <button type="button" onclick="doSubmitForm()">Submit</button>
</form>

<script>
function doSubmitForm() {
    var form = document.getElementById('test-form');
    // 可以在此修改form的input...
    // 提交form:
    form.submit();
}
</script>
```

这种方式的缺点是扰乱了浏览器对form的正常提交。浏览器默认点击`<button type="submit">`时提交表单，或者用户在最后一个输入框按回车键。因此，第二种方式是响应`<form>`本身的`onsubmit`事件，在提交form时作修改：

 ```html
<!-- HTML -->
<form id="test-form" onsubmit="return checkForm()">
    <input type="text" name="test">
    <button type="submit">Submit</button>
</form>

<script>
function checkForm() {
    var form = document.getElementById('test-form');
    // 可以在此修改form的input...
    // 继续下一步:
    return true;
}
</script>
 ```

最后一定要`return true`，这样浏览器才会提交表单，如果`return false`浏览器就不会提交表单

在检查和修改`<input>`时，要充分利用`<input type="hidden">`来传递数据。

例如，很多登录表单希望用户输入用户名和口令，但是，安全考虑，提交表单时不传输明文口令，而是口令的MD5。普通JavaScript开发人员会直接修改`<input>`：

```
<!-- HTML -->
<form id="login-form" method="post" onsubmit="return checkForm()">
    <input type="text" id="username" name="username">
    <input type="password" id="password" name="password">
    <button type="submit">Submit</button>
</form>

<script>
function checkForm() {
    var pwd = document.getElementById('password');
    // 把用户输入的明文变为MD5:
    pwd.value = toMD5(pwd.value);
    // 继续下一步:
    return true;
}
</script>
```

这个做法看上去没啥问题，但用户输入了口令提交时，口令框的显示会突然从几个`*`变成32个`*`（因为MD5有32个字符）。

要想不改变用户的输入，可以利用`<input type="hidden">`实现：

```html
<!-- HTML -->
<form id="login-form" method="post" onsubmit="return checkForm()">
    <input type="text" id="username" name="username">
    <input type="password" id="input-password">
    <input type="hidden" id="md5-password" name="password">
    <button type="submit">Submit</button>
</form>

<script>
function checkForm() {
    var input_pwd = document.getElementById('input-password');
    var md5_pwd = document.getElementById('md5-password');
    // 把用户输入的明文变为MD5:
    md5_pwd.value = toMD5(input_pwd.value);
    // 继续下一步:
    return true;
}
</script>
```

注意到`id`为`md5-password`的`<input>`标记了`name="password"`，而用户输入的`id`为`input-password`的`<input>`没有`name`属性。没有`name`属性的`<input>`的数据不会被提交。

#### 上传文件







# JavaScript 简介

<!--more-->

JavaScript 是互联网上最流行的脚本语言，这门语言可用于 HTML 和 web，更可广泛用于服务器、PC、笔记本电脑、平板电脑和智能手机等设备。

每一句后面添加“；”

放在html的head之间：

①`<script type="text/javascript">     </script>`；

②`<script src="script.js">           </script> ;`

## 直接写入 HTML 输出流

```javascript
document.write("<h1>这是一个标题</h1>");
document.write("<p>这是一个段落。</p>");
```

输出多个内容时与python一样用+连接

输出html标签时（例如输出`“<br/>”`)，需要用引号扩上并用`<>`包围

## 对事件的反应

```javascript
<button type="button" onclick="alert('欢迎!')">点我!</button>
```

## 改变 HTML 内容

```javascript
x=document.getElementById("demo")  //查找元素
x.innerHTML="Hello JavaScript";    //改变内容
```

您会经常看到 ***document.getElementById***("***some id***")。这个方法是 HTML DOM 中定义的。

DOM (**D**ocument **O**bject **M**odel)（文档对象模型）是用于访问 HTML 元素的正式 W3C 标准。

## 定义变量

定义变量使用关键词`var`，语法如下：

`var 变量名`

**变量名可以任意取名，但要遵循命名规则:**

​    1.变量必须使用字母、下划线(_)或者美元符($)开始。

​    2.然后可以使用任意多个英文字母、数字、下划线(_)或者美元符($)组成。

​    3.不能使用JavaScript关键词与JavaScript保留字。

**注意：Javascript里面区分大小写，变量mychar和myChar是不同的变量**

## 条件判断语句

语法：

```javascript
if(条件)
{ 条件成立时执行的代码 }
else
{ 条件不成立时执行的代码 }
```

## JavaScript定义函数

关键字`function`，用法如下：

```javascript
function 函数名(){
  函数代码；
}
```

点击按钮出提示的例子：

```javascript
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>函数调用</title>
   <script type="text/javascript">
       function contxt() //定义函数
      {
         alert("哈哈，调用函数了!");
      }
   </script>
</head>
<body>
   <form>
      <input type="button"  value="点击我" onclick="contxt()"/>  
   </form>
</body>
</html>
```

## alert 警告框

`alert`是在屏幕上弹出一个警示框，点击确认之后消失，其使用方法如下：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <script type="text/javascript">
    function alert_test() {
         var mychar = "一个警告";
        alert(mychar);
    } 
    </script>>
</head>
<body>
<input type="button" name="button" onclick="rec()" value="点击我弹出对话框">
</body>
</html>
```

## confirm 选择框

`confirm`是在屏幕上弹出一个选择框，点击确认返回true，否则返回false

```html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>confirm</title>
  <script type="text/javascript">
  function rec(){
    var mymessage= confirm("你是女士吗")     ;
    if(mymessage==true)
    {
    	document.write("你是女士!");
    }
    else
    {
        document.write("你是男士!");
    }
  }    
  </script>
</head>
<body>
    <input name="button" type="button" onClick="rec()" value="点击我，弹出确认对话框" />
</body>
</html>
```

## prompt提示框

`“”`是弹出一个提示框，同时你可以在这个提示框中输入值并返回

```html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>prompt</title>
  <script type="text/javascript">
  function rec(){
	var score; //score变量，用来存储用户输入的成绩值。
	score = prompt("请输入你的成绩");
	if(score>=90)
	{
	   document.write("你很棒!");
	}
	else if(score>=75)
    {
	   document.write("不错吆!");
	}
	else if(score>=60)
    {
	   document.write("要加油!");
    }
    else
	{
       document.write("要努力了!");
	}
  }
  </script>
</head>
<body>
    <input name="button" type="button" onClick="rec()" value="点击我，对成绩做评价!" />
</body>
</html>
```

## 打开新窗口

`open()` 方法可以查找一个已经存在或者新建的浏览器窗口。语法如下：

```
window.open([URL], [窗口名称], [参数字符串])
```

```
窗口名称：可选参数，被打开窗口的名称。
    1.该名称由字母、数字和下划线字符组成。
    2."_top"、"_blank"、"_self"具有特殊意义的名称。
       _blank：在新窗口显示目标网页
       _self：在当前窗口显示目标网页
       _top：框架网页中在上部窗口中显示目标网页
    3.相同 name 的窗口只能创建一个，要想创建多个窗口则 name 不能相同。
   4.name 不能包含有空格。
参数字符串：可选参数，设置窗口参数，各参数用逗号隔开。
```

![](http://ooi9t4tvk.bkt.clouddn.com/17-7-7/21084204.jpg)

## 关闭窗口

`window.close`关闭窗口

## DOM

dom意思是document object model，文档对象模型，是把html代码分割成3类节点：文本节点，属性节点，元素节点的树形结构

## 通过id寻找元素

`document.getElementByid('id')`

## innerHTML改变html元素内容

用于改变html代码中的内容，通过`docment.getElementById`找到元素并赋值给object，然后用`object.innerHTML = "new content"`进行赋值

## 改变html样式

用`object.style.property ="xxx"`来改变html中元素的样式，object是通过`document.getElementById()`取得的元素对象

## 显示或隐藏

通过`object.style.display = value`，`value`的值为`none`或者是`block`

## 更改类名

通过`object.className=“xxx”`改变一个元素的类名

## 移除style设置

`object.removeAttribute("style")`

用于移除对元素style的设置

