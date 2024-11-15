class HappyProjectTeamsController < ApplicationController
  before_action :set_happy_project_team, only: [:show, :edit, :update, :destroy]

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    #@happyprojects = current_user.happy_projects
    if params[:happy_project_id].present?
      happyProject = HappyProject.find(params[:happy_project_id])
      @happyTeamMembers = happyProject.happy_project_members 
      #.find(params[:happy_project_id])
      @happyTest = HappyProject.find(params[:happy_project_id])
      test = @happyTest.happy_project_member_ids
      puts "test"
      puts test
      @happyTeamMembers = HappyProjectMember.find(test)
      @happyTeam = HappyProject.where("id = ?", params[:happy_project_id])
      #@happyTeam = HappyProject.where("id = ?", params[:happy_project_id]).happy_project_member_ids
      #projectTeam = HappyProjectTeam.happy_project_member_ids
      #@happyTeamMembers = HappyProjectTeam.where("happy_project_id = ?", params[:happy_project_id])
      #@happyTeamMembers = HappyhappyTeam.happy_project_member_ids
      #@happyTeamMembers = happyTeam.where("happy_project_id = ?", params[:happy_project_id])
      puts @happyTeam
      puts "Helllllllll yes"
    end
    @happyProjectMembers = HappyProjectMember.page params[:page]
     @search = params["search"]
    if @search.present?
      @lastName = @search["last_name"]
      @happyProjectMembers = HappyProjectMembers.where("last_name ILIKE ?", "%#{@lastName}%").order("last_name DESC").page(params[:page])
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @happyProjectTeam = @happyProject.happy_project_members.new
    @happyProject = HappyProject.find(params[:happy_project_id])
  end

  # GET /projects/new
  def new
    @happyProjectTeam = HappyProjectTeam.new
  end

  # GET /happy_projects/1/edit
  def edit
    puts "got in edit"
    @happyProjectTeam = HappyProjectTeam.find(params[:id])
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    #puts params
    #puts params[:happy_quote_id] 
    @happyProjectTeam = HappyProjectTeam.new(happyProjectTeam_params)

    @user = current_user
    @happyProjectTeam.user_id = @user.id
    happyProjectMember = HappyProjectMember.where("user_id = ?", @user.id)
    puts "happyProjectMember"
    puts happyProjectMember[0].id
    @happyProjectTeam.happy_project_member_id = happyProjectMember[0].id

    #@happyProjectMember.happy_quote_id = 1062

    respond_to do |format|
      if @happyProjectTeam.save
        format.html { redirect_to @happyProjectTeam, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @happyProjectTeam }
      else
        format.html { render :new }
        format.json { render json: @happyProjectTeam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
    #@happyProject.happy_quote_id = 1062
    respond_to do |format|
      if @happyProjectTeam.update(happyUpdateProjectTeam_params)
         @happyProjectTeam.save
        format.html { redirect_to @happyProjectTeam, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyProjectTeam }
      else
        format.html { render :edit }
        format.json { render json: @happyProjectTeam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @happyProjectTeam.destroy
    respond_to do |format|
      format.html { redirect_to happy_project_teams_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #def loadprocess
    #happyProcess = HappyStandardProcess.find(params[:id])
    #task_ids = Array.new()
    #task_ids = happyProcess.happy_standard_task_ids
    #puts task_ids
#
    #happyTasks = HappyStandardTask.where(id: task_ids)
    #puts happyTasks
    #Rails.logger.debug happyTasks.inspect
    #@happyTasks = @happyProcess.happy_standard_tasks.includes(:happy_standard_activities)
    # p = HappyStandardTask.find(1).happy_standard_activities
    #Rails.logger.debug @happyTasks.inspect

    #@happyActivities = @happyActivities.ties)
    #@happyTasksClone = @happyTasks.clone
    #

    #happyTasks.each { |task|
                            #happyActivities = HappyStandardActivity.where(happy_standard_task_id: task.id)
                                 #happyActivities.each { |activity|
                                        #puts "top activity"
                                        #puts activity.activity_name
                                        #puts "below activity"
                                 #}
                            ##puts task.id
                            #puts task.task_name
                            #puts task.description
                            #}
    #puts @happyTasks
    ##@happyStandardProcess = HappyProcessFlow.includes(:happy_quote_lines).order("happy_quote_lines.id asc").find(params[:happy_quote_id])
    #puts "got in loadProcess"
  #end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_happy_project_team
      @happyProjectTeam = HappyProjectTeam.find_by("happy_project_id = ?", params[:happy_project_id])
      @happyProject = HappyProject.find(@happyProjectTeam.happy_project_id)
    end

    def happyUpdateProject_params
      params.require(:ht).permit!
    end
    

    # Only allow a list of trusted parameters through.
    def happyProject_params
      params.require(:happy_project).permit!
      #params.require(:happy_project).permit(:id, :project_name, :description, :general_contractor,
                     #:site_contact_name, :site_contact_phone, :site_contact_email,
                     #:planned_start_date, :planned_budget, :internal_notes, :external_notes,
                     #:reminder_date, :is_reminder, :status, happy_project_tasks_attributes: [:id, :happy_project_id,
                      #:happy_vendor_id,        
                      #:task_name,        
                      #:description,          
                      #:sales_order,          
                      #:planned_start_date,          
                      #:planned_end_date,          
                      #:actual_start_date,          
                      #:actual_end_date,          
                      #:order_date,          
                      #:ship_date,          
                      #:estimated_delivery_date,          
                      #:receipt_date,          
                      #:reminder_date,          
                      #:priority,             
                      #:group,                
                      #:dependency,
                      #:lead_time,
                      #:is_vendor,            
                      #:duration,                      
                      #:duration_unit,        
                      #:internal_notes,        
                      #:external_notes,        
                      #:is_vendor,            
                      #:_destroy])  
    end
end
