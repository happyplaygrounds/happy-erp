class AddCompanyNameNormalizedToHappyCustomerCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :happy_customer_companies, :company_name_normalized, :string
  end
end
