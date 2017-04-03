#!perl

use strict;
use warnings;
use utf8;

use File::Temp;
use File::ShareDir qw(dist_file);
use Lingua::ZH::Jieba;
use Path::Tiny;

use Test::More;

my $builder = Test::More->builder;
binmode $builder->output,         ":encoding(utf8)";
binmode $builder->failure_output, ":encoding(utf8)";
binmode $builder->todo_output,    ":encoding(utf8)";

sub cut_ok {
    my ( $words, $expected, $msg ) = @_;

    is( join( '/', @$words ), $expected, $msg );
}

my $jieba = Lingua::ZH::Jieba->new();
ok( ( defined $jieba ), "Lingua::ZH::Jieba->new()" );

cut_ok(
    $jieba->cut("他来到了网易杭研大厦"),
    "他/来到/了/网易/杭研/大厦",
    "cut with HMM"
);

cut_ok(
    $jieba->cut( "他来到了网易杭研大厦", { no_hmm => 1 } ),
    "他/来到/了/网易/杭/研/大厦",
    "cut without HMM"
);

cut_ok(
    $jieba->cut( "我来到北京清华大学", { cut_all => 1 } ),
    "我/来到/北京/清华/清华大学/华大/大学",
    "cut all"
);

cut_ok(
    $jieba->cut_for_search(
"小明硕士毕业于中国科学院计算所，后在日本京都大学深造"
    ),
"小明/硕士/毕业/于/中国/科学/学院/科学院/中国科学院/计算/计算所/，/后/在/日本/京都/大学/日本京都大学/深造",
    "cut for search"
);

# insert user word
{
    cut_ok( $jieba->cut("男默女泪"),
        "男默/女泪", "before insert 男默女泪" );

    $jieba->insert_user_word("男默女泪");

    cut_ok( $jieba->cut("男默女泪"),
        "男默女泪", "after insert 男默女泪" );
}

# custom data
{
    my $default_user_dict_path =
      dist_file( 'Lingua-ZH-Jieba', 'dict/user.dict.utf8' );
    my $data = path($default_user_dict_path)->slurp_utf8;

    unlink( $data, qr/男默女泪/,
        "Not having the word in default user dict" );

    my $tempfile = Path::Tiny->tempfile;
    $tempfile->spew_utf8( $data . "\n男默女泪\n" );

    my $jieba_custom =
      Lingua::ZH::Jieba->new( { user_dict_path => $tempfile . "" } );
    ok( defined($jieba_custom), "custom user_dict_path" );
    cut_ok( $jieba_custom->cut("男默女泪"),
        "男默女泪", "custom user_dict_path: cut with HMM" );
}

done_testing();
