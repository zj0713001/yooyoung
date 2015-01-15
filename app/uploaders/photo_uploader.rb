require 'carrierwave/processing/mini_magick'
class PhotoUploader < FileUploader
  include CarrierWave::MiniMagick

  permissions 0666
  directory_permissions 0777
  process convert: :jpg

  WIDTH = 100
  HEIGHT = 100

  version :huge do
    process :resize_to_fit => [WIDTH*12.8, HEIGHT*12.8]
  end

  version :large, from_version: :huge do
    process resize_to_fit: [WIDTH*8, HEIGHT*8]
  end

  version :normal, from_version: :large do
    process resize_to_fit: [WIDTH*6, HEIGHT*6]
  end

  version :small, from_version: :normal do
    process resize_to_fit: [WIDTH*4, HEIGHT*4]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected
  def extension
    :jpg
  end
end
