[![Actions Status](https://github.com/stphnlyd/perl5-jieba/actions/workflows/ci.yml/badge.svg)](https://github.com/stphnlyd/perl5-jieba/actions)

# NAME

Lingua::ZH::Jieba - Perl wrapper for CppJieba (Chinese text segmentation)

# SYNOPSIS

```perl
use Lingua::ZH::Jieba;

binmode STDOUT, ":utf8";

my $jieba = Lingua::ZH::Jieba->new();

# default cut (切词，MP/HMM混合方法)
my $words = $jieba->cut("他来到了网易杭研大厦");
print join('/', @$words), "\n";
# 他/来到/了/网易/杭研/大厦

# cut without HMM (切词，MP方法)
my $words_nohmm = $jieba->cut(
    "他来到了网易杭研大厦",
    { no_hmm => 1 } );
print join('/', @$words_nohmm), "\n";
# 他/来到/了/网易/杭/研/大厦

# cut all (Full方法，切出所有词典里的词语)
my $words_cutall = $jieba->cut(
    "我来到北京清华大学",
    { cut_all => 1 } );
print join('/', @$words_cutall), "\n";
# 我/来到/北京/清华/清华大学/华大/大学

# cut for search (先用Mix方法切词，对于切出的较长词再用Full方法)
my $words_cut4search = $jieba->cut_for_search(
    "小明硕士毕业于中国科学院计算所，后在日本京都大学深造" );
print join('/', @$words_cut4search), "\n";
# 小明/硕士/毕业/于/中国/科学/学院/科学院/中国科学院/计算/计算所/，/后/在/日本/京都/大学/日本京都大学/深造

# get word offset and length with cut_ex() or cut_for_search_ex()
my $words_ex = $jieba->cut_ex("他来到了网易杭研大厦");
# [
#   [ "他",     0, 1 ],
#   [ "来到",   1, 2 ],
#   [ "了",     3, 1 ],
#   [ "网易",   4, 2 ],
#   [ "杭研",   6, 2 ],
#   [ "大厦",   8, 2 ],
# ]

# part-of-speech tagging (词性标注)
my $word_pos_tags = $jieba->tag("我是蓝翔技工拖拉机学院手扶拖拉机专业的。");
for my $pair (@$word_pos_tags) {
    my ($word, $part_of_speech) = @$pair;
    print "$word:$part_of_speech\n";
}
# 我:r
# 是:v
# 蓝翔:nz
# 技工:n
# 拖拉机:n
# ...

# keyword extraction (关键词提取)
my $extractor = $jieba->extractor();
my $word_score = $extractor->extract(
    "我是拖拉机学院手扶拖拉机专业的。不用多久，我就会升职加薪，当上CEO，走上人生巅峰。",
    5
);
for my $pair (@$word_scores) {
    my ($word, $score) = @$pair;
    printf "%s:%.3f\n", $word, $score;
}
# CEO:11.739
# 升职:10.856
# 加薪:10.643
# 手扶拖拉机:10.009
# 巅峰:9.494

# insert user word (动态增加用户词)
my $words_before_insert = $jieba->cut("男默女泪");
print join('/', @$words_before_insert), "\n";
# 男默/女泪

$jieba->insert_user_word("男默女泪");

my $words_after_insert = $jieba->cut("男默女泪");
print join('/', @$words_after_insert), "\n";
# 男默女泪
```

# DESCRIPTION

This module is the Perl wrapper for CppJieba, which is a C++ implementation of
the Jieba Chinese text segmentation library. The Perl/C++ binding is generated
via SWIG. 

The module may contain several packages. Unless stated otherwise, you only
need to `use Lingua::ZH::Jieba;` in your programs.

At present this module is still in alpha state. Its interface is subject to
change in future, although I will keep compatibilities if possible.

# CONSTRUCTOR

## new

```perl
my $jieba = Lingua::ZH::Jieba->new;
```

By default constructor would use data files from "share" dir of its
installation. But it's possible to override any of the data files like below.

```perl
my $jieba = Lingua::ZH::Jieba->new(
    {
        dict_path => $my_dict_path,
        hmm_path => $my_hmm_path,
        user_dict_path => $my_user_dict_path,
        idf_path => $my_idf_path,
        stop_word_path => $my_stop_word,
    }
);
# if you just would like override user dict 
my $jieba = Lingua::ZH::Jieba->new(
    {
        user_dict_path => $my_user_dict_path,
    }
);
```

# METHODS

## cut

```perl
my $words = $jieba->cut($sentence);
```

Default cut mode. Returns an arrayref of utf8 strings of words cut from
the sentence.

```perl
my $words = $jieba->cut($sentence, { no_hmm => 1 });
```

Cut without HMM mode.

```perl
my $words = $jieba->cut($sentence, { cut_all => 1 });
```

Cut all possible words in dictionary.

## cut\_ex

```perl
my $words_ex = $jieba->cut_ex($sentence);
```

Similar to `cut()`, but returns an arrayref of complex data.
Each element in the result arrayref is `[ word, offset, length ]`.

## cut\_for\_search

```perl
my $words = $jieba->cut_for_search($sentence);
my $words_nohmm = $jieba->cut_for_search($sentence, { no_hmm => 1 });
```

## cut\_for\_search\_ex

```perl
my $words_ex = $jieba->cut_for_search_ex($sentence);
```

Similar to `cut_for_search()`, but returns an arrayref of complex data.
Each element in the result arrayref is `[ word, offset, length ]`.

## tag

```perl
my $word_pos_tags = $jieba->tag($sentence);
for my $pair (@$word_pos_tags) {
    my ($word, $part_of_speech) = @$pair;
    ...
}
```

POS (part-of-speech) tagging. Returns an arrayref of which each element is in
the form of `[ $word, $part_of_speech ]`.

## insert\_user\_word

```perl
$jieba->insert_user_word($word);
```

Dynamically inserts a user word.

## extractor

```perl
my $extractor = $jieba->extractor();

```

Get the keyword extractor object. For more about the extractor, see
[Lingua::ZH::Jieba::KeywordExtractor](https://metacpan.org/pod/Lingua%3A%3AZH%3A%3AJieba%3A%3AKeywordExtractor).

# SEE ALSO

[https://github.com/fxsjy/jieba](https://github.com/fxsjy/jieba) - Jieba, the Chinese text segmentation
library

[https://github.com/yanyiwu/cppjieba](https://github.com/yanyiwu/cppjieba) - CppJieba, Jieba implemented in C++

[http://www.swig.org](http://www.swig.org) - SWIG, the Simplified Wrapper and Interface Generator

# AUTHORS

Stephan Loyd <stephanloyd9@gmail.com>

# ACKNOWLEDGEMENTS

Thanks to Junyi Sun, and Yanyi Wu. This piece of Perl library would not be
existing without their work on jieba and CppJieba. 

# COPYRIGHT AND LICENSE

CppJieba is copyright by YanYi Wu under the MIT license. Visit
[https://yanyiwu.mit-license.org/](https://yanyiwu.mit-license.org/) for a copy of the license.

The Perl extension of CppJieba is copyright (c) 2017 by Stephan Loyd.
This is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.
