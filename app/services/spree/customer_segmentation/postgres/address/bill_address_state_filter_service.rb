module Spree
  module CustomerSegmentation
    module Postgres
      class Address::BillAddressStateFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          includes:     { method: 'ransack', logic: 'bill_address_state_name_matches_any' },
          not_includes: { method: 'ransack', logic: 'bill_address_state_name_does_not_match_all' },
          blank:        { method: 'ransack', logic: 'bill_address_state_name_blank' }
        }

        def initialize(collection, operator, values)
          @operator = operator
          @values = values
          super(collection)
        end

        def filter_data
          perform
        end

        def dynamic_column
          { bill_address_state: 'Bill Address State' }
        end
      end
    end
  end
end
