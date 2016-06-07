class AdminOrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_order_mailer.order_problem.subject
  #
  def order_problem(order_id)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
