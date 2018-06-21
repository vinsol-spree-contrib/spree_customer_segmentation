module Spree
  class Admin::FiltersController < Admin::BaseController

    def new
      render
    end

    def create
      @results = CustomerSegmentation::SearchService.new(process_params).perform

      respond_to do |format|
        format.js
      end

    end

    private

      def process_params
        { term: create_term, values: create_values }
      end

      def create_term
        params[:metric] + '__' + params[:operator]
      end

      def create_values
        # SERVICE ??
        params[:operator] =~ /include/ ? params[:value].split : params[:value]
      end

  end
end
