%module "Lingua::ZH::Jieba"
%{
#include "JiebaPerl.hpp" 
%}

%include <std_string.i>
%include <std_vector.i>
//%include <std_pair.i>

namespace std {
    %template(vector_s) vector<string>;
    %template(vector_wordpos) vector<pair<string, string> >;
//    %template(pair_ss) pair<string, string>;
};

%{

void SwigSvFromStringPair(SV* sv, const std::pair<std::string, std::string>& p) {
    SV **svs = new SV*[2];

    svs[0] = sv_newmortal();
    SwigSvFromString(svs[0], p.first);
    svs[1] = sv_newmortal();
    SwigSvFromString(svs[1], p.second);

    AV *myav = av_make(2, svs);
    delete[] svs; 

    sv_setsv(sv, newRV_noinc((SV*) myav));
}

// This is now a dummy function, and we would never use it.
std::pair<std::string, std::string> SwigSvToStringPair(SV* sv) {
    pair<std::string, std::string> pairs;
    return pairs;
}

%}

namespace std {
// dont know why but specialize_std_vector would hang
//    specialize_std_vector((std::pair<std::string, std::string>), SvROK, SwigSvToStringPair, SwigSvFromStringPair);

    %typemap(out) vector<pair<string, string> > {
        size_t len = $1.size();
        SV **svs = new SV*[len];
        for (size_t i=0; i<len; i++) {
            svs[i] = sv_newmortal();
            SwigSvFromStringPair(svs[i], $1[i]);
        }
        AV *myav = av_make(len, svs);
        delete[] svs;
        $result = newRV_noinc((SV*) myav);
        sv_2mortal($result);
        argvi++;
    }
}


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

sub tag {
    my ($self, $sentence) = @_;

    my $words = $self->_tag($sentence);
    for (@$words) {
        utf8::decode($_->[0]);
    }
    return $words;
}


package Lingua::ZH::Jieba;
# ABSTRACT: Perl wrapper for CppJieba (Chinese text segmentation)
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
