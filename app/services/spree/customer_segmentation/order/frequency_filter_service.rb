module Spree
  module  CustomerSegmentation
    class Order::FrequencyFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq: { method: 'custom', logic: 'order_frequency_gteq' },
        gt: { method: 'custom', logic: 'order_frequency_eq' },
        between: { method: 'custom', logic: 'order_frequency_between' },
        eq: { method: 'custom', logic: 'order_frequency_eq' },
        not_eq: { method: 'custom', logic: 'order_frequency_not_eq' },
        lt_eq: { method: 'custom', logic: 'order_frequency_lteq' },
        lt: { method: 'custom', logic: 'order_frequency_lt' }
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
                    select("(COUNT(spree_orders.user_id)*30)/(DATEDIFF('#{Date.current}', spree_users.created_at)) as order_frequency")
                    group('spree_orders.user_id')
      end

      def order_frequency_gteq
        query.having("order_frequency >= ?", values)
      end

      def order_frequency_gt
        query.having("order_frequency > ?", values)
      end

      def order_frequency_lt
        query.having("order_frequency < ?", values)
      end

      def order_frequency_lteq
        query.having("order_frequency <= ?", values)
      end

      def order_frequency_eq
        query.having("order_frequency = ?", values)
      end

      def order_frequency_not_eq
        query.having("order_frequency != ?", values)
      end

      def order_frequency_between
        query.having("order_frequency >= ? AND order_frequency <= ?", values[0], values[1])
      end

    end
  end
end
