class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :nickname, :postal_code, :pref, :city, :street, :apartment_roomnumber, :telnumber])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :nickname, :postal_code, :pref, :city, :street, :apartment_roomnumber, :telnumber])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  # include ErrorHandlers if Rails.env.production? or Rails.env.staging?

  class ApplicationController < ActionController::Base
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
  end

end
