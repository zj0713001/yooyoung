module Admin::SearchFormHelper
  def search_field_tag(object, field, field_type, options={})
    render "admin/shared/search/#{field_type}", object: object, field: field.to_s, options: options
  end

  def search_submit_tag
    submit_tag t('admin.search'), class: :'ui label blue button large'
  end

  def search_page_tag
    render "admin/shared/search/page"
  end

  def new_link_tag(object)
    link_to t('admin.new'), { action: :new }, class: :'ui label green button large' if can? :create, object
  end
end
