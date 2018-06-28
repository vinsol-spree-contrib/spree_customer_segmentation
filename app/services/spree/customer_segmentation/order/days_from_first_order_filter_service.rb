module Spree
  module CustomerSegmentation
    class Order::DaysFromFirstOrderFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq: { method: 'custom', logic: 'days_from_first_order_gteq' },
        gt: { method: 'custom', logic: 'days_from_first_order_eq' },
        between: { method: 'custom', logic: 'days_from_first_order_between' },
        eq: { method: 'custom', logic: 'days_from_first_order_eq' },
        not_eq: { method: 'custom', logic: 'days_from_first_order_not_eq' },
        lt_eq: { method: 'custom', logic: 'days_from_first_order_lteq' },
        lt: { method: 'custom', logic: 'days_from_first_order_lt' },
        blank: { method: 'custom', logic: 'days_from_first_order_blank' }
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
        @required_date = Date.today - values.to_i

        user_collection.with_complete_orders.
                    select("spree_users.*, DATE(MIN(spree_orders.completed_at)) as first_order_date").
                    group('spree_orders.user_id')
      end

      def days_from_first_order_gteq
        query.having("first_order_date <= ?", @required_date)
      end

      def days_from_first_order_gt
        query.having("first_order_date < ?", @required_date)
      end

      def days_from_first_order_lt
        query.having("first_order_date > ?", @required_date)
      end

      def days_from_first_order_lteq
        query.having("first_order_date >= ?", @required_date)
      end

      def days_from_first_order_eq
        query.having("first_order_date = ?", @required_date)
      end

      def days_from_first_order_not_eq
        query.having("first_order_date != ?", @required_date)
      end

      def days_from_first_order_between
        first_date = Date.today - values[0].to_i
        second_date = Date.today - values[1].to_i

        query.having("first_order_date >= ? AND first_order_date <= ?", second_date, first_date)
      end

      def days_from_first_order_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.without_complete_orders : user_collection.with_complete_orders
      end

    end
  end
end
