module Spree
  module CustomerSegmentation

    word_operators = { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    word_operators_with_starts_with = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    match_operators = { contains: 'contains', does_not_contain: 'does not contain' }

    relational_operators = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }
    relational_operators_with_blank = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=', blank: 'blank' }

    FILTERS = {
                user_email: { metric_type: 'alphanumeric', operators: word_operators, service: User::EmailFilterService },
                user_firstname: { metric_type: 'alphanumeric', operators: word_operators_with_starts_with, service: User::FirstNameFilterService },
                user_lastname: { metric_type: 'alphanumeric', operators: word_operators_with_starts_with, service: User::LastNameFilterService },
                user_contact_number: { metric_type: 'alphanumeric', operators: match_operators, service: User::ContactNumberFilterService },

                order_revenue: { metric_type: 'numeric', operators: relational_operators, service: Order::RevenueFilterService },
                days_from_first_order: { metric_type: 'numeric', operators: relational_operators_with_blank, service: Order::DaysFromFirstOrderFilterService },
                days_from_last_order: { metric_type: 'numeric', operators: relational_operators_with_blank, service: Order::DaysFromLastOrderFilterService },
                order_quantity_total: { metric_type: 'numeric', operators: relational_operators, service: Order::QuantityTotalFilterService },
                total_number_of_order: { metric_type: 'numeric', operators: relational_operators, service: Order::TotalNumberOfOrderFilterService },
                order_quantity_average: { metric_type: 'numeric', operators: relational_operators, service: Order::QuantityAverageFilterService },
                order_frequency: { metric_type: 'numeric', operators: relational_operators, service: Order::FrequencyFilterService }
              }

  end
end
