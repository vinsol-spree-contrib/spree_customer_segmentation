Spree::Order.class_eval do

  self.whitelisted_ransackable_attributes += %w(created_at)

  ransacker :created_at, type: :date do
    Arel.sql('date(created_at)')
  end

end
