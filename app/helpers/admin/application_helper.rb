module Admin::ApplicationHelper
  def sortable_muti_fields(fields, field_name)
    render 'admin/shared/sortable_muti_fields/edit', fields: fields, field_name: field_name
  end

  def show_muti_fields(fields)
    render 'admin/shared/sortable_muti_fields/show', fields: fields
  end
end
