module Spree
  module Admin
    module CustomerSegmentsHelper

      def display_data(data)
        data.presence || 'NA'
      end

    end
  end
end
