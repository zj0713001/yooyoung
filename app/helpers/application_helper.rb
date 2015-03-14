module ApplicationHelper
  def background_image_cover(image)
    "url(#{image})"
  end

  def background_image_cover_filter(image)
    "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='#{image}',sizingMethod='scale')"
  end

  def show_currency(number)
    number_to_currency number, precision: 0, unit: ''
  end

  def default_meta_tags
    Settings.seo.merge(separator: "&mdash;".html_safe)
  end
end
