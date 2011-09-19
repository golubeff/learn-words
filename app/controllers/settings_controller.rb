class SettingsController < ApplicationController
  def create
    Setting.get_record(params[:key]).update_attribute :value, params[:value]
    redirect_to :back
  end
end
