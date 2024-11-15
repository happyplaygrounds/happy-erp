class HappyCustomersController < ApplicationController
  before_action :find_customer, only: [:show, :edit, :update, :destroy]

  attr_accessor :cust_name

  def index
    @customers = HappyCustomer.order("customer_name ASC").page params[:page]
    @customers = @customers.left_joins(:happy_install_sites)
      .select("happy_customers.*, count(happy_install_sites.id) as happy_installs_count")
      .group("happy_customers.id")
    @search = params["search"]
    if @search.present? and !@search.blank?
      @name = @search["cust_name"]
      @customers = HappyCustomer.where("customer_name ILIKE ?", "%#{@name.strip}%").order("customer_name asc").page(params[:page])
    end
  end

  def new
    @happycustomer = HappyCustomer.new
  end

  def show
    @happyquotes = HappyQuote.where("happy_customer_id = ?", params[:id]).order("number DESC, sub DESC")
    @quotetotal = HappyQuoteLine.where("happy_quote_id =?",params[:id]).sum('total_line_amount')
    @model_name = controller_name.classify
    @happyReminder = HappyReminder.new
    @happyReminders = HappyReminder.where("remindable_id = ? and remindable_type = ? and user_id = ? and reminder_date >= ?", params[:id], @model_name, current_user.id, Date.today)
  end

  def edit
  end

  def update
    #authorize @happycustomer
    if @happycustomer.update(happycustomer_params)
      flash[:success] = "Happy Customer was successfully updated"
      redirect_to @happycustomer
    else
      render :action => 'edit'
    end
  end

  def create
    @happycustomer = HappyCustomer.new(happycustomer_params)
    if @happycustomer.save
      flash[:success] = "Customer saved!"
      redirect_to @happycustomer
    else
      flash[:alert] = "Customer not saved!"
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render "new"
    end
  end

  def destroy
    @happycustomer.destroy
    redirect_to action: "index"
  end

private 

  def happycustomer_params
     params.require(:happy_customer).permit!
  end

  def find_customer
    @happycustomer = HappyCustomer.find(params[:id])
  end

end
