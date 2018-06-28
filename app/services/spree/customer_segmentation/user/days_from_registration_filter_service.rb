module Spree
  module CustomerSegmentation
    class User::DaysFromRegistrationFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        gt_eq:   { method: 'custom', logic: 'days_from_registration_gteq' },
        gt:      { method: 'custom', logic: 'days_from_registration_eq' },
        between: { method: 'custom', logic: 'days_from_registration_between' },
        eq:      { method: 'custom', logic: 'days_from_registration_eq' },
        not_eq:  { method: 'custom', logic: 'days_from_registration_not_eq' },
        lt_eq:   { method: 'custom', logic: 'days_from_registration_lteq' },
        lt:      { method: 'custom', logic: 'days_from_registration_lt' },
        blank:   { method: 'custom', logic: 'days_from_registration_blank' }
      }

      def initialize(user_collection, operator, values)
        @operator = operator
        @values = values
        super(user_collection)
      end

      def filter_data
        perform
      end

      def days_from_registration_gteq
        user_collection.where("DATE(created_at) <= ?", required_date)
      end

      def days_from_registration_gt
        user_collection.where("DATE(created_at) < ?", required_date)
      end

      def days_from_registration_lt
        user_collection.where("DATE(created_at) > ?", required_date)
      end

      def days_from_registration_lteq
        user_collection.where("DATE(created_at) >= ?", required_date)
      end

      def days_from_registration_eq
        user_collection.where("DATE(created_at) = ?", required_date)
      end

      def days_from_registration_not_eq
        user_collection.where("DATE(created_at) != ?", required_date)
      end

      def days_from_registration_between
        first_date  = (Time.current.utc - values[0].to_i).to_date
        second_date = (Time.current.utc - values[1].to_i).to_date

        user_collection.where("created_at >= ? AND created_at <= ?", last_date, second_date)
      end

      def required_date
        (Time.current.utc - values.to_i).to_date
      end

    end
  end
end
