Spree::Address.class_eval do

  ransacker :full_name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
      [Arel::Nodes::NamedFunction.new('concat_ws',
        [Arel::Nodes::SqlLiteral.new("' '"), parent.table[:firstname], parent.table[:lastname]])])
  end

  def address
    "#{address1} #{address2} #{city}, #{state.name}, #{country.name}"
  end

  self.whitelisted_ransackable_attributes += %w(full_name phone)

end
