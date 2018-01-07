class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!,  only: [:cardusercheck, :gets_usercardinfo, :gets_userdefaultcardid, :gets_cart_number]

  helper_method :gets_cart_items, :gets_cart_itemcount

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

  # 顧客-クレジットカード情報
  def cardusercheck
    # pay.jpに、current_user.idを持つユーザが登録されて入ればtrue、そうでなければfalseを返す
    @payjpusers = Payjp::Customer.all
    @payjpusers.each do |payjpuser|
      if payjpuser.id.to_i == current_user.id
        @existuser_flg = true
        break
      else
        @existuser_flg = false
      end
    end
    return @existuser_flg
  end

  # 顧客-カード情報取得
  def gets_usercardinfo
      @customer_creditcards = Payjp::Customer.retrieve(id: current_user.id.to_s)
  end

  # 顧客-デフォルトカードid取得
  def gets_userdefaultcardid
      @default_cardid = Payjp::Customer.retrieve(id: current_user.id.to_s).default_card
  end

  # カート内の商品を取得
  def gets_cart_items
    return current_user.carts.all
  end
  # カート内の商品の合計数を取得
  def gets_cart_itemcount
    @carts = gets_cart_items
    @totalitems = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
    end
    return @totalitems
  end
end
