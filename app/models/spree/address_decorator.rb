Spree::Address.class_eval do

  def address
    "#{address1} #{address2} #{city}, #{state.name}, #{country.name}"
  end

  self.whitelisted_ransackable_attributes += %w(firstname lastname phone)

end
