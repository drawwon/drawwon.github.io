#!/bin/bash
git add .
$current_date_time=`date "+%Y-%m-%d %H:%M:%S"`
git commit -m "update $current_date_time"
git push origin source
hexo d -g
