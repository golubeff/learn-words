class Setting < ActiveRecord::Base
  DEFAULTS = {
    'enabled' => { 'ttl' => 30.minutes, 'value' => 'on' },
    'timeout' => { 'value' => 1.minute.to_s }
  }

  before_create :handle_default_value
  before_save :handle_empty_value

  def self.get_record(k)
    self.find_by_key(k) || self.create_key(k)
  end

  def self.get(k)
    record = self.get_record(k)
    if DEFAULTS[k]['ttl'] && record.updated_at && Time.now - record.updated_at >= DEFAULTS[k]['ttl']
      record.update_attribute :value, DEFAULTS[k]['value']
    end
    record.value
  end

  def self.create_key(k)
    self.create :key => k, :value => DEFAULTS[k]['value']
  end

  protected
  def handle_default_value
    self.value ||= 'true' if key == 'enabled'
  end

  def handle_empty_value
    self.value = nil if value && value.empty?
  end
end
