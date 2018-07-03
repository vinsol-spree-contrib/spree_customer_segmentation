module Spree
  module CustomerSegmentation
    class Address::BillAddressFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        contains:         { method: 'custom', logic: 'bill_address_contain' },
        does_not_contain: { method: 'custom', logic: 'bill_address_does_not_contain' },
        blank:            { method: 'custom', logic: 'bill_address_blank' }
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
        user_collection.joins(orders: [bill_address: [:state, :country]]).
                        where(spree_orders: { state: 'complete' })
      end

      def bill_address_contain
        query.where("#{concatenated_address} LIKE ?", "%#{values}%").distinct
      end

      def bill_address_does_not_contain
        user_collection.where.not(id: bill_address_contain.pluck(:id))
      end

      def concatenated_address
        "CONCAT(spree_addresses.address1, ' ', spree_addresses.address2, ' ', spree_addresses.city, ' ', spree_states.name, ' ', spree_countries.name, ' ', spree_addresses.zipcode)"
      end

      def bill_address_blank
        choice = ActiveModel::Type::Boolean.new.cast(values) # convert string to boolean, move to process params!!
        choice ? user_collection.without_bill_address : user_collection.with_bill_address
      end

    end
  end
end
