class HappyReminder < ApplicationRecord
  belongs_to :remindable, polymorphic: true
  belongs_to :user

  validates :content,      presence: true

  #after_save :send_calendar_invite

  #def send_calendar_invite
    #user_id = self.user_id
    #happyUser = User.find(user_id)
    #UserMailer.with(user: user).reminder_email.deliver_now
    #UserMailer.with(userID: self.user_id, reminderID: self.id).calendar_email.deliver_now
  #end

  CustomerQuotes =
            ["If you’re competitor-focused, you have to wait until there is a competitor doing something. Being customer-focused allows you to be more pioneering.",
             "The basics of business is to stay as close as possible to your customers—understand their behavior, their preferences, their purchasing patterns, etc.",
             "Customer service should not just be a department, it should be the entire company.",
             "Setting customer expectations at a level that is aligned with consistently deliverable levels of customer service requires that your whole staff, from product development to marketing, works in harmony with your brand image.",
             "When customers get the help and issue resolution they seek, satisfaction, loyalty, and increased spending tend to follow.",
             "It takes 20 years to build a reputation and 5 minutes to ruin it. If you think about that, you'll do things differently.",
             "Whoever is happy will make others happy too",
             "There is only one boss—the customer. And he can fire everybody in the company, simply by spending his money somewhere else.",
             "Repeat business or behavior can be bribed. Loyalty has to be earned.",
             "If we do not take care of our customers, someone else will",
             "A happy customer tells a friend; an unhappy customer tells the world.",
             "The measure of success is not whether you have a tough problem to deal with, but whether it is the same problem you had last year.",
             "You must earn the right to continued relationships with customers.",
             "The customers perception is your reality",
             "We love a Happy customer!"
             ]
end
