module Spree
  class CustomerSegmentation::BaseService

    def initialize(collection)
      @collection = collection
    end

    def perform
      if can_be_ransacked?
        @collection.ransack({ search_query => @values }).result
      else
        @collection.send "#{search_query}", @values
      end
    end

    def can_be_ransacked?
      self.class.const_get(:SEARCH_LOGIC)[@operator][:method] == 'ransack'
    end

    def search_query
      self.class.const_get(:SEARCH_LOGIC)[@operator][:logic]
    end

  end
end
