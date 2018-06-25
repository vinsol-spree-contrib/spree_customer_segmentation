module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      @query = CustomerSegmentation::SearchService.new(search_params).generate_segment
      apply_sorting
      @results = @query.result.page(params[:page])
    end

    private

      def search_params
        {
          metric: params[:metric],
          operator: params[:operator],
          values: CustomerSegmentation::ProcessParamsService.new(params[:operator], params[:value]).process
        }
      end

      def apply_sorting
        if params[:q] && params[:q][:s]
          @query.sorts = params[:q][:s]
        end
      end

  end
end
