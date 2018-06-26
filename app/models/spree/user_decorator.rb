Spree::User.class_eval do

  delegate :full_name, :address, :phone, to: :bill_address, allow_nil: true

  # scope :without_orders, -> { includes(:orders).where(spree_orders: {user_id: nil}) }
  scope :with_complete_orders, -> { joins(:orders).merge(Spree::Order.complete) }
  scope :without_complete_orders, -> { where.not(id: with_complete_orders.pluck(:id)) }

  self.whitelisted_ransackable_associations += %w(orders)

end
