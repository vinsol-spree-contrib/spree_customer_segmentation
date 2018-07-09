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
        options.each do |option|
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

      def get_service_name(metric)
        FILTERS_MAPPER[metric][:service]
      end

    end
  end
end
