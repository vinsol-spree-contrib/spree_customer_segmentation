module Spree
  module CustomerSegmentation
    class Product::ProductsOrderedFilterService < BaseService
      attr_accessor :operator, :values

      SEARCH_LOGIC = {
        includes:     { method: 'custom', logic: 'products_ordered_includes' },
        not_includes: { method: 'custom', logic: 'products_ordered_not_includes' },
        includes_all: { method: 'custom', logic: 'products_ordered_includes_all' },
        blank:        { method: 'custom', logic: 'products_ordered_blank' }
      }

      def initialize(collection, operator, values)
        @operator = operator
        @values = values
        super(collection)
      end

      def filter_data
        perform
      end

      def products_ordered_includes
        user_collection.with_ordered_items.where(spree_line_items: { variant_id: values }).distinct
      end

      def products_ordered_not_includes
        user_collection.with_ordered_items.where.not(id: products_ordered_includes.pluck(:id))
      end

      def products_ordered_includes_all
        user_collection.joins(orders: :line_items).
                        select(select_query).
                        where(spree_orders: { state: 'complete' }).
                        where(spree_line_items: { variant_id: values }).
                        group('spree_users.id').
                        having("variants = ?", sorted_variants).distinct
      end

      def products_ordered_blank
        values ? user_collection.without_complete_orders : user_collection.without_complete_orders
      end

      def select_query
        # MySQL support
        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
          "spree_users.*, GROUP_CONCAT(DISTINCT(spree_line_items.variant_id) ORDER BY spree_line_items.variant_id) as variants"

        # Postgresql support
        else
          "spree_users.*, string_agg(DISTINCT(spree_line_items.variant_id), ',' ORDER BY spree_line_items.variant_id) as variants"
        end
      end

      def sorted_variants
        values.map(&:to_i).sort.join(',')
      end

    end
  end
end