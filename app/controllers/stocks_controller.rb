class StocksController < ApplicationController

  before_action :permission_check, except: [:index, :show]
  before_action :authenticate_user! , except: [:index, :show]

  def index
    @stocks = Stock.all
    if user_signed_in?
      quantitychecker_moveto_buylater
      @cart = current_user.carts.new
      range = Date.current.ago(14.days).beginning_of_day..Date.current.end_of_day
      @recentorders = current_user.orders.where(created_at: range).length
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @reviews = @stock.reviews
    @current_stock_array = quantity_array_maker(@stock)
    if user_signed_in?
      quantitychecker_moveto_buylater
      @cart = current_user.carts.new
      @user = current_user
      @review = current_user.reviews.new
    end
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

  def search
    @stocks = Kaminari.paginate_array(Stock.where('name LIKE(?)', "%#{params[:keyword]}%")).page(params[:page]).per(2)
    @search_result_count = Stock.where('name LIKE(?)', "%#{params[:keyword]}%").count
    @search_result_string = params[:keyword]
    # respond_to do |format|
    #   format.html
    #   format.json
    # end
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
