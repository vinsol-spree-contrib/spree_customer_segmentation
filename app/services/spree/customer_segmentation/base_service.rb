module Spree
  module CustomerSegmentation
    class BaseService
      attr_accessor :user_collection

      def initialize(user_collection)
        @user_collection = user_collection
      end

      def perform
        if can_be_ransacked?
          user_collection.ransack({ search_query => values }).result # Look into this to reduce queries.
        else
          self.send "#{search_query}"
        end
      end

      def can_be_ransacked?
        self.class.const_get(:SEARCH_LOGIC)[operator.to_sym][:method] == 'ransack'
      end

      def search_query
        self.class.const_get(:SEARCH_LOGIC)[operator.to_sym][:logic]
      end

    end
  end
end
