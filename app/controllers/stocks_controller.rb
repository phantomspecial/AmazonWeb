class StocksController < ApplicationController

  before_action :permission_check, except: [:index, :show]
  before_action :authenticate_user! , except: [:index, :show, :search, :autocomplete_stocks]

  def index
    @stocks = Stock.all
    if user_signed_in?
      quantitychecker_moveto_buylater
      @cart = current_user.carts.new
      range = Date.current.ago(14.days).beginning_of_day..Date.current.end_of_day
      @recentorders = current_user.orders.where(created_at: range).length
    end

    # ランダムにカテゴリーidを取得
    @rndm_category = Category.where( 'id >= ?', rand(Category.first.id..Category.last.id) ).first
    @rndm_stock_img = Stock.where(category_id: @rndm_category.id)
    # ランダムにサブカテゴリーの値を取得
    @rndm_subcategory = SubCategory.limit(15)
    @rndm_subcategory_img = Stock.where(category_id: @rndm_subcategory.ids).select('image')
  end

  def show
    @stock = Stock.find(params[:id])
    @reviews = @stock.reviews
    category_id = @stock[:category_id]
    @category = Category.find(category_id)
    sub_category_id = @stock[:sub_category_id]
    @sub_category = SubCategory.find(sub_category_id)
    @current_stock_array = quantity_array_maker(@stock)
    if user_signed_in?
      quantitychecker_moveto_buylater
      @cart = current_user.carts.new
      @user = current_user
      @review = current_user.reviews.new
    end

    # レビュー割合情報出力
    @review_dist = []
    reviewlength = @reviews.length
    if reviewlength != 0
      5.times do |i|
        @review_dist[i] = (@reviews.where(rate: i + 1).length) *100 / reviewlength
      end
    end

    # ランダムにstockを抽出
    @stocks = Stock.where('rand()').limit(10)
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
    # キーワードが空か入っているか
    if params[:keyword].empty?
      redirect_to action: 'index'
    else
      @stocks = Kaminari.paginate_array(search_stocks).page(params[:page]).per(20)

      # 価格の高い順等取得・表示
      if params[:value] == "1"
        set_search
      elsif params[:value] == "2"
        @stocks = set_search.order('sell_price ASC')
      elsif params[:value] == "3"
        @stocks = set_search.order('sell_price DESC')
      elsif params[:value] == "4"
        @stocks = set_search.order('avg_review DESC')
      elsif params[:value] == "5"
        @stocks = set_search.order('created_at DESC')
      end

      respond_to do |format|
        format.html
        format.json
      end

      # サイドバーにカテゴリーを表示させる
      @category_id = params[:category_id]
      @all_categories = Category.all
        if params[:category_id].empty?
          @categories = Category.all
        else
          @categories = Category.find(params[:category_id])
        end
    end
    @search_result_count = search_stocks.count
    @search_result_string = params[:keyword]
  end

  # 検索窓でStockテーブルからオートサジェストさせる
  def autocomplete_stocks
    stocks_suggestions = Stock.autocomplete(params[:term]).pluck(:name)
    respond_to do |format|
      format.html
      format.json {
      render json: stocks_suggestions
      }
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

  # Stockテーブルから曖昧検索する
  def set_search
    Stock.where('name LIKE(?)', "%#{params[:keyword]}%")
  end

  # カテゴリーを含めて検索する
  def search_stocks
    @category = params[:category_id]
    if @category.empty?
      set_search
    else
      set_search.where(category_id: @category)
    end
  end

end
