$ ->
  js_admin_dynamic_field_html = (group) ->
    uuid = (new Date).getTime()
    field_html = $(group).data('field_html').replace(/\_\d+_/g, "_#{uuid}_").replace(/\[\d+\]/g, "[#{uuid}]")
    return field_html

  $(window).load ->
    $('.js_admin_dynamic_fields_group').each (index, group) ->
      $(group).data('field_html', $(group).find('.js_admin_dynamic_fields:last').html())

  $('.js_admin_dynamic_fields_group').on 'click', '.js_admin_dynamic_fields_add', ->
    $group = $(this).parents('.js_admin_dynamic_fields_group')
    field_html = js_admin_dynamic_field_html($group)
    $group.find('.js_admin_dynamic_fields:last').after(field_html)

  $('.js_admin_dynamic_fields_group').on 'click', '.js_admin_dynamic_fields_remove', ->
    console.log 'what'
    $(this).find(':checkbox').prop('checked', true)
    $(this).closest('.js_admin_dynamic_fields').hide()
