class Link
  include Mongoid::Document
  include Mongoid::Timestamps

  field :remote_ip, type: String
  field :referer, type: String
  field :user_agent, type: String
  field :fullpath, type: String
  belongs_to :user_track

  index({ user_track_id: 1 }, { background: true })
  index({ user_agent: 1 }, { background: true })
  index({ fullpath: 1 }, { background: true })

  def request=(request)
    self.remote_ip = request.remote_ip
    self.referer = request.referer
    self.user_agent = request.user_agent
    self.fullpath = request.fullpath
  end
end
