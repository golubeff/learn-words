class Word < ActiveRecord::Base
  #default_scope :order => "archived, created_at"

  scope :archived, :conditions => { :archived => true }
  scope :active, :conditions => { :archived => false }
  validates_presence_of :russian, :english
  validates_uniqueness_of :english
  before_create :apply_counter
  after_save :rebuild_learning_words
  after_destroy :rebuild_learning_words
  before_save :set_archived_at

  class << self
    def screensaver_active?
      !`ps ax|grep [S]creenSaverEngine`.empty?
    end

    def disabled?
      !Setting.get('enabled')
    end

    def show_next
      return false if screensaver_active?
      return false if disabled?

      w = next_word
      if w.counter % 2 == 0
        `growlnotify -m "#{w.english}"`
        `say -v Alex "#{w.english}"`
      else
        `growlnotify -m "#{w.russian}"`
        `say -v Milena "#{w.russian}"`
      end
      sleep 7

      `growlnotify -m "#{w.english}" -t '#{w.russian}'`
      `say -v Alex "#{w.english}"`
      sleep 1
      `say -v Milena "#{w.russian}"`
    end


    def next_word
      w = self.find(:first, :conditions => { :learning => true }, :order => "counter, created_at")
      w.counter += 1
      w.save!
      w
    end

    def start
      while(1) do
        self.show_next
        sleep Setting.get('timeout').to_i
      end
    end

  end

  def apply_counter
    smallest_counter = self.class.find(:first, :conditions => { :archived => false }, :order => "counter").counter
    self.counter = smallest_counter
    true
  end

  def rebuild_learning_words
    self.class.update_all "learning = false"
    self.class.update_all "learning = true", "id in (select id from words where archived is false order by created_at limit 15)"
    true
  end

  def set_archived_at
    if self.changes['archived']
      self.archived_at = Time.now
    end
    true
  end

end
