class HappyProject < ApplicationRecord
#  belongs_to :happy_quote
  has_many :happy_project_tasks, inverse_of: :happy_project
  accepts_nested_attributes_for :happy_project_tasks, reject_if: :all_blank, allow_destroy: true
  has_many :happy_project_teams
  has_many :happy_project_members, through: :happy_project_teams
  has_many :happy_reminders, as: :remindable
  #belongs_to :user
  #has_many :happy_project_members, :through => :happy_project_teams

  #after_save :new_project_steps

  validates :project_name,      presence: true

  validate :verify_project_name_uniqueness, on: :create

#validates :status, inclusion: { in: ['not-started', 'in-progress', 'complete'] }

  STATUS_OPTIONS = [
    ['Not started', 'not-started'],
    ['In progress', 'in-progress'],
    ['Complete', 'complete']
  ]

  def verify_project_name_uniqueness
    errors.add(:base, 'Project Name is already in use') if HappyProject.where(project_name: project_name).exists?
  end

  def badge_color
    case status
    when 'not-started'
      'secondary'
    when 'in-progress'
      'info'
    when 'complete'
      'success'
    end
  end

  def status
    return 'in-progress' if self.status = 'in-progress'
    return 'not-started' if happy_project_tasks.none?

    if happy_project_tasks.all? { |task| task.complete? }
      'complete'
    elsif happy_project_tasks.any? { |task| task.in_progress? || task.complete? }
      'in-progress'
    else
      'not-started'
    end
  end

  def percent_complete
    puts happy_project_tasks.none
    return 0 if happy_project_tasks.none?
    ((total_complete.to_f / total_tasks) * 100).round
  end

  def total_complete
    happy_project_tasks.select { |task| task.complete? }.count
  end

  def total_tasks
    happy_project_tasks.count
  end

  
  def new_project_steps
    project_id = self.id
    user_id = self.user_id
    puts "project_id"
    puts project_id
    puts "user_id"
    puts user_id
    @happyProjectMember = HappyProjectMember.where("user_id = ?", user_id).first
    #puts @happyProjectMember.first_name
    if HappyProjectMember.where("user_id = ?", user_id).exists?
        puts "exists"
        happyProjectTeam = HappyProjectTeam.create(happy_project_member_id: @happyProjectMember.id, happy_project_id: project_id, team_name: self.project_name, user_id: user_id, status: 'created')
    else
        puts "does not exist"
        happyUser = User.find(user_id)

        intial_name = happyUser.email.split('@')
        name = intial_name[0].split('.')
        first_name = name[0]
        last_name = name[1]

        happyProjectMember = HappyProjectMember.create(first_name: first_name, last_name: last_name, email: happyUser.email, user_id: user_id)

        #happyProjectMemberID = HappyProjectMember.where("user_id = ?", user_id)

        #puts "memberid"

        #puts happyProjectMemberID.id

        #happyProjectTeam = HappyProjectTeam.create(happy_project_member_id: happyProjectMemberID.id, happy_project_id: project_id, team_name: self.project_name, user_id: user_id, status: 'created')

        puts "below creates"
        #happyProjectMember = HappyProjectMember.new

    end
  end
end
