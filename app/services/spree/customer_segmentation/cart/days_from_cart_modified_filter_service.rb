module Spree
  module  CustomerSegmentation
    class Cart::DaysFromCartModifiedFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'days_from_cart_modified_gteq' },
        gt:      { method: 'custom', logic: 'days_from_cart_modified_gt' },
        between: { method: 'custom', logic: 'days_from_cart_modified_between' },
        eq:      { method: 'custom', logic: 'days_from_cart_modified_eq' },
        not_eq:  { method: 'custom', logic: 'days_from_cart_modified_not_eq' },
        lt_eq:   { method: 'custom', logic: 'days_from_cart_modified_lteq' },
        lt:      { method: 'custom', logic: 'days_from_cart_modified_lt' },
        blank:   { method: 'custom', logic: 'days_from_cart_modified_blank' }
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
        user_collection.with_incomplete_order.
                    select("spree_users.*, DATE(MAX(spree_orders.updated_at)) as cart_modified_date").
                    group('spree_orders.user_id')
      end

      def days_from_cart_modified_gteq
        query.having("cart_modified_date <= ?", required_date)
      end

      def days_from_cart_modified_gt
        query.having("cart_modified_date < ?", required_date)
      end

      def days_from_cart_modified_lt
        query.having("cart_modified_date > ?", required_date)
      end

      def days_from_cart_modified_lteq
        query.having("cart_modified_date >= ?", required_date)
      end

      def days_from_cart_modified_eq
        query.having("cart_modified_date = ?", required_date)
      end

      def days_from_cart_modified_not_eq
        query.having("cart_modified_date != ?", required_date)
      end

      def days_from_cart_modified_between
        first_date = (Time.current.utc - values[0].to_i.days).to_date
        second_date = (Time.current.utc - values[1].to_i.days).to_date

        query.having("cart_modified_date >= ? AND cart_modified_date <= ?", second_date, first_date)
      end

      def days_from_cart_modified_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.without_incomplete_order : user_collection.with_incomplete_order
      end

      def required_date
        (Time.current.utc - values.to_i.days).to_date
      end

    end
  end
end
