module Spree
  module CustomerSegmentation
    class Address::BillAddressStateFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'bill_address_state_name_eq_any' },
        not_includes: { method: 'ransack', logic: 'bill_address_state_name_not_eq_all' },
        blank:        { method: 'ransack', logic: 'bill_address_state_name_blank' }
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
