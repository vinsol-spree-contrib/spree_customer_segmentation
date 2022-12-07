module Spree
  module UserDecorator
    def self.prepended(base)     
      base.include Spree::UserScopes

      base.delegate :firstname, :lastname, :phone, to: :bill_address, allow_nil: true

      base.has_many :customer_segments, class_name: 'Spree::CustomerSegment', foreign_key: :user_id, dependent: :destroy

      base.ransacker :last_active_session, type: :date do |parent|
        Arel.sql('date(current_sign_in_at)')
      end

      base.whitelisted_ransackable_associations += %w(orders)
      base.whitelisted_ransackable_attributes += %w(sign_in_count last_active_session)

      def user_presenter
        @user_presenter ||= ::Spree::CustomerSegmentation::UserPresenter.new(base)
      end
    end 
  end
end

::Spree::User.prepend Spree::UserDecorator if ::Spree::User.included_modules.exclude?(Spree::UserDecorator)

