module Spree
  module CustomerSegmentation
    module Mysql
      class User::FirstNameFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          starts_with:      { method: 'ransack', logic: 'bill_address_firstname_start' },
          includes:         { method: 'ransack', logic: 'bill_address_firstname_matches_any' },
          not_includes:     { method: 'ransack', logic: 'bill_address_firstname_does_not_match_all' },
          contains:         { method: 'ransack', logic: 'bill_address_firstname_cont' },
          does_not_contain: { method: 'ransack', logic: 'bill_address_firstname_not_cont' }
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
end
