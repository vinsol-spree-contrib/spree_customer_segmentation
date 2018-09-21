module Spree
  module CustomerSegmentation
    module Mysql
      class Session::NumberOfSessionFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'ransack', logic: 'sign_in_count_gteq' },
          gt:      { method: 'ransack', logic: 'sign_in_count_gt' },
          between: { method: 'custom', logic: 'sign_in_count_between' },
          eq:      { method: 'ransack', logic: 'sign_in_count_eq' },
          not_eq:  { method: 'ransack', logic: 'sign_in_count_not_eq' },
          lt_eq:   { method: 'ransack', logic: 'sign_in_count_lteq' },
          lt:      { method: 'ransack', logic: 'sign_in_count_lt' }
        }

        def initialize(collection, operator, values)
          @operator = operator
          @values   = values
          super(collection)
        end

        def filter_data
          perform
        end

        def sign_in_count_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          user_collection.ransack(sign_in_count_gteq: values[0], sign_in_count_lteq: values[1]).result
        end

      end
    end
  end
end
