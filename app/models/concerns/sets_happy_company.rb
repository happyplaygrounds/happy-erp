
module SetsHappyCompany
  extend ActiveSupport::Concern

  included do
    before_validation :set_happy_company_id, on: :create
    validates :happy_company_id, presence: true
  end

  private

  # Single-tenant default for now
  def set_happy_company_id
    self.happy_company_id ||= 1
  end
end
