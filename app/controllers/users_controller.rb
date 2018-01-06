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

    # Payjpに登録されているそのユーザidを持つユーザのクレジットカード情報を取得する。
    # @customer_creditcards = Payjp::Customer.retrieve(id: current_user.id.to_s)
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

    # Pay.jpに顧客を作成（カード情報の保存に必要）
    Payjp::Customer.create(
      id: current_user.id,
      email: current_user.email,
      card: @token_id
    )

  	# お支払いオプションページに戻る
    # アラートを出す
  	redirect_to payments_users_path

  end

  private
  def card_params
  	params.permit(:name, :number, :month, :year, :cvc)
  end

end
