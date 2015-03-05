$ ->
  $(".js_main_date").datepicker
    format: "yyyy-mm-dd"
    weekStart: 1
    language: "zh-CN"
    autoclose: true
    todayHighlight: true
    orientation: "top autp"
    startDate: 'today'

  $(".js_main_date").on 'change', ->
    weekday_arr = ["一", "二", "三", "四", "五", "六", "日"]
    $(this).siblings('.js_main_weekday').text "（星期#{weekday_arr[moment($(this).val()).weekday()]}）"

  $('.js_main_weekday').on 'click', ->
    $(this).siblings('.js_main_date').datepicker('show')
