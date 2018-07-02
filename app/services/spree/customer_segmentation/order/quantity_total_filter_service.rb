module Spree
  module CustomerSegmentation
    class Order::QuantityTotalFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'total_quantity_gteq' },
        gt:      { method: 'custom', logic: 'total_quantity_eq' },
        between: { method: 'custom', logic: 'total_quantity_between' },
        eq:      { method: 'custom', logic: 'total_quantity_eq' },
        not_eq:  { method: 'custom', logic: 'total_quantity_not_eq' },
        lt_eq:   { method: 'custom', logic: 'total_quantity_lteq' },
        lt:      { method: 'custom', logic: 'total_quantity_lt' }
      }

      def initialize(user_collection, operator, values)
        @operator = operator
        @values = values
        super(user_collection)
      end

      def filter_data
        perform
      end

      def query
        user_collection.joins(orders: :line_items).
                   merge(Spree::Order.complete).
                   select('spree_users.*, SUM(spree_line_items.quantity) as total_quantity').
                   group('spree_orders.user_id').distinct
      end

      def total_quantity_gteq
        query.having("total_quantity >= ?", values)
      end

      def total_quantity_gt
        query.having("total_quantity > ?", values)
      end

      def total_quantity_lt
        query.having("total_quantity < ?", values)
      end

      def total_quantity_lteq
        query.having("total_quantity <= ?", values)
      end

      def total_quantity_eq
        if values.to_i == 0
          user_collection.without_complete_orders
        else
          query.having("total_quantity = ?", values)
        end
      end

      def total_quantity_not_eq
        query.having("total_quantity != ?", values)
      end

      def total_quantity_between
        query.having("total_quantity >= ? AND total_quantity <= ?", values[0], values[1])
      end

    end
  end
end
