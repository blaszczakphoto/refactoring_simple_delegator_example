# Preview all emails at http://localhost:3000/rails/mailers/admin_order_mailer
class AdminOrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_order_mailer/order_problem
  def order_problem
    AdminOrderMailer.order_problem
  end

end
