$ ->
  if _.isElement($('.js_main_hotel_show')[0])
    animate_time = 500
    animate_bez = 'easeInOutQuart'

    init_height = ->
      $('.js_main_hotel_show_banner').height($(window).height())
      $('.js_main_hotel_show_content_package_container').height(_.min([$(window).height(), $(window).width()])-60)
    init_height()
    lazy_init_height = _.debounce(init_height, 500)
    $(window).resize(lazy_init_height)

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

    package_info_show = ($slick) ->
      $slick.data('show-info', true)
      $('.js_main_hotel_show_content_package_info').show()
      $('.js_main_hotel_show_content_package_opacity').fadeIn();
      $('.js_main_hotel_show_content_package_info').animate
        left: 0
      , animate_time, animate_bez
      .queue ->
        $('.js_main_hotel_show_content_package_text').fadeIn()
        $(this).dequeue()

    package_info_hide = ($slick) ->
      $slick.data('show-info', false)
      $('.js_main_hotel_show_content_package_opacity').hide();
      $('.js_main_hotel_show_content_package_info').css('left', '-450px')
      $('.js_main_hotel_show_content_package_info').hide()
      $('.js_main_hotel_show_content_package_text').hide()

    package_scroll_event = (event) ->
      $slick_active = $('.js_main_hotel_show_content_package .slick-active')
      if event.deltaY < 0
        if $slick_active.data('show-info')
          if $('.js_main_hotel_show_content_package .slick-slide').length == $slick_active.index()+1
            $('.js_main_hotel_show_content_package').data('package-scroll', false)
            $(document).unmousewheel()
          else
            $('.js_main_hotel_show_content_package').slickNext()
          package_info_hide($slick_active)
        else
          package_info_show($slick_active)
      else
        if $slick_active.data('show-info')
          package_info_hide($slick_active)
        else
          if $slick_active.index() == 0
            $('.js_main_hotel_show_content_package').data('package-scroll', false)
            $(document).unmousewheel()
          else
            $('.js_main_hotel_show_content_package').slickPrev()

    lazy_package_scroll_event = _.throttle package_scroll_event, 1000, { trailing: false }

    package_scroll = ->
      $('.js_main_hotel_show_content_package').data('package-scroll', true)
      $(document).mousewheel (event) ->
        event.preventDefault()
        event.stopPropagation()
        lazy_package_scroll_event(event)
        false

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
      if !$('.js_main_hotel_show_banner').data('is_banner_sliced') && $(this).scrollTop() > 0
        banner_slice()
      if $('.js_main_hotel_show_banner').data('is_banner_sliced')
        if $(this).scrollTop() == 0
          banner_close()
        package_top = parseInt($('.js_main_hotel_show_content_package').offset().top - 60)
        if Math.abs($(document).scrollTop() - package_top) > 100
          $(document).unmousewheel()
          $slick_active = $('.js_main_hotel_show_content_package .slick-active')
          package_info_hide($slick_active) if $slick_active.data('show-info')
          $('.js_main_hotel_show_content_package').data('skip', false) if $(document).scrollTop() < package_top
          $('.js_main_hotel_show_content_package').data('skip', true) if $(document).scrollTop() > package_top
          $('.js_main_hotel_show_content_package').data('package-scroll', false)
        if $(document).scrollTop() >= package_top && ($(document).scrollTop() - package_top) < 100 && !$('.js_main_hotel_show_content_package').data('package-scroll') && !$('.js_main_hotel_show_content_package').data('skip')
          $('.js_main_hotel_show_content_package').data('package-scroll', true)
          $('.js_main_hotel_show_content_package').data('skip', true)
          $(document).scrollTo($('.js_main_hotel_show_content_package').offset().top-60)
          package_scroll()
        if $(document).scrollTop() >= package_top && ($(document).scrollTop() - package_top) > $(window).height()
          $('.js_main_hotel_show_content_package').unslick();
          content_package_slick_bind()
      true

    _.delay ->
      window.scrollTo(0,0)
    , 500

    $('.js_main_hotel_show_content_nav').sticky
      topSpacing: 0

    $('body').scrollspy
      offset: 270
      target: '.js_main_hotel_show_content_nav'

    $('.js_main_hotel_show_content_package_simple').sticky
      topSpacing: -30
      stopScroll: $(this).height()
    $('.js_hotel_show_content_favorite_background').sticky
      topSpacing: 0
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
      $('.js_main_hotel_show_content_overview_images').slickPrev()

    $('.js_main_hotel_show_content_overview_slick_next').on 'click', ->
      $('.js_main_hotel_show_content_overview_images').slickNext()

    $('.js_main_hotel_show_content_overview_tab_item').on 'click', ->
      return if $(this).hasClass('active')
      $from = $(this).siblings('.active')
      $from.removeClass('active')
      $(this).addClass('active')
      $('.js_main_hotel_show_content_overview_item').eq($from.index()).hide()
      $('.js_main_hotel_show_content_overview_item').eq($(this).index()).fadeIn()

    content_package_slick_bind = ->
      $('.js_main_hotel_show_content_package').slick
        accessibility: false
        speed: animate_time
        pauseOnHover: false
        draggable: false
        arrows: false
        infinite: false
        touchMove: false
        lazyLoad: 'progressive'
    content_package_slick_bind()

    $('.js_main_hotel_show_rooms_tab li').on 'click', ->
      return if $(this).hasClass('active')
      $target = $(".js_main_hotel_show_room_photos#{$(this).data('id')}")
      $active_target = $target.siblings('.active')
      $active_target.find('.js_main_hotel_show_room_photo').unslick()
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
      $(this).parents('.js_main_hotel_show_room_photos').find('.js_main_hotel_show_room_photo').slickPrev()

    $('.js_main_hotel_show_room_photos_slick_next').on 'click', ->
      $(this).parents('.js_main_hotel_show_room_photos').find('.js_main_hotel_show_room_photo').slickNext()

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
      $(this).siblings('.js_hotel_show_content_favorite_photos').slickPrev()

    $('.js_hotel_show_content_favorite_photos_slick_next').on 'click', ->
      $(this).siblings('.js_hotel_show_content_favorite_photos').slickNext()
