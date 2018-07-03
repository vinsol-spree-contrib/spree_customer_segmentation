module Spree
  module UserScopes
    extend ActiveSupport::Concern

    included do
      scope :with_complete_orders,      -> { joins(:orders).merge(Spree::Order.complete).distinct }
      scope :without_complete_orders,   -> { where.not(id: with_complete_orders.pluck(:id)) }
      scope :with_incomplete_order,     -> { joins(:orders).where(spree_orders: { completed_at: nil }) }
      scope :without_incomplete_order,  -> { joins(:orders).where.not(id: with_incomplete_order.pluck(:id)) }
      scope :with_unordered_line_items, -> { joins(orders: :line_items).where(spree_orders: { completed_at: nil }) }
    end

  end
end
