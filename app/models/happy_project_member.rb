class HappyProjectMember < ApplicationRecord
  has_many :happy_project_teams
  #has_many :happy_projects, :through => :happy_project_teams
  has_many :happy_projects, through: :happy_project_teams
  #belongs_to :users
  attr_accessor :happy_project_id
  scope :vendor, ->(vendor_id) { where("happy_vendor_id = ?", vendor_id) }
  scope :customer, ->(customer_id) { where("happy_customer_id = ?", customer_id) }

end
