module Spree
  module OrderDecorator
    def self.prepended(base)
      base.whitelisted_ransackable_attributes += %w(created_at)

      base.ransacker :created_at, type: :date do
        Arel.sql('date(created_at)')
      end
    end
    
  end
end

::Spree::Order.prepend Spree::OrderDecorator if ::Spree::Order.included_modules.exclude?(Spree::OrderDecorator)


