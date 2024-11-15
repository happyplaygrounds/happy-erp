class HappyStandardTask < ApplicationRecord
   has_many :happy_process_flows
   has_many :happy_standard_processes, :through => :happy_process_flows
   has_many :happy_standard_activities,-> { order(position: :asc) }, inverse_of: :happy_standard_task
#   validates_associated :happy_standard_activities

   accepts_nested_attributes_for :happy_standard_activities, reject_if: :all_blank, allow_destroy: true
end
