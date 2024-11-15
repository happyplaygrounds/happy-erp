module Reminder
  extend ActiveSupport::Concern

  def loadReminder
    @model_name = controller_name.classify
    @happyReminder = HappyReminder.new
    @happyReminders = HappyReminder.where("remindable_id = ? and remindable_type = ? and user_id = ? and reminder_date >= ?",params[:id], @model_name, current_user.id, Date.today)
  end
end
