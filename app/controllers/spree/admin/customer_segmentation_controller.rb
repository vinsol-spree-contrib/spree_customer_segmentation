module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      @results = CustomerSegmentation::SearchService.new(search_params).generate_segment.page(params[:page])
    end

    private

      def search_params
        {
          metric: params[:metric],
          operator: params[:operator],
          values: CustomerSegmentation::ProcessParamsService.new(params[:operator], params[:value]).process
        }
      end

  end
end
