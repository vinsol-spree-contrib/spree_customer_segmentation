module Spree
  module CustomerSegmentation
    module Postgres
      class Order::TotalNumberOfOrderFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'total_number_of_order_gteq' },
          gt:      { method: 'custom', logic: 'total_number_of_order_gt' },
          between: { method: 'custom', logic: 'total_number_of_order_between' },
          eq:      { method: 'custom', logic: 'total_number_of_order_eq' },
          not_eq:  { method: 'custom', logic: 'total_number_of_order_not_eq' },
          lt_eq:   { method: 'custom', logic: 'total_number_of_order_lteq' },
          lt:      { method: 'custom', logic: 'total_number_of_order_lt' }
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
          user_collection.with_complete_orders.
                      select("spree_users.id, #{select_query} as order_count").
                      group('spree_users.id').distinct
        end

        def total_number_of_order_gteq
          query.having("#{select_query} >= ?", values)
        end

        def total_number_of_order_gt
          query.having("#{select_query} > ?", values)
        end

        def total_number_of_order_lt
          query.having("#{select_query} < ?", values)
        end

        def total_number_of_order_lteq
          query.having("#{select_query} <= ?", values)
        end

        def total_number_of_order_eq
          if values == "0"
            user_collection.without_complete_orders
          else
            query.having("#{select_query} = ?", values)
          end
        end

        def total_number_of_order_not_eq
          query.having("#{select_query} != ?", values)
        end

        def total_number_of_order_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("#{select_query} >= ? AND #{select_query} <= ?", values[0], values[1])
        end

        def select_query
          "COUNT(spree_orders.user_id)"
        end

      end
    end
  end
end
