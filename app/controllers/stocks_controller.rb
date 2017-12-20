class StocksController < ApplicationController

  def index
    @stocks = Stock.all
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


end
