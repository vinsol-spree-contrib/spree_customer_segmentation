module Spree
  module  CustomerSegmentation
    class Address::BillAddressCityFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'orders_bill_address_city_cont_any' },
        not_includes: { method: 'ransack', logic: 'orders_bill_address_city_not_cont_all' },
        includes_all: { method: 'custom', logic: 'city_includes_all' },
        blank:        { method: 'ransack', logic: 'orders_bill_address_city_null' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def city_includes_all
        user_collection.joins(orders: :bill_address).
                        select(select_query).
                        where(spree_orders: { state: 'complete' }).
                        where(spree_addresses: { city: values }).
                        group('spree_users.id').
                        having("address_cities = ?", sorted_cities).distinct
      end

      def select_query
        # MySQL support
        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
          "spree_users.*, GROUP_CONCAT(DISTINCT(spree_addresses.city)) as address_cities"

        # Postgresql support
        else
          "spree_users.*, string_agg(DISTINCT(spree_addresses.city), ',') as address_cities"
        end
      end

      def sorted_cities
        values.sort.join(',')
      end

    end
  end
end
