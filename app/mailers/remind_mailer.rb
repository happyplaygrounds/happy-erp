class RemindMailer < ApplicationMailer

  def invite
    #@happyreminder = HappyReminder.find(params[:reminderID])
    @happyreminder = params[:happyReminder]
    fdate = @happyreminder.reminder_date.strftime("%m-%d-%Y")
    puts fdate
    @user = User.find(@happyreminder.user_id)
    puts "got here"
    #@happyreminder = params[:happyreminder]
    #@user = params[:user]
    #@reminder_url = streaming_sport_reminder_stream_url(sport_slug: @reminder.sport_slug, reminder_slug: @reminder.slug)
    @subject = [@happyreminder.name, fdate].join(', ')
    puts "got here2"
    @greeting = "Hi"
    #ical = HappyReminderMail::IcalendarEvent.new(reminder: @happyreminder, user: @user).call # generate the ical file
    calendar_event = HappyReminderMail::IcalendarEvent.new(reminder: @happyreminder).call # generate the ical file
    puts "got here3"

    # attach ICS file
    #mail.attachments["#{@subject}.ics"] = { mime_type: 'application/ics', content: ical.to_ical }
    # mail.attachments["#{@subject}.ics"] = { mime_type: 'text/calendar', content: ical.to_ical }
    #mail.attachments["#{@subject}.ics"] = { mime_type: 'text/calendar; method=REQUEST', content: ical.to_ical }
    attachments["invite.ics"] = calendar_event

         #from: 'reminders@happyplaygrounds.com',
    mail to: @user.email,
         from: 'Happy Reminders <reminders@happyplaygrounds.com>',
         #cc: Rails.application.config_for(:settings)[:support_email],
         subject: @subject
  end
end
