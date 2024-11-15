class HappyVendor < ApplicationRecord
  has_many :happyquotelines
  has_many :happy_reminders, as: :remindable

 
  validates :vendor_name,      presence: true
  validates :first_name,      presence: true
  validates :last_name,      presence: true 
  validates :title,      presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :business_phone,:presence => true,
                 :length => { :minimum => 10, :maximum => 15 }
  validates :mailing_street1,      presence: true
  validates :mailing_city,      presence: true
  validates :mailing_state,      presence: true
  validates :mailing_zipcode,      presence: true
end
