module Spree
  module CustomerSegmentation
    class Order::QuantityAverageFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'average_quantity_gteq' },
        gt:      { method: 'custom', logic: 'average_quantity_gt' },
        between: { method: 'custom', logic: 'average_quantity_between' },
        eq:      { method: 'custom', logic: 'average_quantity_eq' },
        not_eq:  { method: 'custom', logic: 'average_quantity_not_eq' },
        lt_eq:   { method: 'custom', logic: 'average_quantity_lteq' },
        lt:      { method: 'custom', logic: 'average_quantity_lt' }
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
                   select('spree_users.*, (SUM(spree_line_items.quantity)/COUNT(spree_orders.user_id)) as average_quantity').
                   group('spree_orders.user_id').distinct
      end

      def average_quantity_gteq
        query.having("average_quantity >= ?", values)
      end

      def average_quantity_gt
        query.having("average_quantity > ?", values)
      end

      def average_quantity_lt
        query.having("average_quantity < ?", values)
      end

      def average_quantity_lteq
        query.having("average_quantity <= ?", values)
      end

      def average_quantity_eq
        if values.to_i == 0
          user_collection.without_complete_orders
        else
          query.having("average_quantity = ?", values)
        end
      end

      def average_quantity_not_eq
        query.having("average_quantity != ?", values)
      end

      def average_quantity_between
        query.having("average_quantity >= ? AND average_quantity <= ?", values[0], values[1])
      end

    end
  end
end