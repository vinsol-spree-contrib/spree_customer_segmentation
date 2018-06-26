module Spree
  module  CustomerSegmentation
    class Order::RevenueFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq: { method: 'custom', logic: 'revenue_gteq' },
        gt: { method: 'custom', logic: 'revenue_eq' },
        between: { method: 'custom', logic: 'revenue_between' },
        eq: { method: 'custom', logic: 'revenue_eq' },
        not_eq: { method: 'custom', logic: 'revenue_not_eq' },
        lt_eq: { method: 'custom', logic: 'revenue_lteq' },
        lt: { method: 'custom', logic: 'revenue_lt' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def query(operator)
        Spree::User.with_complete_orders.
                    select('spree_users.*, SUM(spree_orders.total) as revenue').
                    group('spree_orders.user_id')
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
        query.having("revenue = ?", values)
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
