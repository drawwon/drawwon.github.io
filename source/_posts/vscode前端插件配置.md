---
title: vscode前端插件配置
date: 2018-05-27 12:07:22
tags: [工具]
category: [编程学习,工具]
---

## vscode插件安装

<!--more-->

- **Atom One Dark Theme** 主题
- **VSCode Great Icons** 图标主题
- **Beautify** 美化vscode代码
- **Bracket Pair Colorizer** 每一对括号用不同颜色区别
- **Code Runner** node，python等代码不必开命令行即可运行
- **Eslint** 语法检测
- **Git History** git提交历史
- **GitLens** 在代码中显示每一行代码的提交历史
- **HTML CSS Support** vscode对html，css文件支持，便于你快速书写属性
- **Path Intellisense** 路径识别苦战，比如书写图片路径时。遗憾就是，对webpack项目中的路径别名无法扩展
- **Prettier** 格式化，使用大名鼎鼎的prettier对你的文件进行格式化，快捷键 alt+shift +F
- **Python** 添加对.py文件的支持，毕竟tab与空格的痛苦写过python的都知道
- **React Native Tools** 添加对 React Native项目的支持，让便你书写es6以及jsx
- **C/C++** 运行React Native项目时，有些文件的查看需要这个
- **Settings Sync** 用于同步vscode配置（相对而言配置更复杂，可不安装）
- **Sublime Text Keymap** 启动sublimeText的快捷键配置。vscode上面自有一套快捷键设定，个人习惯sublime了
- **Vetur** 添加对单文件.vue后缀文件的快速书写支持。computed,mounted等迅速书写
- **Vue 2 Snippets** 新建vue模板（如何新建参考我另一篇文章）
- **markdownlint** 书写md文件的预览插件
- **language-stylus** CSS预处理器styl后缀文件的识别扩展
- **View In Browser** 迅速通过浏览器打开文件

```
{ // VScode主题配置
    "editor.tabSize": 2,
    "editor.lineHeight": 24,
    "editor.renderLineHighlight": "none",
    "editor.renderWhitespace": "none",
    "editor.fontFamily": "Consolas",
    "editor.fontSize": 15,
    "editor.cursorBlinking": "smooth",
    "editor.multiCursorModifier": "ctrlCmd",
    "editor.formatOnPaste": true,
    // 是否允许自定义的snippet片段提示,比如自定义的vue片段开启后就可以智能提示
    "editor.snippetSuggestions": "top",
    "workbench.iconTheme": "vscode-great-icons",
    "workbench.colorTheme": "One Dark Pro Vivid",
    "workbench.startupEditor": "newUntitledFile",
    "html.suggest.angular1": false,
    "html.suggest.ionic": false,
    "files.trimTrailingWhitespace": true,
    // vetur插件格式化使用beautify内置规则
    "vetur.format.defaultFormatter.html": "js-beautify-html",
    // VScode 文件搜索区域配置
    "search.exclude": {
        "**/dist": true,
        "**/build": true,
        "**/elehukouben": true,
        "**/.git": true,
        "**/.gitignore": true,
        "**/.svn": true,
        "**/.DS_Store": true,
        "**/.idea": true,
        "**/.vscode": false,
        "**/yarn.lock": true,
        "**/tmp": true
    },
    // 排除文件搜索区域，比如node_modules(贴心的默认设置已经屏蔽了)
    "files.exclude": {
        "**/.idea": true,
        "**/yarn.lock": true,
        "**/tmp": true
    },
    // 配置文件关联，以便启用对应的智能提示，比如wxss使用css
    "files.associations": {
        "*.vue": "vue",
        "*.wxss": "css"
    },
    // 配置emmet是否启用tab展开缩写
    "emmet.triggerExpansionOnTab": true,
    // 配置emmet对文件类型的支持，比如vue后缀文件按照html文件来进行emmet扩写
    "emmet.syntaxProfiles": {
        "vue-html": "html",
        "vue": "html",
        "javascript": "javascriptreact",
        // xml类型文件默认都是单引号，开启对非单引号的emmet识别
        "xml": {
            "attr_quotes": "single"
        }
    },
    // 在react的jsx中添加对emmet的支持
    "emmet.includeLanguages": {
        "jsx-sublime-babel-tags": "javascriptreact"
    },
    // 是否开启eslint检测
    "eslint.enable": false,
    // 文件保存时，是否自动根据eslint进行格式化
    "eslint.autoFixOnSave": false,
    // eslint配置文件
    "eslint.options": {
        "plugins": [
            "html",
            "javascript",
            {
                "language": "vue",
                "autoFix": true
            },
            "vue"
        ]
    },
    // eslint能够识别的文件后缀类型
    "eslint.validate": [
        "javascript",
        "javascriptreact",
        "html",
        "vue",
        "typescript",
        "typescriptreact"
    ],
    // 快捷键方案,使用sublime的一套快捷键
    "sublimeTextKeymap.promptV3Features": true,
    // 格式化快捷键 shirt+alt+F
    // prettier进行格式化时是否安装eslint配置去执行，建议false
    "prettier.eslintIntegration": true,
    // 如果为true，将使用单引号而不是双引号
    "prettier.singleQuote": true,
    // 细节,配置gitlen中git提交历史记录的信息显示情况
    "gitlens.advanced.messages": {
        "suppressCommitHasNoPreviousCommitWarning": false,
        "suppressCommitNotFoundWarning": false,
        "suppressFileNotUnderSourceControlWarning": false,
        "suppressGitVersionWarning": false,
        "suppressLineUncommittedWarning": false,
        "suppressNoRepositoryWarning": false,
        "suppressResultsExplorerNotice": false,
        "suppressUpdateNotice": true,
        "suppressWelcomeNotice": false
    },
    // 开启apicloud在vscode中的wifi真机同步
    "apicloud.port": "23450",
    // 设置apicloud在vscode中的wifi真机同步根目录
    "apicloud.subdirectories": "/apiclouduser",
    // git是否启用自动拉取
    "git.autofetch": true,
}
```