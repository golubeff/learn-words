class WordsController < InheritedResources::Base
  def create
    create!{ new_word_path }
  end
end
