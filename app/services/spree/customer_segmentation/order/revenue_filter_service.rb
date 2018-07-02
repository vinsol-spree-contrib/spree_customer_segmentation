module Spree
  module CustomerSegmentation
    class Order::RevenueFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'revenue_gteq' },
        gt:      { method: 'custom', logic: 'revenue_gt' },
        between: { method: 'custom', logic: 'revenue_between' },
        eq:      { method: 'custom', logic: 'revenue_eq' },
        not_eq:  { method: 'custom', logic: 'revenue_not_eq' },
        lt_eq:   { method: 'custom', logic: 'revenue_lteq' },
        lt:      { method: 'custom', logic: 'revenue_lt' }
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
        user_collection.with_complete_orders.
                    select('spree_users.*, SUM(spree_orders.total) as revenue').
                    group('spree_orders.user_id').distinct
      end

      def revenue_gteq
        query.having("revenue >= ?", values)
      end

      def revenue_gt
        query.having("revenue > ?", values)
      end

      def revenue_lt
        query.having("revenue < ?", values)
      end

      def revenue_lteq
        query.having("revenue <= ?", values)
      end

      def revenue_eq
        if values.to_i == 0
          user_collection.without_complete_orders
        else
          query.having("revenue = ?", values)
        end
      end

      def revenue_not_eq
        query.having("revenue != ?", values)
      end

      def revenue_between
        query.having("revenue >= ? AND revenue <= ?", values[0], values[1])
      end

    end
  end
end
