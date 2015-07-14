class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :normal_narrow_url
end
