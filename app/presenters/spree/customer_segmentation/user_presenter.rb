module Spree
  module CustomerSegmentation
    class UserPresenter
      attr_accessor :user

      def initialize(user)
        @user = user
      end

      def display_data(data)
        data.presence || 'NA'
      end

      def method_missing(method, *args, &block)
        if user.respond_to? method
          display_data(user.send method)
        else
          super
        end
      end

      def full_bill_address
        display_data(user.bill_address.try(:full_address))
      end

      def full_ship_address
        display_data(user.ship_address.try(:full_address))
      end

      def phone
        display_data(user.bill_address.try(:phone))
      end

      def user_since
        user.created_at.present? ? display_data(user.created_at.strftime('%Y-%m-%d')) : display_data('')
      end

      def bill_address_city
        display_data(user.bill_address.try(:city))
      end

      def bill_address_state
        display_data(user.bill_address.try(:state))
      end

      def bill_address_zipcode
        display_data(user.bill_address.try(:zipcode))
      end

      def ship_address_city
        display_data(user.ship_address.try(:city))
      end

      def ship_address_state
        display_data(user.ship_address.try(:state))
      end

      def ship_address_zipcode
        display_data(user.ship_address.try(:zipcode))
      end

      def last_active_session
        user.current_sign_in_at.present? ? display_data(user.current_sign_in_at.strftime('%Y-%m-%d')) : display_data('')
      end

    end
  end
end
