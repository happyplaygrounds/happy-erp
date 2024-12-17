#!/usr/bin/env ruby
desc "This task is called by the Heroku scheduler add-on"
##task :update_feed => :environment do
#  puts "Updating feed..."
#  NewsFeed.update
#  puts "done."
#end

task :send_reminders => :environment do
  reminders = HappyReminder.where("DATE(reminder_date) = ?", Date.today)  
  #mail_users = HappyReminder.select(:user_id).where("DATE(reminder_date) = ?", Date.today).distinct  
  #mail_users = User.joins(:happy_reminders).where("Date(reminder_date) = ?",Date.today).distinct
  #mail_users = User.all

  if reminders.count > 0
    reminders.each do |reminder|
      UserMailer.with(reminder: reminder).reminder_email.deliver_now
    end
  end

#  if reminders.count > 0
#    mail_users.each do |user|
#      puts user
#      UserMailer.with(user: user).reminder_email.deliver_now
#    end
#  end

  #reminders.each_slice do |reminder|
    #puts reminder.name
    #puts reminder.content
    #UserMailer.with(happyReminder: reminder).reminder_email.deliver
  #end
  #reminders.each do |reminder|
  #  UserMailer.with(happyReminder: reminder).reminder_email.deliver
  #end
  puts "Cleaning old sessions..."
  #DB["select * from happy_notes"]
end

task :load_po_reminders => :environment do
  if Time.now.monday? || Time.now.thursday?  
      HappyReminder.where("status = ?", 'HappyAutoPo').destroy_all 
    happyPos = HappyPo.where("state = ?", "Purchase").distinct.select('happy_quote_id', 'happy_customer_id', 'number', 'sub', 'user_id')

      puts "above each"
      happyPos.each { |po|


      puts "got in each"
      puts po.happy_quote_id

      happyCustomer = HappyCustomer.find(po.happy_customer_id)

    happyVendorRemind = HappyQuoteLine.where("happy_quote_id = ? and happy_vendor_id not in ( ? )", po.happy_quote_id,
    HappyPo.where("happy_pos.happy_quote_id = ?", po.happy_quote_id).select('happy_pos.happy_vendor_id')).distinct.select('happy_vendor_id')

    quoteContent = ""
    if happyVendorRemind
      happyVendorRemind.each { |vendor|
        vendorName = HappyVendor.find(vendor.happy_vendor_id)
        #vendorContent = "Purchase Order: " + po.happy_vendor_id + "-" + po.number + "-" + po.sub + " has not been finalized" 
        vendorContent = "Unfinalized Purchase Order: #{vendor.happy_vendor_id}-#{po.number}-#{po.sub}\n Vendor: #{vendorName.vendor_name}\n" 
        quoteContent =  "#{quoteContent} #{vendorContent}"
        puts vendor.happy_vendor_id
        puts vendorContent
        puts "QuoteContent"
        puts quoteContent
      }
      happyRemind = HappyReminder.new(
        name: "Quote: #{po.number}-#{po.sub} #{happyCustomer.customer_name}",
        content: quoteContent,
        remindable_id: po.happy_quote_id,
        remindable_type: 'HappyQuote',
        status: 'HappyAutoPo',
        is_sent: 'True',
        reminder_date: Date.today,
        user_id: po.user_id,
        user_id_update: po.user_id)
      happyRemind.save
    else
      HappyPo.where("happy_quote_id = ?", po.happy_quote_id).update_all(state: 'Complete')
    end

    }

  #reminders = HappyReminder.where("DATE(reminder_date) = ?", Date.today)  
  #mail_users = HappyReminder.select(:user_id).where("DATE(reminder_date) = ?", Date.today).distinct  
  #mail_users = User.joins(:happy_reminders).where("Date(reminder_date) = ?",Date.today).distinct
  #mail_users = User.all

  end

end

task :send_calendars => :environment do
      #ReminderMailer.with(user: user).reminder_email.deliver_now
      UserMailer.calendar_email.deliver_now

  #reminders.each_slice do |reminder|
    #puts reminder.name
    #puts reminder.content
    #UserMailer.with(happyReminder: reminder).reminder_email.deliver
  #end
  #reminders.each do |reminder|
  #  UserMailer.with(happyReminder: reminder).reminder_email.deliver
  #end
  puts "Cleaning old sessions..."
  #DB["select * from happy_notes"]
end
