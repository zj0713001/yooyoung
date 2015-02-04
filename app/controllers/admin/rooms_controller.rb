class Admin::RoomsController < Admin::ApplicationController
  def update
    @room = model.find params[:id]
    authorize! :edit, Hotel

    @room.attributes = params[:room].permit!
    @success = @room.save

    respond_to do |format|
      format.json { render json: { status: @success } }
    end

  end
end
