class HappyOrdersController < ApplicationController

  def index
     @happyorder = HappyOrder.all
  end

  def new
     @happyorder = HappyOrder.new
  end
end
