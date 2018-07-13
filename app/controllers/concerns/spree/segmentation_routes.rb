module Spree
  module SegmentationRoutes
    extend ActiveSupport::Concern

    included do
      helper_method :csv_segment_route, :segment_filter_route, :csv_segment_filter_route
    end

    def csv_segment_route(id)
      segment = CustomerSegment.find_by(id: id)

      if segment.present?
        "#{admin_customer_segment_path(id)}.csv"
      end
    end

    def segment_filter_route(filters)
      "#{filter_admin_customer_segments_path}?#{filters}"
    end

    def csv_segment_filter_route(filters)
      "#{filter_admin_customer_segments_path}.csv?#{filters}"
    end

  end
end
