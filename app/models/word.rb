class Word < ActiveRecord::Base
  #default_scope :order => "archived, created_at"

  scope :archived, :conditions => { :archived => true }
  scope :active, :conditions => { :archived => false }
  validates_presence_of :russian, :english
  validates_uniqueness_of :english
  before_create :apply_counter

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
      hint = w.russian
      hint = w.english if w.counter % 2 == 0
      `growlnotify -m "#{hint}"`
      sleep 7

      `growlnotify -m "#{w.english}" -t '#{w.russian}'`
      `say -v Alex "#{w.english}"`
      sleep 1
      `say -v Milena "#{w.russian}"`
    end


    def next_word
      w = self.find(:first, :conditions => { :archived => false }, :order => "counter, created_at")
      w.counter += 1
      w.save!
      w
    end

    def start
      while(1) do
        self.show_next
        sleep 180
      end
    end

  end

  def apply_counter
    smallest_counter = self.class.find(:first, :conditions => { :archived => false }, :order => "counter").counter
    self.counter = smallest_counter
    true
  end

end
