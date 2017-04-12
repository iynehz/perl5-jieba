#include <cppjieba/Jieba.hpp> 

using namespace std;

// a wrapper on Jieba
namespace perljieba {

    class Jieba {
        public:
            Jieba(const string& dict_path, 
                const string& model_path,
                const string& user_dict_path, 
                const string& idf_path, 
                const string& stop_word_path)
                : jieba_(dict_path, model_path, user_dict_path, idf_path, stop_word_path) {

            }

            vector<string> _cut(const string& sentence, bool hmm = true) {
                vector<string> words;
                jieba_.Cut(sentence, words, hmm);
                return words;
            }

            vector<string> _cut_all(const string& sentence) {
                vector<string> words;
                jieba_.CutAll(sentence, words);
                return words;
            }

            vector<string> _cut_for_search(const string& sentence, bool hmm = true) {
                vector<string> words;
                jieba_.CutForSearch(sentence, words, hmm);
                return words;
            }
            
            bool insert_user_word(const string& word, const string& tag = "") {
                return jieba_.InsertUserWord(word, tag);
            }

            vector<pair<string, string> > _tag(const string& sentence) {
                vector<pair<string, string> > words;
                jieba_.Tag(sentence, words);
                return words;
            }
            
        private:
            cppjieba::Jieba jieba_;
            
    };
}
