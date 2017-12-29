class OrdersController < ApplicationController
  def index
  end

  def show
  end


  def delivery
    # 配送先の選択画面
    @user = current_user
  end

  def gift
    # 決済方法の選択画面
    @user = current_user
  end

  def new
    # 購入確認画面
    @user = current_user
    @carts = current_user.carts
  end

  def create
    # 購入完了画面
    # カートテーブルから、そのユーザのレコードを持ってくる
    @currentorder = current_user.carts

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

    # そのユーザのカートを削除する。
    @currentorder.each do |currentorder|
      currentorder.destroy
    end
  end

end
