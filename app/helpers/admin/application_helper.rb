module Admin::ApplicationHelper
  def sortable_muti_fields(fields, field_name)
    render 'admin/shared/sortable_muti_fields/edit', fields: fields, field_name: field_name
  end

  def show_muti_fields(fields)
    render 'admin/shared/sortable_muti_fields/show', fields: fields
  end

  def all_cities_options_for_select(city_id)
    grouped_options_for_select(Country.active.includes(:cities).map{|country| { country.chinese => country.cities.map{|city| [city.chinese, city.id]}}}.inject(&:merge), city_id)
  end

  def admin_paginate_tag(collections)
    render 'admin/shared/admin_paginate', collections: collections
  end
end
