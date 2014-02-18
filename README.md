[![Build Status](https://travis-ci.org/jjulien/augeas-gitolite.png)](https://travis-ci.org/jjulien/augeas-gitolite)

Overview
==============
This is an augeas lens that is used to manage a gitolite.conf file.  There are still some additional challenges to managing the gitolite.conf file since it resides in the gitolite-admin repo.  The best way to use this lens is in conjunction with your own custom script to clone and push the gitolite-admin repo before/after changes.

Documentation
-----------
### Usage
Coming soon...

### Development
Any new features or modifications should have an associated test with a comment describing the test in tests/test_gitolite.aug

**Running tests**
```make test```

**Installing**
```make install````

**Loading a test gitolite config file using augtool**
```
john@linux3 [/home/john]
$ augtool -I /home/john/augeas-gitolite
augtool> set /augeas/load/Gitolite/incl[last()+1] "/home/john/gitolite.conf"
augtool> load
augtool> print /files/home/john/gitolite.conf
/files/home/john/gitolite.conf
/files/home/john/gitolite.conf/group = "group1"
/files/home/john/gitolite.conf/group/user = "user1"
augtool> 
```
