#!/bin/bash
git add .
git commit -m "update"
git push origin source
hexo d -g
