namespace :photos do
  desc '删除无用的photos'
  task clear: :environment do
    used_photo_ids = [Hotel, HotelPackage, HotelPackageItem, Room].map do |klass|
      klass.pluck(:cover_photo_id)
    end.flatten.compact.uniq
    Photo.where(target: nil, target_id: nil).where('id NOT IN (?)', used_photo_ids).each do |photo|
      photo.delete
      FileUtils.rm_rf File.dirname photo.image.path
    end
  end
end
