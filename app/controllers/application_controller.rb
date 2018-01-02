class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :nickname, :postal_code, :pref, :city, :street, :apartment_roomnumber, :telnumber])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :nickname, :postal_code, :pref, :city, :street, :apartment_roomnumber, :telnumber])
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


  # pay.jpのapi_keyの設定
  Payjp.api_key = ENV['PAYJP_SECRET_KEY']
end
