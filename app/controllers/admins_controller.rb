class AdminsController < ApplicationController

  before_action :permission_check

  def index
    # 注文履歴最新５件
    @recentorders = Order.order(created_at: :desc).limit(10)
    # 在庫数５未満の商品一覧
    @limitedstocks = []
    @stocks = Stock.all
    @stocks.each do |stock|
      if stock.current_stock <= 5
        @limitedstocks += stock
      end
    end
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
