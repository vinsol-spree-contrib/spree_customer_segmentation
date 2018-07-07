module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      if params[:q].present?
        @search_params = search_params
        @arranged_params = arrange_search_params
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

      def arrange_search_params
        arranged_params = @search_params.clone

        arranged_params.each do |filter|
          if filter[:metric].include?('product') || filter[:operator] == "blank" || filter[:operator] == "equals" || (filter[:operator] == "eq" && filter[:value] == "0")
            arranged_params.insert(0, arranged_params.delete(filter))
          end
        end

        arranged_params
      end

  end
end
