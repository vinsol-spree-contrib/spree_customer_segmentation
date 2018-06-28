module Spree
  module CustomerSegmentation
    class User::LastNameFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        starts_with:  { method: 'ransack', logic: 'bill_address_lastname_start' },
        includes:     { method: 'ransack', logic: 'bill_address_lastname_matches_any' },
        not_includes: { method: 'ransack', logic: 'bill_address_lastname_does_not_match_all' },
        contains:     { method: 'ransack', logic: 'bill_address_lastname_cont' },
        not_contains: { method: 'ransack', logic: 'bill_address_lastname_not_cont' }
      }

      def initialize(user_user_collection, operator, values)
        @operator = operator
        @values = values
        super(user_user_collection)
      end

      def filter_data
        perform
      end

    end
  end
end
