module Spree
  module CustomerSegmentation
    class Address::ShipAddressFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        contains:         { method: 'custom', logic: 'ship_address_contain' },
        does_not_contain: { method: 'custom', logic: 'ship_address_does_not_contain' },
        blank:            { method: 'ransack', logic: 'ship_address_id_null' }
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
        user_collection.joins(orders: [ship_address: [:state, :country]]).
                        where(spree_orders: { state: 'complete' })
      end

      def ship_address_contain
        query.where("#{concatenated_address} LIKE ?", "%#{values}%" ).distinct
      end

      def ship_address_does_not_contain
        user_collection.where.not(id: ship_address_contain.pluck(:id))
      end

      def concatenated_address
        "CONCAT(spree_addresses.address1, ' ', spree_addresses.address2, ' ', spree_addresses.city, ' ', spree_states.name, ' ', spree_countries.name, ' ', spree_addresses.zipcode)"
      end

    end
  end
end
