module Spree
  module CustomerSegmentation
    module Postgres

      class Order::DaysFromFirstOrderFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'days_from_first_order_gteq' },
          gt:      { method: 'custom', logic: 'days_from_first_order_gt' },
          between: { method: 'custom', logic: 'days_from_first_order_between' },
          eq:      { method: 'custom', logic: 'days_from_first_order_eq' },
          not_eq:  { method: 'custom', logic: 'days_from_first_order_not_eq' },
          lt_eq:   { method: 'custom', logic: 'days_from_first_order_lteq' },
          lt:      { method: 'custom', logic: 'days_from_first_order_lt' },
          blank:   { method: 'custom', logic: 'days_from_first_order_blank' }
        }

        def initialize(user_collection, operator, values)
          @operator = operator
          @values = values
          super(user_collection)
        end

        def filter_data
          perform
        end

        def dynamic_column
          unless operator == "blank"
            { first_order_date: 'First Order Date' }
          end
        end

        def query
          user_collection.with_complete_orders.
                      group('spree_users.id').
                      select("spree_users.*, DATE(MIN(spree_orders.completed_at)) as first_order_date").
                      group('spree_orders.user_id').distinct
        end

        def days_from_first_order_gteq
          query.having("DATE(MIN(spree_orders.completed_at)) <= ?", required_date)
        end

        def days_from_first_order_gt
          query.having("DATE(MIN(spree_orders.completed_at)) < ?", required_date)
        end

        def days_from_first_order_lt
          query.having("DATE(MIN(spree_orders.completed_at)) > ?", required_date)
        end

        def days_from_first_order_lteq
          query.having("DATE(MIN(spree_orders.completed_at)) >= ?", required_date)
        end

        def days_from_first_order_eq
          query.having("DATE(MIN(spree_orders.completed_at)) = ?", required_date)
        end

        def days_from_first_order_not_eq
          query.having("DATE(MIN(spree_orders.completed_at)) != ?", required_date)
        end

        def days_from_first_order_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          first_date  = (current_utc_time - values[0].to_i.days).to_date
          second_date = (current_utc_time - values[1].to_i.days).to_date

          query.having("DATE(MIN(spree_orders.completed_at)) >= ? AND DATE(MIN(spree_orders.completed_at)) <= ?", second_date, first_date)
        end

        def days_from_first_order_blank
          values ? user_collection.without_complete_orders : user_collection.with_complete_orders
        end

        def required_date
          required_date = (current_utc_time - values.to_i.days).to_date
        end

      end
    end
  end
end