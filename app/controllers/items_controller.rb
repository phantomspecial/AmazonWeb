class ItemsController < ApplicationController

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

      # Itemテーブルのidが確定したので、その値をitem_idカラムにも追加する
      @item.item_id = @item.id
      @item.save

      Stock.create(item_id: @item.item_id, avg_unit_cost: @item.unit_cost, current_stock: @item.quantity)

    else
      # 既存商品のときの処理(action: :addtoから来た場合)

      #Itemテーブルの処理

      # 抜けているカラム（name,image,detail,maker,sell_price,shipping_cost）を追加
      # 同じitem_idの最後の行を取得し、その値を格納する。
      @same_item = Item.where(item_id: @item.item_id)
      @last_same_item = @same_item.last

      # データ格納
      @item.name = @last_same_item.name
      @item.image = @last_same_item.image
      @item.detail = @last_same_item.detail
      @item.maker = @last_same_item.maker
      @item.sell_price = @last_same_item.sell_price
      @item.shipping_cost = @last_same_item.shipping_cost

      # 全カラムを埋めたので、保存する
      @item.save

      # Stockテーブルの処理
      # 総仕入金額・総仕入数量の算出
      totalcost = 0
      totalstock = 0
      @targetitems = Item.where(item_id: @item.item_id)
      @targetitems.each do |targetitem|
        totalcost = totalcost + targetitem.unit_cost * targetitem.quantity
        totalstock = totalstock + targetitem.quantity
      end

      # 平均単価算出
      avg_cost = (totalcost/totalstock).round

      # Stockテーブルからそのitem_idを持ったインスタンスを取得
      @stocktargets =  Stock.where(item_id: @item.item_id)

      @stocktarget = @stocktargets[0]

      # 新在庫算出
      new_stock = @stocktarget.current_stock + @item.quantity

      @stocktarget.update(item_id: @item.item_id, avg_unit_cost: avg_cost, current_stock: new_stock)

    end

    redirect_to action: :index

  end

  def addto
    @item = Item.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def new_item_params
    params.require(:item).permit(:item_id,:name,:image,:detail,:maker,:unit_cost, :quantity, :sell_price,:shipping_cost, :item_flg)
  end

end
