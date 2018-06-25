module Spree
  module CustomerSegmentation
    class SearchService
      attr_accessor :collection, :options

      # Assuming that args will give us formatted values
      # Format values inside controller, call service
      def initialize(args = {})
        @collection = ::Spree::User.all
        @options = [{ metric: args[:metric], operator: args[:operator], value: args[:values] }]
      end

      def generate_segment
        # when no filter is applied, return all users
        if options[0][:metric].nil?
          Spree::User.ransack
        else
          perform
        end
      end

      def perform
        options.each do |option|
          metric = option[:metric].to_sym
          @ransack_query = SEARCH_SERVICE_MAPPER[metric].new(collection, option[:operator], option[:value]).filter_data
          self.collection = @ransack_query.result
        end

        @ransack_query
      end

    end
  end
end
