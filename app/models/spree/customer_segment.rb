module Spree
  class CustomerSegment < Spree::Base

    belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'

    validates :name, :filters, presence: true

  end
end
