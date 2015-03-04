class Admin::UsersController < Admin::ApplicationController
  def index
    @users = model.by_space(params[:space])

    @users = @users
    ._where(permited_params[:where])
    ._order((params[:order]||{id: :desc}))
    .page(params[:page]).per(params[:per_page])

    @users = @users.none unless can?(:index, model)

    respond_with(@users)
  end

  def links
    @users = model.where(permited_params[:where])
    @users = @users.none if @users.where_values_hash.blank?

    @admin_users = model.by_space(Role.spaces[:main])

    @links = Link.not_in(user_track_id: @admin_users.map(&:user_track).compact.uniq.map(&:_id)).includes(:user_track)
    @links = @links.where(user_track_id: @users.map(&:user_track).map(&:_id)) if @users.present?

    @links = @links.group_by{|link| link.fullpath}

    @links_data = @links.map do |link|
      OpenStruct.new({
        fullpath: link.first,
        count: link.last.count,
        anonymous_count: link.last.map(&:user_track).select{|ut| ut.user_id.blank?}.count,
        anonymous_user_count: link.last.map(&:user_track).select{|ut| ut.user_id.blank?}.uniq.compact.count,
        known_count: link.last.map(&:user_track).select{|ut| ut.user_id.present?}.count,
        known_user_count: link.last.map(&:user_track).select{|ut| ut.user_id.present?}.uniq.compact.count,
      })
    end.sort_by{|link| -link.count}

    @links_data = Kaminari.paginate_array(@links_data).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html
      format.json { render json: { data: @links_data } }
    end
  end

  def agents
    @users = model.where(permited_params[:where])
    @users = @users.none if @users.where_values_hash.blank?

    @admin_users = model.by_space(Role.spaces[:main])

    @links = Link.not_in(user_track_id: @admin_users.map(&:user_track).compact.uniq.map(&:_id)).includes(:user_track)
    @links = @links.where(user_track_id: @users.map(&:user_track).map(&:_id)) if @users.present?

    @links = @links.group_by do |link|
      user_agent = UserAgent.parse link.user_agent
      "#{user_agent.browser} #{user_agent.version.to_s.scan(/\d+/).first}"
    end

    @links_data = @links.map do |link|
      OpenStruct.new({
        user_agent: link.first,
        count: link.last.count,
        anonymous_count: link.last.map(&:user_track).select{|ut| ut.user_id.blank?}.count,
        anonymous_user_count: link.last.map(&:user_track).select{|ut| ut.user_id.blank?}.uniq.compact.count,
        known_count: link.last.map(&:user_track).select{|ut| ut.user_id.present?}.count,
        known_user_count: link.last.map(&:user_track).select{|ut| ut.user_id.present?}.uniq.compact.count,
      })
    end.sort_by{|link| -link.count}

    @links_data = Kaminari.paginate_array(@links_data).page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html
      format.json { render json: { data: @links_data } }
    end
  end

  def show
    authorize! :show, model

    @user = model.acquire params[:id]
  end

  def edit
    authorize! :edit, model

    @user = model.acquire params[:id]

    render :show
  end

  def update
    @user = model.acquire params[:id]

    authorize! :edit, model
    @user.attributes = params[:user].permit!
    @user.save

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { status: @success } }
    end
  end
end
