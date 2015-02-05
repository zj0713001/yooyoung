class Admin::PricesController < Admin::ApplicationController
  def index
    authorize! :edit, Hotel #TODO

    @target = params[:target].to_s.camelize.safe_constantize.find_by(id: params[:target_id])
    @hotel = @target.try(:hotel)

    respond_to do |format|
      format.html
      format.json {
        price_service = PriceService.new(@target)
        param_date = (params[:start_date] || Time.zone.now).to_date
        start_date = param_date.beginning_of_month.beginning_of_week
        end_date = param_date.end_of_month.end_of_week
        data = price_service.find_all_by_date(start_date, end_date)
        render json: { status: true, data: data }
      }
    end
  end

  def create
    @target = params[:target].to_s.camelize.safe_constantize.find_by_id(params[:target_id])

    price_service = PriceService.new(@target)
    data = params[:dates].map do |date|
      price_service.update_by_date(Date.parse(date.to_s), local_price: params[:local_price], price_unit: params[:price_unit], cost_price: params[:cost_price], sale_price: params[:sale_price])
    end

    respond_to do |format|
      format.json { render json: { status: true, data: data } }
    end
  end

  def update
  end
end
