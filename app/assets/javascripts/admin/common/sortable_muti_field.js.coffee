$ ->
  # $(".js_admin_sortable_muti_fields").sortable
  #   placeholder: "ui-state-highlight"
  # $(".js_admin_sortable_muti_fields").disableSelection()

  $('.js_admin').on 'click', '.js_admin_sortable_muti_add', ->
    $last_field = $(this).parents('.js_admin_sortable_muti_fields').find('.js_admin_sortable_muti_field:last')
    $last_field.after("<div class='field js_admin_sortable_muti_field'>#{$last_field.html()}</div>")
