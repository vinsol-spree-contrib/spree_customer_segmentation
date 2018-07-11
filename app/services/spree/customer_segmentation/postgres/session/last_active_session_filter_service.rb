module Spree
  module CustomerSegmentation
    module Postgres
      class Session::LastActiveSessionFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          before:  { method: 'ransack', logic: 'last_active_session_lt' },
          after:   { method: 'ransack', logic: 'last_active_session_gt' },
          between: { method: 'custom', logic: 'last_active_session_between' },
          eq:      { method: 'ransack', logic: 'last_active_session_eq' },
          blank:   { method: 'custom', logic: 'last_active_session_blank' }
        }

        def initialize(collection, operator, values)
          @operator = operator
          @values   = values
          super(collection)
        end

        def dynamic_column
          unless operator == "blank" && values == true
            { last_active_session: 'Last Active Session' }
          end
        end

        def filter_data
          perform
        end

        def last_active_session_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          required_date1 = convert_to_date(values[0])
          required_date2 = convert_to_date(values[1])

          if required_date1 && required_date2
            user_collection.ransack(last_active_session_gteq: required_date1, last_active_session_lteq: required_date2).result
          else
            ::Spree::User.none
          end
        end

        def last_active_session_blank
          values ? user_collection.without_last_active_session : user_collection.with_last_active_session
        end

        # if valid date
        def convert_to_date(date)
          begin
            date.to_date
          rescue ArgumentError
            false
          end
        end

      end
    end
  end
end
