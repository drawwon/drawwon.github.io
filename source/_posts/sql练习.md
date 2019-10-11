---
title: sql练习
mathjax: true
date: 2019-09-26 10:05:51
tags: [sql]
category: [编程学习]
---

在牛客上看到sql练习题，之前对于多表join类的操作不够熟悉，刚好练习一下

<!--more-->

#### 1. 查找最晚入职员工的所有信息

>CREATE TABLE `employees` (
>`emp_no` int(11) NOT NULL,
>`birth_date` date NOT NULL,
>`first_name` varchar(14) NOT NULL,
>`last_name` varchar(16) NOT NULL,
>`gender` char(1) NOT NULL,
>`hire_date` date NOT NULL,
>PRIMARY KEY (`emp_no`));

```sql
select * from employees order by hire_date desc limit 1
```

#### 2. 查找入职员工时间排名倒数第三的员工所有信息

>CREATE TABLE `employees` (
>`emp_no` int(11) NOT NULL,
>`birth_date` date NOT NULL,
>`first_name` varchar(14) NOT NULL,
>`last_name` varchar(16) NOT NULL,
>`gender` char(1) NOT NULL,
>`hire_date` date NOT NULL,
>PRIMARY KEY (`emp_no`));

```sql
select * from employees order by hire_date desc limit 2,1
```

limit m,n 表示从m开始，取n个数

#### 3. 查找各个部门当前(to_date='9999-01-01')领导当前薪水详情以及其对应部门编号dept_no

> CREATE TABLE `dept_manager` (
> `dept_no` char(4) NOT NULL,
> `emp_no` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));
> CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));

```sql
select s.*, d.dept_no from salaries as s, dept_manager as d where s.to_date='9999-01-01' and d.to_date='9999-01-01' and s.emp_no=d.emp_no
```

也可以用join来实现

```sql
select s.*, d.dept_no from salaries as s join dept_manager as d on s.emp_no=d.emp_no where s.to_date='9999-01-01' and d.to_date='9999-01-01'
```

#### 4. 查找所有已经分配部门的员工的last_name和first_name

>CREATE TABLE `dept_emp` (
>`emp_no` int(11) NOT NULL,
>`dept_no` char(4) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`dept_no`));
>
>CREATE TABLE `employees` (
>`emp_no` int(11) NOT NULL,
>`birth_date` date NOT NULL,
>`first_name` varchar(14) NOT NULL,
>`last_name` varchar(16) NOT NULL,
>`gender` char(1) NOT NULL,
>`hire_date` date NOT NULL,
>PRIMARY KEY (`emp_no`));

```sql
select e.last_name, e.first_name, d.dept_no from employees as e, dept_emp as d where e.emp_no=d.emp_no
```

#### 5. 查找所有员工的last_name和first_name以及对应部门编号dept_no，也包括展示没有分配具体部门的员工

>CREATE TABLE `dept_emp` (
>`emp_no` int(11) NOT NULL,
>`dept_no` char(4) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`dept_no`));
>
>CREATE TABLE `employees` (
>`emp_no` int(11) NOT NULL,
>`birth_date` date NOT NULL,
>`first_name` varchar(14) NOT NULL,
>`last_name` varchar(16) NOT NULL,
>`gender` char(1) NOT NULL,
>`hire_date` date NOT NULL,
>PRIMARY KEY (`emp_no`));

```sql
select e.last_name, e.first_name, d.dept_no from employees as e left join dept_emp as d on e.emp_no=d.emp_no
```

#### 6. 查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t

>CREATE TABLE `salaries` (
>`emp_no` int(11) NOT NULL,
>`salary` int(11) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`from_date`));

```sql
select emp_no, count(1) as t from salaries group by emp_no having t>15
```

这是查出数量大于15条的记录，其实这道题的题意是涨薪15次，应该用join来做

```sql
select a.emp_no, count(1) as t from salaries as a left join salaries as b on a.emp_no=b.emp_no and a.to_date=b.from_date group by a.emp_no having t>15
```

#### 7. 获取所有部门当前manager的当前薪水情况，给出dept_no, emp_no以及salary，当前表示to_date='9999-01-01'

>CREATE TABLE `dept_manager` (
>`dept_no` char(4) NOT NULL,
>`emp_no` int(11) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`dept_no`));
>
>
>
>CREATE TABLE `salaries` (
>`emp_no` int(11) NOT NULL,
>`salary` int(11) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`from_date`));

```sql
select d.dept_no, d.emp_no, s.salary 
from dept_manager as d, salaries as s 
where d.emp_no=s.emp_no 
AND d.to_date = '9999-01-01'
AND s.to_date = '9999-01-01' 
order by d.emp_no 
```

#### 8. 获取所有非manager的员工emp_no

> CREATE TABLE `dept_manager` (
> `dept_no` char(4) NOT NULL,
> `emp_no` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));
>
> CREATE TABLE `employees` (
> `emp_no` int(11) NOT NULL,
> `birth_date` date NOT NULL,
> `first_name` varchar(14) NOT NULL,
> `last_name` varchar(16) NOT NULL,
> `gender` char(1) NOT NULL,
> `hire_date` date NOT NULL,
> PRIMARY KEY (`emp_no`));

方法1：not in

```sql
select emp_no from employees where emp_no not in (select emp_no from dept_manager)
```

方法2：left join is null

```sql
select e.emp_no from employees as e left join 
dept_manager as d on e.emp_no=d.emp_no 
where d.dept_no is null
```

#### 9. 获取所有员工当前的manager，如果当前的manager是自己的话结果不显示，当前表示to_date='9999-01-01'。
结果第一列给出当前员工的emp_no,第二列给出其manager对应的manager_no。

> CREATE TABLE `dept_emp` (
> `emp_no` int(11) NOT NULL,
> `dept_no` char(4) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));
>
> CREATE TABLE `dept_manager` (
> `dept_no` char(4) NOT NULL,
> `emp_no` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));

```sql
select e.emp_no, m.emp_no from dept_emp as e left join 
dept_manager as m on e.dept_no=m.dept_no 
where e.emp_no!=m.emp_no and e.to_date='9999-01-01' and m.to_date='9999-01-01'
```

#### 10. 获取所有部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary
> CREATE TABLE `dept_emp` (
> `emp_no` int(11) NOT NULL,
> `dept_no` char(4) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));
> CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));

```sql
select d.dept_no, s.emp_no, max(s.salary) as salary from 
salaries as s, dept_emp as d on s.emp_no=d.emp_no 
where d.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
group by d.dept_no
```

####  11. 从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。

> CREATE TABLE IF NOT EXISTS "titles" (
> `emp_no` int(11) NOT NULL,
> `title` varchar(50) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date DEFAULT NULL);

```sql
select title, count(1) as t from titles group by title having t>=2
```

#### 12. 从titles表获取按照title进行分组，每组个数大于等于2，给出title以及对应的数目t。
注意对于重复的emp_no的title进行忽略。

> CREATE TABLE IF NOT EXISTS `titles` (
> `emp_no` int(11) NOT NULL,
> `title` varchar(50) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date DEFAULT NULL);

```sql
select  title, count(distinct emp_no) as t from titles group by title having t>=2
```

#### 13. 查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，并按照hire_date逆序排列
> CREATE TABLE `employees` (
> `emp_no` int(11) NOT NULL,
> `birth_date` date NOT NULL,
> `first_name` varchar(14) NOT NULL,
> `last_name` varchar(16) NOT NULL,
> `gender` char(1) NOT NULL,
> `hire_date` date NOT NULL,
> PRIMARY KEY (`emp_no`));

```sql
select emp_no,birth_date, first_name, last_name, gender, hire_date from employees 
where emp_no%2=1 and last_name!='Mary' order by hire_date desc
```

#### 14.统计出当前各个title类型对应的员工当前（to_date='9999-01-01'）薪水对应的平均工资。结果给出title以及平均工资avg。
>  CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));
>
> CREATE TABLE IF NOT EXISTS "titles" (
> `emp_no` int(11) NOT NULL,
> `title` varchar(50) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date DEFAULT NULL);

```sql
select t.title, avg(s.salary) as avg from titles as t inner join salaries as s on t.emp_no=s.emp_no 
where s.to_date='9999-01-01' and t.to_date='9999-01-01'
group by t.title
```

####15. 获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no以及其对应的薪水salary
> CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));

要去掉工资相同的情况

```sql
select emp_no, salary from salaries 
where to_date='9999-01-01' and salary=(select distinct salary from salaries order by salary desc limit 1,1)
```

#### 16. 查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、薪水salary、last_name以及first_name，不准使用order by
> CREATE TABLE `employees` (
> `emp_no` int(11) NOT NULL,
> `birth_date` date NOT NULL,
> `first_name` varchar(14) NOT NULL,
> `last_name` varchar(16) NOT NULL,
> `gender` char(1) NOT NULL,
> `hire_date` date NOT NULL,
> PRIMARY KEY (`emp_no`));
> CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));

用两遍max来代理order by limit 1,1

```sql
select e.emp_no, max(s.salary) as salary, e.last_name, e.first_name 
from employees as e inner join salaries as s 
on s.emp_no=e.emp_no 
where s.to_date='9999-01-01' and 
s.salary not in (select max(salary) from salaries where to_date='9999-01-01')
```

####17. 查找所有员工的last_name和first_name以及对应的dept_name，也包括暂时没有分配部门的员工
> CREATE TABLE `departments` (
> `dept_no` char(4) NOT NULL,
> `dept_name` varchar(40) NOT NULL,
> PRIMARY KEY (`dept_no`));
>
> CREATE TABLE `dept_emp` (
> `emp_no` int(11) NOT NULL,
> `dept_no` char(4) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`dept_no`));
>
> CREATE TABLE `employees` (
> `emp_no` int(11) NOT NULL,
> `birth_date` date NOT NULL,
> `first_name` varchar(14) NOT NULL,
> `last_name` varchar(16) NOT NULL,
> `gender` char(1) NOT NULL,
> `hire_date` date NOT NULL,
> PRIMARY KEY (`emp_no`));

三个表两次级联

```sql
select e.last_name, e.first_name, dp.dept_name 
from employees as e left join dept_emp as d on e.emp_no=d.emp_no
left join departments as dp on d.dept_no=dp.dept_no
```

#### 18. 查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth
>  CREATE TABLE `salaries` (
> `emp_no` int(11) NOT NULL,
> `salary` int(11) NOT NULL,
> `from_date` date NOT NULL,
> `to_date` date NOT NULL,
> PRIMARY KEY (`emp_no`,`from_date`));

两次查找，一次以to_date正向排序，一次逆向排序

```sql
select 
(select salary from salaries where emp_no=10001 order by to_date desc)-
(select salary from salaries where emp_no=10001 order by to_date)
as growth
```

#### 19. 查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no以及其对应的薪水涨幅growth，并按照growth进行升序

>CREATE TABLE `employees` (
>`emp_no` int(11) NOT NULL,
>`birth_date` date NOT NULL,
>`first_name` varchar(14) NOT NULL,
>`last_name` varchar(16) NOT NULL,
>`gender` char(1) NOT NULL,
>`hire_date` date NOT NULL,
>PRIMARY KEY (`emp_no`));
>
>CREATE TABLE `salaries` (
>`emp_no` int(11) NOT NULL,
>`salary` int(11) NOT NULL,
>`from_date` date NOT NULL,
>`to_date` date NOT NULL,
>PRIMARY KEY (`emp_no`,`from_date`));

方法一：用两次left join，加一次inner join

```sql
SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM (SELECT s.emp_no, s.salary FROM employees e
      LEFT JOIN salaries s ON e.emp_no = s.emp_no WHERE s.to_date = '9999-01-01') AS sCurrent
INNER JOIN (SELECT s.emp_no, s.salary FROM employees e 
            LEFT JOIN salaries s ON e.emp_no = s.emp_no WHERE s.from_date = e.hire_date) AS sStart
ON sCurrent.emp_no = sStart.emp_no
ORDER BY growth
```

方法二：用多次select


```sql
SELECT sCurrent.emp_no, (sCurrent.salary-sStart.salary) AS growth
FROM (SELECT s.emp_no, s.salary FROM employees e, salaries s 
      WHERE e.emp_no = s.emp_no AND s.to_date = '9999-01-01') AS sCurrent,
(SELECT s.emp_no, s.salary FROM employees e, salaries s 
 WHERE e.emp_no = s.emp_no AND s.from_date = e.hire_date) AS sStart
WHERE sCurrent.emp_no = sStart.emp_no
ORDER BY growth
```

