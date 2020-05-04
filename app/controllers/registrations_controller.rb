class RegistrationsController < Devise::RegistrationsController

  before_action :user_params, only: [:update]
    
  def update
    if params[:commit] == "Delete"
      if resource.destroy_with_password(params[:user][:current_password])
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        set_flash_message :notice, :destroyed
        yield resource if block_given?
        respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
      else
        redirect_to edit_user_registration_path
        flash[:danger] = "Can not delete. Password incorrect"
      end
    else
      super
    end
  end


  private

  def user_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end
  
end