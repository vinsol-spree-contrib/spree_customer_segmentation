Spree::User.class_eval do

  INCOMPLETE_ORDER_STATES = [:cart, :address, :delivery, :payment, :confirm]

  delegate :firstname, :lastname, :full_address, :phone, to: :bill_address, allow_nil: true

  scope :with_complete_orders,     -> { joins(:orders).merge(Spree::Order.complete).distinct }
  scope :without_complete_orders,  -> { where.not(id: with_complete_orders.pluck(:id)) }
  scope :with_incomplete_order,    -> { joins(:orders).where(spree_orders: { state: INCOMPLETE_ORDER_STATES }) }
  scope :without_incomplete_order, -> { joins(:orders).where.not(id: with_incomplete_order.pluck(:id)) }

  self.whitelisted_ransackable_associations += %w(orders)

end
