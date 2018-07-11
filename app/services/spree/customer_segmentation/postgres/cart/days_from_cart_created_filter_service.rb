module Spree
  module CustomerSegmentation
    module Postgres
      class Cart::DaysFromCartCreatedFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'days_from_cart_created_gteq' },
          gt:      { method: 'custom', logic: 'days_from_cart_created_gt' },
          between: { method: 'custom', logic: 'days_from_cart_created_between' },
          eq:      { method: 'custom', logic: 'days_from_cart_created_eq' },
          not_eq:  { method: 'custom', logic: 'days_from_cart_created_not_eq' },
          lt_eq:   { method: 'custom', logic: 'days_from_cart_created_lteq' },
          lt:      { method: 'custom', logic: 'days_from_cart_created_lt' },
          blank:   { method: 'custom', logic: 'days_from_cart_created_blank' }
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
          { cart_created_date: 'Cart Creation Date' }
        end

        def query
          user_collection.with_items_in_cart.
                      group('spree_users.id').
                      select("spree_users.*, DATE(MIN(spree_orders.created_at)) as cart_created_date").
                      group('spree_orders.user_id').distinct
        end

        def days_from_cart_created_gteq
          query.having("DATE(MIN(spree_orders.created_at)) <= ?", required_date)
        end

        def days_from_cart_created_gt
          query.having("DATE(MIN(spree_orders.created_at)) < ?", required_date)
        end

        def days_from_cart_created_lt
          query.having("DATE(MIN(spree_orders.created_at)) > ?", required_date)
        end

        def days_from_cart_created_lteq
          query.having("DATE(MIN(spree_orders.created_at)) >= ?", required_date)
        end

        def days_from_cart_created_eq
          query.having("DATE(MIN(spree_orders.created_at)) = ?", required_date)
        end

        def days_from_cart_created_not_eq
          query.having("DATE(MIN(spree_orders.created_at)) != ?", required_date)
        end

        def days_from_cart_created_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          first_date  = (current_utc_time - values[0].to_i.days).to_date
          second_date = (current_utc_time - values[1].to_i.days).to_date

          query.having("DATE(MIN(spree_orders.created_at)) >= ? AND DATE(MIN(spree_orders.created_at)) <= ?", second_date, first_date)
        end

        def days_from_cart_created_blank
          values ? user_collection.without_items_in_cart : user_collection.with_items_in_cart
        end

        def required_date
          (current_utc_time - values.to_i.days).to_date
        end

      end
    end
  end
end
