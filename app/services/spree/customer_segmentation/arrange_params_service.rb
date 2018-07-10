module Spree
  module CustomerSegmentation
    class ArrangeParamsService
      attr_accessor :search_params

      def initialize(search_params)
        @search_params = search_params
      end

      def arrange
        arranged_params = search_params.clone

        search_params.each do |filter|
          metric = filter[:metric].to_sym
          service = FILTERS_MAPPER[metric][:service]

          if service.new([], filter[:operator], filter[:value]).can_be_ransacked? || needs_to_be_processed_first?(filter)
            arranged_params.insert(0, arranged_params.delete(filter))
          end
        end

        arranged_params
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
