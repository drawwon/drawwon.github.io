---
title: react初探
mathjax: true
date: 2018-06-07 22:21:13
tags: [js,前端]
category: [js,前端]
---

React是Facebook用来开发insgram的

MVC：Model，View，Control，称之为模型，视图，控制，react属于视图部分

ES5和ES6之间的转换工具叫做Babel，是Nodejs的一个包

<!--more-->

## npm与nodejs及react的安装

安装好Nodejs和npm环境，查看是否安装成功

```sh
node -v
npm -v
```

配置国内镜像

淘宝镜像提供了一个cnpm的工具，可以用`cnpm`命令来安装所有的包

```sh
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
```

也可以直接配置全局文件改变下载地址，mac和Linux的配置文件在`~/.npm/.npmrc`，windows的在node安装目录下`/node_modules/npm/npmrc`。在其中添加：

```sh
registry=https://registry.npm.taobao.org
```

### 旧版react的配置方式

mooc教程中用到的方法比较旧，具体是首先执行`npm init`，生成一个`package.json`文件，这个文件记录了项目的所有信息，然后通过`npm install --sava xxxx`各种包，`--save`的意思是将这个包的安装同步到`package.json`文件中

### 新版react的配置方式

现在react官网已经提供了一个专门用于管理react项目的npm包——`create-react-app`，用`npm install -g`安装，`-g`的意思是global，全局安装

```sh
npm install -g create-react-app
create-react-app my-app
#删除所有/src文件夹下面的内容
cd my-app
rm -f src/*
#添加一个index.css在src/目录下，其内容在https://codepen.io/gaearon/pen/oWWQNa?editors=0100
#添加一个index.js在src/目录下，其内容为 https://codepen.io/gaearon/pen/oWWQNa?editors=0010
```

再加入以下几行到index.js最上面，用于引用React的相关包

```js
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
```

然后在项目文件夹下运行`npm star`，打开浏览器[http://localhost:3000](http://localhost:3000)，就可以看到一个九宫格页面

运行时如果发现端口占用，在windows下就执行

```bash
netstat -ano | findstr 3000
tskill xxx
```

在Linux下执行

```sh
netstat -aux | grep 3000
kill xxx
```

### webpack热加载配置

通过`npm install webpack --save`和`npm install webpack-dev-server --sava`之后，新建一个`webpack.config.js`，输入以下内容用于打包整个文件，然后在命令行执行`webpack`，就生成了一个名为`bundle.js`的文件，你在html当中应该包含的就是这个`bundle.js`文件。

可以使用`webpack --watch`命令进入debug模式，这样在你保存文件之后就可以自动打包，不然每次都需要自己去执行`webpack`命令。

但是这样还需要自己刷新页面，如果需要自动刷新网页，运行`webpack-dev-server --contentbase src --inline --hot`，这样在你更改js之后网页会自动刷新

```js
var debug = process.env.NODE_ENV !== "production";
var webpack = require('webpack');
var path = require('path');

module.exports = {
  context: path.join(__dirname),
  devtool: debug ? "inline-sourcemap" : null,
  entry: "./src/js/root.js",
  module: {
    loaders: [
      {
        test: /\.js?$/,
        exclude: /(node_modules)/,
        loader: 'babel-loader',
        query: {
          presets: ['react', 'es2015'],
          plugins: ['react-html-attrs'], //添加组件的插件配置
        }
      },
      //下面是使用 ant-design 的配置文件
      { test: /\.css$/, loader: 'style-loader!css-loader' }
    ]
  },
  output: {
    path: __dirname,
    filename: "./src/bundle.js"
  },
  plugins: debug ? [] : [
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({ mangle: false, sourcemap: false }),
  ],
};

```

不过新的react的安装方式已经可以自动打包了，就不用手动安装`webpack`了

## React基本概念

### React Virtual DOM

在页面和DOM之间加了一层virtual DOM，dom本身是document object model，有了虚拟DOM之后就可以利用virtual DOM对页面进行更改，virtual DOM由于在数据结构上面的优化，使得原本对不同的DOM的比较的复杂度由$O(n^3)$变成了$O(n)$，

![](http://ooi9t4tvk.bkt.clouddn.com/18-6-8/98201829.jpg)

### React组件

组件就是一个个小模块，小模块在不同的页面之间都需要用，那么就可以复用，这样开发起来就很快。

我们先开发一个页面头部文件，在`src`目录中新建`components`文件夹，在其中新建`header.js`：

```jsx
import React, {Component} from 'react'
export default class ComponentHeader extends Component {
    render() {
        return (
            <header>
                <h1>这是头部</h1>
            </header>
        )
    }
}
```

这段代码的逻辑是首先从`React`这个包里面引入`React`和`React.Component`两个内容，`{}`的作用就是引入包当中的某个变量，然后定义一个外部可访问(`export`)的类叫做`ComponentHeader`，继承自引入的`Component`，类名一定要大写，在其中调用render方法，return一段html内容，注意：返回的一定是一个闭合的HTML标签，也就是最终是一个大的HTML节点，不能有多个，有多个的时候你可以尝试用一个大的节点把他们包裹起来

然后在`index.js`当中引用定义的`ComponentHeader`组件，render到html文件的header这个id之下，其中定义的ComponentHeader要用tag标记扩起来

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import ComponentHeader from "./components/header";

ReactDOM.render(<ComponentHeader />,document.getElementById('header'));
```

用同样的方法我们可以建立`footer.js`和`body.js`

```jsx
// footer.js
import React, { Component } from 'react'

export default class ComponentFooter extends Component {
  render() {
    return (
      <h1>这是尾部</h1>
    )
  }
}
```

```jsx
//indexBody.js
import React, { Component } from 'react'

export default class IndexBody extends Component {
  render() {
    return (
      <div>
        <h2>页面Body的内容</h2>
      </div>
    )
  }
}
```

然后在`index.js`里面再定义一个class用于包含已有的三个`header`，`indexbody`,`footer`三个类

```jsx
// index.js
import ComponentHeader from "./components/header";
import ComponentFooter from "./components/footer.js"
import IndexBody from "./components/indexBody";

export default class Index extends Component {
  render() {
    return (
      <div>
        <ComponentHeader />
        <IndexBody />
        <ComponentFooter />
      </div>
    )
  }
}
```

**注意**：所有的class的name一定要是大写开头的，不然无法识别 

### JSX内置表达式

```jsx
import React, {Component} from 'react'

export default class IndexBody extends Component {
    render() {
        var userName = '';
        var boolinput = false;
        var html = "this\u0020is"
        return (
            <div>
                <h2>页面主体内容</h2>
                <p>{userName=='' ? '用户还没有登陆':'用户名:'+userName}</p>
                <p><input type="button" value="默认按钮" disabled={boolinput}/></p>
                <p>{html}</p>
                {/* 注释 */}
            </div>
        )
    }
}

```

#### 三元表达式

三元表达式主要是用来进行条件判断的，比如我们在上面的代码汇总，需要判断`username`是否为空，用三元表达式`a==b?c:d`，判断ab是否相等，如果相等执行c，如果不相等执行d，这个判断语句要包含在大括号中

```jsx
<p>{userName=='' ? '用户还没有登陆':'用户名:'+userName}</p>
```

#### 绑定参数

如果要对一个input的button绑定是否disable的属性，只需要用一个大括号带参数就可以直接绑定成功

**注意**：绑定js参数的时候，**没有引号**，有引号会被解析为字符串

#### 解析HTML

如果我们现在有一串HTML代码，需要让render之后可以正确被解析，有两种方法：

1. 使用在线的转码工具，将html代码转成unicode编码的内容，然后传给内容html，比如下面的空格被转换成`\u0020`再传给render

   ```jsx
   var html = "this\u0020is"
   <p>{html}</p>
   ```

2. 使用不推荐的`dangerouslySetInnerHTML`，因为这种方法可能造成xss攻击，因此不推荐

   ```jsx
   var html = "this\u0020is"
   <p dangerouslySetInnerHTML=={{__html : html}}></p>
   ```

### 生命周期

react本身定义了一系列的关于页面加载状态的函数，你可以用这些函数来判断页面加载的状态，并在不同状态的时候定义不同的命令

常用的生命周期函数有如下几种，示意图如下

```jsx
componentWillMount() {}  //将要加载成功

componentDidMount() {}	//已经加载成功

componentWillReceiveProps(nextProps) {}

shouldComponentUpdate(nextProps, nextState) {}

componentWillUpdate(nextProps, nextState) {}

componentDidUpdate(prevProps, prevState) {}

componentWillUnmount() {}
```

![](http://ooi9t4tvk.bkt.clouddn.com/18-6-9/88589699.jpg)

## React事件与属性

### state属性

state用于存放react组件的状态，一般赋值为一个json类型，放在`constructor`里面

```jsx
import React, {Component} from 'react'


export default class IndexBody extends Component {
    constructor(props) {
        super(props);
        this.state = {
            username: 'carry',
            age: 20
        }
    }
    render() {
        setTimeout(() => {
            this.setState({username: "ohjj"})
        }, 4000);
        return (
            <div>
                <h2>页面主体内容</h2>
                <p>{this.state.username} {this.state.age}</p>
                {/* 注释 */}
            </div>
        )
    }
}
```

通过`setState`函数可以改变组件的状态值

### props属性

想要把外来的属性传给某个组件，就需要用到props属性，在render的内容中加入`参数名={参数值}`就可以直接传回参数，在对应的js文件中直接用`{this.props.参数名}`就可以调用

```jsx
//index.js
export default class Index extends Component {
  render() {
    return (
      <div>
        <ComponentHeader/>
        <IndexBody userid={123456}/>
        <ComponentFooter />
        <App/>
      </div>
    )
  }
}

// indexbody.js
export default class IndexBody extends Component {
    constructor(props) {
        super(props);
        this.state = {
            username: 'carry',
            age: 20
        }
    }


    render() {
        setTimeout(() => {
            this.setState({username: "ohjj"})
        }, 4000);
        return (
            <div>
                <h2>页面主体内容</h2>
                <p>{this.state.username} {this.state.age} {this.props.userid}</p>
                {/* 注释 */}
            </div>
        )
    }
}
```

### 事件与数据的双向绑定

父页面向子页面传递参数是在父页面直接定义变量，在子页面使用props属性来获取。

那么子页面如何向父页面传递参数呢，就需要由父页面向子页面传递一个处理函数，处理函数的event参数可以取到子页面中的值，比如在子页面的输入框中输入内容，改变父页面的某个参数值：

```jsx
//父页面 indexbody.js
import React, {Component} from 'react'
import Bodychild from "./bodychild";


export default class IndexBody extends Component {
    constructor(props) {
        super(props);
        this.state = {
            username: 'carry',
            age: 20
        }
    }

    changeUserInfo(age) {
        this.setState({age: age})
    }

    handleChildChange(event) {
        this.setState({age: event.target.value});
    }

    render() {
        return (
            <div>
                <h2>页面主体内容</h2>
                <input type="button" value="提交" onClick={this.changeUserInfo.bind(this,99)}/>
                <p>{this.state.username} {this.state.age}</p>
                <Bodychild handleChildChange={this.handleChildChange.bind(this)}/>
            </div>
        )
    }
}


//子页面 bodychild.js
import React, {Component} from 'react';

class Bodychild extends Component {
    render() {
        return (
            <div>
                <p>子页面输入：<input type="text" onChange={this.props.handleChildChange}/></p>
            </div>
        );
    }
}
export default Bodychild;

```

#### bind方法

bind方法和call方法以及apply方法差不多，主要是用于解决this的指向问题的，

call方法参数第一个是需要执行的对象，后面依次表示不同的参数

```js
var a={
    age:10,
    fn:function getAge(){console.log(this.age)}
}
a.fn();//输出10
var b = a.fn();
b;	//输出undefined，因为此时的this指向b，this.age就相当于b.age，当然是未定义
b.call(a) //输出10，call的格式是function.call(object,params)
```

apply方法与call方法基本类似，只是apply后面第一个参数是object，第二个参数是一个打包好的array对象，用于存放所有的后面的参数

```js
var a={
    age:10,
    fn:function getAge(params){console.log(this.age+this.params)}
}
a.fn(5);//输出15
var b = a.fn();
b;	//输出undefined
b.apply(a,[5]) //输出15，apply的格式是function.apply(object,[params])
```

bind方法与apply和call略有不同，但是三者都是用来改变this指向的

```js
var a={
    age:10,
    fn:function getAge(params){console.log(this.age+this.params)}
}
a.fn(5);//输出15
var b = a.fn;
b.bind(a);//发现没有任何输出，其实bind只是绑定了，但是没有执行
var c = b.bind(a);
c();//输出15，bind的格式是function.apply(object,params)()
```

### prop验证

用`propTypes`来约束类中的props的类型，`isRequired`表示必须给定这个值

用`defaultProps`来给定props的默认值

```jsx
const defaultProps={
    userid:'默认的userid'
};
IndexBody.propTypes = {
    userid: PropTypes.number.isRequired
};
IndexBody.defaultProps = defaultProps;

```

还有一个技巧：如果有多个参数从父页面传递到子页面，子页面需要再传给自身的子页面的时候，可以用`...this.props`，三个点的前两个表示上级页面，第三个点表示上级页面自身的this

```jsx
<Bodychild {...this.props}/>
```

### 组件refs

refs可以用来找到某个组件，类似于js当中的`getElementById`的作用，在某个组建中定义一个ref，在改变的时候只需要用`this.refs.xxx`

```jsx
changeUserInfo(age) {
    this.setState({
        age: age
    });
    //第一种方法，原生js的方法
    let mySubmitButton = document.getElementById('submitButton');
    ReactDOM.findDOMNode(mySubmitButton).style.color = 'red';

    //第二种方法，refs的方法
    console.log(this.refs.submitButton);
    this.refs.submitButton.style.color = 'blue'
}

render(){
<input id="submitButton" ref="submitButton" type="button" value="提交" onClick={this.changeUserInfo.bind(this, 99)}/>}

```

### 独立组件间共享Mixins

官方完全不推荐这个方法，因为ES6本身语法不支持，并且可能造成很多问题

如果非要用可以安装一个`react-mixin`的库，在需要用到这个东西的地方用`React.Mixin(类名.prototypem, 用到的mixins名称)`

## React样式

### React内联样式

直接定义在render函数里面，然后通过className引用，这样相当于在html当中直接嵌入了css代码，是比较不美观的

```jsx

render() {
    const styleHeader = {
        header: {
            backgroundColor: "#333333",
            color: "#FFFFFF",
            paddingTop: "15px",
            paddingBottom: "15px"
        }
    };
    return (
        <header  className="styleHeader">
            <h1>这是头部</h1>
        </header>
    )
}
```

还可以单独定义css文件

```jsx
// style.css
.smallFontSize h1{
    font-size: 12px;
}

//header.js
import React, {Component} from 'react'
import '../css/style.css'
export default class ComponentHeader extends Component {
    render() {
        return (
            <header  className="smallFontSize">
                <h1>这是头部</h1>
            </header>
        )
    }
}
```

### 内联css当中的表达式

内联css当中可以嵌套一些简单的三元条件表达式，下面这个例子是在点击使得状态`miniHeader`改变的时候，调整header的padding值

```jsx
export default class ComponentHeader extends Component {
    constructor(props) {
        super(props);
        this.state = {
            miniHeader : false
        }
    }

    swithHeader(){
            this.setState({
                miniHeader : !this.state.miniHeader
            })
    }

    render() {
        const styleHeader = {
            header: {
                backgroundColor: "#333333",
                color: "#FFFFFF",
                paddingTop: (this.state.miniHeader) ? "3px" : "15px",
                paddingBottom: (this.state.miniHeader) ? "3px" : "15px",
            }
        };
        return (
            <header style={styleHeader.header} onClick={this.swithHeader.bind(this)}>
                <h1>这是头部</h1>
            </header>
        )
    }
}
```

### css模块化

css模块化就是在css引入的时候的第二种方法，引入css文件，给组件的ClassName赋值

```jsx
import '../css/style.css'
        return (
            <header className="smallFontSize">
                <h1>这是头部</h1>
            </header>
        )
```

### css与React内联样式互转

如果你有一个很大的css文件，在开发React-native的时候，你只能使用内联样式，这时你可以使用在线转换工具把css转换为React内联样式，[转换工具地址](https://staxmanade.com/CssToReact/)

### Ant Design框架

Ant Design是蚂蚁金服出的一个React UI框架，其中有一部分是介绍设计审美的，是非常值得一看的

通过[https://ant.design/docs/react/use-with-create-react-app-cn](https://ant.design/docs/react/use-with-create-react-app-cn)进行使用

#### 引入Ant Design

现在从 yarn 或 npm 安装并引入 antd。

```
$ yarn add antd
```

修改 `src/App.js`，引入 antd 的按钮组件。

```
import React, { Component } from 'react';
import Button from 'antd/lib/button';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Button type="primary">Button</Button>
      </div>
    );
  }
}

export default App;
```

修改 `src/App.css`，在文件顶部引入 `antd/dist/antd.css`。

```
@import '~antd/dist/antd.css';

.App {
  text-align: center;
}

...
```

好了，现在你应该能看到页面上已经有了 antd 的蓝色按钮组件，接下来就可以继续选用其他组件开发应用了。其他开发流程你可以参考 create-react-app 的[官方文档](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md)。

## React-Router

React-Router用于页面之间的跳转

### 刷新部分页面内容

如果需要刷新部分页面内容，可以用`BrowserRouter`或者是`HashRouter`当中的一个，引入方法如下

```jsx
import {HashRouter as Router, Route, Link} from "react-router-dom";
```

然后在`index`类当中加入链接地址和`Route`

```jsx
export default class Index extends Component {

    render() {
        return (
            <Router>
            <div>
                <ul>
                    <li><Link to={`/`}>首页</Link></li>
                    <li><Link to={`/list1`}>list1</Link></li>
                    <li><Link to={`/list2`}>list2</Link></li>
                </ul>
                <ComponentHeader/>
                <IndexBody userid={1111}/>
                <ComponentFooter/>
                <Button type="primary marb10">button</Button>
                <Input placeholder="请输入内容" size="small"/>
                <App/>
                <div>
                                            <Route path='/list1' component={List}/>
                        <Route path='/list2' component={List2}/>
                </div>
            </div>
                </Router>
        )
    }
}
ReactDOM.render(<Index/>, document.getElementById('root'));、
```

Route是专门用来改变内容的，Route那一部分在哪，就改变哪一部分的内容，比如现在Route在`<APP />`后面，那么就改变`<App />`后面的内容

### 重新定向到新页面

如果需要定向到新页面，需要用到`Switch`参数，导入方法是：

```jsx
import {HashRouter as Router, Switch, Route, Link} from "react-router-dom";
```

此时需要将Index当成一个普通的类，嵌套到另一个export的类当中（因为一个js页面只能有1个export的类），比如我们现在定义一个`Root`类，在`Root`类当中定义一个`Router`，在`Router`中嵌套`Switch`方法（因为官方规定Switch只能在Router当中使用），再在Switch当中嵌套一堆`Route`，用于定于需要路由的地址（第一个地址默认解析，后面的在你点的时候解析），代码如下：

```jsx
class Index extends Component {

    render() {
        return (
            <div>
                <ul>
                    <li><Link to={`/`}>首页</Link></li>
                    <li><Link to={`/list1`}>list1</Link></li>
                    <li><Link to={`/list2`}>list2</Link></li>
                </ul>
                <ComponentHeader/>
                <IndexBody userid={1111}/>
                <ComponentFooter/>
                <Button type="primary marb10">button</Button>
                <Input placeholder="请输入内容" size="small"/>
                <App/>
            </div>
        )
    }
}

export default class Root extends Component {
    render() {
        return (
            <Router>
                <div>
                    <Switch>
                        {/*第一个默认解析*/}
                        <Route exact path='/' component={Index}/>
                        <Route path='/list1' component={List}/>
                        <Route path='/list2' component={List2}/>
                    </Switch>
                </div>
            </Router>
        )
    }
}

ReactDOM.render(<Root/>, document.getElementById('root'));
```

## 网站开发常用技巧及资源

### chrome模拟手机端

直接在chrome的开发者工具中点审查元素旁边的按钮，就可以模拟手机的显示效果，还可以显示手机边框

![](http://ooi9t4tvk.bkt.clouddn.com/18-6-11/73459277.jpg)

### findIcon找图标

一个非常好的网站图标资源网站，地址：[https://www.iconfinder.com/](https://www.iconfinder.com/)

## 项目实战开发

### pc端页头的开发

用到ant design的menu组件，还有ant desing的flex布局，flex布局将整个页面一共分为24列，我们这里左右各空2列，4列用于放logo，16列用于放menu

```jsx
//pc_header.js
import React, {Component} from 'react';
// import ReactDOM from 'react-dom';
import {Row, Col, Menu, Icon} from 'antd';
import logo from '../img/logo.png'
import '../css/pc.css'

class PCHeader extends Component {
    constructor(props) {
        super(props);
        this.state = {
            current : "top"}
    }

    render() {
        return (
            <header>
                <Row>
                    <Col span={2}/>

                    <Col span={4}>
                        <a href="/" className="logo">
                            <img src={logo} alt="logo"/>
                            <span>ReactNews</span>
                        </a>
                    </Col>

                    <Col span={16}>
                        <Menu mode="horizontal" selectedKeys={[this.state.current]}>
                            <Menu.Item key="top">
                                <Icon type="appstore" />头条
                            </Menu.Item>

                            <Menu.Item key="shehui">
                                <Icon type="appstore" />社会
                            </Menu.Item>

                            <Menu.Item key="guonei">
                                <Icon type="appstore" />国内
                            </Menu.Item>

                            <Menu.Item key="guoji">
                                <Icon type="appstore" />国际
                            </Menu.Item>

                            <Menu.Item key="yule">
                                <Icon type="appstore" />娱乐
                            </Menu.Item>

                            <Menu.Item key="tiyu">
                                <Icon type="appstore" />体育
                            </Menu.Item>

                            <Menu.Item key="keji">
                                <Icon type="appstore" />科技
                            </Menu.Item>

                            <Menu.Item key="shishang">
                                <Icon type="appstore" />时尚
                            </Menu.Item>
                        </Menu>
                    </Col>

                    <Col span={2}/>

                </Row>
            </header>
        );
    }
}

PCHeader.propTypes = {};

export default PCHeader;

```

```css
/*pc.css*/
.logo{
    align-items: center;
    display: flex;
}

.logo img{
    width: 48px;
    height: 48px;
}

.logo span{
    font-size: 24px;
    padding-left: 5px;
}
```

注意**：引入图片的时候要用import的方法来引入，不然会找不到图片

menu菜单有两个属性，`mode`用于控制菜单的水平或者是竖直，`selectedKeys`用于设置一开始选中的标签

` mode="horizontal" selectedKeys={[this.state.current]}`

### 移动端header的开发

要判断是pc端还是移动端用到一个`react-responsive`这个库，通过`npm install --save react-responsive`进行安装

在`index.js`中进行判断是pc则返回fc端index，是手机则返回手机端index

```jsx
class Root extends Component {
    render() {
        return (
            <div>
                <MediaQuery query="(min-device-width: 1224px)">
                    <PCIndex/>
                </MediaQuery>
                <MediaQuery query="(max-device-width: 1224px)">
                    <MobileIndex/>
                </MediaQuery>
            </div>
        )
    }
}
```

在mobile header中先放入图标和名称，别的先不动

```jsx
// mobile_header.js
class MobileHeader extends Component {
render() {
        return (
            <header id="mobileheader">
                <a href="/" className="logo">
                    <img src={logo} alt="logo"/>
                    <span>ReactNews</span>
                </a>
            </header>
            ）
  }           
```

```css
html{
    font-size: 50px;
}

/*mobile.css*/
#mobileheader{
    flex: 1;
    padding-left: 5px;
}

#mobileheader{
    border-bottom: 1px solid #2db7f5;
}

#mobileheader img{
    height: 50px;
}

#mobileheader span{
    font-size: 35px;
    vertical-align: center;
    padding-left: 10px;
    color: #2db7f5;

}
```

### mobile及pc的footer开发

两者内容基本相同，这里贴出一个`mobile_footer.js`

```jsx
import React,{Component} from 'react';
import {Row, Col} from 'antd';

class MobileFooter extends Component {
    render() {
        return (
            <div>
                <Row>
                    <Col span={2}/>
                    <Col span={20} className="footer">
                        @ 2018 ReactNews. All Rights Reseved.
                    </Col>
                    <Col span={2}/>

                </Row>
            </div>
        );
    }
}


export default MobileFooter;
```





