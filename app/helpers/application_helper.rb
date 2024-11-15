module ApplicationHelper
  def set_model_name
    @model_name = controller_name.classify
  end

  def get_today_reminders
    if current_user
      @todayReminderCount = HappyReminder.where("DATE(reminder_date) = ? and user_id = ?", Date.today, current_user.id).count
      @todayReminders = HappyReminder.where("DATE(reminder_date) = ? and user_id = ?", Date.today, current_user.id)
    end
  end
  
end
