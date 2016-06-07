require 'rails_helper'

describe PaymentGatewayController, type: :controller do
  describe "#callback" do
    let(:order) { build_stubbed(:order) }
    let(:params) do
      {
        order_id: 1,
        status: "1",
        error_message: "true",
        merchant_error_message: ""
      }
    end
    before do
      allow(controller.request).to receive(:remote_ip) { "127.0.0.1" }
    end
    it "searchs for order" do
      expect(Order).to receive(:find).with("1") { order }
      get :callback, params
    end

    it "creates order transaction" do
      allow(Order).to receive(:find) { order }
      expected_params = {callback: params.slice(:status, :error_message, :merchant_error_message)}
      expect_any_instance_of(OrderTransactions).to receive(:create).with(expected_params) { Transaction.new }
      get :callback, params
    end

    context "transaction successful" do
      it "fires order paid send mail and redirect to success" do
        allow(Order).to receive(:find) { order }
        allow_any_instance_of(Transaction).to receive(:successful?) {true}
        expect_any_instance_of(Order).to receive(:paid!)
        expect(OrderMailer).to receive(:order_paid).with(order.id) { double('mailer', deliver: 'true') }
        get :callback, params
        expect(response).to redirect_to(successful_order_path(order.id))
      end
    end

    context "transaction is not successful" do
      it "fires order paid send mail and redirect to success" do
        allow(Order).to receive(:find) { order }
        allow_any_instance_of(Transaction).to receive(:successful?) {false}
        expect_any_instance_of(Order).to_not receive(:paid!)
        get :callback, params
        expect(response).to redirect_to(retry_order_path(order.id))
      end
    end

    context "records is not found" do
      it "redirect to missing_order_path" do
        get :callback, params
        expect(response).to redirect_to(missing_order_path("1"))
      end
    end

    context "there is other error" do
      it "redirectts to failded order and send email to admin" do
        allow(Order).to receive(:find) { order }
        allow_any_instance_of(Transaction).to receive(:successful?) { raise StandardError }
        expect_any_instance_of(Honeybadger).to receive(:notify).with(StandardError)
        expect(AdminOrderMailer).to receive(:order_problem).with(order.id) { double('mailer', deliver: 'true') }
        get :callback, params
        expect(response).to redirect_to(failed_order_path(order.id))
      end
    end
  end
end
