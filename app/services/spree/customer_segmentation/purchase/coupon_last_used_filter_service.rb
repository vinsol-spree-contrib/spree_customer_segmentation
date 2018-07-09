module Spree
  module CustomerSegmentation
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

      def dynamic_column
        unless operator == "blank"
          { coupon_last_used: 'Coupon Last Used' }
        end
      end

      def query
        user_collection.used_a_coupon.
                        select("spree_users.*, DATE(MAX(spree_orders.completed_at)) as coupon_last_used").
                        group('spree_orders.user_id').distinct
      end

      def coupon_last_used_before
        query.having("coupon_last_used < ?", values)
      end

      def coupon_last_used_after
        query.having("coupon_last_used > ?", values)
      end

      def coupon_last_used_eq
        query.having("coupon_last_used = ?", values)
      end

      def coupon_last_used_between
        return ::Spree::User.none if (values[0].nil? || values[1].nil?)

        query.having("coupon_last_used >= ? AND coupon_last_used <= ?", values[1], values[0])
      end

      def coupon_last_used_blank
        values ? user_collection.not_used_a_coupon : user_collection.used_a_coupon
      end

    end
  end
end
