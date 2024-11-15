class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  #  has_many :happy_customers
    has_many :happy_quotes
    has_many :happy_notes
    has_many :happy_customers
    has_many :happy_vendors
    has_many :happy_projects
    has_many :happy_reminders
    has_one :happy_project_members
 
  STATES =
  [ 
    ['AK', 'AK'], ['AL', 'AL'], ['AR', 'AR'], ['AZ', 'AZ'],
    ['CA', 'CA'], ['CO', 'CO'], ['CT', 'CT'], ['DC', 'DC'],
    ['DE', 'DE'], ['FL', 'FL'], ['GA', 'GA'], ['HI', 'HI'],
    ['IA', 'IA'], ['ID', 'ID'], ['IL', 'IL'], ['IN', 'IN'],
    ['KS', 'KS'], ['KY', 'KY'], ['LA', 'LA'], ['MA', 'MA'],
    ['MD', 'MD'], ['ME', 'ME'], ['MI', 'MI'], ['MN', 'MN'],
    ['MO', 'MO'], ['MS', 'MS'], ['MT', 'MT'], ['NC', 'NC'],
    ['ND', 'ND'], ['NE', 'NE'], ['NH', 'NH'], ['NJ', 'NJ'],
    ['NM', 'NM'], ['NV', 'NV'], ['NY', 'NY'], ['OH', 'OH'],
    ['OK', 'OK'], ['OR', 'OR'], ['PA', 'PA'], ['RI', 'RI'],
    ['SC', 'SC'], ['SD', 'SD'], ['TN', 'TN'], ['TX', 'TX'],
    ['UT', 'UT'], ['VA', 'VA'], ['VT', 'VT'], ['WA', 'WA'],
    ['WI', 'WI'], ['WV', 'WV'], ['WY', 'WY']
  ]   
end
