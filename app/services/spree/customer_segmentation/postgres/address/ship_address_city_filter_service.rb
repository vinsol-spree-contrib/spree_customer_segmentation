module Spree
  module CustomerSegmentation
    module Postgres
      class Address::ShipAddressCityFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          includes:     { method: 'ransack', logic: 'ship_address_city_matches_any' },
          not_includes: { method: 'ransack', logic: 'ship_address_city_does_not_match_all' },
          blank:        { method: 'ransack', logic: 'ship_address_city_null' }
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
          { ship_address_city: 'Ship Address City' }
        end
      end
    end
  end
end
