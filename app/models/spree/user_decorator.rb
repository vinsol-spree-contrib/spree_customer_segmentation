Spree::User.class_eval do

  include Spree::UserScopes
  include Spree::DisplayData

  delegate :firstname, :lastname, :full_bill_address, :phone, to: :bill_address, allow_nil: true
  delegate :full_ship_address, to: :ship_address, allow_nil: true

  has_many :customer_segments, class_name: 'Spree::CustomerSegment', foreign_key: :user_id, dependent: :destroy

  ransacker :last_active_session, type: :date do |parent|
    Arel.sql('date(current_sign_in_at)')
  end

  self.whitelisted_ransackable_associations += %w(orders)
  self.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

end
