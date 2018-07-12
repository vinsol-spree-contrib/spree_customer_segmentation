module Spree
  class Admin::CustomerSegmentsController < Admin::ResourceController
    include SegmentationRoutes

    def index
      @customer_segments = Spree::CustomerSegment.all
    end

    def filter
      if params[:q].present?
        @search_params = search_params(params[:q])
      end

      search_service = CustomerSegmentation::SearchService.new(@search_params)

      @results = search_service.generate_segment.page(params[:page])
      @dynamic_columns = search_service.get_dynamic_columns

      respond_to do |format|
        format.html
        format.csv do
          ::Spree::CustomerSegmentation::CsvExporterService.new(all_results, @dynamic_columns, spree_current_user.email).export
          flash.notice = Spree.t(:csv_exported)
          redirect_to segment_filter_route(request.query_string)
        end
      end
    end

    def create
      @customer_segment = CustomerSegment.new(segment_params)

      if @customer_segment.save
        flash[:notice] = Spree.t(:segment_saved_successfully)
        redirect_to admin_customer_segments_path
      else
        flash[:error] = @customer_segment.errors.full_messages.join("\n")
        redirect_to segment_filter_route(request.query_string)
      end

    end

    def show
      @customer_segment = CustomerSegment.find_by(id: params[:id])
      @search_params = search_params(extract_filter_params)
      search_service = CustomerSegmentation::SearchService.new(@search_params)

      @results = search_service.generate_segment.page(params[:page])
      @dynamic_columns = search_service.get_dynamic_columns

      respond_to do |format|
        format.html
        format.csv do
          ::Spree::CustomerSegmentation::CsvExporterService.new(all_results, @dynamic_columns, spree_current_user.email).export
          flash.notice = Spree.t(:csv_exported)
          redirect_to admin_customer_segment_path(@customer_segment.id)
        end
      end
    end

    private

      def search_params(parameters)
        filters = []

        parameters.each do |metric, operator_value|
          operator = operator_value.keys.first
          value    = operator_value[operator]["value"]
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

      def all_results
        @results.per(@results.total_count)
      end

      def extract_filter_params
        parameter = Rack::Utils.parse_nested_query(@customer_segment.filters)
        parameter["q"]
      end

  end
end
