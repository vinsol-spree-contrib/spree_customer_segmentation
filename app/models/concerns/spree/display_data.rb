module Spree
  module DisplayData
    extend ActiveSupport::Concern

    def user_since
      created_at.strftime('%Y-%m-%d')
    end

    def bill_address_city
      bill_address.try(:city)
    end

    def bill_address_state
      bill_address.try(:state)
    end

    def bill_address_zipcode
      bill_address.try(:zipcode)
    end

    def ship_address_city
      ship_address.try(:city)
    end

    def ship_address_state
      ship_address.try(:state)
    end

    def ship_address_zipcode
      ship_address.try(:zipcode)
    end

    def last_active_session
      last_sign_in_at.strftime('%Y-%m-%d')
    end

  end
end
