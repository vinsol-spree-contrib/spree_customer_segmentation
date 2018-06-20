module Spree
  class BaseService

    class NotImplementedError < StandardError; end

    def send_request
      perform
    end

    def perform
      raise NotImplementedError
    end

  end
end
