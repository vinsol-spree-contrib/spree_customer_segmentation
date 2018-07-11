require 'csv'

module Spree
  module CustomerSegmentation
    class CsvExporterService
      attr_accessor :results, :dynamic_columns, :admin_email

      CSV_HEADERS = { firstname: 'First Name', lastname: 'Last Name', email: 'Email', full_bill_address: 'Billing Address', phone: 'Contact Number' }

      def initialize(results, dynamic_columns, email)
        @results = results
        @dynamic_columns = dynamic_columns
        @admin_email = email
      end

      def export
        csv = convert_to_csv
        ::Spree::CustomerSegmentationMailer.export_csv(csv, admin_email).deliver_later
      end

      def convert_to_csv
        CSV.generate(headers: true) do |csv|
          csv << headers

          results.each do |result|
            row = []

            user_attributes.each do |method|
              row << result.user_presenter.send(method)
            end

            csv << row
          end
        end
      end

      def headers
        columns = []
        @dynamic_columns.each { |column| columns.push(column.values.first) }

        (CSV_HEADERS.values).concat(columns)
      end

      def user_attributes
        attributes = []
        @dynamic_columns.each { |column| attributes.push(column.keys.first) }

        (CSV_HEADERS.keys).concat(attributes)
      end

    end
  end
end
