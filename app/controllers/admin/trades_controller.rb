class Admin::TradesController < Admin::ApplicationController
  def index
    @trades = model
    ._where(permited_params[:where])
    ._order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])
    @trades = @trades.none unless can?(:index, model)

    respond_with(@trades)
  end

  def show
    authorize! :show, model

    @trade = model.find_by trade_no: params[:id]
  end

  def edit
    authorize! :edit, model

    @trade = model.find_by trade_no: params[:id]

    render_options = request.xhr? ? { layout: false} : {}
    case params[:render]
    when 'confirm'
      render :confirm, render_options
    when 'reject'
      render :reject, render_options
    else
      render :show, render_options
    end
  end

  def update
    @trade = model.find_by trade_no: params[:id]

    authorize! :edit, model
    @trade.attributes = params[:trade].permit!
    @trade.editor = current_user

    case params[:command]
    when 'confirm'
      @trade.confirm
    when 'reject'
      @trade.reject
    end

    @success = @trade.save

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { status: @success } }
    end
  end
end
