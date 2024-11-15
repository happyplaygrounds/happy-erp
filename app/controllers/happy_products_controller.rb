class HappyProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = HappyProduct.page params[:page]
    @search = params["search"]
    if @search.present?
      @number = @search["part_number"]
      @name = @search["description"]
      #@products = HappyProduct.where("description ILIKE ?", "%#{@name}%").order("description DESC").page(params[:page])
      if @number.present?
        @products = HappyProduct.where("part_number ILIKE ?", "%#{@number}%").order("description DESC").page(params[:page])
      else
        @products = HappyProduct.where("description ILIKE ?", "%#{@name}%").order("description DESC").page(params[:page])
      end
    end
  end

  def new
    @happyproduct = HappyProduct.new
  end

  def show
  end

  def edit
  end

  def update
    authorize @happyproduct
    if @happyproduct.update(happyproduct_params)
      redirect_to @happyproduct
    else
      render :action => 'edit'
    end
  end

  def create
    @happyproduct = HappyProduct.new(happyproduct_params)
    if @happyproduct.save
      flash[:success] = "Contact saved!"
      redirect_to @happyproduct
    else
      flash[:alert] = "Contact not saved!"
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render "new"
    end
  end

  def productinfo
   if params[:productid]
        @happyproduct = HappyProduct.where("part_number = ?" ,params[:productid])
        puts @happyproduct
     end
   respond_to do |format|    
      format.html              
      format.json { render json: { happyproduct: @happyproduct } } 
    end
    puts "here above product"       
  end

  def destroy
    @happyproduct.destroy
    redirect_to action: "index"
  end

private 

  def happyproduct_params
     params.require(:happy_product).permit!
  end

  def find_product
    @happyproduct = HappyProduct.find(params[:id])
  end

end
