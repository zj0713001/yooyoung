module ActiveRecord
  module CoverPhotoable
    extend ActiveSupport::Concern

    included do
      has_one :cover_photo, as: :target, dependent: :destroy, class_name: Photo
    end

    def cover_photo_id=(id)
      self.cover_photo = Photo.find(id)
    end
  end
end
