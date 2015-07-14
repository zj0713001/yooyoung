class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :image, :normal_narrow_url
end
