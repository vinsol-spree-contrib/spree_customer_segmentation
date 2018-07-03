module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      @search_params = search_params
      @results = CustomerSegmentation::SearchService.new(@search_params).generate_segment.page(params[:page])
    end

    private

      def search_params
        return if params[:q].nil?
        filters = []

<<<<<<< HEAD
        params[:q].each do |metric, operator_value|
          operator = operator_value.keys.first
          value    = operator_value[operator][:value]
=======
        params[:q].each do |metric, x|
          operator = x.keys.first
          value    = x[operator][:value]
>>>>>>> add multiple filter functionality
          filters << { metric: metric, operator: operator, value: process_params(operator, value) }
        end

        filters
      end

      def process_params(operator, value)
        CustomerSegmentation::ProcessParamsService.new(operator,value).process
      end

  end
end
