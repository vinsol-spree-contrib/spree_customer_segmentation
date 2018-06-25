Spree::User.class_eval do

  # scope :orders_revenue, -> { joins(:orders).merge(Spree::Order.revenue) }
  #
  # self.whitelisted_ransackable_scopes = %w(orders_revenue)

  def name
    if bill_address.present?
      "#{bill_address.first_name} #{bill_address.last_name}"
    end
  end

  def address
    if bill_address.present?
      "#{bill_address.address1} #{bill_address.address2} #{bill_address.city}, #{bill_address.state.name}, #{bill_address.country.name}"
    end
  end

  def phone
    if bill_address.present?
      bill_address.phone
    end
  end

  self.whitelisted_ransackable_associations += %w(orders)

end
