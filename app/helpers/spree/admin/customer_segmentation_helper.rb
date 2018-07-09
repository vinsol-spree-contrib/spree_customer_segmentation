module Spree
  module Admin
    module CustomerSegmentationHelper

      def display_data(data)
        data.presence || 'NA'
      end

    end
  end
end
