module Spree
  module CustomerSegmentation
    class Purchase::UsedACouponFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        eq: { method: 'custom', logic: 'used_a_coupon_eq' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def used_a_coupon_eq
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.used_a_coupon : user_collection.not_used_a_coupon
      end

    end
  end
end
