module Spree
  class Admin::CustomerSegmentsController < Admin::ResourceController
    include SegmentationRoutes

    before_action :set_customer_segment, only: [:show, :update]

    def index
      @customer_segments = Spree::CustomerSegment.all
    end

    def filter
      if params[:q].present?
        @search_params = search_params(params[:q])
      end
      get_data

      respond_to do |format|
        format.html
        format.csv do
          export_csv
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
      @search_params = search_params(extract_filter_params)
      get_data

      respond_to do |format|
        format.html
        format.csv do
          export_csv
          redirect_to admin_customer_segment_path(@customer_segment.id)
        end
      end
    end

    def update
      @customer_segment.filters = params.permit!.to_query

      if @customer_segment.save
        flash[:notice] = Spree.t(:segment_updated_successfully)
      else
        flash[:error] = @customer_segment.errors.full_messages.join("\n")
      end

      redirect_to admin_customer_segment_path(@customer_segment.id)
    end

    private

      def search_params(parameters)
        filters = []
        return filters if parameters.blank?

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

      def set_customer_segment
        @customer_segment = CustomerSegment.find_by(id: params[:id])

        unless @customer_segment.present?
          flash[:error] = Spree.t(:segment_not_found)
          redirect_to admin_customer_segment_path
        end
      end

      def get_data
        search_service = CustomerSegmentation::SearchService.new(@search_params)

        @results = search_service.generate_segment.page(params[:page])
        @dynamic_columns = search_service.get_dynamic_columns
      end

      def export_csv
        ::Spree::CustomerSegmentation::CsvExporterService.new(all_results, @dynamic_columns, spree_current_user.email).export
        flash.notice = Spree.t(:csv_exported)
      end

  end
end
