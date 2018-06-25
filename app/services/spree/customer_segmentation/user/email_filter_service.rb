module Spree
  module  CustomerSegmentation
    class User::EmailFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes: { method: 'ransack', logic: 'email_matches_any' },
        not_includes: { method: 'ransack', logic: 'email_does_not_match_all' },
        contains: { method: 'ransack', logic: 'email_cont' },
        does_not_contains: { method: 'ransack', logic: 'email_not_cont' }
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
