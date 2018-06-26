Spree::User.class_eval do

  delegate :full_name, :address, :phone, to: :bill_address, allow_nil: true

  self.whitelisted_ransackable_associations += %w(orders)

end
