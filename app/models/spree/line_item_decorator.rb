Spree::LineItem.class_eval do

    # ransacker :id do
    #   if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
    #     Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    #   else
    #     Arel.sql("to_char(id, '9999999')")
    #   end
    # end

end
