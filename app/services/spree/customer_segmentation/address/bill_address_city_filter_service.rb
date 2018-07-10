module Spree
  module CustomerSegmentation
    class Address::BillAddressCityFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'bill_address_city_eq_any' },
        not_includes: { method: 'ransack', logic: 'bill_address_city_not_eq_all' },
        blank:        { method: 'ransack', logic: 'bill_address_city_null' }
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
        { bill_address_city: 'Bill Address City' }
      end

    end
  end
end
