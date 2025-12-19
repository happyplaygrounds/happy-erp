class HappyCategory < ApplicationRecord
  include SetsHappyCompany
  has_many :happy_products
end
