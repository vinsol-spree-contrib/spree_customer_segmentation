module Spree
  module CustomerSegmentation
    class ProcessParamsService
      attr_accessor :operator, :value

      def initialize(operator, value)
        @operator = operator
        @value = value
      end

      def process
        if operator && operator =~ /include/
          value.split(',') # convert to array
        else
          value
        end
      end

    end
  end
end
