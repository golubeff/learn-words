class Word < ActiveRecord::Base
  validates_presence_of :russian, :english
  validates_uniqueness_of :english

  before_create :apply_counter

  class << self
    def screensaver_active?
      !`ps ax|grep [S]creenSaverEngine`.empty?
    end

    def show_next
      return false if screensaver_active?

      w = next_word
      `growlnotify -m "#{w.russian}"`
      sleep 7

      `growlnotify -m "#{w.english}" -t '#{w.russian}'`
      `say -v Alex "#{w.english}"`
      sleep 1
      `say "#{w.russian}"`

      w.destroy if w.counter - w.initial_counter > 10
    end


    def next_word
      w = self.find(:first, :order => "counter")
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
    smallest_counter = self.class.find(:first, :order => "counter").counter
    self.counter = smallest_counter
    self.initial_counter = smallest_counter
    true
  end

end
