Spree::User.class_eval do

  include Spree::UserScopes

  delegate :firstname, :lastname, :full_address, :phone, to: :bill_address, allow_nil: true

  ransacker :last_active_session, type: :date do |parent|
    Arel.sql('date(last_sign_in_at)')
  end

  self.whitelisted_ransackable_associations += %w(orders)
  self.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

  def user_since
    created_at.strftime('%Y-%m-%d')
  end

end
