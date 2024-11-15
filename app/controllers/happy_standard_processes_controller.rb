class HappyStandardProcessesController < ApplicationController
  before_action :find_process, only: [:show, :edit, :update, :destroy]
#  before_action :set_happy_standard_process, only: [:show, :edit, :update, :destroy]
#  before_action :set_happy_process, only: [:show, :edit, :update, :destroy]

  def index
    @happyStandardProcesses = HappyStandardProcess.order("process_name ASC").page params[:page]
    @search = params["search"]
    if @search.present?
      @name = @search["process_name"]
      @happyStandardProcesses = HappyStandardProcess.where("process_name ILIKE ?", "%#{@name}%").order("process_name DESC").page(params[:page])
    end
  end

  #def index
    #@happyProcesses = current_user.happy_processes
    #@happyStandardProcesses = HappyStandardProcess.page params[:page]
  #end

  # GET /processes/1
  # GET /processes/1.json
  def show
    @happyStandardProcess.user_id = current_user.id
  end

  # GET /processes/new
  def new
    @happyStandardProcess = HappyStandardProcess.new
  end

  # GET /happy_processes/1/edit
  def edit
  end

  # POST /happy_processes
  # POST /happy_processes.json
  def create
    #@user = current_user
    @happyStandardProcess = HappyStandardProcess.new(happyStandardProcess_params)
    @happyStandardProcess.user_id = current_user.id

    respond_to do |format|
      if @happyStandardProcess.save
        format.html { redirect_to @happyStandardProcess, notice: 'Process was successfully created.' }
        format.json { render :show, status: :created, location: @happyStandardProcess }
      else
        format.html { render :new }
        format.json { render json: @happyStandardProcess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /happy_processes/1
  # PATCH/PUT /happy_processes/1.json
  def update
    @happyStandardProcess.user_id = current_user.id
    respond_to do |format|
      if @happyStandardProcess.update(happyUpdateStandardProcess_params)
        format.html { redirect_to @happyStandardProcess, notice: 'Process was successfully updated.' }
        format.json { render :show, status: :ok, location: @happyStandardProcess }
      else
        format.html { render :edit }
        format.json { render json: @happyStandardProcess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /happy_processes/1
  # DELETE /happy_processes/1.json
  def destroy
    @happyStandardProcess.destroy
    respond_to do |format|
      format.html { redirect_to happy_processes_url, notice: 'Process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def happyStandardProcess_params
      params.require(:happy_standard_process).permit!
    end

    def happyUpdateStandardProcess_params
      params.require(:hp).permit!
    end

    def find_process
      @happyStandardProcess = HappyStandardProcess.find(params[:id])
    end

    #def set_happy_standard_task
      #@happyStandardProcess = HappyStandardProcess.find(params[:id])
    #end

    #def set_happy_task_task
      #@happyStandardProcess = @happyStandardProcess.find(params[:id])
    #end

    # Only allow a list of trusted parameters through.
    #def task_params
      #params.require(:task).permit(:name, :description)
    #end
end
