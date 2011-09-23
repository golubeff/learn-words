class Word < ActiveRecord::Base
  default_scope :order => "archived"

  MAX_COUNTER = 10
      
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
      `growlnotify -m "#{w.russian}"`
      sleep 7

      `growlnotify -m "#{w.english} (#{w.show_counter} / #{MAX_COUNTER})" -t '#{w.russian}'`
      `say -v Alex "#{w.english}"`
      sleep 1
      `say "#{w.russian}"`

      w.destroy if w.show_counter >= MAX_COUNTER
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

  def show_counter
    counter - initial_counter
  end

  def apply_counter
    smallest_counter = self.class.find(:first, :order => "counter").counter
    self.counter = smallest_counter
    self.initial_counter = smallest_counter
    true
  end

end
