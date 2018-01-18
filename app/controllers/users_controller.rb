class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :quantitychecker_moveto_buylater


  def index
    # アカウントサービス画面
  end

  def show
    # マイストア画面
    @user = current_user

    # サブカテゴリー別に商品を表示させる
    @categories = Category.all
    @subcategories = SubCategory.all
    @stocks = []
      @subcategories.each do |sub_category|
        stock = Stock.where(sub_category_id: sub_category.id)
        @stocks << stock if stock.length != 0
      end

    # @stock_one = []
    # @stocks.each do |t|
    #   @stock_one << t.first
    # end
    # @stock_one.take(9)

    # binding.pry
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

      #カード名義、カード番号(下4桁)、有効期限(月・年)すべてが同じものがある場合、登録できないようにする。
      cards = customer.cards.all
      samecard_flg = false
      cards.each do |card|
        if card_params[:number][-4,4] == card.last4 && card_params[:month] == card.exp_month.to_s && card_params[:year] == card.exp_year.to_s
          samecard_flg = true
        end
      end

      #  samecard_flgがfalseのまま：同じカードが存在しないことになるので、カードを作成する。
      if samecard_flg == false
        customer.cards.create(
            card: @token_id
          )
      end

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

  def creditcard_destroy
    # 顧客情報取得
    # 取得したparams[:id]と合致したものを削除する
    @customer_creditcards = gets_usercardinfo
    @customer_creditcards.cards.data.each do |customer_creditcard|
      if customer_creditcard.id == params[:id]
        card = @customer_creditcards.cards.retrieve(params[:id])
        card.delete
      end
    end
    redirect_to payments_users_path
  end

  private
  def card_params
  	params.permit(:name, :number, :month, :year, :cvc)
  end

  def delete_card_params
    params.permit(:id, :name)
  end

end
