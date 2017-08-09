#!/bin/bash
cd /home/jeffrey/codes/blog
hexo d -g
git add .
git commit -m "Updated"
git push origin source
echo -e "push and deploy done!\n"
