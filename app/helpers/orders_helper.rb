module OrdersHelper

  # 1注文とその注文に紐付いている注文詳細を取得する
  def order_orderdetails(order,range)
    @orderdetails = order.orderdetails.where(created_at: range)
    return @orderdetails
  end
end
