require 'carrierwave/processing/mini_magick'
class AvatarUploader < FileUploader
  include CarrierWave::MiniMagick

  permissions 0666
  directory_permissions 0777
  process convert: :jpg

  WIDTH = 100
  HEIGHT = 100

  version :x1 do
    process :resize_to_fit => [WIDTH, HEIGHT]
  end

  version :x2 do
    process :resize_to_fit => [WIDTH*2, HEIGHT*2]
  end

  version :x3 do
    process :resize_to_fit => [WIDTH*3, HEIGHT*3]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected
  def extension
    :jpg
  end
end
