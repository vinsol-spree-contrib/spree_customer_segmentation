Spree::Address.class_eval do

  def address
    "#{address1} #{address2} #{city} #{state.name} #{country.name} #{zipcode}"
  end

  self.whitelisted_ransackable_attributes += %w(firstname lastname phone city zipcode state)
  self.whitelisted_ransackable_associations = %w(state)

end
