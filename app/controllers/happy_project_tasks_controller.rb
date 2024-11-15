class HappyProjectTasksController < ApplicationController
  before_action :set_happy_project
  before_action :set_happy_project_task, only: [:show, :edit, :update, :destroy]

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    #@happyProjects = current_user.happy_projects
    @happyProjects = HappyProject.page params[:page]
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @happyProjectTask = @happyProject.happy_project_task.new
  end

  # GET /happy_projects/1/edit
  def edit
    #@happyProjectTask = HappyProjectTask.find(params[:id])
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    Rails.logger.debug happyProjectTask_params.inspect
    Rails.logger.debug @happyProject.inspect
#    @happyProject = current_user.happy_projects.build(project_params)
   
    @happyProjectTask = @happyProject.happy_project_tasks.new(happyProjectTask_params)
    @happyProjectTask.user_id = current_user.id
    Rails.logger.debug @happyProjectTask.inspect

    respond_to do |format|
      if @happyProjectTask.save
        format.html { redirect_to @happyProject, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @happyproject }
      else
        format.html { render :new }
        format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
    respond_to do |format|
      if @happyProjectTask.update(happyProjectTask_params)
        format.html { redirect_to @happyProject, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyProject }
      else
        format.html { render :edit }
        format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @happyProjectTask.destroy
    respond_to do |format|
      format.html { redirect_to happy_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_happy_project
      @happyProject = HappyProject.find(params[:happy_project_id])
    end

    def set_happy_project_task
      @happyProjectTask = @happyProject.happy_project_tasks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def happyProjectTask_params
      params.require(:happy_project_task).permit(:task_name, :description, :status, :happy_project_id)
    end
end
