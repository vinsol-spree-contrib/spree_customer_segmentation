module Spree
  module CustomerSegmentation
    class Order::DaysFromLastOrderFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'days_from_last_order_gteq' },
        gt:      { method: 'custom', logic: 'days_from_last_order_eq' },
        between: { method: 'custom', logic: 'days_from_last_order_between' },
        eq:      { method: 'custom', logic: 'days_from_last_order_eq' },
        not_eq:  { method: 'custom', logic: 'days_from_last_order_not_eq' },
        lt_eq:   { method: 'custom', logic: 'days_from_last_order_lteq' },
        lt:      { method: 'custom', logic: 'days_from_last_order_lt' },
        blank:   { method: 'custom', logic: 'days_from_last_order_blank' }
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
                    select("spree_users.*, DATE(MAX(spree_orders.completed_at)) as last_order_date").
                    group('spree_orders.user_id')
      end

      def days_from_last_order_gteq
        query.having("last_order_date <= ?", @required_date)
      end

      def days_from_last_order_gt
        query.having("last_order_date < ?", @required_date)
      end

      def days_from_last_order_lt
        query.having("last_order_date > ?", @required_date)
      end

      def days_from_last_order_lteq
        query.having("last_order_date >= ?", @required_date)
      end

      def days_from_last_order_eq
        query.having("last_order_date = ?", @required_date)
      end

      def days_from_last_order_not_eq
        query.having("last_order_date != ?", @required_date)
      end

      def days_from_last_order_between
        last_date = Date.today - values[0].to_i
        second_date = Date.today - values[1].to_i

        query.having("last_order_date >= ? AND last_order_date <= ?", second_date, last_date)
      end

      def days_from_last_order_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.without_complete_orders : user_collection.with_complete_orders
      end

    end
  end
end
