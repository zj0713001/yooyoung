#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require turbolinks
#= require underscore

#= require 3rd/slick
#= require 3rd/jquery.browser
#= require 3rd/jquery.lazyload
#= require 3rd/jquery.waterfall

$ ->
  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"

  slick_lazy_load = (index) ->
    $target = $($('.js_home_index_banner_image')[index])
    if !_.isBoolean($target.data('loaded'))
      if $.browser.msie && $.browser.version < 9
        $target.css('filter', $target.data('filter'))
      else
        $target.css('background-image', $target.data('background-image'))
      $target.data('loaded', true)

  $('.js_home_index_banner_slick').slick
    autoplay: true
    autoplaySpeed: 5000
    speed: 500
    fade: true
    slide: 'div'
    cssEase: 'linear'
    pauseOnHover: false
    onBeforeChange: (slick, currentIndex, targetIndex) ->
      slick_lazy_load targetIndex
    onInit: ->
      slick_lazy_load 0

  $('.js_home_index_banner_slick_prev').on 'click', ->
    $('.js_home_index_banner_slick').slickPrev()

  $('.js_home_index_banner_slick_next').on 'click', ->
    $('.js_home_index_banner_slick').slickNext()

  $('.js_home_index_section').waterfall
    colLength: 4
    autoresize: false

  if $.browser.msie && $.browser.version < 9
    fit_height = ->
      $('.js_home_index_banner_height').height($(window).height())
    lazy_fit_height = _.debounce(fit_height, 300)
    $(window).resize(lazy_fit_height)

    resize_items_height = ->
      unit_length = ($(window).width() - 20) / 4 - 20;
      $.each $('.js_home_index_section_item'), (index, item) ->
        unit_number = parseInt($(item).data('height'))
        item_height = unit_length * unit_number + (unit_number-1) * 20
        $(item).height("#{item_height}px")

    reflow_home_index_section = ->
      resize_items_height()
      $('.js_home_index_section').waterfall('reflow')

    lazy_reflow_home_index_section = _.debounce(reflow_home_index_section, 300)
    $(window).resize(lazy_reflow_home_index_section)

    $(window).trigger('resize')
  else
    reflow_home_index_section = ->
      $('.js_home_index_section').waterfall('reflow')
    lazy_reflow_home_index_section = _.debounce(reflow_home_index_section, 300)
    $(window).resize(lazy_reflow_home_index_section)
