module Spree
  module CustomerSegmentation
    module Postgres
      class Order::RevenueFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'revenue_gteq' },
          gt:      { method: 'custom', logic: 'revenue_gt' },
          between: { method: 'custom', logic: 'revenue_between' },
          eq:      { method: 'custom', logic: 'revenue_eq' },
          not_eq:  { method: 'custom', logic: 'revenue_not_eq' },
          lt_eq:   { method: 'custom', logic: 'revenue_lteq' },
          lt:      { method: 'custom', logic: 'revenue_lt' }
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
          unless operator == "eq" && values == "0"
            { revenue: 'Revenue' }
          end
        end

        def query
          user_collection.with_complete_orders.
                      group('spree_users.id').
                      select('spree_users.*, SUM(spree_orders.total) as revenue').
                      group('spree_orders.user_id').distinct
        end

        def revenue_gteq
          query.having("SUM(spree_orders.total) >= ?", values)
        end

        def revenue_gt
          query.having("SUM(spree_orders.total) > ?", values)
        end

        def revenue_lt
          query.having("SUM(spree_orders.total) < ?", values)
        end

        def revenue_lteq
          query.having("SUM(spree_orders.total) <= ?", values)
        end

        def revenue_eq
          if values == "0"
            user_collection.without_complete_orders
          else
            query.having("SUM(spree_orders.total) = ?", values)
          end
        end

        def revenue_not_eq
          query.having("SUM(spree_orders.total) != ?", values)
        end

        def revenue_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          query.having("SUM(spree_orders.total) >= ? AND SUM(spree_orders.total) <= ?", values[0], values[1])
        end

      end
    end
  end
end
