module Spree
  module CustomerSegmentation
    module Postgres
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
          @values = values
          super(collection)
        end

        def filter_data
          perform
        end

        def dynamic_column
          unless operator == "eq" && values == "0"
            { number_of_items_in_cart: 'Number Of Items In Cart' }
          end
        end

        def query
          user_collection.with_items_in_cart.
                      group('spree_users.id').
                      select('spree_users.*, SUM(spree_line_items.quantity) as number_of_items_in_cart').
                      group('spree_orders.user_id').distinct
        end

        def number_of_items_in_cart_gteq
          query.having("SUM(spree_line_items.quantity) >= ?", values)
        end

        def number_of_items_in_cart_gt
          query.having("SUM(spree_line_items.quantity) > ?", values)
        end

        def number_of_items_in_cart_lt
          query.having("SUM(spree_line_items.quantity) < ?", values)
        end

        def number_of_items_in_cart_lteq
          query.having("SUM(spree_line_items.quantity) <= ?", values)
        end

        def number_of_items_in_cart_eq
          if values == "0"
            user_collection.without_items_in_cart
          else
            query.having("SUM(spree_line_items.quantity) = ?", values)
          end
        end

        def number_of_items_in_cart_not_eq
          query.having("SUM(spree_line_items.quantity) != ?", values)
        end

        def number_of_items_in_cart_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("SUM(spree_line_items.quantity) >= ? AND SUM(spree_line_items.quantity) <= ?", values[0], values[1])
        end

      end
    end
  end
end
