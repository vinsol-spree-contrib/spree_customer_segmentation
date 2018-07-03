module Spree
  module CustomerSegmentation
    class Cart::NumberOfItemsFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'number_of_items_in_cart_gteq' },
        gt:      { method: 'custom', logic: 'number_of_items_in_cart_gt' },
        between: { method: 'custom', logic: 'number_of_items_in_cart_between' },
        eq:      { method: 'custom', logic: 'number_of_items_in_cart_eq' },
        not_eq:  { method: 'custom', logic: 'number_of_items_in_cart_not_eq' },
        lt_eq:   { method: 'custom', logic: 'number_of_items_in_cart_lteq' },
        lt:      { method: 'custom', logic: 'number_of_items_in_cart_lt' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values   = values
        super(collection)
      end

      def filter_data
        perform
      end

      def query
        user_collection.with_unordered_line_items.
                    select('spree_users.*, SUM(spree_line_items.quantity) as number_of_items_in_cart').
                    group('spree_orders.user_id').distinct
      end

      def number_of_items_in_cart_gteq
        query.having("number_of_items_in_cart >= ?", values)
      end

      def number_of_items_in_cart_gt
        query.having("number_of_items_in_cart > ?", values)
      end

      def number_of_items_in_cart_lt
        query.having("number_of_items_in_cart < ?", values)
      end

      def number_of_items_in_cart_lteq
        query.having("number_of_items_in_cart <= ?", values)
      end

      def number_of_items_in_cart_eq
        query.having("number_of_items_in_cart = ?", values)
      end

      def number_of_items_in_cart_not_eq
        query.having("number_of_items_in_cart != ?", values)
      end

      def number_of_items_in_cart_between
        return ::Spree::User.none if (values[0].blank? || values[1].blank?)
        
        query.having("number_of_items_in_cart >= ? AND number_of_items_in_cart <= ?", values[0], values[1])
      end

    end
  end
end
