module Spree
  module UserScopes
    extend ActiveSupport::Concern

    included do
      scope :with_complete_orders,    -> { joins(:orders).merge(Spree::Order.complete).distinct }
      scope :without_complete_orders, -> { where.not(id: with_complete_orders.pluck(:id)) }
      scope :with_items_in_cart,      -> { joins(orders: :line_items).where(spree_orders: { completed_at: nil }).distinct }
      scope :without_items_in_cart,   -> { where.not(id: with_items_in_cart.pluck(:id)) }
      scope :with_ordered_items,      -> { joins(orders: :line_items).merge(Spree::Order.complete).distinct }
      scope :used_a_coupon,           -> { joins(orders: :order_promotions).merge(Spree::Order.complete).distinct }
      scope :not_used_a_coupon,       -> { where.not(id: used_a_coupon.pluck(:id)) }
      scope :with_bill_address,       -> { where.not(bill_address_id: nil) }
      scope :without_bill_address,    -> { where(bill_address_id: nil) }
      scope :with_ship_address,       -> { where.not(ship_address_id: nil) }
      scope :without_ship_address,    -> { where(ship_address_id: nil) }

      def self.with_recent_orders
        joins(orders: :line_items).where("spree_line_items.created_at > ?", time_seven_days_ago ).where(spree_orders: { state: 'complete' }).distinct
      end

      def self.without_recent_orders
        where.not(id: with_recent_product_orders.pluck(:id))
      end

      def self.with_recent_product_added_to_cart
        joins(orders: :line_items).where("spree_line_items.created_at > ?", time_seven_days_ago ).where(spree_orders: { completed_at: nil }).distinct
      end

      def self.without_recent_product_added_to_cart
        where.not(id: with_recent_product_added_to_cart.pluck(:id))
      end

      def self.with_new_product_orders
        joins(orders: [line_items: :product]).where("spree_products.created_at > ?", time_seven_days_ago).where(spree_orders: { state: 'complete' }).distinct
      end

      def self.without_new_product_orders
        where.not(id: with_new_product_orders.pluck(:id))
      end

      def self.with_new_product_added_to_cart
        joins(orders: [line_items: :product]).where("spree_products.created_at > ?", time_seven_days_ago).where(spree_orders: { completed_at: nil }).distinct
      end

      def self.without_new_product_orders
        where.not(id: with_new_product_added_to_cart.pluck(:id))
      end

      def self.time_seven_days_ago
        @time_seven_days_ago ||= Time.current.utc - 7.days
      end
    end

  end
end
