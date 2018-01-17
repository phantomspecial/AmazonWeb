class ItemsController < AdminsController

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    # 新規商品/既存商品仕入 共通処理

    @item = Item.new(new_item_params)

    if @item.item_flg == 0
      #新規商品のときの処理（action: :newから来た場合）

      @item.save

      #Stockテーブルにレコードを作成する
      @stock = Stock.create(name: @item.name, image: @item.image, detail: @item.detail, maker: @item.maker, avg_unit_cost: @item.unit_cost, current_stock: @item.quantity, sell_price: @item.sell_price, shipping_cost: @item.shipping_cost, category_id: @item.category_id, sub_category_id: @item.sub_category_id)


      # Stockテーブルのidが確定したので、その値をItemテーブルのstock_idカラムに追加して保存
      @item.stock_id = @stock.id
      @item.save

    else
      # 既存商品のときの処理(action: :addtoから来た場合)

      # 抜けているカラム（name,image,detail,maker,sell_price,shipping_cost）を追加
      # Stockテーブルから同じstock_idのレコードを取得し、そのインスタンスを格納する。
      # 画像については、Itemテーブルから、最新のupdated_atのtimestampのものを抽出する。
      # Stock.find(@item.stock_id).imageでは正常に動作しなかったため
      @target_item = Stock.find(@item.stock_id)

      # データ格納
      @item.name = @target_item.name
      @item.image = Item.where(stock_id: @item.stock_id).order(updated_at: :desc).limit(1)[0].image
      @item.detail = @target_item.detail
      @item.maker = @target_item.maker
      @item.sell_price = @target_item.sell_price
      @item.shipping_cost = @target_item.shipping_cost

      # 全カラムを埋めたので、保存する
      @item.save

      # Stockテーブルの処理
      # 総仕入金額・総仕入数量の算出
      totalcost = 0
      totalstock = 0
      @targetitems = Item.where(stock_id: @item.stock_id)
      @targetitems.each do |targetitem|
        totalcost = totalcost + targetitem.unit_cost * targetitem.quantity
        totalstock = totalstock + targetitem.quantity
      end

      # 平均単価算出
      avg_cost = (totalcost/totalstock).round

      # 新在庫算出
      new_stock = @target_item.current_stock + @item.quantity
      @target_item.update(avg_unit_cost: avg_cost, current_stock: new_stock)

    end

    redirect_to action: :index

  end

  def addto
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
    @@old_item_dataset = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    #Itemテーブルの編集対象レコードを更新
    item.update(new_item_params)

    # new_item_paramsでもらって来た更新内容で、stockテーブルを更新する。
    # Stockテーブルからそのitem.stock_idを持ったインスタンスを取得
    @stocktarget = Stock.find(item.stock_id)
    @@old_item_dataset = Item.find(params[:id])

    # 総仕入金額・総仕入数量の算出
    totalcost = 0
    totalstock = 0
    @targetitems = Item.where(stock_id: item.stock_id)
    @targetitems.each do |targetitem|
      totalcost = totalcost + targetitem.unit_cost * targetitem.quantity
      totalstock = totalstock + targetitem.quantity
    end
    # 平均単価算出
    avg_cost = (totalcost/totalstock).round
    # 新在庫算出

    # データupdate
    new_stock = @stocktarget.current_stock + item.quantity - @@old_item_dataset.quantity
    @stocktarget.update(name: item.name, image: item.image, detail: item.detail, maker: item.maker, avg_unit_cost: avg_cost, current_stock: new_stock, sell_price: item.sell_price, shipping_cost: item.shipping_cost, category_id: item.category_id, sub_category_id: item.sub_category_id)

    redirect_to action: :index
  end

  private
  def new_item_params
    params.require(:item).permit(:stock_id, :name,:image,:detail,:maker,:unit_cost, :quantity, :sell_price,:shipping_cost, :item_flg, :category_id, :sub_category_id)
  end

end
