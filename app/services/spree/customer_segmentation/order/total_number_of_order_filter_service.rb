module Spree
  module  CustomerSegmentation
    class Order::TotalNumberOfOrderFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq: { method: 'custom', logic: 'total_number_of_order_gteq' },
        gt: { method: 'custom', logic: 'total_number_of_order_eq' },
        between: { method: 'custom', logic: 'total_number_of_order_between' },
        eq: { method: 'custom', logic: 'total_number_of_order_eq' },
        not_eq: { method: 'custom', logic: 'total_number_of_order_not_eq' },
        lt_eq: { method: 'custom', logic: 'total_number_of_order_lteq' },
        lt: { method: 'custom', logic: 'total_number_of_order_lt' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def query
        collection.with_complete_orders.
                    select('spree_users.*, COUNT(spree_orders.user_id) as order_count').
                    group('spree_orders.user_id')
      end

      def total_number_of_order_gteq
        query.having("order_count >= ?", values)
      end

      def total_number_of_order_gt
        query.having("order_count > ?", values)
      end

      def total_number_of_order_lt
        query.having("order_count < ?", values)
      end

      def total_number_of_order_lteq
        query.having("order_count <= ?", values)
      end

      def total_number_of_order_eq
        query.having("order_count = ?", values)
      end

      def total_number_of_order_not_eq
        query.having("order_count != ?", values)
      end

      def total_number_of_order_between
        query.having("order_count >= ? AND order_count <= ?", values[0], values[1])
      end

    end
  end
end
