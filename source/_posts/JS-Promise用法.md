---
title: JS Promise用法
date: 2018-06-05 17:09:34
tags: [JavaScript]
category: [JavaScript]
---

## 基本用法

Promise对象就是一个异步调用的对象，有两个参数`resolve`和`reject`，执行调用成功的情况下使用resolve，失败的时候使用`reject`。

<!--more-->

在keystroke项目中，我用到了下面这个例子

```js
registerKeystroke() {
    var username = $('#id_username').val();
    var password = $('#id_password').val();
    return this._sendRequest('/pc_data/', {'username': username, 'password': password})
        .then(res1 => {
        console.log('res1:' + res1);
        this._change_status(res1.toString());
        return res1;
    })
        .then((res2) => {
        console.log('res2:' + res2);
        return this._sendRequest('/server/register_keystroke/', {
            'login': username, 'password': password, "login_timestamps": this._loginInput.timeStamps,
            "password_timestamps": this._passwordInput.timeStamps,
        });
    }
             )
        .then(
        res3 => {
            console.log('res3:' + res3);
            return res3;
        })



        _sendRequest(url, data) {
        return new Promise((resolve) => {
            $.post(
                url,
                JSON.stringify(data),
                (data) => resolve(data),
                'json'
            );
        })
    }
}
```

先发送第一个请求到`/pc_data/`，如果成功，再发送一个到`/server/register_keystroke/`，

ES6原生提供了Promise对象。所谓Promise对象，就是代表了未来某个将要发生的事件（通常是一个异步操作）。它的好处在于，有了Promise对象，就可以将异步操作以同步操作的流程表达出来，避免了层层嵌套的回调函数。此外，Promise对象还提供了一整套完整的接口，使得可以更加容易地控制异步操作。Promise对象的概念的详细解释，请参考[《JavaScript标准参考教程》](http://javascript.ruanyifeng.com/)。

ES6的Promise对象是一个构造函数，用来生成Promise实例。下面是Promise对象的基本用法。

```js
var promise = new Promise(function(resolve, reject) {
  if (/* 异步操作成功 */){
    resolve(value);
  } else {
    reject(error);
  }
});

promise.then(function(value) {
  // success
}, function(value) {
  // failure
});
```

上面代码表示，Promise构造函数接受一个函数作为参数，该函数的两个参数分别是resolve方法和reject方法。如果异步操作成功，则用resolve方法将Promise对象的状态变为“成功”（即从pending变为resolved）；如果异步操作失败，则用reject方法将状态变为“失败”（即从pending变为rejected）。

promise实例生成以后，可以用then方法分别指定resolve方法和reject方法的回调函数。

下面是一个使用Promise对象的简单例子。

```js
function timeout(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

timeout(100).then(() => {
  console.log('done');
});
```

上面代码的timeout方法返回一个Promise实例对象，表示一段时间以后改变自身状态，从而触发then方法绑定的回调函数。

 下面是一个用Promise对象实现的Ajax操作的例子。

```js
var getJSON = function(url) {
  var promise = new Promise(function(resolve, reject){
    var client = new XMLHttpRequest();
    client.open("GET", url);
    client.onreadystatechange = handler;
    client.responseType = "json";
    client.setRequestHeader("Accept", "application/json");
    client.send();

    function handler() {
      if (this.status === 200) {
              resolve(this.response);
          } else {
              reject(new Error(this.statusText));
          }
    };
  });

  return promise;
};

getJSON("/posts.json").then(function(json) {
  console.log('Contents: ' + json);
}, function(error) {
  console.error('出错了', error);
});
```

 上面代码中，`resolve`方法和`reject`方法调用时，都带有参数。它们的参数会被传递给回调函数。`reject`方法的参数通常是`Error`对象的实例，而`resolve`方法的参数除了正常的值以外，还可能是另一个Promise实例，比如像下面这样。

```js
var p1 = new Promise(function(resolve, reject){
  // ... some code
});

var p2 = new Promise(function(resolve, reject){
  // ... some code
  resolve(p1);
})
```

上面代码中，`p1`和`p2`都是Promise的实例，但是`p2`的`resolve`方法将`p1`作为参数，这时`p1`的状态就会传递给`p2`。如果调用的时候，`p1`的状态是pending，那么`p2`的回调函数就会等待p1的状态改变；如果p1的状态已经是fulfilled或者rejected，那么p2的回调函数将会立刻执行。

## Promise.prototype.then方法：链式操作

Promise.prototype.then方法返回的是一个新的Promise对象，因此可以采用链式写法。

```js
getJSON("/posts.json").then(function(json) {
  return json.post;
}).then(function(post) {
  // proceed
});
```

上面的代码使用then方法，依次指定了两个回调函数。第一个回调函数完成以后，会将返回结果作为参数，传入第二个回调函数。

如果前一个回调函数返回的是Promise对象，这时后一个回调函数就会等待该Promise对象有了运行结果，才会进一步调用。

```js
getJSON("/post/1.json").then(function(post) {
  return getJSON(post.commentURL);
}).then(function(comments) {
  // 对comments进行处理
});
```

这种设计使得嵌套的异步操作，可以被很容易得改写，从回调函数的“横向发展”改为“向下发展”。

## Promise.prototype.catch方法：捕捉错误

Promise.prototype.catch方法是Promise.prototype.then(null, rejection)的别名，用于指定发生错误时的回调函数。

```js
getJSON("/posts.json").then(function(posts) {
  // some code
}).catch(function(error) {
  // 处理前一个回调函数运行时发生的错误
  console.log('发生错误！', error);
});
```

Promise对象的错误具有“冒泡”性质，会一直向后传递，直到被捕获为止。也就是说，错误总是会被下一个catch语句捕获。

```js
getJSON("/post/1.json").then(function(post) {
  return getJSON(post.commentURL);
}).then(function(comments) {
  // some code
}).catch(function(error) {
  // 处理前两个回调函数的错误
});
```

## Promise.all方法，Promise.race方法

Promise.all方法用于将多个Promise实例，包装成一个新的Promise实例。

```
var p = Promise.all([p1,p2,p3]);
```

上面代码中，Promise.all方法接受一个数组作为参数，p1、p2、p3都是Promise对象的实例。（Promise.all方法的参数不一定是数组，但是必须具有iterator接口，且返回的每个成员都是Promise实例。）

p的状态由p1、p2、p3决定，分成两种情况。

（1）只有p1、p2、p3的状态都变成fulfilled，p的状态才会变成fulfilled，此时p1、p2、p3的返回值组成一个数组，传递给p的回调函数。

（2）只要p1、p2、p3之中有一个被rejected，p的状态就变成rejected，此时第一个被reject的实例的返回值，会传递给p的回调函数。

下面是一个具体的例子。

```js
// 生成一个Promise对象的数组
var promises = [2, 3, 5, 7, 11, 13].map(function(id){
  return getJSON("/post/" + id + ".json");
});

Promise.all(promises).then(function(posts) {
  // ...
}).catch(function(reason){
  // ...
});
```

Promise.race方法同样是将多个Promise实例，包装成一个新的Promise实例。

```js
var p = Promise.race([p1,p2,p3]);
```

上面代码中，只要p1、p2、p3之中有一个实例率先改变状态，p的状态就跟着改变。那个率先改变的Promise实例的返回值，就传递给p的返回值。

如果Promise.all方法和Promise.race方法的参数，不是Promise实例，就会先调用下面讲到的Promise.resolve方法，将参数转为Promise实例，再进一步处理。

## Promise.resolve方法，Promise.reject方法

有时需要将现有对象转为Promise对象，Promise.resolve方法就起到这个作用。

```
var jsPromise = Promise.resolve($.ajax('/whatever.json'));
```

上面代码将jQuery生成deferred对象，转为一个新的ES6的Promise对象。

如果Promise.resolve方法的参数，不是具有then方法的对象（又称thenable对象），则返回一个新的Promise对象，且它的状态为fulfilled。

```js
var p = Promise.resolve('Hello');

p.then(function (s){
  console.log(s)
});
// Hello
```

上面代码生成一个新的Promise对象的实例p，它的状态为fulfilled，所以回调函数会立即执行，Promise.resolve方法的参数就是回调函数的参数。

如果Promise.resolve方法的参数是一个Promise对象的实例，则会被原封不动地返回。

Promise.reject(reason)方法也会返回一个新的Promise实例，该实例的状态为rejected。Promise.reject方法的参数reason，会被传递给实例的回调函数。

```js
var p = Promise.reject('出错了');

p.then(null, function (s){
  console.log(s)
});
// 出错了
```

上面代码生成一个Promise对象的实例p，状态为rejected，回调函数会立即执行。
