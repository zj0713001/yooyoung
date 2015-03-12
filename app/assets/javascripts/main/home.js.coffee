#= require jquery
#= require jquery_ujs
#= require underscore

#= require 3rd/slick
#= require 3rd/jquery.browser
#= require 3rd/jquery.lazyload
#= require 3rd/jquery.waterfall
#= require 3rd/velocity
#= require 3rd/jquery.tooltipster

#= require main/common/redraw_font_size
#= require main/common/footer

$ ->
  resize_delay_time = 100

  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"

  slick_lazy_load = (index) ->
    $target = $($('.js_main_home_index_banner_image')[index])
    if !_.isBoolean($target.data('loaded'))
      $target.css('background-image', $target.data('background-image'))
      $target.data('loaded', true)

  banner_info_fadein = (index) ->
    $.each $($('.slick-slide')[index]).find('.js_main_home_index_banner_item_delay'), (i, item) ->
      _.delay ->
        $(item).fadeIn()
      , resize_delay_time * 2

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

  $('.js_main_home_index_banner_slick_prev').on 'click', ->
    $('.js_main_home_index_banner_slick').slickPrev()

  $('.js_main_home_index_banner_slick_next').on 'click', ->
    $('.js_main_home_index_banner_slick').slickNext()

  $('.js_main_home_index_section').waterfall
    colLength: 4
    autoresize: false

  $('.js_main_home_index_section_item').on
    mouseenter: ->
      $(this).velocity("stop").velocity({'height': '110%', 'width': '110%', 'top': '-5%', 'left': '-5%'}, 500, 'easeIn')
    mouseleave: ->
      $(this).velocity("stop").velocity({'height': '100%', 'width': '100%', 'top': '0', 'left': '0'}, 500, 'easeIn')
    , '.js_main_home_index_section_item_background'

  fit_height = ->
    $('.js_main_home_index_banner_height').height($(window).height())
  lazy_fit_height = _.debounce(fit_height, resize_delay_time)
  $(window).resize(lazy_fit_height)

  resize_items_height = ->
    unit_length = ($(window).width() - 100) / 4
    $.each $('.js_main_home_index_section_item'), (index, item) ->
      span_multiple = parseInt($(item).data('span'))
      height_multiple = parseInt($(item).data('height'))
      item_width = unit_length * span_multiple + (span_multiple-1) * 20
      item_height = unit_length * height_multiple + (height_multiple-1) * 20
      $(item).css('width', item_width).css('height', item_height)

  reflow_home_index_section = ->
    resize_items_height()
    _.delay ->
      $('.js_main_home_index_section').waterfall('reflow')
    , resize_delay_time

  lazy_reflow_home_index_section = _.debounce(reflow_home_index_section, resize_delay_time)
  $(window).resize(lazy_reflow_home_index_section)

  $(window).trigger('resize')
