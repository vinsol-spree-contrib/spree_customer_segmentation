module Spree
  class Admin::CustomerSegmentsController < Admin::ResourceController

    def index
      @customer_segments = spree_current_user.customer_segments
    end

    def filter
      if params[:q].present?
        @search_params = search_params
      end

      search_serivce = CustomerSegmentation::SearchService.new(@search_params)

      @results = search_serivce.generate_segment.page(params[:page])
      @dynamic_columns = search_serivce.get_dynamic_columns

      respond_to do |format|
        format.html
        format.csv do
          ::Spree::CustomerSegmentation::CsvExporterService.new(@results.per(@results.total_count), @dynamic_columns, spree_current_user.email).export
          redirect_to filter_admin_customer_segments_path
        end
      end
    end

    def create
      @customer_segment = CustomerSegment.new(segment_params)

      if @customer_segment.save
        flash[:notice] = Spree.t(:segment_saved_successfully)
      else
        flash[:error] = @customer_segment.errors.full_messages.join("\n")
      end

      redirect_to @customer_segment.filters.presence || filter_admin_customer_segments_path
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

      def segment_params
        {
          name: params[:name],
          filters: params[:filters],
          user_id: spree_current_user.id
        }
      end

  end
end
