$ ->
  $(document).on 'page:fetch', ->
    NProgress.inc()
  $(document).on 'page:restore', ->
    NProgress.remove()

  $(document).on 'page:change', ->
    NProgress.done()
    $("input.date, input[name$='_on]']").datepicker
      format: "yyyy-mm-dd"
      weekStart: 1
      language: "zh-CN"
      keyboardNavigation: false
      calendarWeeks: true
      autoclose: true
      todayHighlight: true
    $("input.datetime, input[name$='_at]']").datepicker
      format: "yyyy-mm-dd"
      weekStart: 1
      language: "zh-CN"
      keyboardNavigation: false
      calendarWeeks: true
      autoclose: true
      todayHighlight: true
    $("select.js_admin_search_select").select2()
