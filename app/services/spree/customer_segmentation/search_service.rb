module Spree
  module CustomerSegmentation
    class SearchService
      attr_accessor :collection, :options

      # Assuming that args will give us formatted values
      # Format values inside controller, call service
      def initialize(args = {})
        @collection = ::Spree::User.all
        # @options = [ { term: 'user_email__includes', value: ['abc@mail.com', 'xyz@mail.com'] } ]  #args[:options]
        # @options = [ { term: 'user_email__does_not_includes', value: ['xyz@mail.com'] } ]  #args[:options]
        @options = [ { term: 'user_email__includes', value: ['abc@mail.com', 'xyz@mail.com'] }, { term: 'user_email__does_not_includes', value: ['xyz@mail.com'] } ]  #args[:options]
      end

      def perform
        options.each do |option|
          service_name_key = get_search_key_name(option[:term])
          operator = get_operator(option[:term])

          self.collection = SEARCH_SERVICE_MAPPER[service_name_key].new(collection, operator, option[:value]).filter_data
        end

        collection
      end

      # user_email__includes => user_email
      def get_search_key_name(term)
        term.split('__').first.to_sym
      end

      # user_email__includes => includes
      def get_operator(term)
        term.split('__').last.to_sym
      end

    end
  end
end
