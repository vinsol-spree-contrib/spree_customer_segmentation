SEARCH_SERVICE_MAPPER = {
  user_email: Spree::CustomerSegmentation::User::EmailFilterService,
  user_name: Spree::CustomerSegmentation::User::NameFilterService,
  user_contact_number: Spree::CustomerSegmentation::User::ContactNumberFilterService,

  order_revenue: Spree::CustomerSegmentation::Order::RevenueFilterService,
  order_days_from_first_order: Spree::CustomerSegmentation::Order::DaysFromFirstOrderFilterService,
  order_days_from_last_order: Spree::CustomerSegmentation::Order::DaysFromLastOrderFilterService,
  order_quantity_total: Spree::CustomerSegmentation::Order::QuantityTotalFilterService,
  order_total_number_of_order: Spree::CustomerSegmentation::Order::TotalNumberOfOrderFilterService,
  order_quantity_average: Spree::CustomerSegmentation::Order::QuantityAverageFilterService,
  order_frequency: Spree::CustomerSegmentation::Order::FrequencyFilterService,

  cart_number_of_items: Spree::CustomerSegmentation::Cart::NumberOfItemsFilterService,
  cart_days_from_cart_created: Spree::CustomerSegmentation::Cart::DaysFromCartCreatedFilterService,
  cart_days_from_cart_modified: Spree::CustomerSegmentation::Cart::DaysFromCartModifiedFilterService,

<<<<<<< HEAD
  purchase_used_a_coupon: Spree::CustomerSegmentation::Purchase::UsedACouponFilterService,
  purchase_coupon_not_used_since: Spree::CustomerSegmentation::Purchase::CouponNotUsedSinceFilterService 

=======
>>>>>>> add services for cart filter
}
