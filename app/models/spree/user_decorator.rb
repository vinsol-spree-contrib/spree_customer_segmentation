Spree::User.class_eval do

  def self.email_not_in(values)
    ransack({ email_not_in: values }).result
  end
end
