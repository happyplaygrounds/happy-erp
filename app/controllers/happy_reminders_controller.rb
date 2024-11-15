class HappyRemindersController < ApplicationController

def new
  @happyReminder = HappyReminder.new
end

def index
  @happyReminder = HappyReminder.new
end


def create
    @happyReminder = HappyReminder.new(happyreminder_params)

     @user = current_user
     @happyReminder.user_id = @user.id 

    #@happyReminder.noteable_id = 1 
    #@happyReminder.noteable_type = "HappyProject" 
    @happyModel = @happyReminder.remindable_type.constantize.find(@happyReminder.remindable_id)
    #@happyGo = @happyProject
    if @happyReminder.save
      RemindMailer.with(happyReminder: @happyReminder).invite.deliver_now
      #@model_name = controller_name.classify
      #@happyReminders = HappyReminder.where("noteable_id = ? and noteable_type = ?","1062" ,"HappyQuote")
      flash[:success] = "Reminder saved!"
       redirect_to @happyModel #or wherever you want to redirect
       ##respond_to do |format|
       #  format.html { redirect_to @happyModel.id } #or wherever you want to redirect
       #    format.js {} #this will render create.js.erb
       #end
    else
      #@happyReminders = HappyReminder.where("noteable_id = ? and noteable_type = ?","1062" ,"HappyQuote")
      flash[:alert] = "Reminder not saved!"
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      render "new"
    end
  end

private

  def happyreminder_params
     params.require(:happy_reminder).permit!
  end

  def find_customer
    @happyReminder = HappyReminder.find(params[:id])
  end

end
