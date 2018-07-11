module Spree
  module CustomerSegmentation
    module Mysql
      class User::DaysFromRegistrationFilterService < BaseService
        attr_accessor :operator, :values

        SEARCH_LOGIC = {
          gt_eq:   { method: 'custom', logic: 'days_from_registration_gteq' },
          gt:      { method: 'custom', logic: 'days_from_registration_gt' },
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

        def dynamic_column
          { user_since: 'Date Of Registration' }
        end

        def days_from_registration_gteq
          user_collection.where("DATE(spree_users.created_at) <= ?", required_date)
        end

        def days_from_registration_gt
          user_collection.where("DATE(spree_users.created_at) < ?", required_date)
        end

        def days_from_registration_lt
          user_collection.where("DATE(spree_users.created_at) > ?", required_date)
        end

        def days_from_registration_lteq
          user_collection.where("DATE(spree_users.created_at) >= ?", required_date)
        end

        def days_from_registration_eq
          user_collection.where("DATE(spree_users.created_at) = ?", required_date)
        end

        def days_from_registration_not_eq
          user_collection.where("DATE(spree_users.created_at) != ?", required_date)
        end

        def days_from_registration_between
          return ::Spree::User.none if (values[0].nil? || values[1].nil?)

          first_date = (current_utc_time - values[0].to_i.days).to_date
          second_date = (current_utc_time - values[1].to_i.days).to_date

          user_collection.where("DATE(spree_users.created_at) >= ? AND DATE(spree_users.created_at) <= ?", second_date, first_date)
        end

        def required_date
          (current_utc_time - values.to_i.days).to_date
        end
      end
    end
  end
end
