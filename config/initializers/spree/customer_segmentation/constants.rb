module Spree
  module CustomerSegmentation

    WORD_OPERATORS =                  { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    WORD_OPERATORS_WITH_STARTS_WITH = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    MATCH_OPERATORS =                 { contains: 'contains', does_not_contain: 'does not contain' }
    MATCH_OPERATORS_WITH_BLANK =      { contains: 'contains', does_not_contain: 'does not contain', blank: 'blank' }

    RELATIONAL_OPERATORS =            { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }
    RELATIONAL_OPERATORS_WITH_BLANK = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=', blank: 'blank' }

    LOGICAL_OPERATORS = { equals: 'equals' }
    DATE_OPERATORS =    { before: 'before', after: 'after', eq: 'equals', between: 'between', blank: 'blank' }

    ADDRESS_OPERATORS = { includes: 'includes', not_includes: 'does not include', includes_all: 'includes all', blank: 'blank' }

    # Map services with operators available, and type of metric
    FILTERS_MAPPER = {
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
      days_from_cart_modified: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: Cart::DaysFromCartModifiedFilterService },

      purchase_coupon_applied:   { metric_type: 'logical', operators: LOGICAL_OPERATORS, service: Purchase::CouponAppliedFilterService },
      purchase_coupon_last_used: { metric_type: 'numeric', operators: DATE_OPERATORS, service: Purchase::CouponLastUsedFilterService },

      number_of_session:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: Session::NumberOfSessionFilterService },
      last_active_session: { metric_type: 'date', operators: DATE_OPERATORS, service: Session::LastActiveSessionFilterService },

      bill_address_city:    { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::BillAddressCityFilterService },
      bill_address_state:   { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::BillAddressStateFilterService },
      bill_address_zipcode: { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::BillAddressZipcodeFilterService },
      bill_address:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS_WITH_BLANK, service: Address::BillAddressFilterService },

      ship_address_city:    { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::ShipAddressCityFilterService },
      ship_address_state:   { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::ShipAddressStateFilterService },
      ship_address_zipcode: { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Address::ShipAddressZipcodeFilterService },
      ship_address:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS_WITH_BLANK, service: Address::ShipAddressFilterService },

      # RENAME [OPTIMIZE]
      products_added_to_cart: { metric_type: 'alphanumeric', operators: ADDRESS_OPERATORS, service: Product::ProductsAddedToCartFilterService },
    }

    # Maps filters with their services
    AVAILABLE_FILTERS =     {
      order:  [
        ['Days From First Order Completed', :days_from_first_order],
        ['Days From Last Order Completed', :days_from_last_order],
        ['Order Quantity Total', :order_quantity_total],
        ['Total Number Of Orders', :total_number_of_order],
        ['Order Quantity Average', :order_quantity_average],
        ['Order Frequency', :order_frequency],
        ['Revenue', :order_revenue]
      ],

      cart: [
        ['Number Of Items In Cart', :cart_number_of_items],
        ['Days From Cart Created', :days_from_cart_created],
        ['Days From Cart Modified', :days_from_cart_modified]
      ],

      purchase: [
        ['Used A Coupon', :purchase_coupon_applied],
        ['Coupon Not Used Since', :purchase_coupon_last_used]
      ],

      sessions: [
        ['Number Of Sessions', :number_of_session],
        ['Last Active Session', :last_active_session]
      ],

      address: [
        ['Billing Address', :bill_address],
        ['Billing City', :bill_address_city],
        ['Billing State', :bill_address_state],
        ['Billing Zipcode', :bill_address_zipcode],
        ['Shipping Address', :ship_address],
        ['Shipping City', :ship_address_city],
        ['Shipping State', :ship_address_state],
        ['Shipping Zipcode', :ship_address_zipcode]
      ],

      'user info and demographics': [
        ['First Name', :user_firstname],
        ['Last Name', :user_lastname],
        ['Email', :user_email],
        ['Phone', :user_contact_number],
        ['Days From Registration', :user_days_from_registration]
      ],

      products: [
        ['Products Viewed', :to_be_added],
        ['Products Added To Cart', :products_added_to_cart],
        ['Products Ordered', :to_be_added],
        ['Products Recently Viewed', :to_be_added],
        ['Products Recently Added To Cart', :to_be_added],
        ['Products Recently Ordered', :to_be_added],
        ['New Products Viewed', :to_be_added],
        ['New Products Added To Cart', :to_be_added],
        ['New Products Ordered', :to_be_added]
      ]
    }

  end
end
