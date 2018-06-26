SEARCH_SERVICE_MAPPER = {
  user_email: Spree::CustomerSegmentation::User::EmailFilterService,
  user_name: Spree::CustomerSegmentation::User::NameFilterService,
  user_contact_number: Spree::CustomerSegmentation::User::ContactNumberFilterService,

  order_revenue: Spree::CustomerSegmentation::Order::RevenueFilterService,
  order_days_from_first_order: Spree::CustomerSegmentation::Order::DaysFromFirstOrderFilterService,
  order_days_from_last_order: Spree::CustomerSegmentation::Order::DaysFromLastOrderFilterService,
  order_quantity_total: Spree::CustomerSegmentation::Order::QuantityTotalFilterService,
  order_total_number_of_order: Spree::CustomerSegmentation::Order::TotalNumberOfOrderFilterService

}
