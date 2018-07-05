# This is done to get multiple variants when we rebuild the filter structure on page refresh.

Spree::Api::V1::VariantsController.class_eval do

  def show
    @variant = scope.includes(*variant_includes).find(process_id_param)
    respond_with(@variant)
  end

  def process_id_param
    if params[:id].present? && params[:id].include?(',')
      params[:id].presence.split(',')
    else
      params[:id]
    end
  end

end
