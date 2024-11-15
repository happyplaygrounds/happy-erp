class HappyStandardProcess < ApplicationRecord
  has_many :happy_process_flows
  has_many :happy_standard_tasks, through: :happy_process_flows
end
