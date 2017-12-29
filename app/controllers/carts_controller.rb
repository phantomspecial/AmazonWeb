class CartsController < ApplicationController

# stockのshowからカートに追加した際の処理
  def index
    # @cart = Cart.stocks.find(params[:id])
  end

  def show
    @carts = current_user.carts.all
  end

  def create
    @cart = current_user.carts.new(cart_params)
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
    params.require(:cart).permit(:quantity, :stock_id)
  end

end
