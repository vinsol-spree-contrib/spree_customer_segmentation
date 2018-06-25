module Spree
  module  CustomerSegmentation
    class User::ContactNumberFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        contains: { method: 'ransack', logic: 'bill_address_phone_cont' },
        does_not_contains: { method: 'ransack', logic: 'bill_address_phone_not_cont' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

    end
  end
end
