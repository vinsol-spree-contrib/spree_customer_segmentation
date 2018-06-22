module Spree
  class Admin::CustomerSegmentationController < Admin::BaseController

    def index
      @query = CustomerSegmentation::SearchService.new(process_params).generate_segment
      apply_sorting
      @results = @query.result.page(params[:page])
    end

    private

      def process_params
        { term: create_term, values: create_values }
      end

      def create_term
        "#{params[:metric]}__#{params[:operator]}"
      end

      # SERVICE ??
      def create_values
        if params[:operator] && params[:operator] =~ /include/
          params[:value].split(',') # convert to array
        else
          params[:value]
        end
      end

      def apply_sorting
        if params[:q] && params[:q][:s]
          @query.sorts = params[:q][:s]
        end
      end

  end
end
