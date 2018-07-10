module Spree
  module DisplayData
    extend ActiveSupport::Concern

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

    def last_active_session
      last_sign_in_at.strftime('%Y-%m-%d')
    end

  end
end
