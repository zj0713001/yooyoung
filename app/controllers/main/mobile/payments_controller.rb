class Main::Mobile::PaymentsController < Main::Mobile::ApplicationController
  def new
    @trade = Trade.find_by_param params[:trade_id]

    authorize! :update, model

    redirect_to @trade and return if !@trade.confirmed?


  end
end
