$ ->
  $(document).on 'page:change', ->
    $("input.date, input[name$='_on]']").datepicker
      firstDay: 1
    $("input.datetime, input[name$='_at]']").datepicker
      firstDay: 1
    $("select.js_admin_search_select").select2()
