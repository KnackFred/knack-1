# To change this template, choose Tools | Templates
# and open the template in the editor.

class Statistics
  def initialize

  end

  def self.get_statistics(date, full)
    statistics = Array.new

    date = DateUtilites.new(date)

    statistics << self.get_signups(date, full)
    statistics << self.get_r2p_total(date, full)
    statistics << self.get_r2p(date, full)
    statistics << self.get_network_additions(date, full)
    statistics << self.get_add_own(date, full)
    statistics << self.get_out_of_network(date, full)
    statistics << self.get_orders(date, full)
    statistics << self.get_amount_to_registry(date, full)
    statistics << self.get_from_network_orders(date, full)
    statistics << self.get_own_networks(date, full)
    statistics << self.get_from_cash(date, full)

    return statistics
  end

  def self.get_signups(date, full)

    today = Registrant.where(:IsDeleted => false, :created_at => (date.today..(date.today + 1))).count
    week = Registrant.where(:IsDeleted => false, :created_at => (date.week..(date.today + 1))).count
    month = Registrant.where(:IsDeleted => false, :created_at => (date.month..(date.today + 1))).count
    year = full ? Registrant.where(:IsDeleted => false, :created_at => (date.year..(date.today + 1))).count : 0

    return StatisticsSection.new('New sign ups', today, week, month, year, 0)
  end

  def self.get_r2p(date, full)
    today = RegistryItem.where(:IsDeleted => false, :created_at => (date.today..(date.today + 1))).count
    week = RegistryItem.where(:IsDeleted => false, :created_at => (date.week..(date.today + 1))).count
    month = RegistryItem.where(:IsDeleted => false, :created_at => (date.month..(date.today + 1))).count
    year = full ? RegistryItem.where(:IsDeleted => false, :created_at => (date.year..(date.today + 1))).count : 0

    return StatisticsSection.new("Gifts added to registry", today, week, month, year, 0)
  end

  def self.get_r2p_total(date, full)
    r2p = RegistryItem.where(:IsDeleted => false)

    today = RegistryItem.where(:IsDeleted => false, :created_at => (date.today..(date.today + 1)))
    week = RegistryItem.where(:IsDeleted => false, :created_at => (date.week..(date.today + 1)))
    month = RegistryItem.where(:IsDeleted => false, :created_at => (date.month..(date.today + 1)))
    year = full ? RegistryItem.where(:IsDeleted => false, :created_at => (date.year..(date.today + 1))) : []

    today_amount = week_amount = month_amount = year_amount = 0

    today.each{|item| today_amount += item.total}
    week.each{|item| week_amount += item.total}
    month.each{|item| month_amount += item.total}
    year.each{|item| year_amount += item.total}

    return StatisticsSection.new("$ amount of items added to registry", today_amount, week_amount, month_amount, year_amount, true)
  end

  def self.get_orders(date, full)
    orders = Order.where(:IsDeleted => false)

    name = 'Orders Placed'

    today = Order.where(:IsDeleted => false, :created_at => (date.today..(date.today + 1))).count
    week = Order.where(:IsDeleted => false, :created_at => (date.week..(date.today + 1))).count
    month = Order.where(:IsDeleted => false, :created_at => (date.month..(date.today + 1))).count
    year = full ? Order.where(:IsDeleted => false, :created_at => (date.year..(date.today + 1))).count : 0

    return StatisticsSection.new(name, today, week, month, year, 0)
  end

  def self.get_amount_to_registry(date, full)

    name = '$ amount contributed towards registry items'
    today = Contribute.where(:created_at => (date.today..(date.today + 1))).sum(:Contribute)
    week = Contribute.where(:created_at => (date.week..(date.today + 1))).sum(:Contribute)
    month = Contribute.where(:created_at => (date.month..(date.today + 1))).sum(:Contribute)
    year = full ? Contribute.where(:created_at => (date.year..(date.today + 1))).sum(:Contribute) : 0

    return StatisticsSection.new(name, today, week, month, year, 1)
  end

  def self.get_network_additions(date, full)

    name = '"In network" gifts added to registry'

    today = RegistryItem.joins(:product).where(:IsDeleted => false, :created_at => (date.today..(date.today + 1)), :product => {:Registrant_ID => nil}).count
    week = RegistryItem.joins(:product).where(:IsDeleted => false, :created_at => (date.week..(date.today + 1)), :product => {:Registrant_ID => nil}).count
    month = RegistryItem.joins(:product).where(:IsDeleted => false, :created_at => (date.month..(date.today + 1)), :product => {:Registrant_ID => nil}).count
    year = full ? RegistryItem.joins(:product).where(:IsDeleted => false, :created_at => (date.year..(date.today + 1)), :product => {:Registrant_ID => nil}).count : 0

    return StatisticsSection.new(name, today, week, month, year, 0)
  end

  def self.get_add_own(date, full)
    name = '"Add your own" gifts added to registry'

    today = RegistryItem.joins(:product).where(:IsDeleted => false, :IsToolbar => false, :created_at => (date.today..(date.today + 1))).where("products.Registrant_ID IS NOT NULL").count
    week = RegistryItem.joins(:product).where(:IsDeleted => false, :IsToolbar => false, :created_at => (date.week..(date.today + 1))).where("products.Registrant_ID IS NOT NULL").count
    month = RegistryItem.joins(:product).where(:IsDeleted => false, :IsToolbar => false, :created_at => (date.month..(date.today + 1))).where("products.Registrant_ID IS NOT NULL").count
    year = full ? RegistryItem.joins(:product).where(:IsDeleted => false, :IsToolbar => false, :created_at => (date.year..(date.today + 1))).where("products.Registrant_ID IS NOT NULL").count : 0

    return StatisticsSection.new(name, today, week, month, year, 0)
  end

  def self.get_out_of_network(date, full)

    name = '"Add from other site" gifts added to registry'

    today = RegistryItem.where(:IsDeleted => false, :created_at => (date.today..(date.today + 1)), :IsToolbar => true).count
    week = RegistryItem.where(:IsDeleted => false, :created_at => (date.week..(date.today + 1)), :IsToolbar => true).count
    month = RegistryItem.where(:IsDeleted => false, :created_at => (date.month..(date.today + 1)), :IsToolbar => true).count
    year = full ? RegistryItem.where(:IsDeleted => false, :created_at => (date.year..(date.today + 1)), :IsToolbar => true).count : 0

    return StatisticsSection.new(name, today, week, month, year, 0)
  end

  def self.get_from_network_orders(date, full)

    name = 'Knack Fee from network orders'

    today = 0
    tmp = Order.where(:IsDeleted => false, :PaymentMethod_ID => Typepayment::TYPES.invert['Buy'], :created_at => (date.today..(date.today + 1)))

    tmp.each do |t|
      today += t.get_knack_fee_network.to_f
    end

    week = 0
    tmp = Order.where(:IsDeleted => false, :PaymentMethod_ID => Typepayment::TYPES.invert['Buy'], :created_at => (date.week..(date.today + 1)))

    tmp.each do |t|
      week += t.get_knack_fee_network.to_f
    end

    month = 0
    tmp = Order.where(:IsDeleted => false, :PaymentMethod_ID => Typepayment::TYPES.invert['Buy'], :created_at => (date.month..(date.today + 1)))

    tmp.each do |t|
      month += t.get_knack_fee_network.to_f
    end

    year = 0
    if full
      tmp = Order.where(:IsDeleted => false, :PaymentMethod_ID => Typepayment::TYPES.invert['Buy'], :created_at => (date.year..(date.today + 1)))

      tmp.each do |t|
        year += t.get_knack_fee_network.to_f
      end
    end
    return StatisticsSection.new(name, today, week, month, year, 1)
  end

  def self.get_own_networks(date, full)

    name = 'Knack fee from withdrawls of cash items'

    today = Withdrawal.where(:IsDeleted => false,:created_at => (date.today..(date.today + 1))).where("registry_item_id IS NOT NULL").sum(:Tax)
    week = Withdrawal.where(:IsDeleted => false,:created_at => (date.week..(date.today + 1))).where("registry_item_id IS NOT NULL").sum(:Tax)
    month = Withdrawal.where(:IsDeleted => false,:created_at => (date.month..(date.today + 1))).where("registry_item_id IS NOT NULL").sum(:Tax)
    year = full ? Withdrawal.where(:IsDeleted => false,:created_at => (date.year..(date.today + 1))).where("registry_item_id IS NOT NULL").sum(:Tax) : 0

    return StatisticsSection.new(name, today, week, month, year, 1)
  end

  def self.get_from_cash(date, full)

    name = 'Knack fee from withdrawls of catalog items'

    today = Withdrawal.where(:IsDeleted => false, :registry_item_id => nil, :created_at => (date.today..(date.today + 1))).sum(:Tax)
    week = Withdrawal.where(:IsDeleted => false, :registry_item_id => nil, :created_at => (date.week..(date.today + 1))).sum(:Tax)
    month = Withdrawal.where(:IsDeleted => false, :registry_item_id => nil, :created_at => (date.month..(date.today + 1))).sum(:Tax)
    year = full ? Withdrawal.where(:IsDeleted => false, :registry_item_id => nil, :created_at => (date.year..(date.today + 1))).sum(:Tax) : 0
    return StatisticsSection.new(name, today, week, month, year, 1)
  end
end

class DateUtilites
  attr_accessor :today
  attr_accessor :week
  attr_accessor :month
  attr_accessor :year

  def initialize(date)
    self.today = date.to_date
    self.week = self.today - 7
    self.month = self.today - 30
    self.year = self.today - 365
  end
end

class StatisticsSection
  attr_accessor :name
  attr_accessor :today
  attr_accessor :week
  attr_accessor :month
  attr_accessor :year
  attr_accessor :type

  def initialize(name, today, week, month, year, type)
    self.name = name
    self.today = today
    self.week = week
    self.month = month
    self.year = year
    self.type = type
  end
end
