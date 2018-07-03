module Spree
  module UserScopes
    extend ActiveSupport::Concern

    included do
      scope :with_complete_orders,    -> { joins(:orders).merge(Spree::Order.complete).distinct }
      scope :without_complete_orders, -> { where.not(id: with_complete_orders.pluck(:id)) }
      scope :with_items_in_cart,      -> { joins(orders: :line_items).where(spree_orders: { completed_at: nil }).distinct }
      scope :without_items_in_cart,   -> { where.not(id: with_items_in_cart.pluck(:id)) }
      scope :with_ordered_items,      -> { joins(orders: :line_items).merge(Spree::Order.complete).distinct }
      scope :with_unordered_line_items, -> { joins(orders: :line_items).where(spree_orders: { completed_at: nil }) }
      scope :used_a_coupon,             -> { joins(orders: :order_promotions).merge(Spree::Order.complete).distinct }
      scope :not_used_a_coupon,         -> { where.not(id: used_a_coupon.pluck(:id)) }
    end

  end
end
