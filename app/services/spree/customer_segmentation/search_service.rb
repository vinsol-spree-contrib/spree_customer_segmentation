module Spree
  module CustomerSegmentation
    class SearchService
      attr_accessor :user_collection, :options

      # Assuming that args will give us formatted values
      # Format values inside controller, call service
      def initialize(params = {})
        @user_collection = ::Spree::User.all
        @options = params
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
          results = service.new(user_collection, option[:operator], option[:value]).filter_data

          self.user_collection = Spree::User.where(id: results.map(&:id))
          return Spree::User.none if user_collection.empty?
        end

        user_collection
      end

      def get_service_name(metric)
        FILTERS_MAPPER[metric][:service]
      end

    end
  end
end
