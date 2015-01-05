module ApplicationHelper
  def background_image_cover(image)
    "url(#{image})"
  end

  def background_image_cover_filter(image)
    "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='#{image}',sizingMethod='scale')"
  end
end
