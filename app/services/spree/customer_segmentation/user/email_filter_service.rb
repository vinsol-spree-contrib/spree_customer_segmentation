module Spree
  module  CustomerSegmentation
    class User::EmailFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes: { method: 'ransack', logic: 'email_in' },
        does_not_includes: { method: 'custom', logic: 'email_not_in' }  # change to ransack!!
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def email_not_in
        collection.ransack(email_not_in: values).result
      end

    end
  end
end
