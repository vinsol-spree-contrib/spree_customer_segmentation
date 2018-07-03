Spree::User.class_eval do

  include Spree::UserScopes

  delegate :firstname, :lastname, :full_address, :phone, to: :bill_address, allow_nil: true

  self.whitelisted_ransackable_associations += %w(orders)

end
