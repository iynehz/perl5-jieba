# NAME

Lingua::ZH::Jieba - Perl wrapper for CppJieba

# SYNOPSIS

    use Lingua::ZH::Jieba;
    
    my $jieba = Lingua::ZH::Jieba->new();

    # default cut
    my $words = $jieba->cut("他来到了网易杭研大厦");

    # cut without hmm
    my $words_nohmm = $jieba->cut(
        "他来到了网易杭研大厦",
        { no_hmm => 1 } );

    # cut all
    my $words_cutall = $jieba->cut(
        "我来到北京清华大学",
        { cut_all => 1 } );

    # cut for search
    my $words_cut4search = $jieba->cut_for_search(
        "小明硕士毕业于中国科学院计算所，后在日本京都大学深造" );

    # insert user word
    my $words_before_insert = $jieba->cut("男默女泪");
    $jieba->insert_user_word("男默女泪");
    my $words_after_insert = $jieba->cut("男默女泪");

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

    $words = $self->cut($sentence);

Default cut mode. Returns an arrayref of utf8 strings of words cut from
the sentence.

    $words = $self->cut($sentence, { no_hmm => 1 });

Cut without HMM mode.

    $words = $self->cut($sentence, { cut_all => 1 });

Cut all possible words in dictionary.

## cut\_for\_search

    $words = $self->cut_for_search($sentence);
    $words = $self->cut_for_search($sentence, { no_hmm => 1 });

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
same terms as the Perl itself.
