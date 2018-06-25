module Spree
  module CustomerSegmentation
    class BaseService
      attr_accessor :collection

      def initialize(collection)
        @collection = collection
      end

      def perform
        if can_be_ransacked?
          collection.ransack({ search_query => values }) # Look into this to reduce queries.
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
