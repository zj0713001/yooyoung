class Admin::ProvincesController < Admin::ApplicationController
  def index
    @provinces = model
    .where(params[:where].to_h)
    .order((params[:order]||{id: :desc}))
    .includes(:country)
    .page(params[:page]).per(params[:per_page])
    @provinces = @provinces.none unless can?(:index, model)

    respond_with(@provinces)
  end

  def show
    authorize! :show, model

    @province = model.acquire params[:id]
  end

  def new
    authorize! :create, model

    @province = model.new

    render :show
  end

  def create
    authorize! :create, model

    @province = model.new
    @province.editor = current_user
    @province.attributes = params[:province].permit!
    @province.save

    render :show
  end

  def edit
    authorize! :edit, model

    @province = model.acquire params[:id]

    render :show
  end

  def update
    @province = model.acquire params[:id]
    if params[:published].nil?
      authorize! :edit, model
      @province.attributes = params[:province].permit!
    else
      authorize! :publish, model
      @province.attributes = { published: params[:published] }
    end
    @success = @province.save

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { status: @success } }
    end
  end

  def delete
    authorize! :destroy, model
  end

  def destroy
    authorize! :destroy, model
  end
end
