module Spree
  class CustomerSegmentationMailer < BaseMailer

    def export_csv(csv, email)
      attachments['segment.csv'] = csv
      mail to: email, subject: Spree.t('customer_segmentation_mailer.subject'), from: from_address 
    end

  end
end
