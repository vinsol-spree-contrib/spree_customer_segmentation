module Spree
  module CustomerSegmentation
    class SearchService
      attr_accessor :user_collection, :options

      # Assuming that args will give us formatted values
      # Format values inside controller, call service
      def initialize(args = {})
        @user_collection = ::Spree::User.all
        @options = [{ metric: args[:metric], operator: args[:operator], value: args[:values] }]
      end

      def generate_segment
        # when no filter is applied, return all users
        if options[0][:metric].nil?
          Spree::User.all
        else
          perform
        end
      end

      def perform
        options.each do |option|
          metric = option[:metric].to_sym
          service = FILTERS_MAPPER[metric][:service]
          self.user_collection = service.new(user_collection, option[:operator], option[:value]).filter_data
        end

        user_collection
      end

    end
  end
end
