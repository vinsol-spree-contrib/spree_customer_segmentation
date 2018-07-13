module Spree
  module CustomerSegmentation
    module Postgres
      class Order::QuantityTotalFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'total_quantity_gteq' },
          gt:      { method: 'custom', logic: 'total_quantity_gt' },
          between: { method: 'custom', logic: 'total_quantity_between' },
          eq:      { method: 'custom', logic: 'total_quantity_eq' },
          not_eq:  { method: 'custom', logic: 'total_quantity_not_eq' },
          lt_eq:   { method: 'custom', logic: 'total_quantity_lteq' },
          lt:      { method: 'custom', logic: 'total_quantity_lt' }
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
          user_collection.with_ordered_items.
                     select("spree_users.id, #{select_query} as total_quantity").
                     group('spree_users.id').distinct
        end

        def total_quantity_gteq
          query.having("#{select_query} >= ?", values)
        end

        def total_quantity_gt
          query.having("#{select_query} > ?", values)
        end

        def total_quantity_lt
          query.having("#{select_query} < ?", values)
        end

        def total_quantity_lteq
          query.having("#{select_query} <= ?", values)
        end

        def total_quantity_eq
          if values == "0"
            user_collection.without_complete_orders
          else
            query.having("#{select_query} = ?", values)
          end
        end

        def total_quantity_not_eq
          query.having("#{select_query} != ?", values)
        end

        def total_quantity_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("#{select_query} >= ? AND #{select_query} <= ?", values[0], values[1])
        end

        def select_query
          "SUM(spree_line_items.quantity)"
        end

      end
    end
  end
end
