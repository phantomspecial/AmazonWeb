class StocksController < ApplicationController

  before_action :permission_check, except: :index

  def index
    @stocks = Stock.all

    @carts = current_user.carts.all
    @cart = current_user.carts.new
    @totalitems = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @carts = current_user.carts.all
    @cart = current_user.carts.new
    @user = current_user
    @totalitems = 0
    @carts.each do |cart|
      @totalitems += cart.quantity
    end
  end

  def create

  end

  def destroy
    stock = Stock.find(params[:id])
    # nameを削除しますか？この操作は元に戻せませんのアラート
    # [はい]がクリックしたときの動作
    if stock.current_stock == 0
      stock.destroy
    else
      # 在庫が０でないため、削除できませんのアラートを出す
    end
    redirect_to action: :index
  end


  private
  def permission_check
    #権限制御 トップページが出来上がってから動作させる。
    if user_signed_in?
      if current_user.admin_flg == nil
        render "errors/forbidden"
      end
    end
  end

end
