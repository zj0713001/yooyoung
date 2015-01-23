$(document).on 'page:change', ->
  resize_delay_time = 100

  redraw_font_size = ->
    font_size = parseInt($(window).width() / 80)
    font_size = _.find [font_size, font_size+1], (size) ->
      size % 2 == 0
    font_size = 20 if font_size > 20
    $('body').css('font-size', font_size)
  redraw_font_size()
  lazy_redraw_font_size = _.debounce(redraw_font_size, resize_delay_time)
  $(window).resize(lazy_redraw_font_size)
