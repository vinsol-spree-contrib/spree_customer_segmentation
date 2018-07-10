Spree::User.class_eval do

  include Spree::UserScopes
  include Spree::DisplayData

  delegate :firstname, :lastname, :full_bill_address, :phone, to: :bill_address, allow_nil: true
  delegate :full_ship_address, to: :ship_address, allow_nil: true

  ransacker :last_active_session, type: :date do |parent|
    Arel.sql('date(last_sign_in_at)')
  end

  self.whitelisted_ransackable_associations += %w(orders)
  self.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

end
