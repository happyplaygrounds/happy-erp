class HappyProjectMembersController < ApplicationController
  before_action :set_happy_project_member, only: [:show, :edit, :update, :destroy]

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    #@happyprojects = current_user.happy_projects
    @happyProject = HappyProject.find(params[:happy_project_id])
    #@happyProjectMembers = happHappyProjectMember.page params[:page]
    # last working 7/4 @happyProjectMembers = HappyProjectMember.find(happyProject.happy_project_member_ids) 
    #@happyProjectMembers = HappyProjectMember.find(happyProject.happy_project_member_ids).where("happy_vendor_id =?", '2')
    #if params[:happy_venodor_id].nil?
      if (params.has_key?(:happy_vendor_id))
         @happyProjectMembers = HappyProjectMember.where("happy_vendor_id =?", params[:happy_vendor_id])
         #@happyProjectMembers = HappyProjectMember.find(happyProject.happy_project_member_ids)
         puts "top params"
    else
      #@happyProjectMembers = HappyProjectMember.where("happy_vendor_id =?", '2')   
      @happyProjectMembers = HappyProjectMember.find(@happyProject.happy_project_member_ids)
         puts "bottom params"
    end
   
    @happyProjectVendors = HappyQuoteLine.joins(:happy_vendor).where("happy_quote_id = ? and happy_vendor_id is not null", params[:happy_quote_id]).distinct.select('happy_vendor_id', 'happy_vendors.vendor_name')
    @happyUsers = User.joins(:happy_project_members).where.not(users: :current_user)
    #@happyCustomer = HappyCustomer.find(params[:happy_customer_id])
    @happyProjectCustomer = HappyQuote.joins(:happy_customer).where("happy_quotes.id = ?", params[:happy_quote_id]).select('happy_customers.id', 'happy_customers.customer_name')
    
     if @happyProjectVendors.exists?  
      @happyProjectVendors.each do |projectVendor| 
          
          @happyVendorMembers = HappyProjectMember.where("happy_vendor_id = ?", "#{projectVendor.happy_vendor_id}").distinct
       end
      end 
    
    
    #@happyVendorMembers = HappyProjectMember.where(happy_vendor_id = @happyProjectVendors.happy_vendor_ids)
    #@happyCustomerMembers = HappyProjectMember.find(happyProject.happy_project_member_ids)

    #happyProjectTeam = HappyProjectTeam.create(happy_project_id: params[:happy_project_id], happy_project_member_id: 15)
    @search = params["search"]
    if @search.present?
      @lastName = @search["last_name"]
      @happyProjectMembers = HappyProjectMember.where("last_name ILIKE ?", "%#{@lastName}%").order("last_name DESC").page(params[:page])
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    #@happyProjectTask = @happyProject.happy_project_tasks.new
  end

  # GET /projects/new
  def new
    @happyProjectMember = HappyProjectMember.new
  end

  # GET /happy_projects/1/edit
  def edit
    puts "got in edit"
    @happyProjectMember = HappyProjectMember.find(params[:id])
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    #puts params
    #puts params[:happy_quote_id]
    puts "HappyProject"
    puts params[:happy_project_id]
    puts "HappyVendor"
    puts params[:happy_vendor_id]
    @happyProjectMember = HappyProjectMember.new(happyprojectmember_params)
    happyProject = HappyProject.find(@happyProjectMember.happy_project_id)
    @user = current_user
    @happyProjectMember.user_id = @user.id
    
    #@happyProjectMember.happy_quote_id = 1062
   #@happyProject.happy_project_members.create(@happHappyProjectMember) 
    
    respond_to do |format|
      #if @happyProjectMember.save
       if happyProject.happy_project_members << @happyProjectMember
        format.html { redirect_to happyProject, notice: 'Project Member was successfully created.' }
        format.json { render :show, status: :created, location: @happyProjectMember }
      else
        format.html { render :new }
        format.json { render json: @happyProjectMember.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
    happyProject = HappyProject.find(happyprojectmember_params[:happy_project_id])
    respond_to do |format|
      if @happyProjectMember.update(happyprojectmember_params)
         @happyProjectMember.save
        format.html { redirect_to happyProject, notice: 'Project Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyProjectMember }
      else
        format.html { render :edit }
        format.json { render json: @happyProjectMember.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @happyProjectMember.destroy
    respond_to do |format|
      format.html { redirect_to happy_projects_url, notice: 'Project was successfully destroyed.' }
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
    def set_happy_project_member
      @happyProjectMember = HappyProjectMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def happyprojectmember_params
      params.require(:happy_project_member).permit(:first_name, :last_name, :title, :role, :state, :email, :phone_number, :is_sms, :is_muted, :happy_project_id)
      
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
