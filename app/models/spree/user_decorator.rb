Spree::User.class_eval do

  include Spree::UserScopes

  delegate :firstname, :lastname, :phone, to: :bill_address, allow_nil: true

  has_many :customer_segments, class_name: 'Spree::CustomerSegment', foreign_key: :user_id, dependent: :destroy

  ransacker :last_active_session, type: :date do |parent|
    Arel.sql('date(current_sign_in_at)')
  end

  self.whitelisted_ransackable_associations += %w(orders)
  self.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

  def user_presenter
    @user_presenter ||= ::Spree::CustomerSegmentation::UserPresenter.new(self)
  end

end
