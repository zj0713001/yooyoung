$ ->
  # $(".js_admin_sortable_muti_fields").sortable
  #   placeholder: "ui-state-highlight"
  # $(".js_admin_sortable_muti_fields").disableSelection()

  $('.js_admin').on 'click', '.js_admin_sortable_muti_add', ->
    $last_field = $(this).parents('.js_admin_sortable_muti_fields').find('.js_admin_sortable_muti_field:last')
    html = $("<p>").append($last_field.find('input').clone().attr('value', '')).html()
    $added_field = $('<div/>', class: 'field js_admin_sortable_muti_field').append(html)
    $last_field.after($added_field)
    $added_field.focus()
