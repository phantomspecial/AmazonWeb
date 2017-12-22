class ItemsController < ApplicationController

  before_action :permission_check

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


      Stock.create(item_id: @item.item_id, name: @item.name, image: @item.image, detail: @item.detail, maker: @item.maker, avg_unit_cost: @item.unit_cost, current_stock: @item.quantity, sell_price: @item.sell_price, shipping_cost: @item.shipping_cost)

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

      @stocktarget.update(item_id: @item.item_id, name: @item.name, image: @item.image, detail: @item.detail, maker: @item.maker, avg_unit_cost: avg_cost, current_stock: new_stock, sell_price: @item.sell_price, shipping_cost: @item.shipping_cost)

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
    # Stockテーブルからそのitem_idを持ったインスタンスを取得
    @stocktargets =  Stock.where(item_id: item.item_id)
    @stocktarget = @stocktargets[0]

    # 総仕入金額・総仕入数量の算出
    totalcost = 0
    totalstock = 0
    @targetitems = Item.where(item_id: item.item_id)
    @targetitems.each do |targetitem|
      totalcost = totalcost + targetitem.unit_cost * targetitem.quantity
      totalstock = totalstock + targetitem.quantity
    end
    # 平均単価算出
    avg_cost = (totalcost/totalstock).round
    # 新在庫算出

    # データupdate
    new_stock = @stocktarget.current_stock + item.quantity - @@old_item_dataset.quantity
    @stocktarget.update(item_id: item.item_id, name: item.name, image: item.image, detail: item.detail, maker: item.maker, avg_unit_cost: avg_cost, current_stock: new_stock, sell_price: item.sell_price, shipping_cost: item.shipping_cost)

    redirect_to action: :index
  end

  private
  def new_item_params
    params.require(:item).permit(:item_id,:name,:image,:detail,:maker,:unit_cost, :quantity, :sell_price,:shipping_cost, :item_flg)
  end


  def permission_check

    # #権限制御 トップページが出来上がってから動作させる。
    # if current_user.admin_flg == false
    #   render "errors/forbidden"
    # end

  end


end
