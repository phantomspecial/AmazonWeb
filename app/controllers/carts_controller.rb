class CartsController < ApplicationController

  before_action :authenticate_user!
  before_action :quantitychecker_moveto_buylater

  def index
    # 表示用変数
    @totalyen = 0
    # カート内の商品を取得
    @carts = gets_cart_items
    @totalitems = gets_cart_itemcount
    @carts.each do |cart|
      @totalyen += cart.quantity * Stock.find(cart.stock_id).sell_price
    end
    # あとで買う内の商品を取得
    @buylaters = gets_buylater_items
  end

  def create
    @stocks = Stock.all
    @carts = gets_cart_items
    update_flg = 0
    @carts.each do |cartitem|
      if cartitem.stock_id == cart_params[:stock_id].to_i
        new_quantity = cartitem.quantity + cart_params[:quantity].to_i
        cartitem.update(quantity: new_quantity)
        update_flg = 1
      end
    end
    if update_flg == 0
      @cart = current_user.carts.new(cart_params)
      @cart.save
    else
      @cart = current_user.carts.where(stock_id: cart_params[:stock_id])[0]
    end

    # 合計点数と合計金額の表示
    @carts = current_user.carts.all
    @totalitems = 0
    @totalyen = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
      @totalyen += cart.quantity * Stock.find(cart.stock_id).sell_price
    end

  end

  def destroy
    cart = Cart.find(params[:id])
    cart.destroy
    redirect_to carts_path
  end

  def update
    if params[:updflg].to_i == 1
      # jsで数量を更新するとき
      cart = Cart.find(params[:cartid].to_i)
      cart.update(quantity: params[:quantity].to_i)
    else
      # あとで買う,カートにもどすのとき
      cart = Cart.find(params[:id])
      cart.update(cart_params)
    end
    redirect_to carts_path
  end

  private
  def cart_params
    params.require(:cart).permit(:quantity, :stock_id, :buylater_flg, :updflg)
  end

  # 数量セレクトボックスの配列作成
  def quantity_array_maker(stocks)
    @current_stock_array = []
    stocks.current_stock.times do |current_stock|
      if current_stock < 10
        @current_stock_array << [current_stock + 1,current_stock + 1]
      else
        break
      end
    end
    return @current_stock_array
  end

end
