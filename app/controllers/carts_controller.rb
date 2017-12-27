class CartsController < ApplicationController

# stockのshowからカートに追加した際の処理
  def index
    # @cart = Cart.stocks.find(params[:id])
  end

  def show
    @carts = current_user.carts.all
    # @stock = Stock.find(params[:id])
    # @order = order.new
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.save
  end

  def destroy

  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def update
    cart = Cart.find(params[:id])
    cart.update
  end

  private
  def cart_params
    params.require(:cart).permit(:quantity, :user_id, :stock_id)
  end

end
