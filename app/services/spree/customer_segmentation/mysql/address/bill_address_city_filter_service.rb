module Spree
  module CustomerSegmentation
    module Mysql
      class Address::BillAddressCityFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          includes:     { method: 'ransack', logic: 'bill_address_city_matches_any' },
          not_includes: { method: 'ransack', logic: 'bill_address_city_does_not_match_all' },
          blank:        { method: 'ransack', logic: 'bill_address_city_null' }
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
end
