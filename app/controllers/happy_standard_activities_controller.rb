class HappyStandardActivitiesController < ApplicationController
  before_action :find_activity, only: [:show, :edit, :update, :destroy]
  #before_action :set_happy_standard_task, only: [:show, :edit, :update, :destroy]
  #before_action :set_happy_project_task, only: [:show, :edit, :update, :destroy]

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    @happyStandardActivities = HappyStandardActivity.order("id ASC").page params[:page]
    @search = params["search"]
    if @search.present?
      @name = @search["activity_name"]
      @happyStandardActivities = HappyStandardActivity.where("activity_name ILIKE ?", "%#{@name}%").order("id ASC").page(params[:page])
    end
  end

  #def index
    #@happyProjects = current_user.happy_projects
    #@happyStandardActivities = HappyStandardActivity.page params[:page]
  #end

  # GET /projects/1
  # GET /projects/1.json

  def show
  end

  # GET /projects/new
  def new
    @happystandardactivity = HappyStandardActivity.new
  end

  # GET /happy_projects/1/edit
  def edit
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    @happystandardactivity = HappyStandardActivity.new(happystandardactivity_params)

    respond_to do |format|
      if @happystandardactivity.save
        #flash[:success] = "Activity saved!"
        #redirect_to @happystandardactivity
        format.html { redirect_to @happystandardactivity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @happyStandardActivity }
      else
        #flash[:success] = "Activity not saved!"
        #render "new"
        format.html { render :new }
        format.json { render json: @happystandardactivity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
    respond_to do |format|
      if @happyStandardActivity.update(happystandardactivity_params)
        format.html { redirect_to @happyStandardActivity, notice: 'Activitiy was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyStandardActivity }
      else
        format.html { render :edit }
        format.json { render json: @happyStandardActivity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @happyStandardActivity.destroy
    respond_to do |format|
      format.html { redirect_to happy_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  
    def happystandardactivity_params
      params.require(:happy_standard_activity).permit!
    end

    def find_activity
      @happyStandardActivity = HappyStandardActivity.find(params[:id])
    end

    def set_happy_standard_task
      @happyStandardActivity = HappyStandardActivity.find(params[:id])
    end

    def set_happy_project_task
      @happyStandardActivity = @happyStandardActivity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    #def project_params
      #params.require(:project).permit(:name, :description)
    #end
end
