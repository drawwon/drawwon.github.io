---
title: leetcode-22解答
mathjax: true
date: 2018-08-27 21:31:18
tags: [leetcode]
category: [算法,leetcode]
---

给定一个值n，要求能生成n对括号的组合数，题目具体如下：

Given *n* pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

<!--more-->

For example, given *n* = 3, a solution set is:

```
[
  "((()))",
  "(()())",
  "(())()",
  "()(())",
  "()()()"
]
```

 ### 方法一：暴力求解

把所有有可能的情况全部列出来，判断是否符合要求，符合的留下：

```python
class Solution:
    def generateParenthesis(self, n):
        """
        :type n: int
        :rtype: List[str]
        """
        def is_valid(str_list):
            count=0
            for i in str_list:
                if i=='(':count+=1
                else:count-=1
                if count<0:return False
            return count==0
        res = ["("]
        for i in range(2*n-1):
            cur_res = []
            for j in res:
                cur_res.append(j+'(')
                cur_res.append(j+')')
            res = cur_res
        fin = []
        for i in res:
            if is_valid(i):
                fin.append(i)
        return fin
```

### 方法二：递归

```python
class Solution(object):
    def generateParenthesis(self, n):
        def generate(A = []):
            if len(A) == 2*n:
                if valid(A):
                    ans.append("".join(A))
            else:
                A.append('(')
                generate(A)
                A.pop()
                A.append(')')
                generate(A)
                A.pop()

        def valid(A):
            bal = 0
            for c in A:
                if c == '(': bal += 1
                else: bal -= 1
                if bal < 0: return False
            return bal == 0

        ans = []
        generate()
        return ans
```

### 方法三：回溯

只加那些可能是正确的情况，不像前面两种方法枚举所有情况

```python
class Solution(object):
    def generateParenthesis(self, N):
        ans = []
        def backtrack(S = '', left = 0, right = 0):
            if len(S) == 2 * N:
                ans.append(S)
                return
            if left < N:
                backtrack(S+'(', left+1, right)
            if right < left:
                backtrack(S+')', left, right+1)

        backtrack()
        return ans
```

