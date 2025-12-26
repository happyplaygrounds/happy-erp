
class AddCompanyAndCustomerIndexes < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    unless index_name_exists?(:happy_customer_companies, "uniq_hcc_norm_name_per_tenant")
      add_index :happy_customer_companies,
                [:happy_company_id, :company_name_normalized],
                unique: true,
                where: "company_name_normalized IS NOT NULL AND company_name_normalized <> ''",
                name: "uniq_hcc_norm_name_per_tenant",
                algorithm: :concurrently
    end

    unless index_name_exists?(:happy_customers, "idx_happy_customers_company_id")
      add_index :happy_customers,
                :happy_customer_company_id,
                name: "idx_happy_customers_company_id",
                algorithm: :concurrently
    end

    execute <<~SQL
      CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_happy_customers_email_per_tenant
      ON happy_customers (happy_company_id, lower(trim(email)))
      WHERE email IS NOT NULL AND trim(email) <> '';
    SQL
  end

  def down
    remove_index :happy_customer_companies, name: "uniq_hcc_norm_name_per_tenant" if index_name_exists?(:happy_customer_companies, "uniq_hcc_norm_name_per_tenant")
    remove_index :happy_customers, name: "idx_happy_customers_company_id" if index_name_exists?(:happy_customers, "idx_happy_customers_company_id")

    execute <<~SQL
      DROP INDEX CONCURRENTLY IF EXISTS idx_happy_customers_email_per_tenant;
    SQL
  end
end
