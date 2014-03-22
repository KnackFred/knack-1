# To change this template, choose Tools | Templates
# and open the template in the editor.

class Transactions
  attr_accessor :Date
  attr_accessor :Type
  attr_accessor :Amount
  attr_accessor :Credit
  attr_accessor :ID
  attr_accessor :product_names

  def initialize(date, type, amount, credit, id, product_names = '')
    self.Date = date
    self.Type = type
    self.Amount = amount
    self.Credit = credit
    self.ID = id
    self.product_names = product_names
  end

  ORDERED = 0
  PURCHASED = 1
  PURCHASED_EXTERNAL = 4
  CANCELED = 2
  WITHDRAWAL = 3

  TYPES = %w(Ordered Purchased Canceled Withdrawal Purchased\ Externally)
  LINES = %w(- + + - o)

  def self.get_transactions(registrant_id)
    transactions = Array.new

    # Get All Contributions made to this users registry
    o2r2p = Orders2registryItem.get_registrant_contributes(registrant_id).group_by { |o| o.Order_ID }
    o2r2p.each  do |o|
      type = PURCHASED
      amount = 0.0
      o[1].each do |i|
        amount += i.contribute.Contribute.to_f
        type = PURCHASED_EXTERNAL if i.contribute.external?
      end
      amount = 0 if type == PURCHASED_EXTERNAL
      transactions << Transactions.new(o[1][0].order.DateTime, type, amount, 100, o[1][0].order.id, o[1][0].registry_item.product.Name)

    end

    # Get All Orders made by this user (This includes withdrawals)
    orders = Order.where(:registrant_id => registrant_id)

    orders.each do |o|
      if o.withdrawals.blank?
        amount = o.Amount
        names = ''

        if o.TakeMoneyAmount.blank?
          get_money = 0.0
        else
          get_money = o.TakeMoneyAmount.to_f
        end

        o.orders2products.each do |o2p|
          names += "#{o2p.product.Name},"
        end

        o.orders2registry_items.each do |o2p|
          names += "#{o2p.registry_item.product.Name},"
        end

        if names.length > 0
          names[names.length - 1] = ''
        end

        unless amount == get_money
          transactions << Transactions.new(o.DateTime - 1, PURCHASED, amount - get_money, 0, o.id, names)
        end

        unless o.closed_payments.blank?
          payment = o.closed_payments.find_all { |p| p.typepayment_id.to_i == Typepayment::KNACK_CREDIT && !p.IsDeleted}
          unless payment.blank?
            payment_amount = 0.0
            payment.each do |p|
              payment_amount += p.amount.to_f  if p.status_id.to_i == 2
            end
            transactions << Transactions.new(o.DateTime + 1, CANCELED, payment_amount, 0, o.id, names)
          end
        end
        transactions << Transactions.new(o.DateTime, ORDERED, amount, 0, o.id, names)
      else
        amount = 0.0
        o.withdrawals.each do |w|
          amount += w.Cash.to_f
        end

        transactions << Transactions.new(o.DateTime, WITHDRAWAL, amount, 0, o.id, "")
      end
    end

    # Sort the transactions chronologically and calculate the credits at each step.
    transactions = transactions.sort_by { |o| o.Date}

    credit = 0.0
    transactions.each do |t|
      if t.Type.to_i == PURCHASED || t.Type.to_i == CANCELED
        credit += t.Amount.to_f
      else
        credit -= t.Amount.to_f # WITHDRAWAL or PURCHASED_EXTERNAL
      end

      if credit < 0
        credit = 0
      end
      t.Credit = credit
    end

    return transactions.reverse
  end

  def self.get_transaction(order)

    order = Order.find(order)

    if order.withdrawals.blank?
      names = ''
      order.orders2products.each do |o2p|
        names += "#{o2p.product.Name},"
      end

      order.orders2registry_items.each do |o2p|
        names += "#{o2p.registry_item.product.Name},"
      end

      if names.length > 0
        names[names.length - 1] = ''
      end

      Transactions.new(order.DateTime, ORDERED, order.Amount, 0, order.id, names)
    else
      amount = 0.0
      order.withdrawals.each do |w|
        amount += w.Cash.to_f
      end

      Transactions.new(order.DateTime, WITHDRAWAL, amount, 0, order.id, "")
    end

  end
end
