class WordsController < InheritedResources::Base
  def archive
    resource.update_attribute :archived, true
    redirect_to :back
  end

  def unarchive
    resource.update_attribute :archived, false
    redirect_to :back
  end

  def create
    create!{ new_word_path }
  end
end
