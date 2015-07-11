$ ->
  # $(".js_admin_sortable_muti_fields").sortable
  #   placeholder: "ui-state-highlight"
  # $(".js_admin_sortable_muti_fields").disableSelection()

  $('.js_admin').on 'click', '.js_admin_sortable_muti_add', ->
    $fields = $(this).parents('.js_admin_sortable_muti_fields')
    $field_html = $fields.find('.js_admin_sortable_muti_field_html').val()
    $fields.find('.js_admin_sortable_muti_field:last').after($field_html)
