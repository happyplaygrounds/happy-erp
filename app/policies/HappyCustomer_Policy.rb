class HappyCustomerPolicy < ApplicationPolicy
  attr_reader :user, :happycustomer

  def initialize(user, happycustomer)
    @user = user
    @happycustomer = happycustomer
  end

  def update?
    user.admin? #or happycustomer.isactive?
  end
end
