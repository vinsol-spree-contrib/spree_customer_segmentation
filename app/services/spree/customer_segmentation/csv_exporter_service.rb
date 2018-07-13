require 'csv'

module Spree
  module CustomerSegmentation
    class CsvExporterService
      attr_accessor :results, :admin_email

      CSV_HEADERS = { firstname: 'First Name', lastname: 'Last Name', email: 'Email', full_bill_address: 'Billing Address', phone: 'Contact Number' }

      def initialize(results, email)
        @results = results
        @admin_email = email
      end

      def export
        csv = convert_to_csv
        ::Spree::CustomerSegmentationMailer.export_csv(csv, admin_email).deliver_later
      end

      def convert_to_csv
        CSV.generate(headers: true) do |csv|
          csv << CSV_HEADERS.values

          results.each do |result|
            row = []

            CSV_HEADERS.keys.each do |method|
              row << result.user_presenter.send(method)
            end

            csv << row
          end
        end
      end

    end
  end
end
