%module "Lingua::ZH::Jieba"
%{
#include "JiebaPerl.hpp" 
%}

%include <std_string.i>
%include <std_vector.i>

namespace std {
    %template(vectors) vector<string>;
};

%include "JiebaPerl.hpp"

%perlcode %{

package Lingua::ZH::Jieba::Jieba;
use strict;
use warnings;
use utf8;

sub cut {
    my ($self, $sentence, $opts) = @_;
    
    $opts ||= {};
    my $no_hmm = $opts->{no_hmm};
    my $cut_all = $opts->{cut_all};
    
    my $words;
    if ($cut_all) {
        $words = $self->_cut_all($sentence);
    } else {
        $words = $self->_cut($sentence, !$no_hmm);
    }
    
    for (@$words) {
        utf8::decode($_);
    }
    return $words;
}

sub cut_for_search {
    my ($self, $sentence, $opts) = @_;

    $opts ||= {};
    my $no_hmm = $opts->{no_hmm};
    
    my $words = $self->_cut_for_search($sentence, !$no_hmm);
    
    for (@$words) {
        utf8::decode($_);
    }
    return $words;
}


package Lingua::ZH::Jieba;
# ABSTRACT: Perl wrapper for CppJieba 
use 5.010;
use strict;
use warnings;
use utf8;

use File::ShareDir qw(dist_file);

sub _shared_file {
    my $file = shift;
    return dist_file('Lingua-ZH-Jieba', $file);
}
my $default_dict_path = _shared_file('dict/jieba.dict.utf8');
my $default_user_dict_path = _shared_file('dict/user.dict.utf8');
my $default_hmm_path = _shared_file('dict/hmm_model.utf8');
my $default_idf_path = _shared_file('dict/idf.utf8');
my $default_stop_word_path = _shared_file('dict/stop_words.utf8');

sub new {
    my $pkg = shift;
    my $opts = shift;

    $opts //= {};
    
    my $dict_path = $opts->{dict_path};
    my $hmm_path = $opts->{hmm_path};
    my $user_dict_path = $opts->{user_dict_path};
    my $idf_path = $opts->{idf_path};
    my $stop_word_path = $opts->{stop_word_path};

    $dict_path //= $default_dict_path;
    $hmm_path //= $default_hmm_path;
    $user_dict_path //= $default_user_dict_path;
    $idf_path //= $default_idf_path;
    $stop_word_path //= $default_stop_word_path;
   
    return Lingua::ZH::Jieba::Jieba->new(
            $dict_path . "",
            $hmm_path . "",
            $user_dict_path . "",
            $idf_path . "",
            $stop_word_path . ""   
        );
}

%}
