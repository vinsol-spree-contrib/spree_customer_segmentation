module Spree
  module CustomerSegmentation
    module Postgres
      class Purchase::CouponAppliedFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          equals: { method: 'custom', logic: 'coupon_applied_equals' }
        }

        def initialize(collection, operator, values)
          @operator = operator
          @values = values
          super(collection)
        end

        def filter_data
          perform
        end

        def coupon_applied_equals
          values ? user_collection.used_a_coupon : user_collection.not_used_a_coupon
        end

      end
    end
  end
end
