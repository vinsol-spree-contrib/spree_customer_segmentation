module Spree
  module  CustomerSegmentation
    class Cart::DaysFromCartCreatedFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq: { method: 'custom', logic: 'days_from_cart_created_gteq' },
        gt: { method: 'custom', logic: 'days_from_cart_created_eq' },
        between: { method: 'custom', logic: 'days_from_cart_created_between' },
        eq: { method: 'custom', logic: 'days_from_cart_created_eq' },
        not_eq: { method: 'custom', logic: 'days_from_cart_created_not_eq' },
        lt_eq: { method: 'custom', logic: 'days_from_cart_created_lteq' },
        lt: { method: 'custom', logic: 'days_from_cart_created_lt' },
        blank: { method: 'custom', logic: 'days_from_cart_created_blank' }
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
        @required_date = Date.today - values.to_i

        collection.with_incomplete_orders.
                    select("spree_users.*, DATE(MIN(spree_orders.created_at)) as cart_created_date").
                    group('spree_orders.user_id')
      end

      def days_from_cart_created_gteq
        query.having("cart_created_date <= ?", @required_date)
      end

      def days_from_cart_created_gt
        query.having("cart_created_date < ?", @required_date)
      end

      def days_from_cart_created_lt
        query.having("cart_created_date > ?", @required_date)
      end

      def days_from_cart_created_lteq
        query.having("cart_created_date >= ?", @required_date)
      end

      def days_from_cart_created_eq
        query.having("cart_created_date = ?", @required_date)
      end

      def days_from_cart_created_not_eq
        query.having("cart_created_date != ?", @required_date)
      end

      def days_from_cart_created_between
        first_date = Date.today - values[0].to_i
        second_date = Date.today - values[1].to_i

        query.having("cart_created_date >= ? AND cart_created_date <= ?", second_date, first_date)
      end

      def days_from_cart_created_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? collection.without_incomplete_orders : collection.with_incomplete_orders
      end

    end
  end
end
