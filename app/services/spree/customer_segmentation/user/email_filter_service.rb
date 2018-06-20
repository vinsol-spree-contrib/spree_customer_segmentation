module Spree
  class CustomerSegmentation::User::EmailFilterService < CustomerSegmentation::BaseService

    SEARCH_LOGIC = {
      includes: { method: 'ransack', logic: 'email_in' },
      does_not_includes: { method: 'custom', logic: 'email_not_in' }  # change to ransack!!
    }

    def initialize(collection, operator, values)
      @operator = operator
      @values = values
      super(collection)
    end

    def filter_data
      perform
    end

  end
end
