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

  def all_provinces_options_for_select(province_id)
    grouped_options_for_select(Country.active.includes(:provinces).map{|country| { country.chinese => country.provinces.map{|province| [province.chinese, province.id]}}}.inject(&:merge), province_id)
  end

  def all_countries_options_for_select(country_id)
    options_for_select(Country.active.map{|country| { country.chinese => country.id}}.inject(&:merge), country_id)
  end

  def all_areas_options_for_select(area_id)
    options_for_select(Area.active.map{|area| { area.chinese => area.id}}.inject(&:merge), area_id)
  end

  def admin_paginate_tag(collections)
    render 'admin/shared/admin_paginate', collections: collections
  end

  def admin_publish_tag(object)
    if can? :publish, object.class
      render 'admin/shared/admin_publish', object: object
    end
  end
end
