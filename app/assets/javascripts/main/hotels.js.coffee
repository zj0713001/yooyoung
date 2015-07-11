$ ->
  if _.isElement($('.js_main_hotel_show')[0])
    animate_time = 500
    animate_bez = 'easeInOutQuart'

    $('.js_main_hotel_show_nav').sticky
      topSpacing: 0
    $('.js_main_hotel_show_nav').on 'sticky-start', ->
      $(this).fadeIn()
    $('.js_main_hotel_show_nav').on 'sticky-end', ->
      $(this).fadeOut()

    $('body').scrollspy
      offset: 60
      target: '.js_main_hotel_show_nav'

    $('.js_main_hotel_show_overview_images').slick
      autoplay: true
      autoplaySpeed: animate_time * 10
      speed: animate_time
      fade: true
      slide: 'div'
      cssEase: 'linear'
      pauseOnHover: true
      dots: false
      arrows: false
      lazyLoad: 'ondemand'
      asNavFor: '.js_main_hotel_show_overview_images_nav'

    $('.js_main_hotel_show_overview_images_nav').slick
      autoplay: false
      slidesToShow: 10
      centerMode: true
      slide: 'div'
      cssEase: 'linear'
      dots: false
      arrows: false
      variableWidth: true
      focusOnSelect: true
      asNavFor: '.js_main_hotel_show_overview_images'

    $('.js_main_hotel_show_overview_slick_prev').on 'click', ->
      $('.js_main_hotel_show_overview_images').slick('slickPrev')

    $('.js_main_hotel_show_overview_slick_next').on 'click', ->
      $('.js_main_hotel_show_overview_images').slick('slickNext')

    $('.js_main_hotel_show_overview_images_model_images').slick
      autoplay: false
      autoplaySpeed: animate_time * 10
      speed: animate_time / 2
      slide: 'div'
      cssEase: 'linear'
      pauseOnHover: true
      dots: false
      arrows: false
      lazyLoad: 'progressive'

    $('.js_main_hotel_show_overview_images_model_images_slick_prev').on 'click', ->
      $('.js_main_hotel_show_overview_images_model_images').slick('slickPrev')

    $('.js_main_hotel_show_overview_images_model_images_slick_next').on 'click', ->
      $('.js_main_hotel_show_overview_images_model_images').slick('slickNext')

    $('.js_main_hotel_show_overview_images_fullscreen').on 'click', ->
      index =  $('.js_main_hotel_show_overview_images').slick('slickCurrentSlide')
      $('.js_main_hotel_show_overview_images_modal').modal('show')
      $('.js_main_hotel_show_overview_images_model_images').slick('slickGoTo', index, true)

    $('.js_main_hotel_show_overview_tab_item').on 'click', ->
      return if $(this).hasClass('active')
      $from = $(this).siblings('.active')
      $from.removeClass('active')
      $(this).addClass('active')
      $('.js_main_hotel_show_overview_item').eq($from.index()).hide()
      $('.js_main_hotel_show_overview_item').eq($(this).index()).fadeIn()

    $('.js_main_hotel_show_rooms_list li').on 'click', ->
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
        dots: false
    $(".js_main_hotel_show_room_photos.active .js_main_hotel_show_room_photo").slick
      autoplay: true
      autoplaySpeed: animate_time * 10
      speed: animate_time
      fade: true
      arrows: false
      lazyLoad: 'progressive'
      pauseOnHover: true
      dots: false

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

    $('.js_main_hotel_show_extras_simple').on 'click', ->
      $(this).parents('.js_main_hotel_show_extras').find('.js_main_hotel_show_extras_content').slideToggle()

    $(document).on 'scroll', (e) ->
      setTimeout ->
        package_index = _.findIndex $('.js_main_hotel_show_package'), (item) ->
          $(item).offset().top - 60 <= $('body').scrollTop() && $('body').scrollTop() <= $(item).offset().top + $(item).height() + 40
          $(item).offset().top + $(item).height() - 20 >= $('body').scrollTop()

        if package_index > -1
          $package = $($('.js_main_hotel_show_package')[package_index])

          if $package.data('id') != $('.js_main_hotel_show_package_days').data('id')
            $('.js_main_hotel_show_package_days').data('id', $package.data('id'))
            $('.js_main_hotel_show_package_days').text($package.data('text'))
            $('.js_main_hotel_show_package_min_price').text($package.data('price'))
      , 1
      true
