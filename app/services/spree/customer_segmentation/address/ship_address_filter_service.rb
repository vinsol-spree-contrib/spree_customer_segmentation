module Spree
  module  CustomerSegmentation
    class Address::ShipAddressFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        contains:         { method: 'custom', logic: 'ship_address_contain' },
        does_not_contain: { method: 'custom', logic: 'ship_address_does_not_contain' },
        blank:            { method: 'custom', logic: 'ship_address_blank' }
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
        query.where.not("#{concatenated_address} LIKE ?", "%#{values}%" ).distinct
      end

      def concatenated_address
        "CONCAT(spree_addresses.address1, ' ', spree_addresses.address2, ' ', spree_addresses.city, ' ', spree_states.name, ' ', spree_countries.name, ' ', spree_addresses.zipcode)"
      end

      def ship_address_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.without_ship_address : user_collection.with_ship_address
      end

    end
  end
end
