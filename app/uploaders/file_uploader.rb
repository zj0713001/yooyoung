class FileUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "uploads/#{mounted_as}/#{model_id_partition}"
  end

  def model_id_partition
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end

  def filename
    if super.present?
      "#{secure_token}.#{extension}"
    end
  end

  protected
  def extension
    file.extension
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(4))
  end
end
