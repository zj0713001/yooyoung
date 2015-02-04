require 'carrierwave/processing/mime_types'
class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  storage :file

  process :set_content_type
  process :save_file_info_in_model

  def store_dir
    "uploads/#{mounted_as}/#{model_id_partition}"
  end

  def model_id_partition
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end

  def filename
    "#{secure_token}.#{extension}"
  end

  protected
  def extension
    file.extension
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, Digest::MD5.hexdigest(model.file_name)[0..7])
  end

  def save_file_info_in_model
    if model.new_record?
      model.file_name = file.filename
      model.file_size = file.size.to_s
      model.content_type = file.content_type
    end
  end
end
