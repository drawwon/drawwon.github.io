---
title: leetcode 322 解答--动态规划
date: 2018-04-23 09:53:45
tags: [动态规划,leetcode]
category: [编程练习]

---

### 题目

给定不同面额的硬币(coins)和一个总金额(amount)。写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合方式能组成总金额，返回`-1`。
<!--more-->

**示例 1:**
coins = `[1, 2, 5]`, amount = `11`
return `3` (11 = 5 + 5 + 1)

**示例 2:**
coins = `[2]`, amount = `3`
return `-1`.

**注意**:

你可以认为每种硬币的数量是无限的。

## 解答

动态规划的思路是用一个数组来存放需要的值，在零钱问题中，用dp[i]来表示凑齐钱数i所需要的最少硬币。

考虑凑齐钱数amount需要的最少硬币：如果需要`coin[j]` 硬币一枚，那么就相当于求`dp[amount-coin[j]]`，j的遍历范围是从0到`len(coin)-1` 

本来我们应该要把所有dp赋值为正无穷，但是因为就算是最小的面值为1，那么组成amount也只需要amount枚硬币，因此我们把所有的值都赋值为amount+1，首先定义一个迭代的起始值，组成0元钱只需要0枚硬币，即dp[0]=0

接下来开始遍历所有的coins，再遍历所有的dp，dp[i]应该等于自身和dp[i-c]+1当中小的那个，相当于用了一枚面值为c的硬币之后，dp[i-c]所用的最少的硬币，加上这一枚面值c硬币需要的总数

```python
class Solution(object):
    def coinChange(self, coins, amount):
        dp = [amount+1 for _ in range(amount+1)]
        dp[0] = 0
        for c in coins:
            for i in range(c,amount+1):
                dp[i] = min(dp[i],dp[i-c]+1)

        return -1 if dp[amount]==amount+1 else dp[amount]
```



变形：给定不同面额的硬币(coins)和一个总金额(amount)。写一个函数来计算可以凑成总金额可能的组合情况。如果没有任何一种硬币组合方式能组成总金额，返回0。

这里的区别和上面只是初始dp的方法和起始值dp[0]不同

此时的dp[0]=1，因为用所有硬币组合成0元钱只有一种方法，那就是所有的硬币都取0枚

然后dp其余值初始化为0，因为一开始是没有组成后面的可能的，迭代条件变为dp[i] = dp[i] + dp[i-c]，表示用一枚硬币c的时候，组合的情况

```python
class Solution(object):
    def coinChange(self, coins, amount):
        dp = [0 for _ in range(amount+1)]
        dp[0] = 1
        for c in coins:
            for i in range(c,amount+1):
                dp[i] += dp[i-c]

        return -1 if dp[amount]==amount+1 else dp[amount]
```





### 循环数组的不相邻求和最大值

因为结果不能同时包含最后一个值和第一个值，因此做两次调用，一次是1到最后，一次是0到倒数第二个，取其中最大值

迭代的条件是`dp[i] = max(my_list[i]+dp[i-2],dp[i-1])`，因为要么当前值加上跳过上一个值的和，要么不要当前值，要上一个值的和，取两者的最大值

```python
def sum_max(my_list):
    dp = [0 for _ in my_list]
    dp[0] = my_list[0]
    dp[1] = max(my_list[1],my_list[0])
    dp[2] = max(my_list[1],my_list[0] + my_list[2])

    for i in range(3,len(my_list)):
        dp[i] = max(my_list[i]+dp[i-2],dp[i-1])
    # if max(dp) == dp[i]:
    return max(dp)

if __name__ == '__main__':
    test_list = [10,3,5,7,9]
    print(max(sum_max(my_list=test_list[1:]),sum_max(test_list[:-1])))
```