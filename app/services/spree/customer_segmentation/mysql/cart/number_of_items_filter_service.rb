module Spree
  module CustomerSegmentation
    module Mysql
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

        def query
          user_collection.with_items_in_cart.
                      select('spree_users.id, SUM(spree_line_items.quantity) as number_of_items_in_cart').
                      group('spree_users.id').distinct
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
          if values == "0"
            user_collection.without_items_in_cart
          else
            query.having("number_of_items_in_cart = ?", values)
          end
        end

        def number_of_items_in_cart_not_eq
          query.having("number_of_items_in_cart != ?", values)
        end

        def number_of_items_in_cart_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("number_of_items_in_cart >= ? AND number_of_items_in_cart <= ?", values[0], values[1])
        end

      end
    end
  end
end
