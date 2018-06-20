module Spree
  class User::EmailFilterService < BaseService

    def initialize(args = {})
      @category = Spree::User #args[:category]
      @metric = 'email' #args[:metric]
      @option = args[:option].to_sym #[ include, does not include, includes all ]
      @value = args[:value] # can be an array
    end

    def perform
      @category.ransack({ search_query => @value }).result
    end

    def search_query
      "#{@metric}_#{SEARCH_MATCHER_MAPPER[@option]}"
    end

    def filter_data
      send_request
    end

  end
end
