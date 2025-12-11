class HappyCustomerCompany < ApplicationRecord
  self.table_name = "happy_customer_companies"

  # Associations
  belongs_to :happy_company, optional: true # tenant/org (you said only one tenant now)
  has_many :happy_customers, dependent: :nullify
  has_many :happy_quotes, through: :happy_customers

  # Normalization (for duplicate prevention)
  before_validation :normalize_name

  validates :company_name, presence: true

  # If you add company_name_normalized + unique index:
  validates :company_name_normalized,
            uniqueness: { scope: :happy_company_id, allow_nil: true }

  scope :active, -> { where(active: true) }

  private

  def normalize_name
    self.company_name_normalized =
      company_name.to_s.downcase.gsub(/[^a-z0-9]+/, " ").strip
  end
end

