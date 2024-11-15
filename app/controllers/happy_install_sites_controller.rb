class HappyInstallSitesController < ApplicationController
  before_action :find_install_site, only: [:show, :edit, :update, :destroy]

  attr_accessor :length, :width, :height

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    #@projects = current_user.happy_projects
    @happyInstallSites = HappyInstallSite.includes(:happy_customer).page params[:page]
    if (params.has_key?(:happy_customer_id))
        @happyInstallSites = HappyInstallSite.where("happy_customer_id = ?", params[:happy_customer_id]).page params[:page]
        @happyCustomer = HappyCustomer.find(params[:happy_customer_id])
    else
        @happyInstallSites = HappyInstallSite.includes(:happy_customer).search(params[:search]).page params[:page]
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    #@happyInstallSite = HappyInstallSite.where("id = ?", @happyInstallSite.id)
  end

  # GET /projects/new
  def new
    @happyCustomer = HappyCustomer.find(params[:happy_customer_id])
    puts @happyCustomer.customer_name
    @happyInstallSite = HappyInstallSite.new
  end

  # GET /happy_projects/1/edit
  def edit
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    @happyInstallSite = HappyInstallSite.new(happyInstallSite_params)
    #@happyInstallSite.happy_customer_id = 13
    #@happyInstallSite.happy_customer_id = params[:happy_customer_id]
    puts "top of create"
    puts @happyInstallSite.inspect
    @user = current_user
    puts @user_id
    #@happyInstallSite.user_id_add = 1


    #@happyInstallSite = current_user.happy_projects.build(project_params)
    #@happyLocationSite = HappyLocationSite.new

    respond_to do |format|
      if @happyInstallSite.save
        format.html { redirect_to @happyInstallSite, notice: 'Site was successfully created.' }
        #format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        #format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to happy_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_install_site
      #@happyInstallSite = current_user.happy_projects.find(params[:id])
      @happyInstallSite = HappyInstallSite.find(params[:id])
    end

    def happyInstallSite_params
     params.require(:happy_install_site).permit!
    end

    # Only allow a list of trusted parameters through.
    #def project_params
      #params.require(:project).permit(:name, :description)
    #end
end
