class HappyCustomer < ApplicationRecord
  has_many :happy_quotes
  has_many :happy_orders
  has_many :happy_reminders, as: :remindable
  has_many :happy_install_sites
  geocoded_by :address, latitude: :mailing_lat, longitude: :mailing_long
  #belongs_to :user

  validates :customer_name,      presence: true
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

  def address
  [mailing_street1, mailing_street2, mailing_city, mailing_state, mailing_zipcode, mailing_country].compact.join(', ')
  end

end
