Spree::User.class_eval do

  include Spree::UserScopes

  delegate :firstname, :lastname, :full_bill_address, :phone, to: :bill_address, allow_nil: true
  delegate :full_ship_address, to: :ship_address, allow_nil: true

  ransacker :last_active_session, type: :date do |parent|
    Arel.sql('date(last_sign_in_at)')
  end

  self.whitelisted_ransackable_associations += %w(orders)
  self.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

  def user_since
    created_at.strftime('%Y-%m-%d')
  end

  def bill_address_city
    bill_address.city
  end

  def bill_address_state
    bill_address.state
  end

  def bill_address_zipcode
    bill_address.zipcode
  end

  def ship_address_city
    ship_address.city
  end

  def ship_address_state
    ship_address.state
  end

  def ship_address_zipcode
    ship_address.zipcode
  end

end
