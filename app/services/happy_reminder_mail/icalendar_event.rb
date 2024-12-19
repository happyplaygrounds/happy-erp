# app/services/games/icalendar_event.rb
# Games::IcalendarEvent.new(game: Game.last).call
# Games::IcalendarEvent.new(game: Game.last, user: User.last).call
class HappyReminderMail::IcalendarEvent
  require 'icalendar'
  include Rails.application.routes.url_helpers

  def initialize(reminder:, user: nil)
    @happyreminder = reminder
    @user = User.find(@happyreminder.user_id)
    #@user = user
  #  @url = reminder_url(@happyreminder)
  end

   def call
    # Create a calendar with an event (standard method)
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new @happyreminder.reminder_date + 8.hours + 30.minutes + 0.seconds
      e.dtend = Icalendar::Values::DateTime.new @happyreminder.reminder_date + 8.hours + 45.minutes + 0.seconds
      e.summary = @happyreminder.name
      e.description = @happyreminder.content
      # e.ip_class = "PRIVATE"
      e.ip_class = "PUBLIC"
      #e.location = @game.address
      #e.uid = "gameid:#{@game.id.to_s}"
      e.uid = "reminderid:#{@happyreminder.id.to_s}"
      e.sequence = Time.now.to_i
      #e.url = game_url(@game)
      e.organizer = Icalendar::Values::CalAddress.new("mailto:reminders@happyplaygrounds.com", cn: 'Reminders from Happy')
      e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}", partstat: 'accepted') # DECLINED # TENTATIVE
      #e.attendee = Icalendar::Values::CalAddress.new("mailto:brian.collins@happyplaygrounds.com", partstat: 'accepted')
      # e.status = 'CANCELLED'
    end
    cal.publish
    cal.ip_method = 'REQUEST'
    cal.to_ical
  end

#  def call
    #ical = ::Icalendar::Calendar.new
    #event = ::Icalendar::Event.new
    #event.dtstart = Icalendar::Values::DateTime.new @happyreminder.reminder_date
    #event.dtend = Icalendar::Values::DateTime.new @happyreminder.reminder_date
    #event.summary = @happyreminder.name
    #event.description = "Get this done today #{@happyreminder.content}"
    #event.uid = @happyreminder.id.to_s # important for updating/canceling an event
    #event.sequence = Time.now.to_i # important for updating/canceling an event
    #event.url = @url
    #event.location = @happyreminder.address # location on map
    # event.attendee = %w(mailto:abc@example.com mailto:xyz@example.com)
    #if @user.present?
    #  event.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}", partstat: 'accepted') # DECLINED # TENTATIVE
    #end
    # event.organizer = "mailto:organizer@example.com"
    #event.organizer = Icalendar::Values::CalAddress.new("mailto:#{ApplicationMailer.default_params[:from]}", cn: 'Admin from Happy Playgrounds')
    #    event.organizer = Icalendar::Values::CalAddress.new("mailto:brian.collins@happyplaygrounds.com", cn: 'Admin from Happy Playgrounds')
    #event.status = 'CONFIRMED' # 'CANCELLED'
    #event.ip_class = 'PUBLIC' # 'PRIVATE'
    # event.attach = Icalendar::Values::Uri.new @url
    # event.append_attach = Icalendar::Values::Uri.new(@url, "fmttype" => "application/binary")
    #event.created = @happyreminder.created_at
    #event.last_modified = @happyreminder.updated_at

    #event.alarm do |a|
      #a.summary = "#{@happyreminder.name} starts in 30 minutes!"
      #a.trigger = '-PT30M'
    #end

    #ical.add_event(event)
    #ical.append_custom_property('METHOD', 'REQUEST') # add event to calendar by default!
    #ical.publish
    ## ical.ip_method = 'REQUEST'
    # ical.ip_method = 'PUBLISH'
    # ical.ip_method = 'CANCEL'
    #ical
  #end
end
