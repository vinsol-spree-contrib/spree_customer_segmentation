module Spree
  module CustomerSegmentation
    NEW_PRODUCT_DATE_LIMIT = 7
    RECENT_ORDER_DATE_LIMIT = 7

    WORD_OPERATORS =                  { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    WORD_OPERATORS_WITH_STARTS_WITH = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
    MATCH_OPERATORS =                 { contains: 'contains', does_not_contain: 'does not contain' }
    MATCH_OPERATORS_WITH_BLANK =      { contains: 'contains', does_not_contain: 'does not contain', blank: 'blank' }

    RELATIONAL_OPERATORS =            { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: 'not equals to', lt: '<', lt_eq: '<=' }
    RELATIONAL_OPERATORS_WITH_BLANK = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: 'not equals to', lt: '<', lt_eq: '<=', blank: 'blank' }

    LOGICAL_OPERATORS = { equals: 'equals' }
    DATE_OPERATORS =    { before: 'before', after: 'after', eq: 'equals', between: 'between', blank: 'blank' }

    MULTIPLE_OPERATORS = { includes: 'includes(OR)', not_includes: 'does not include', blank: 'blank' }
    MULTIPLE_OPERATORS_WITH_INCLUDES_ALL = { includes: 'includes(OR)', not_includes: 'does not include', includes_all: 'includes all(AND)', blank: 'blank' }

    # Map services with operators available, and type of metric
    FILTERS_MAPPER = {
      user_email:                  { metric_type: 'alphanumeric', operators: WORD_OPERATORS, service: 'DB::User::EmailFilterService' },
      user_firstname:              { metric_type: 'alphanumeric', operators: WORD_OPERATORS_WITH_STARTS_WITH, service: 'DB::User::FirstNameFilterService' },
      user_lastname:               { metric_type: 'alphanumeric', operators: WORD_OPERATORS_WITH_STARTS_WITH, service: 'DB::User::LastNameFilterService' },
      user_contact_number:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS, service: 'DB::User::ContactNumberFilterService' },
      user_days_from_registration: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::User::DaysFromRegistrationFilterService' },

      order_revenue:          { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Order::RevenueFilterService' },
      days_from_first_order:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: 'DB::Order::DaysFromFirstOrderFilterService' },
      days_from_last_order:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: 'DB::Order::DaysFromLastOrderFilterService' },
      order_quantity_total:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Order::QuantityTotalFilterService' },
      total_number_of_order:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Order::TotalNumberOfOrderFilterService' },
      order_quantity_average: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Order::QuantityAverageFilterService' },
      order_frequency:        { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Order::FrequencyFilterService' },

      cart_number_of_items:    { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Cart::NumberOfItemsFilterService' },
      days_from_cart_created:  { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: 'DB::Cart::DaysFromCartCreatedFilterService' },
      days_from_cart_modified: { metric_type: 'numeric', operators: RELATIONAL_OPERATORS_WITH_BLANK, service: 'DB::Cart::DaysFromCartModifiedFilterService' },

      purchase_coupon_applied:   { metric_type: 'logical', operators: LOGICAL_OPERATORS, service: 'DB::Purchase::CouponAppliedFilterService' },
      purchase_coupon_last_used: { metric_type: 'date', operators: DATE_OPERATORS, service: 'DB::Purchase::CouponLastUsedFilterService' },

      number_of_session:   { metric_type: 'numeric', operators: RELATIONAL_OPERATORS, service: 'DB::Session::NumberOfSessionFilterService' },
      last_active_session: { metric_type: 'date', operators: DATE_OPERATORS, service: 'DB::Session::LastActiveSessionFilterService' },

      bill_address_city:    { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::BillAddressCityFilterService' },
      bill_address_state:   { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::BillAddressStateFilterService' },
      bill_address_zipcode: { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::BillAddressZipcodeFilterService' },
      bill_address:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS_WITH_BLANK, service: 'DB::Address::BillAddressFilterService' },

      ship_address_city:    { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::ShipAddressCityFilterService' },
      ship_address_state:   { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::ShipAddressStateFilterService' },
      ship_address_zipcode: { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS, service: 'DB::Address::ShipAddressZipcodeFilterService' },
      ship_address:         { metric_type: 'alphanumeric', operators: MATCH_OPERATORS_WITH_BLANK, service: 'DB::Address::ShipAddressFilterService' },

      products_added_to_cart:          { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::ProductsAddedToCartFilterService' },
      products_ordered:                { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::ProductsOrderedFilterService' },
      products_recently_added_to_cart: { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::ProductsRecentlyAddedToCartFilterService' },
      products_recently_ordered:       { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::ProductsRecentlyOrderedFilterService' },
      new_products_added_to_cart:      { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::NewProductsAddedToCartFilterService' },
      new_products_ordered:            { metric_type: 'alphanumeric', operators: MULTIPLE_OPERATORS_WITH_INCLUDES_ALL, service: 'DB::Product::NewProductsOrderedFilterService' }
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
        ['Coupon Last Used', :purchase_coupon_last_used]
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
        ['Products Added To Cart', :products_added_to_cart],
        ['Products Ordered', :products_ordered],
        ['Products Recently Added To Cart', :products_recently_added_to_cart],
        ['Products Recently Ordered', :products_recently_ordered],
        ['New Products Added To Cart', :new_products_added_to_cart],
        ['New Products Ordered', :new_products_ordered]
      ]
    }

  end
end
