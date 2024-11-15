class HappyProjectsController < ApplicationController
  before_action :set_happy_project, only: [:show, :edit, :update, :destroy, :add]

  # GET /happy_projects
  # GET /happy_projects.json
  def index
    #@happyprojects = current_user.happy_projects
    @happyProjects = HappyProject.page params[:page]
  end

  # GET /projects/1
  # GET /projects/1.json
  def show

    @model_name = controller_name.classify
     #helpers.set_model_name
     puts "Model"
     puts @model_name

     @happyReminder = HappyReminder.new
     @happyReminders = HappyReminder.where("remindable_id = ? and remindable_type = ? and user_id = ? and reminder_date >= ?", params[:id], @model_name, current_user.id, Date.today)

    @happyProjectTask = @happyProject.happy_project_tasks.new
    @happyProjectMembersCount = @happyProject.happy_project_members.distinct.count()

    #association = HappyNote.reflect_on_all_associations(:belongs_to).first
    #polymorphic = association.options[:polymorphic]

    #associations = ApplicationRecord.subclasses.select do |model|
    #    model.reflect_on_all_associations(:has_many).any? do |has_many_association|
    #        has_many_association.options[:as] == association.name
    #  end
    #end
    #@model_name = controller_name.classify
    puts "model"
    puts @model_name
    #puts "association"
    #puts association
    #puts "polymorphic"
    #puts polymorphic
    #puts "associations"
    #puts associations
    #puts "testReflect"
    #puts $testReflect
  end

  # GET /projects/new
  def new
    @happyProject = HappyProject.new
    @happyvendors = HappyVendor.all.order("vendor_name asc")
      @happyCustomer = HappyCustomer.find(params[:happy_customer_id])
      @happyQuote = HappyQuote.find(params[:happy_quote_id])
      @happyInstallSite = HappyInstallSite.find(params[:happy_install_site_id])

    #@happyProject.name = @happyInstallSite.name
    @happyProject.description = @happyInstallSite.description
    @happyProject.site_contact_phone = @happyInstallSite.phone
    @happyProject.site_contact_email = @happyInstallSite.email
    @happyProject.actual_start_date = Date.today
    @happyProject.planned_budget = @happyQuote.total
    

    @user = current_user
    user_id = @user.id
    if HappyProjectMember.where("user_id = ?", user_id).exists?
      puts "exists"
    else
      puts "does not exist"
      happyUser = User.find(user_id)

      intial_name = happyUser.email.split('@')
      name = intial_name[0].split('.')
      first_name = name[0]
      last_name = name[1]

      happyProjectMember = HappyProjectMember.create(first_name: first_name, last_name: last_name, email: happyUser.email, user_id: user_id)
    end
  end


  # GET /happy_projects/1/edit
  def edit
    puts "got in edit"
    @happyvendors = HappyVendor.select('vendor_name','id').order("vendor_name asc")
    @happyProject = HappyProject.includes(:happy_project_tasks).order("happy_project_tasks.position asc").find(params[:id])
  end

  # POST /happy_projects
  # POST /happy_projects.json
  def create
    puts "create params"
    puts params
    
    @happyProject = HappyProject.new(happyProject_params)
    #params[:happy_quote_id] = @happyProject.happy_quote_id

    puts "after params"
    puts params
    @user = current_user
    @happyProject.user_id = @user.id
    @happyProject.status = 'in-progress'
    #@happyProject.happy_quote_id = @happy_quote_id
    #@happyProject.happy_quote_id = "1008"
  

    respond_to do |format|
      if @happyProject.save
        format.html { redirect_to @happyProject, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @happyProject }
      else
        @happyQuote = HappyQuote.find(happyProject_params[:happy_quote_id])
        @happyCustomer = HappyCustomer.find(happyProject_params[:happy_customer_id])
        @happyInstallSite = HappyInstallSite.find(happyProject_params[:happy_install_site_id])
        @happyvendors = HappyVendor.all.order("vendor_name asc")
        format.html { render :new }
        format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_projects/1
  # PATCH/PUT /happy_projects/1.json
  def update
     #raise params.inspect
    puts "got in update"
    #@happyProject.happy_quote_id = 1062
    
    if params[:addjoin] # addjoin is a name on the submit button
    respond_to do |format|
      #if params[:happyProject_params]
          #form_params = happyProject_params
      #else
          #form_params =happyUpdateProject_params
      #end
      #if @happyProject.update(happyProject_params)
         #@happyProject.save!
      if @happyProject.update(happyUpdateProject_params)
        format.html { redirect_to @happyProject, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyProject }
      else
        @happyvendors = HappyVendor.select('vendor_name','id').order("vendor_name asc")
        format.html { render :edit }
        format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      end
    end
  else
    respond_to do |format|
      #if params[:happyProject_params]
          #form_params = happyProject_params
      #else
          #form_params =happyUpdateProject_params
      #end
      #if @happyProject.update(happyProject_params)
         #@happyProject.save!
      if @happyProject.update(happyProject_params)
        format.html { redirect_to @happyProject, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyProject }
      else
        format.html { render :edit }
        format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      end
    end

  end
  

  end

  def add 
    puts "got in add"

    @happyMembers = HappyProjectMember.where("happy_vendor_id is null and happy_customer_id is null")

    @happyProjectVendors = HappyQuoteLine.joins(:happy_vendor).where("happy_quote_id = ? and happy_vendor_id is not null", params[:happy_quote_id]).distinct.select('happy_vendor_id', 'happy_vendors.vendor_name')
    
    if @happyProjectVendors.exists?
      @happyProjectVendors.each do |projectVendor|
          #@happyVendorMembers = HappyProjectMember.where("happy_vendor_id = ?", "#{projectVendor.happy_vendor_id}").distinct
          @happyVendorMembers = HappyProjectMember.where("happy_vendor_id = ?", "#{projectVendor.happy_vendor_id}").distinct
       end
    end
   
    @happyProjectCustomer = HappyQuote.joins(:happy_customer).where("happy_quotes.id = ?", params[:happy_quote_id]).select('happy_customers.id', 'happy_customers.customer_name')

    #@happyProjectCustomer = HappyCustomer.where("id =?", 9)

    #@happyCustomerMember = HappyProjectMember.all
    if @happyProjectCustomer.exists?
      @happyProjectCustomer.each do |projectCustomer|
        @happyCustomerMember = HappyProjectMember.where("happy_customer_id = ?", "#{projectCustomer.id}")
     end
          #@happyCustomerMember = HappyProjectMember.where("happy_customer_id = ?", @happyProjectCustomer.id) 
    end
    
    #@happyProject.happy_quote_id = 1062
    #respond_to do |format|
      #if params[:happyProject_params]
          #form_params = happyProject_params
      #else
          #form_params =happyUpdateProject_params
      #end
      #if @happyProject.update(happyProject_params)
         #@happyProject.save!
         #if request.post?
          #@course = Course.find(params[:course_id])
          #@student.student_course_assignments << @course
      #end
      #if @happyProject.update(happyProject_params)
        #format.html { redirect_to @happyProject, notice: 'Project was successfully updated.' }
        #format.json { render :show, status: :ok, location: @happyProject }
     # else
        #format.html { render :edit }
       # format.json { render json: @happyProject.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # DELETE /happy_projects/1
  # DELETE /happy_projects/1.json
  def destroy
    @happyProject.destroy
    respond_to do |format|
      format.html { redirect_to happy_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def loadprocess
    happyProcess = HappyStandardProcess.find(params[:id])
    task_ids = Array.new()
    task_ids = happyProcess.happy_standard_task_ids
    puts "Task ids"
    puts task_ids

    happyTasks = HappyStandardTask.where(id: task_ids)
    puts "happyTasks"
    puts happyTasks
    Rails.logger.debug happyTasks.inspect
    #@happyTasks = @happyProcess.happy_standard_tasks.includes(:happy_standard_activities)
    # p = HappyStandardTask.find(1).happy_standard_activities
    #Rails.logger.debug @happyTasks.inspect

    #@happyActivities = @happyActivities.ties)
    #@happyTasksClone = @happyTasks.clone
    #
    @user = current_user
    
    happyTasks.each { |task|
                            #happyActivities = HappyStandardActivity.where(happy_standard_task_id: task.id)
                                 #happyActivities.each { |activity|
                                        #puts "top activity"
                                        #puts activity.activity_name
                                        #puts "below activity"
                                 #}
                            puts task.id
                            puts task.task_name
                            puts task.description
                            happyProjectTask = HappyProjectTask.create(happy_project_id: params[:happy_project_id],happy_vendor_id: task.happy_vendor_id, 
                              task_name: task.task_name, 
                              description: task.description,
                              priority: task.priority, 
                              dependency: task.dependency, 
                              lead_time: task.lead_time, 
                              is_vendor: task.is_vendor, 
                              image_name: task.image_name, 
                              image_url: task.image_url, 
                              status: 'not-started',
                              user_id: @user.id)
                            }
    
    @happyProject = HappyProject.find(params[:happy_project_id])
    @happyProjectTasks = @happyProject.happy_project_tasks
    #@happyProjectTasks = HappyProjectTask.find(id: params[:happy_project_id])
    #@happyStandardProcess = HappyProcessFlow.includes(:happy_quote_lines).order("happy_quote_lines.id asc").find(params[:happy_quote_id])
    puts "got in loadProcess"
    respond_to do |format|
      format.html { redirect_to happy_project_path(@happyProject) }
    end
  end

  def edit_happy_members
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_happy_project
      @happyProject = HappyProject.find(params[:id])
    end

    def happyUpdateProject_params
      params.require(:ht).permit!
    end

    # Only allow a list of trusted parameters through.
    def happyProject_params
      #params.require(:happy_project).permit!
      params.require(:happy_project).permit(:id, :ht, :project_name, :description, :general_contractor,
                     :site_contact_name, :site_contact_phone, :site_contact_email, :project_type,
                     :planned_start_date, :planned_end_date, :actual_start_date, :actual_end_date, :planned_budget, :internal_notes, :external_notes,
                     :reminder_date, :is_reminder, :status, :happy_customer_id, :happy_quote_id, :happy_install_site_id, happy_project_tasks_attributes: [:id, :happy_project_id,
                      :happy_vendor_id,        
                      :task_name,        
                      :description,          
                      :sales_order,          
                      :planned_start_date,          
                      :planned_end_date,          
                      :actual_start_date,          
                      :actual_end_date,          
                      :order_date,          
                      :ship_date,          
                      :estimated_delivery_date,          
                      :receipt_date,          
                      :reminder_date,
                      :is_reminder,
                      :priority,             
                      :group,                
                      :dependency,
                      :lead_time,
                      :is_vendor,            
                      :duration,
                      :status,
                      :duration_unit,        
                      :internal_notes,        
                      :external_notes,        
                      :is_vendor,            
                      :_destroy])  
                                            
    end
end
