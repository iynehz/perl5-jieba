#!/usr/bin/sh 

# swig
swig -c++ -perl5 -I./cppjieba/include -I. Jieba.i
mv Jieba.pm ./lib/Lingua/ZH/

#
rm -rf ./share
mkdir ./share
cp -r cppjieba/dict ./share
