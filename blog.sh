!#/bin/bash

cd /home/jeffrey/codes/blogs
hexo d -g
git add .
git commit -m "Updated"
git push origin source
echo "push and deploy done!\n"
