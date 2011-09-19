class Setting < ActiveRecord::Base
  before_create :handle_default_value
  before_save :handle_empty_value

  def self.get_record(k)
    self.find_by_key(k) || self.create_key(k)
  end

  def self.get(k)
    self.get_record(k).value
  end

  def self.create_key(k)
    self.create :key => k
  end

  protected
  def handle_default_value
    self.value ||= 'true' if key == 'enabled'
  end

  def handle_empty_value
    self.value = nil if value && value.empty?
  end
end
