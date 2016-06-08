class PaymentGatewayService
  def callback(order_id, transaction_attributes)
    order = Order.find(order_id)
    transaction = order.order_transactions.create(callback: transaction_attributes)
    if transaction.successful?
      order.paid!
      OrderMailer.order_paid(order.id).deliver_now
      return true
    else
      return false
    end
  rescue ActiveRecord::RecordNotFound
    raise
  rescue => e
    Honeybadger.notify(e)
    AdminOrderMailer.order_problem(order.id).deliver_now
    raise
  end
end
