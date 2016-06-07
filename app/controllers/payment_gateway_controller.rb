class PaymentGatewayController < ApplicationController
  ALLOWED_IPS = ["127.0.0.1"]
  before_filter :whitelist_ip

  def callback
    order = Order.find(params[:order_id])
    transaction = order.order_transactions.create(callback: params.slice(:status, :error_message, :merchant_error_message, :shop_orderid, :transaction_id, :type, :payment_status, :masked_credit_card, :nature, :require_capture, :amount, :currency))
    if transaction.successful?
      order.paid!
      OrderMailer.order_paid(order.id).deliver_now
      redirect_to successful_order_path(order.id)
    else
      redirect_to retry_order_path(order.id)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to missing_order_path(params[:order_id])
  rescue => e
    Honeybadger.notify(e)
    AdminOrderMailer.order_problem(order.id).deliver_now
    redirect_to failed_order_path(order.id), alert: t("order.problems")
  end

  private

  def whitelist_ip
    raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
  end
end
