class HappyProjectTask < ApplicationRecord
  belongs_to :happy_project
  acts_as_list scope: :happy_project

 
#  validates :status, inclusion: { in: ['not-started', 'in-progress', 'complete'] }

  STATUS_OPTIONS = [
    ['Not started', 'not-started'],
    ['In progress', 'in-progress'],
    ['Complete', 'complete']
  ]

  PRIORITY_OPTIONS = [
    ['High', 'high'],
    ['Medium', 'medium'],
    ['Low', 'low']
  ]

  DURATION_OPTIONS = [
    ['Day', 'day'],
    ['Week', 'week'],
    ['Month', 'month']
  ]

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

  def complete?
    status == 'complete'
  end

  def in_progress?
    status == 'in-progress'
  end

  def not_started?
    status == 'not-started'
  end


   def totoal_percent_complete
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
end
