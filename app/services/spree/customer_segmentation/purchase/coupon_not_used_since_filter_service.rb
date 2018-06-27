module Spree
  module  CustomerSegmentation
    class Purchase::CouponNotUsedSinceFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        before: { method: 'custom', logic: 'coupon_not_used_since_before' },
        after: { method: 'custom', logic: 'coupon_not_used_since_after' },
        between: { method: 'custom', logic: 'coupon_not_used_since_between' },
        eq: { method: 'custom', logic: 'coupon_not_used_since_eq' },
        blank: { method: 'custom', logic: 'coupon_not_used_since_blank' }
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
        collection.used_a_coupon.
                        select("spree_users.*, DATE(MAX(spree_orders.completed_at)) as coupon_not_used_since").
                        group('spree_orders.user_id')
      end

      def coupon_not_used_since_before
        query.having("coupon_not_used_since < ?", values)
      end

      def coupon_not_used_since_after
        query.having("coupon_not_used_since > ?", values)
      end

      def coupon_not_used_since_eq
        query.having("coupon_not_used_since = ?", @required_date)
      end

      def coupon_not_used_since_between
        query.having("coupon_not_used_since >= ? AND coupon_not_used_since <= ?", values[1], values[0])
      end

    end
  end
end
