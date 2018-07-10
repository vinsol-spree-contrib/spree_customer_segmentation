Spree::Address.class_eval do

  def full_address
    "#{address1} #{address2} #{city} #{state.name} #{country.name} #{zipcode}"
  end

  def full_bill_address
    full_address
  end

  def full_ship_address
    full_address
  end

  self.whitelisted_ransackable_attributes += %w(firstname lastname phone city zipcode state)
  self.whitelisted_ransackable_associations = %w(state)

end
