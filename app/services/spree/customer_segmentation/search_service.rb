module Spree
  module CustomerSegmentation
    class SearchService
      attr_accessor :user_collection, :options, :dynamic_columns

      # Assuming that args will give us formatted values
      # Format values inside controller, call service
      def initialize(params = {})
        @user_collection = ::Spree::User.all
        @options = params
        @dynamic_columns = []
      end

      def generate_segment
        # when no filter is applied, return all users
        if options.nil?
          Spree::User.all
        else
          perform
        end
      end

      def perform
        arranged_params = arrange_params

        arranged_params.each do |option|
          service = get_service_name(option[:metric].to_sym)
          self.user_collection = service.new(user_collection, option[:operator], option[:value]).filter_data
        end

        user_collection
      end

      def get_dynamic_columns
        if options.present?
          options.each do |option|
            service = get_service_name(option[:metric].to_sym)
            column = service.new(user_collection, option[:operator], option[:value]).try(:dynamic_column)
            self.dynamic_columns << column if column.present?
          end
        end

        dynamic_columns
      end

      def arrange_params
        arranged_params = options.clone

        arranged_params.each do |option|
          service = get_service_name(option[:metric].to_sym)

          if service.new([], option[:operator], option[:value]).can_be_ransacked? || needs_to_be_processed_first?(option)
            arranged_params.insert(0, arranged_params.delete(option))
          end
        end

        arranged_params
      end

      def get_service_name(metric)
        FILTERS_MAPPER[metric][:service]
      end

      # The filters which are ransacked, returns only a scope, or uses NOT operator needs to be processed first
      def needs_to_be_processed_first?(filter)
        ['blank', 'equals'].include?(filter[:operator]) ||
        (filter[:metric].include?('product') && filter[:operator] == "not_includes") ||
        (filter[:operator] == "eq" && filter[:value] == "0")
      end

    end
  end
end
