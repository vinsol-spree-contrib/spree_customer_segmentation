module Spree
  module CustomerSegmentation
    class Session::LastActiveSessionFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        before:  { method: 'ransack', logic: 'last_active_session_lt' },
        after:   { method: 'ransack', logic: 'last_active_session_gt' },
        between: { method: 'custom', logic: 'last_active_session_between' },
        eq:      { method: 'ransack', logic: 'last_active_session_eq' },
        blank:   { method: 'ransack', logic: 'last_active_session_blank' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values   = values
        super(collection)
      end

      def dynamic_column
        { last_sign_in_at: 'Last Active Session' }
      end

      def filter_data
        perform
      end

      def last_active_session_between
        return ::Spree::User.none if (values[0].nil? || values[1].nil?)

        user_collection.ransack(last_active_session_gteq: values[0], last_active_session_lteq: values[1]).result
      end

    end
  end
end
