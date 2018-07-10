module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      if params[:q].present?
        @search_params = search_params
        @arranged_params = CustomerSegmentation::ArrangeParamsService.new(search_params).arrange
      end

      @results = CustomerSegmentation::SearchService.new(@arranged_params).generate_segment.page(params[:page])
    end

    private

      def search_params
        filters = []

        params[:q].each do |metric, operator_value|
          operator = operator_value.keys.first
          value    = operator_value[operator][:value]
          filters << { metric: metric, operator: operator, value: process_params(operator, value) }
        end

        filters
      end

      def process_params(operator, value)
        CustomerSegmentation::ProcessParamsService.new(operator,value).process
      end

  end
end
