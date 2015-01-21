$ ->
  $('.js_admin_dynamic_fields_group').each (index, group) ->
    $(group).data('field-html', $(group).find('.js_admin_dynamic_fields:last').html())

  js_admin_dynamic_field_html = (group) ->
    uuid = (new Date).getTime()
    field_html = $(group).data('field-html').replace(/\_\d+_/g, "_#{uuid}_").replace(/\[\d+\]/g, "[#{uuid}]")
    return field_html

  $('.js_admin_dynamic_fields_group').on 'click', '.js_admin_dynamic_fields_add', ->
    $group = $(this).parents('.js_admin_dynamic_fields_group')
    field_html = js_admin_dynamic_field_html($group)
    $group.find('.js_admin_dynamic_fields:last').after($('<div/>', class: 'js_admin_dynamic_fields').append(field_html))

  $('.js_admin_dynamic_fields_group').on 'click', '.js_admin_dynamic_fields_remove', ->
    $(this).find(':checkbox').prop('checked', true)
    $(this).closest('.js_admin_dynamic_fields').hide()
