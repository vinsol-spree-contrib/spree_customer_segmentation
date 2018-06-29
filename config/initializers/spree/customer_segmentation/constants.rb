module Spree
  module CustomerSegmentation

    WORD_OPERATORS =                  { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    WORD_OPERATORS_WITH_STARTS_WITH = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    MATCH_OPERATORS =                 { contains: 'contains', does_not_contain: 'does not contain' }

    RELATIONAL_OPERATORS =            { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }
    RELATIONAL_OPERATORS_WITH_BLANK = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=', blank: 'blank' }

    FILTERS = {
      user_email:                  { metric_type: 'alphanumeric', operators: WORD_OPERATORS, service: User::EmailFilterService },
      user_firstname:              { metric_type: 'alphanumeric', operators: WORD_OPERATORS_WITH_STARTS_WITH, service: User::FirstNameFilterService },
      user_lastname:               { metric_type: 'alphanumeric', operators: WORD_OPERATORS_WITH_STARTS_WITH, service: User::LastNameFilterService },
      user_contact_number:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS, service: User::ContactNumberFilterService },
      user_days_from_registration: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: User::DaysFromRegistrationFilterService },

      order_revenue:          { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Order::RevenueFilterService },
      days_from_first_order:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: Order::DaysFromFirstOrderFilterService },
      days_from_last_order:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: Order::DaysFromLastOrderFilterService },
      order_quantity_total:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Order::QuantityTotalFilterService },
      total_number_of_order:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Order::TotalNumberOfOrderFilterService },
      order_quantity_average: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Order::QuantityAverageFilterService },
      order_frequency:        { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Order::FrequencyFilterService },

      cart_number_of_items:    { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Cart::NumberOfItemsFilterService },
      days_from_cart_created:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: Cart::DaysFromCartCreatedFilterService },
      days_from_cart_modified: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: Cart::DaysFromCartModifiedFilterService }
    }

  end
end
