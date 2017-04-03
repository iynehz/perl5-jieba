#!/usr/bin/env perl

# swig
system("swig -c++ -perl5 -I./cppjieba/include -I. Jieba.i");
system("mv Jieba.pm ./lib/Lingua/ZH/");

# share dir
system("rm -rf ./share");
mkdir("./share");
system("cp -r cppjieba/dict ./share");
