class HappyProduct < ApplicationRecord
  include SetsHappyCompany
  belongs_to :happy_categories
  belongs_to :happy_vendors
  belongs_to :happy_vendor_pricelists
end
