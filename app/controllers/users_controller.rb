class UsersController < ApplicationController
  def index
    # アカウントサービス画面
  end

  def show
    @user = current_user
    # マイストア画面
  end

  def payments
  	# 支払いオプション画面
  	@user = current_user
   	# 現在の年を格納する（クレジットカード情報登録用）
    @year = Time.current.in_time_zone('Tokyo').strftime("%Y").to_i

    # そのユーザにカードが登録されているかを調べる(メソッドはapplication_controller.rbに記載)
    @existuser_flg = cardusercheck


    # Payjpに登録されているそのユーザidを持つユーザのクレジットカード情報を取得する。
    if @existuser_flg == true
      @customer_creditcards = gets_usercardinfo
      @default_cardid = gets_userdefaultcardid
    end
   end

  def creditcard_regist
  	# pay.jpにクレジットカード情報を登録する

  	# トークン作成
    token = Payjp::Token.create(
      card: {
        number: card_params[:number],
        cvc: card_params[:cvc],
        exp_year: card_params[:year],
        exp_month: card_params[:month],
        name: card_params[:name]
      }
    )
    @token_id = token.id


    # Pay.jpへのカード追加に関わる処理
    # そのユーザにカードが登録されているかを調べる(privateメソッド)
    @existuser_flg = cardusercheck

    if @existuser_flg == true
      #既存顧客：すでに１枚以上カードがあり、そこに追加する場合
      customer = gets_usercardinfo
      customer.cards.create(
        card: @token_id
      )
    else
      #新規顧客：１枚もカードがない場合
      # Pay.jpに顧客を作成（カード情報の保存に必要）
      Payjp::Customer.create(
        id: current_user.id,
        email: current_user.email,
        card: @token_id
      )
    end

  	# お支払いオプションページに戻る
    # アラートを出す
  	redirect_to payments_users_path

  end

  private
  def card_params
  	params.permit(:name, :number, :month, :year, :cvc)
  end

end
