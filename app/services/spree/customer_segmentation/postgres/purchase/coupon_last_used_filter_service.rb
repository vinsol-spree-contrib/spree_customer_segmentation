module Spree
  module CustomerSegmentation
    module Postgres
      class Purchase::CouponLastUsedFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          before:  { method: 'custom', logic: 'coupon_last_used_before' },
          after:   { method: 'custom', logic: 'coupon_last_used_after' },
          between: { method: 'custom', logic: 'coupon_last_used_between' },
          eq:      { method: 'custom', logic: 'coupon_last_used_eq' },
          blank:   { method: 'custom', logic: 'coupon_last_used_blank' }
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
          user_collection.used_a_coupon.
                          select("spree_users.id, #{select_query} as coupon_last_used").
                          group('spree_users.id').distinct
        end

        def coupon_last_used_before
          required_date = convert_to_date(values)

          if required_date
            query.having("#{select_query} < ?", required_date)
          else
            ::Spree::User.none
          end
        end

        def coupon_last_used_after
          required_date = convert_to_date(values)
          if required_date
            query.having("#{select_query} > ?", required_date)
          else
            ::Spree::User.none
          end
        end

        def coupon_last_used_eq
          required_date = convert_to_date(values)
          if required_date
            query.having("#{select_query} = ?", required_date)
          else
            ::Spree::User.none
          end
        end

        def coupon_last_used_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)
          required_date1 = convert_to_date(values[0])
          required_date2 = convert_to_date(values[1])

          if required_date1 && required_date2
            query.having("#{select_query} >= ? AND #{select_query} <= ?", required_date1, required_date2)
          else
            ::Spree::User.none
          end
        end

        def coupon_last_used_blank
          values ? user_collection.not_used_a_coupon : user_collection.used_a_coupon
        end

        # if valid date
        def convert_to_date(date)
          begin
            date.to_date
          rescue ArgumentError
            false
          end
        end

        def select_query
          "DATE(MAX(spree_orders.completed_at))"
        end

      end
    end
  end
end
