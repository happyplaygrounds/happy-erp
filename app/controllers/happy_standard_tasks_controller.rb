class HappyStandardTasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  #before_action :set_happy_standard_task, only: [:show, :edit, :update, :destroy]
  #before_action :set_happy_task_task, only: [:show, :edit, :update, :destroy]

  def index
    @happyStandardTasks = HappyStandardTask.order("id ASC").page params[:page]
    @search = params["search"]
    if @search.present?
      @name = @search["task_name"]
      @happyStandardTasks = HappyStandardTask.where("task_name ILIKE ?", "%#{@name}%").order("id ASC").page(params[:page])
    end
  end

  #def index
    #@happyProjects = current_user.happy_tasks
    #@happyStandardTasks = HappyStandardTask.page params[:page]
  #end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    #@happyTaskCategories = HappyTaskCategory.find(@happyStandardTask.happy_task_category_id)
    @happyTaskCategories = HappyTaskCategory.find_by_id(params[:id])
  end

  # GET /tasks/new
  def new
    @happyStandardTask = HappyStandardTask.new
    @happyTaskCategories = HappyTaskCategory.all.order("category_name asc")
  end

  # GET /happy_tasks/1/edit
  def edit
  end

  # POST /happy_tasks
  # POST /happy_tasks.json
  def create
    @happyStandardTask = HappyStandardTask.new(happyStandardTask_params)
    @happyStandardTask.user_id = current_user.id

    respond_to do |format|
      if @happyStandardTask.save
        format.html { redirect_to @happyStandardTask, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @happyStandardTask }
      else
        format.html { render :new }
        format.json { render json: @happyStandardTask.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_tasks/1
  # PATCH/PUT /happy_tasks/1.json
  def update
    respond_to do |format|
      if @happyStandardTask.update(happyStandardTask_params)
        format.html { redirect_to @happyStandardTask, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyStandardTask }
      else
        format.html { render :edit }
        format.json { render json: @happyStandardTask.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_tasks/1
  # DELETE /happy_tasks/1.json
  def destroy
    @happyStandardTask.destroy
    respond_to do |format|
      format.html { redirect_to happy_standard_tasks_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def happyStandardTask_params
      params.require(:happy_standard_task).permit(:task_name, :description, :priority,
            :happy_task_category_id, :dependency, :is_vendor,
            happy_standard_activities_attributes: [:id, :happy_standard_task_id,
        :activity_name,
        :description,
        :priority,
        :group,
        :dependency,
        :lead_time,
        :is_vendor,
        :duration,              
        :duration_unit,       
        :is_vendor,       
        :_destroy]) 
    end

    def find_task
      @happyStandardTask = HappyStandardTask.find(params[:id])
    end

    def set_happy_standard_task
      @happyStandardTask = HappyStandardTask.find(params[:id])
    end

    def set_happy_task
      @happyStandardTask = @HappyStandardTask.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    #def task_params
      #params.require(:task).permit(:name, :description)
    #end
end
