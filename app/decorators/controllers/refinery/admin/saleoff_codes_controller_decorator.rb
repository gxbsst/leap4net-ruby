Refinery::SaleoffCodes::Admin::SaleoffCodesController.class_eval do

  before_filter :update_user_type, :only => [:create, :update]

  def update_user_type
    params[:saleoff_code][:user_id] = current_refinery_user.id
  end
  # your controller logic goes here
end


