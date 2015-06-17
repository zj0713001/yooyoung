$ ->
  if _.isElement($('.js_main_hotel_show')[0])
    animate_time = 500
    animate_bez = 'easeInOutQuart'

    cancel_scroll = ->
      $(document).mousewheel (event) ->
        event.preventDefault()
        event.stopPropagation()
        if event.deltaY < 0
          $(document).scrollTo(1)
        false

    reset_scroll = ->
      _.delay ->
        $(document).unmousewheel()
      , 850

    cancel_scroll()

    banner_slice = ->
      return if $('.js_main_hotel_show_banner').data('is_banner_slicing')

      $('.js_main_hotel_show_banner').data('is_banner_slicing', true)
      $('.js_main_hotel_show_banner_down').addClass('hidden')
      $('.js_main_hotel_show_banner_booking').addClass('hidden')
      $('.js_main_hotel_show_banner_first_half').animate
        top: "#{100-$(window).height()}"
      , animate_time, animate_bez
      $('.js_main_hotel_show_banner_section_block').addClass('hotel-show-banner-section--sliced')
      $('.js_main_hotel_show_banner_section').animate
        fontSize: "16px"
      , animate_time, animate_bez
      .queue ->
        $('.js_main_hotel_show_banner_section').animate
          top: "170"
        , animate_time, animate_bez
        $(this).dequeue()
      $('.js_main_hotel_show_banner_second_half').animate
        bottom: '-100%'
      , animate_time, animate_bez
      .queue ->
        $('.js_main_hotel_show_content').animate
          marginTop: "#{180-$(window).height()}"
        , animate_time, animate_bez
        $('.js_main_hotel_show_banner').data('is_banner_sliced', true)
        $('.js_main_hotel_show_banner').data('is_banner_slicing', false)
        reset_scroll()
        $(this).dequeue()
        true
    $('.js_main_hotel_show_banner_down').on 'click', ->
      banner_slice()

    banner_close = ->
      return if $('.js_main_hotel_show_banner').data('is_banner_slicing')

      $('.js_main_hotel_show_banner').data('is_banner_slicing', true)
      $('.js_main_hotel_show_banner_down').removeClass('hidden')
      $('.js_main_hotel_show_banner_booking').removeClass('hidden')
      $('.js_main_hotel_show_content').css('margin-top', 0)
      $('.js_main_hotel_show_banner_section').animate
        fontSize: "12px"
        top: "50%"
      , animate_time, animate_bez
      .queue ->
        $('.js_main_hotel_show_banner_section_block').removeClass('hotel-show-banner-section--sliced')
        $(this).dequeue()
      $('.js_main_hotel_show_banner_first_half').animate
        top: "-50%"
      , animate_time, animate_bez
      $('.js_main_hotel_show_banner_second_half').animate
        bottom: '-50%'
      , animate_time, animate_bez
      .queue ->
        $('.js_main_hotel_show_banner').data('is_banner_sliced', false)
        $('.js_main_hotel_show_banner').data('is_banner_slicing', false)
        cancel_scroll()
        $(this).dequeue()
        true


    $(document).on 'scroll', (e) ->
      setTimeout ->
        if !$('.js_main_hotel_show_banner').data('is_banner_sliced') && $(this).scrollTop() > 0
          banner_slice()
        if $('.js_main_hotel_show_banner').data('is_banner_sliced')
          if $(this).scrollTop() == 0
            banner_close()
          if $(this).scrollTop() > $('.js_main_hotel_show_content_favorite').offset().top
            min_price = $('.js_main_hotel_show_banner_booking').data('favorite-min-price')
            days = $('.js_main_hotel_show_banner_booking').data('favorite-package-days')
          else
            min_price = $('.js_main_hotel_show_banner_booking').data('package-min-price')
            days = $('.js_main_hotel_show_banner_booking').data('package-days')
          $('.js_main_hotel_show_package_min_price').text(min_price) if parseInt(min_price) != parseInt($('.js_main_hotel_show_package_min_price'))
          $('.js_main_hotel_show_package_days').text("#{parseInt(days)+1}天#{parseInt(days)}晚")
      , 1
      true

    _.delay ->
      window.scrollTo(0,0)
    , 500

    $('.js_main_hotel_show_content_nav').sticky
      topSpacing: 0

    $('body').scrollspy
      offset: 270
      target: '.js_main_hotel_show_content_nav'

    $('.js_main_hotel_show_content_package_section').slick
      autoplay: true
      autoplaySpeed: animate_time * 10
      speed: 500
      slide: 'div'
      cssEase: 'linear'
      pauseOnHover: true
      dots: false
      arrows: false

    $('.js_main_hotel_show_content_package_section_prev').on 'click', ->
      $('.js_main_hotel_show_content_package_section').slick('slickPrev')

    $('.js_main_hotel_show_content_package_section_next').on 'click', ->
      $('.js_main_hotel_show_content_package_section').slick('slickNext')

    $('.js_hotel_show_content_favorite_background').sticky
      topSpacing: 60
      wrapperClassName: 'hotel-show-content-favorite__package-background'

    content_overview_info_fadeout = ->
      $('.js_main_hotel_show_content_overview_info').fadeOut()

    content_overview_info_fadein = (index) ->
      info = $(".js_main_hotel_show_content_overview_images .slick-slide:eq(#{index}) img").data('info')
      $('.js_main_hotel_show_content_overview_info').text(info)
      $('.js_main_hotel_show_content_overview_info').fadeIn()

    $('.js_main_hotel_show_content_overview_images').slick
      autoplay: true
      autoplaySpeed: animate_time * 10
      speed: 500
      fade: true
      slide: 'div'
      cssEase: 'linear'
      pauseOnHover: true
      dots: true
      arrows: false
      lazyLoad: 'progressive'
      onBeforeChange: ->
        content_overview_info_fadeout()
      onAfterChange: (slick, currentIndex) ->
        content_overview_info_fadein currentIndex
      onInit: ->
        content_overview_info_fadein 0

    $('.js_main_hotel_show_content_overview_slick_prev').on 'click', ->
      $('.js_main_hotel_show_content_overview_images').slick('slickPrev')

    $('.js_main_hotel_show_content_overview_slick_next').on 'click', ->
      $('.js_main_hotel_show_content_overview_images').slick('slickNext')

    $('.js_main_hotel_show_content_overview_tab_item').on 'click', ->
      return if $(this).hasClass('active')
      $from = $(this).siblings('.active')
      $from.removeClass('active')
      $(this).addClass('active')
      $('.js_main_hotel_show_content_overview_item').eq($from.index()).hide()
      $('.js_main_hotel_show_content_overview_item').eq($(this).index()).fadeIn()

    $('.js_main_hotel_show_rooms_tab li').on 'click', ->
      return if $(this).hasClass('active')
      $target = $(".js_main_hotel_show_room_photos#{$(this).data('id')}")
      $active_target = $target.siblings('.active')
      $active_target.find('.js_main_hotel_show_room_photo').slick('unslick')
      $active_target.removeClass('active blur')
      $("##{$active_target.attr('id')}_info").hide()
      $(this).siblings('.active').removeClass('active')
      $target.addClass('active')
      $(this).addClass('active')
      $target.find('.js_main_hotel_show_room_photo').slick
        autoplay: true
        autoplaySpeed: animate_time * 10
        speed: animate_time
        fade: true
        arrows: false
        lazyLoad: 'progressive'
        pauseOnHover: true
        dots: true
    $(".js_main_hotel_show_room_photos.active .js_main_hotel_show_room_photo").slick
      autoplay: true
      autoplaySpeed: animate_time * 10
      speed: animate_time
      fade: true
      arrows: false
      lazyLoad: 'progressive'
      pauseOnHover: true
      dots: true

    $('.js_main_hotel_show_room_photos_slick_prev').on 'click', ->
      $(this).parents('.js_main_hotel_show_room_photos').find('.js_main_hotel_show_room_photo').slick('slickPrev')

    $('.js_main_hotel_show_room_photos_slick_next').on 'click', ->
      $(this).parents('.js_main_hotel_show_room_photos').find('.js_main_hotel_show_room_photo').slick('slickNext')

    $('.js_main_hotel_show_rooms_info_show').on 'click', ->
      $target = $('.js_main_hotel_show_room_photos.active')
      $target.addClass('blur')
      $("##{$target.attr('id')}_info").fadeIn()
    $('.js_main_hotel_show_room_infos').on 'click', ->
      $(this).fadeOut()
      $('.js_main_hotel_show_room_photos.active').removeClass('blur')

    $('.js_hotel_show_content_favorite_help').on 'click', ->
      $('.js_hotel_show_content_favorite_explain').slideToggle(100)

    $('.js_hotel_show_content_favorite_photos').slick
      autoplay: false
      fade: true
      arrows: false
      lazyLoad: 'progressive'
      dots: true

    $('.js_hotel_show_content_favorite_photos_slick_prev').on 'click', ->
      $(this).siblings('.js_hotel_show_content_favorite_photos').slick('slickPrev')

    $('.js_hotel_show_content_favorite_photos_slick_next').on 'click', ->
      $(this).siblings('.js_hotel_show_content_favorite_photos').slick('slickNext')

    $(window).on 'load', ->
      $.ajax
        url: $('.js_main_hotel_show_banner_booking').data('url')
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          if data.status
            $('.js_main_hotel_show_banner_booking').data('favorite-min-price', data.data.favorite_price)
