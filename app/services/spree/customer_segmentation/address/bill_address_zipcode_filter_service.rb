module Spree
  module CustomerSegmentation
    class Address::BillAddressZipcodeFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'orders_bill_address_zipcode_eq_any' },
        not_includes: { method: 'ransack', logic: 'orders_bill_address_zipcode_not_eq_all' },
        includes_all: { method: 'custom', logic: 'zipcode_includes_all' },
        blank:        { method: 'ransack', logic: 'orders_bill_address_zipcode_null' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def zipcode_includes_all
        user_collection.joins(orders: :bill_address).
                        select(select_query).
                        where(spree_orders: { state: 'complete' }).
                        where(spree_addresses: { zipcode: values }).
                        group('spree_users.id').
                        having("address_codes = ?", sorted_codes).distinct
      end

      def select_query
        # MySQL support
        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
          "spree_users.*, GROUP_CONCAT(DISTINCT(spree_addresses.zipcode) ORDER BY spree_addresses.zipcode) as address_codes"

        # Postgresql support
        else
          "spree_users.*, string_agg(DISTINCT(spree_addresses.zipcode), ',' ORDER BY spree_addresses.zipcode) as address_codes"
        end
      end

      def sorted_codes
        values.sort.join(',')
      end

    end
  end
end
