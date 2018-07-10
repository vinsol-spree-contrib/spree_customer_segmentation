module Spree
  module CustomerSegmentation
    class Address::ShipAddressZipcodeFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'ship_address_zipcode_eq_any' },
        not_includes: { method: 'ransack', logic: 'ship_address_zipcode_not_eq_all' },
        blank:        { method: 'ransack', logic: 'ship_address_zipcode_null' }
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
