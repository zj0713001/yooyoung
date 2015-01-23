#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require underscore

#= require 3rd/slick
#= require 3rd/jquery.browser
#= require 3rd/jquery.lazyload
#= require 3rd/jquery.waterfall

#= require main/common/redraw_font_size

#= require turbolinks

$(document).on 'page:change', ->
  resize_delay_time = 100

  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"

  slick_lazy_load = (index) ->
    $target = $($('.js_main_home_index_banner_image')[index])
    if !_.isBoolean($target.data('loaded'))
      if $.browser.msie && $.browser.version < 9
        $target.css('filter', $target.data('filter'))
      else
        $target.css('background-image', $target.data('background-image'))
      $target.data('loaded', true)

  banner_info_fadein = (index) ->
    $.each $($('.slick-slide')[index]).find('.js_main_home_index_banner_item_delay'), (i, item) ->
      _.delay ->
        $(item).fadeIn()
      , $(item).data('time')

  $('.js_main_home_index_banner_slick').slick
    autoplay: true
    autoplaySpeed: 5000
    speed: 500
    fade: true
    slide: 'div'
    cssEase: 'linear'
    pauseOnHover: false
    arrows: false
    onBeforeChange: (slick, currentIndex, targetIndex) ->
      slick_lazy_load targetIndex
      $('.js_main_home_index_banner_item_delay').hide()
    onAfterChange: (slick, currentIndex) ->
      banner_info_fadein currentIndex
    onInit: ->
      slick_lazy_load 0
      $('.js_main_home_index_banner_item_delay').hide()
      banner_info_fadein 0

  $(window).load ->
    $('.js_main_home_index_section').waterfall
      colLength: 4
      autoresize: false

  $('.js_main_home_index_banner_slick_prev').on 'click', ->
    $('.js_main_home_index_banner_slick').slickPrev()

  $('.js_main_home_index_banner_slick_next').on 'click', ->
    $('.js_main_home_index_banner_slick').slickNext()

  if $.browser.msie && $.browser.version < 9
    fit_height = ->
      $('.js_main_home_index_banner_height').height($(window).height())
    lazy_fit_height = _.debounce(fit_height, resize_delay_time)
    $(window).resize(lazy_fit_height)

    resize_items_height = ->
      unit_length = ($(window).width() - 20) / 4 - 20;
      $.each $('.js_main_home_index_section_item'), (index, item) ->
        unit_number = parseInt($(item).data('height'))
        item_height = unit_length * unit_number + (unit_number-1) * 20
        $(item).height("#{item_height}px")

    reflow_home_index_section = ->
      resize_items_height()
      $('.js_main_home_index_section').waterfall('reflow')

    lazy_reflow_home_index_section = _.debounce(reflow_home_index_section, resize_delay_time)
    $(window).resize(lazy_reflow_home_index_section)

    $(window).trigger('resize')
  else
    reflow_home_index_section = ->
      $('.js_main_home_index_section').waterfall('reflow')
    lazy_reflow_home_index_section = _.debounce(reflow_home_index_section, resize_delay_time)
    $(window).resize(lazy_reflow_home_index_section)
