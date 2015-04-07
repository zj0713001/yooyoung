$ ->
  hide_nav = ->
    $('.js_main_mobile_nav').velocity("slideUp", {duration: 200})
    $('.js_main_mobile_nav_open').show()

  $('.js_main_mobile_nav_open').on 'click', ->
    $('.js_main_mobile_nav').velocity("slideDown", {duration: 200})
    $(this).hide()
  $('.js_main_mobile_nav_close').on 'click', ->
    hide_nav()
  $('.js_main_mobile').on 'click', (e) ->
    return unless $('.js_main_mobile_nav').is(':visible')
    unless $(e.target).hasClass('.js_main_mobile_nav') || _.isElement($(e.target).parents('.js_main_mobile_nav')[0])
      hide_nav()
