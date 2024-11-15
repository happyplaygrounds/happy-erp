class HappyProjectTeam < ApplicationRecord
  belongs_to :happy_project_member
  belongs_to :happy_project
end


#validates :status, inclusion: { in: ['not-started', 'in-progress', 'complete'] }

