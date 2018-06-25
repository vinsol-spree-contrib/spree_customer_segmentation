Spree::User.class_eval do

  # scope :orders_revenue, -> { joins(:orders).merge(Spree::Order.revenue) }
  #
  # self.whitelisted_ransackable_scopes = %w(orders_revenue)

  delegate :full_name, :address, :phone, to: :bill_address, allow_nil: true


  self.whitelisted_ransackable_associations += %w(orders)

end
