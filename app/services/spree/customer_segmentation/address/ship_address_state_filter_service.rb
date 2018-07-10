module Spree
  module CustomerSegmentation
    class Address::ShipAddressStateFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'ship_address_state_name_eq_any' },
        not_includes: { method: 'ransack', logic: 'ship_address_state_name_not_eq_all' },
        blank:        { method: 'ransack', logic: 'ship_address_state_name_blank' }
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
        { ship_address_state: 'Ship Address State' }
      end

    end
  end
end
