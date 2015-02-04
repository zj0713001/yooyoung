require 'carrierwave/processing/mini_magick'
class PhotoUploader < FileUploader
  include CarrierWave::MiniMagick

  permissions 0666
  directory_permissions 0755
  process convert: :jpg

  WIDTH = 100
  HEIGHT = 100

  version :huge do
    process :resize_to_fit => [WIDTH*12.8, HEIGHT*12.8]
  end

  version :huge_narrow do
    process :resize_to_fit => [WIDTH*12.8, HEIGHT*12.8]
    process :cropper_narrow
  end

  version :large, from_version: :huge do
    process resize_to_fit: [WIDTH*8, HEIGHT*8]
  end

  version :large_narrow, from_version: :huge do
    process resize_to_fit: [WIDTH*8, HEIGHT*8]
    process :cropper_narrow
  end

  version :normal, from_version: :large do
    process resize_to_fit: [WIDTH*6, HEIGHT*6]
  end

  version :normal_narrow, from_version: :large do
    process resize_to_fit: [WIDTH*6, HEIGHT*6]
    process :cropper_narrow
  end

  version :small, from_version: :normal do
    process resize_to_fit: [WIDTH*4, HEIGHT*4]
  end

  version :small_narrow, from_version: :normal do
    process resize_to_fit: [WIDTH*4, HEIGHT*4]
    process :cropper_narrow
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected
  def extension
    :jpg
  end

  def cropper_narrow
    manipulate! do |img|
      height = img[:width] * 0.625
      # height = img[:width] * 0.5625
      crop_y = (img[:height] - height) / 2.0
      img = img.crop "#{img[:width]}x#{height}+#{0}+#{crop_y}"
      img
    end
  end
end
