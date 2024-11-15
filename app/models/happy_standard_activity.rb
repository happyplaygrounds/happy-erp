class HappyStandardActivity < ApplicationRecord
  #has_many :happy_standard_processes
  #has_many :happy_standard_tasks, :through => :happy_standard_processes
  belongs_to :happy_standard_task
  acts_as_list scope: :happy_standard_task
end
