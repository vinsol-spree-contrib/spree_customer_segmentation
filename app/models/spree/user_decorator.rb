Spree::User.class_eval do

  delegate :full_name, :address, :phone, to: :bill_address, allow_nil: true

end
