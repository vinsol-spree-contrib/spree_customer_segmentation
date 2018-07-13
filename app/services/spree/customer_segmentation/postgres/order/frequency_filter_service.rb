module Spree
  module CustomerSegmentation
    module Postgres
      class Order::FrequencyFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'order_frequency_gteq' },
          gt:      { method: 'custom', logic: 'order_frequency_gt' },
          between: { method: 'custom', logic: 'order_frequency_between' },
          eq:      { method: 'custom', logic: 'order_frequency_eq' },
          not_eq:  { method: 'custom', logic: 'order_frequency_not_eq' },
          lt_eq:   { method: 'custom', logic: 'order_frequency_lteq' },
          lt:      { method: 'custom', logic: 'order_frequency_lt' }
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
                      select("spree_users.id, #{select_query} as order_frequency").
                      group('spree_users.id').distinct
        end

        def order_frequency_gteq
          query.having("#{select_query} >= ?", values)
        end

        def order_frequency_gt
          query.having("#{select_query} > ?", values)
        end

        def order_frequency_lt
          query.having("#{select_query} < ?", values)
        end

        def order_frequency_lteq
          query.having("#{select_query} <= ?", values)
        end

        def order_frequency_eq
          if values == "0"
            user_collection.without_complete_orders
          else
            query.having("#{select_query} = ?", values)
          end
        end

        def order_frequency_not_eq
          query.having("#{select_query} != ?", values)
        end

        def order_frequency_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("#{select_query} >= ? AND #{select_query} <= ?", values[0], values[1])
        end

        def current_date
          current_utc_time.to_date
        end

        def select_query
          "(COUNT(spree_orders.user_id)*30)/(('#{current_date}' - MIN(spree_users.created_at::date)) + 1)"
        end

      end
    end
  end
end
