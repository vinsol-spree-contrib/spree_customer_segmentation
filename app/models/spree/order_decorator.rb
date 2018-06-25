Spree::Order.class_eval do

  # ransacker :days_from_first_order do
  #
  # end
  #
  # ransacker :days_from_last_order do
  #
  # end

  # scope :revenue, -> { complete.where.not(user_id: nil).group(:user_id).sum(:total) }

  ransacker :revenue do |parent|
    # orders = Arel::Table.new(:spree_users)
    # query = orders.group(orders[:user_id]).project(orders[:total].sum)
  end

  self.whitelisted_ransackable_attributes += %w(revenue)

end
