module Spree
  module  CustomerSegmentation
    class Address::BillAddressStateFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'ransack', logic: 'orders_bill_address_state_name_cont_any' },
        not_includes: { method: 'ransack', logic: 'orders_bill_address_state_name_not_cont_all' },
        includes_all: { method: 'custom', logic: 'state_includes_all' },
        blank:        { method: 'ransack', logic: 'orders_bill_address_state_name_blank' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def state_includes_all
        user_collection.joins(orders: [bill_address: :state]).
                        select(select_query).
                        where(spree_orders: { state: 'complete' }).
                        where(spree_states: { name: values }).
                        group('spree_users.id').
                        having("address_states = ?", sorted_states).distinct
      end

      def select_query
        # MySQL support
        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
          "spree_users.*, GROUP_CONCAT(DISTINCT(spree_states.name)) as address_states"

        # Postgresql support
        else
          "spree_users.*, string_agg(DISTINCT(spree_states.name), ',') as address_states"
        end
      end

      def sorted_states
        values.sort.join(',')
      end

    end
  end
end
