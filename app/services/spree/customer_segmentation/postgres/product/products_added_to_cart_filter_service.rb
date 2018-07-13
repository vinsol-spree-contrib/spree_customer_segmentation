module Spree
  module CustomerSegmentation
    module Postgres
      class Product::ProductsAddedToCartFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          includes:     { method: 'custom', logic: 'added_to_cart_includes' },
          not_includes: { method: 'custom', logic: 'added_to_cart_not_includes' },
          includes_all: { method: 'custom', logic: 'added_to_cart_includes_all' },
          blank:        { method: 'custom', logic: 'added_to_cart_blank' }
        }

        def initialize(collection, operator, values)
          @operator = operator
          @values = values
          super(collection)
        end

        def filter_data
          perform
        end

        def added_to_cart_includes
          user_collection.with_items_in_cart.where(spree_line_items: { variant_id: values }).distinct
        end

        def added_to_cart_not_includes
          user_collection.with_items_in_cart.where.not(id: added_to_cart_includes.pluck(:id))
        end

        def added_to_cart_includes_all
          user_collection.joins(orders: :line_items).
                          select(select_query).
                          where(spree_orders: { completed_at: nil }).
                          where(spree_line_items: { variant_id: values }).
                          group('spree_users.id').
                          having("string_agg(spree_line_items.variant_id::varchar, ',' ORDER BY spree_line_items.variant_id) = ?", sorted_variants).distinct
        end

        def added_to_cart_blank
          values ? user_collection.without_items_in_cart : user_collection.with_items_in_cart
        end

        def select_query
          "spree_users.id, string_agg(spree_line_items.variant_id::varchar, ',' ORDER BY spree_line_items.variant_id) as variants"
        end

        def sorted_variants
          values.map(&:to_i).sort.join(',')
        end

      end
    end
  end
end
