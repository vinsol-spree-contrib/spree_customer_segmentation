module Spree
  module CustomerSegmentation
    module Postgres
      class Order::DaysFromLastOrderFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'days_from_last_order_gteq' },
          gt:      { method: 'custom', logic: 'days_from_last_order_gt' },
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
          user_collection.with_complete_orders.
                      select("spree_users.id, #{select_query} as last_order_date").
                      group('spree_users.id').distinct
        end

        def days_from_last_order_gteq
          query.having("#{select_query} <= ?", required_date)
        end

        def days_from_last_order_gt
          query.having("#{select_query} < ?", required_date)
        end

        def days_from_last_order_lt
          query.having("#{select_query} > ?", required_date)
        end

        def days_from_last_order_lteq
          query.having("#{select_query} >= ?", required_date)
        end

        def days_from_last_order_eq
          query.having("#{select_query} = ?", required_date)
        end

        def days_from_last_order_not_eq
          query.having("#{select_query} != ?", required_date)
        end

        def days_from_last_order_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          first_date  = (current_utc_time - values[0].to_i.days).to_date
          second_date = (current_utc_time - values[1].to_i.days).to_date

          query.having("#{select_query} >= ? AND #{select_query} <= ?", second_date, first_date)
        end

        def days_from_last_order_blank
          values ? user_collection.without_complete_orders : user_collection.with_complete_orders
        end

        def required_date
          (current_utc_time - values.to_i.days).to_date
        end

        def select_query
          "DATE(MAX(spree_orders.completed_at))"
        end
      end
    end
  end
end
