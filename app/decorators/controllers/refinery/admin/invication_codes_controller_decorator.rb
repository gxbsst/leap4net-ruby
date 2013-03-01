Refinery::InvicationCodes::Admin::InvicationCodesController.class_eval do

  before_filter :update_user_type, :only => [:create, :update]

  def update_user_type
    params[:invication_code][:user_type] = 'Refinery::User'
    params[:invication_code][:user_id] = current_refinery_user.id
  end
  # your controller logic goes here
end


