class PaymentGatewayController < ApplicationController

  ALLOWED_IPS = ["127.0.0.1"]
  before_filter :whitelist_ip

  def callback
    if PaymentGatewayService.new.callback(params[:order_id], transactions_attributes)
      redirect_to successful_order_path(params[:order_id])
    else
      redirect_to retry_order_path(params[:order_id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to missing_order_path(params[:order_id])
  rescue
    redirect_to failed_order_path(params[:order_id]), alert: t("order.problems")
  end

  private

  def whitelist_ip
    raise UnauthorizedIpAccess unless ALLOWED_IPS.include?(request.remote_ip)
  end

  def transactions_attributes
    params.slice(:status, :error_message, :merchant_error_message, :shop_orderid, :transaction_id, :type, :payment_status, :masked_credit_card, :nature, :require_capture, :amount, :currency)
  end
end
