class OrdersController < ApplicationController

  before_action :authenticate_user!

  def index
    # 個別ユーザ：履歴画面
    # アソシエーションを組んでいる前提

    # オーダ情報取得
    @user_orders = current_user.orders
    # オーダ詳細情報取得
    @user_order_details = []
    @user_orders.each do |user_order|
      @user_order_details += Orderdetail.where(order_id: user_order.id)
    end

    # 画面表示用
    # ユーザ登録年取得
    @user_regist_year = current_user.created_at.in_time_zone('Tokyo').strftime("%Y").to_i
    # 現在年取得
    @current_year = Time.current.in_time_zone('Tokyo').strftime("%Y").to_i
    # ループ回数変数格納
    # 現在の年 ー 登録の年だけでは、ループが1回分不足するので、1回増やす
    @yearcount = @current_year - @user_regist_year + 1
  end

  def show
    # 個別ユーザ：注文詳細画面
  end


  def confirm
    # 配送先の選択画面
    # 決済方法の選択画面
    # ギフトの選択画面
    @user = current_user

    # そのユーザにカードが登録されているかを調べる(メソッドはapplication_controller.rbに記載)
    @existuser_flg = cardusercheck
    if @existuser_flg == true
      @customer_creditcards = gets_usercardinfo
      @default_cardid = gets_userdefaultcardid
    end
  end

  def new
    # 購入確認画面
    @user = current_user
    @carts = gets_cart_items
    # 合計点数と合計金額の表示
    @totalitems = 0
    @totalitemyen = 0
    @totalshipyen = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
      @totalitemyen += cart.quantity * Stock.find(cart.stock_id).sell_price
      @totalshipyen += cart.quantity * Stock.find(cart.stock_id).shipping_cost
    end

    # そのユーザにカードが登録されているかを調べる(メソッドはapplication_controller.rbに記載)
    @existuser_flg = cardusercheck
    if @existuser_flg == true
      @customer_creditcards = gets_usercardinfo
      @default_cardid = gets_userdefaultcardid
    end
  end

  def create
    # 購入完了画面
    # カートテーブルから、そのユーザのレコードのうち、ショッピングカートにあるもの
    # (= buylater_flgがfalseのもの）を持ってくる
    @currentorder = gets_cart_items

    # order_idを確定するために、Orderテーブルにレコードを作成する
    # 現状わかっている、ユーザIDのみを格納する
    @order = Order.create(user_id: current_user.id)

    # 0クリア
    total = 0
    total_shippingcost = 0

    # カートにあるそのユーザのレコード分、Orderdetailsテーブルにレコードを作成する。
    @currentorder.each do |currentorder|
      # インスタンス作成
      @ordermaking = Orderdetail.new

      # order_idカラムに、先ほど作成した@orderのidを格納
      @ordermaking.order_id = @order.id

      # currentorder（そのユーザのカートに入っているもの）の、stock_idとquantityを書き込む
      @ordermaking.stock_id = currentorder.stock_id
      @ordermaking.quantity = currentorder.quantity

      # そのstock_idを持つ商品をStockテーブルから参照し、インスタンス変数にしまう
      @stock = Stock.find(currentorder.stock_id)

      # 販売価格と送料を代入
      # 販売価格や送料は変動する可能性があるので、購入時点での価格と送料を保存する必要がある
      @ordermaking.sell_price = @stock.sell_price
      @ordermaking.shipping_cost = @stock.shipping_cost

      # 1商品あたりの金額の算出：注文履歴画面で利用予定
      @ordermaking.total_price = @ordermaking.quantity * @ordermaking.sell_price
      @ordermaking.total_shippingcost = @ordermaking.quantity * @ordermaking.shipping_cost

      # orderテーブルに書き込むための合計金額、合計送料の集計
      total += @ordermaking.total_price
      total_shippingcost += @ordermaking.total_shippingcost

      # 全カラム値を格納したので、保存する
      @ordermaking.save

      # Stockテーブルから、その商品の在庫数を注文数量分減らして更新
      @stock.current_stock -= @ordermaking.quantity
      @stock.update(current_stock: @stock.current_stock)

    end

    # オーダーテーブルの残ったカラムへの値の書き込み
    @order.update(total: total, total_shippingcost: total_shippingcost)
    @order.update(payments: "Creditcard", status: "Shipping(preparation)")

    # そのユーザのカートを削除する。
    @currentorder.each do |currentorder|
      currentorder.destroy
    end

    #payjpの処理
    Payjp::Charge.create(
      currency: 'jpy',
      amount: total + total_shippingcost,
      customer: current_user.id
    )

    # 注文完了画面表示用
    @orderviews = Orderdetail.where(order_id: @order.id)
    @orderstocknames = []
    @orderviews.each do |orderview|
      @orderstocknames << Stock.find(orderview.stock_id)
    end
    @user = current_user
    @deliverydate = Order.find(@order.id).created_at.since(2.days)
  end

end
