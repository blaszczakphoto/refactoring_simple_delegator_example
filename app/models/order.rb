class Order < ActiveRecord::Base
  def order_transactions
    OrderTransactions.new
  end

  def paid!
    true
  end
end

class OrderTransactions
  def create(callback:)
    Transaction.new
  end
end

class Transaction
  def successful?
    true
  end
end

# class Honeybadger
#   def notify(e)
#   end
# end

