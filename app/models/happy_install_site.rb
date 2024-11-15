class HappyInstallSite < ApplicationRecord
  #has_many :happy_tasks
  belongs_to :happy_customer
  #attr_accessor :length, :width, :height

  validates :site_name,      presence: true
  validates :description,      presence: true
  validates :site_type,      presence: true

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

#  def status
    #return 'not-started' if tasks.none?
#
    #if tasks.all? { |task| task.complete? }
      #'complete'
    #elsif tasks.any? { |task| task.in_progress? || task.complete? }
      #'in-progress'
    #else
      #'not-started'
    #end
  #end

  def percent_complete
    return 0 if tasks.none?
    ((total_complete.to_f / total_tasks) * 100).round
  end

  def total_complete
    tasks.select { |task| task.complete? }.count
  end

  def total_tasks
    tasks.count
  end

  def self.search(search)
    if search
      installCustomer = HappyCustomer.where('lower(customer_name) LIKE ?', "%#{search.strip}%")
      if installCustomer
        self.where(happy_customer_id: installCustomer)
      else
        #HappyInstallSite.includes(:happy_customer).all
        HappyInstallSite.all
      end
    else
      #HappyInstallSite.includes(:happy_customer).all
        HappyInstallSite.all
    end
  end

end
