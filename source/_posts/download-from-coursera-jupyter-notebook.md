---
title: download from coursera jupyter notebook
date: 2018-05-02 20:59:22
tags:[coursera]
category:[python]

---

为了从coursera上面下载写过的jupyter notebook，可以在根目录下新建一个notebook，执行以下代码，然后生成一个currdir.tar的文件，下载这个文件即可


```python
import os
import tarfile
tarFileName='currdir.tar'
def RecursiveFiles(dn='.',ignoreTarFile=tarFileName):
    ignore={'.pynb_checkpoints','pycache',ignoreTarFile}
    for dirname,subdirs,files in os.walk(dn):
        if os.path.basename(dirname) in ignore: continue
        for fn in files:
            fname=os.path.join(dirname,fn)
            yield(fname)
		#return # 这个return在我的notebook中要注释掉，网上说有些情况下要不注释，因此需要尝试一下
def makeTarFile(dn='.',tfn=tarFileName):
    tar=tarfile.open(tfn,'w')
    for name in RecursiveFiles(dn,tfn):
        tar.add(name)
    tar.close()

makeTarFile()
```

