SEARCH_SERVICE_MAPPER = {
  user_email: Spree::CustomerSegmentation::User::EmailFilterService,
  user_name: Spree::CustomerSegmentation::User::NameFilterService,
  user_contact_number: Spree::CustomerSegmentation::User::ContactNumberFilterService,

  order_revenue: Spree::CustomerSegmentation::Order::RevenueFilterService
}
