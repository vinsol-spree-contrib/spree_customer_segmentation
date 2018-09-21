Spree::State.class_eval do

  self.whitelisted_ransackable_attributes += %w(name)

end
