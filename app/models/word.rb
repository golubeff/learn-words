class Word < ActiveRecord::Base
  validates_presence_of :russian, :english
  validates_uniqueness_of :english

  before_create :apply_counter

  def self.show_next
    w = next_word
    `growlnotify -m "#{w.english}" -t '#{w.russian}'`
    `say "#{w.english}, #{w.russian}"`

    w.destroy if w.counter - w.initial_counter > 10
  end


  def self.next_word
    w = self.find(:first, :order => "counter")
    w.counter += 1
    w.save!
    w
  end

  def apply_counter
    smallest_counter = self.class.find(:first, :order => "counter").counter
    self.counter = smallest_counter
    self.initial_counter = smallest_counter
    true
  end

  def self.start
    while(1) do
      self.show_next
      sleep 180
    end
  end
end
