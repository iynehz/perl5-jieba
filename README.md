[![Build Status](https://travis-ci.org/stphnlyd/perl5-jieba.svg?branch=master)](https://travis-ci.org/stphnlyd/perl5-jieba)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/github/stphnlyd/perl5-jieba?branch=master&svg=true)](https://ci.appveyor.com/project/stphnlyd/perl5-jieba)

# NAME

Lingua::ZH::Jieba - Perl wrapper for CppJieba (Chinese text segmentation)

# SYNOPSIS

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

    # part-of-speech tagging (词性标注)
    my $word_pos_tags = $self->tag($sentence);
    for my $pair (@$word_pos_tags) {
        my ($word, $part_of_speech) = @$pair;
        ...
    }

    # insert user word (动态增加用户词)
    my $words_before_insert = $jieba->cut("男默女泪");
    print join('/', @$words_before_insert), "\n";
    # 男默/女泪

    $jieba->insert_user_word("男默女泪");

    my $words_after_insert = $jieba->cut("男默女泪");
    print join('/', @$words_after_insert), "\n";
    # 男默女泪

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

    my $jieba = Lingua::ZH::Jieba->new;

By default constructor would use data files from "share" dir of its
installation. But it's possible to override any of the data files like below.

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

# METHODS

## cut

    my $words = $self->cut($sentence);

Default cut mode. Returns an arrayref of utf8 strings of words cut from
the sentence.

    my $words = $self->cut($sentence, { no_hmm => 1 });

Cut without HMM mode.

    my $words = $self->cut($sentence, { cut_all => 1 });

Cut all possible words in dictionary.

## cut\_for\_search

    my $words = $self->cut_for_search($sentence);
    my $words_nohmm = $self->cut_for_search($sentence, { no_hmm => 1 });

## tag

part-of-speech tagging. Returns an arrayref of which each element is in
the form of `[ $word, $part_of_speech ]`.

    my $word_pos_tags = $self->tag($sentence);
    for my $pair (@$word_pos_tags) {
        my ($word, $part_of_speech) = @$pair;
        ...
    }

## insert\_user\_word

    $self->insert_user_word($word);

Dynamically inserts a user word.

# SEE ALSO

[https://github.com/fxsjy/jieba](https://github.com/fxsjy/jieba) - Jieba, the Chinese text segmentation
library

[https://github.com/yanyiwu/cppjieba](https://github.com/yanyiwu/cppjieba) - CppJieba, Jieba implemented in C++

[http://www.swig.org](http://www.swig.org) - SWIG, the Simplified Wrapper and Interface Generator

# AUTHORS

Stephan Loyd <stephanloyd9@gmail.com>

# COPYRIGHT AND LICENSE

CppJieba is copyright by YanYi Wu under the MIT license. Visit
[https://yanyiwu.mit-license.org/](https://yanyiwu.mit-license.org/) for a copy of the license.

The Perl extension of CppJieba is copyright (c) 2017 by Stephan Loyd.
This is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.
