module Spree
  module  CustomerSegmentation
    class User::NameFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        starts_with: { method: 'ransack', logic: 'bill_address_full_name_start' },
        includes: { method: 'ransack', logic: 'bill_address_full_name_matches_any' },
        not_includes: { method: 'ransack', logic: 'bill_address_full_name_does_not_match_all' }
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
