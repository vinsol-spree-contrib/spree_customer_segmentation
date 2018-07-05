module Spree
  module CustomerSegmentation
    class ProcessParamsService
      attr_accessor :operator, :value

      def initialize(operator, value)
        @operator = operator
        @value = value
      end

      def process
        if operator =~ /include/
          value.split(',')
        elsif operator == 'blank'
          ActiveModel::Type::Boolean.new.cast(value)
        else
          value
        end
      end

    end
  end
end
