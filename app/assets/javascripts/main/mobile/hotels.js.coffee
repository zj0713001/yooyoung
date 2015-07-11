$ ->
  if _.isElement($('.js_main_mobile_hotels_show')[0])
    $('.js_main_mobile_hotels_album').slick
      autoplay: false
      arrows: false
      lazyLoad: 'progressive'
      dots: false
      infinite: true
      touchThreshold: 5
      speed: 500

    $('.js_main_mobile_hotels_album_prev').on 'click', ->
      $('.js_main_mobile_hotels_album').slick('slickPrev')

    $('.js_main_mobile_hotels_album_next').on 'click', ->
      $('.js_main_mobile_hotels_album').slick('slickNext')

    $('.js_main_mobile_hotels_rooms_dropdown').dropdown
      on: 'disable'#disable
      onChange: (value) ->
        return false if !value
        $('.js_main_mobile_hotels_rooms_album_info:visible').trigger('click')
        $('.js_main_mobile_hotels_rooms_album').hide()
        $(".js_main_mobile_hotels_rooms_album[data-room-id='#{value}']").fadeIn()

    _.each $('.js_main_mobile_hotels_rooms_photos img'), (img) ->
      $(img).width($(window).width() - 20)

    $('.js_main_mobile_hotels_rooms_photos').slick
      autoplay: false
      arrows: false
      lazyLoad: 'progressive'
      dots: false
      infinite: true
      touchThreshold: 5
      speed: 500
      variableWidth: true

    $('.js_main_mobile_hotels_rooms_album_prev').on 'click', ->
      $(this).siblings('.js_main_mobile_hotels_rooms_photos').slick('slickPrev')

    $('.js_main_mobile_hotels_rooms_album_next').on 'click', ->
      $(this).siblings('.js_main_mobile_hotels_rooms_photos').slick('slickNext')

    $('.js_main_mobile_hotels_rooms_album_info_btn').on 'click', ->
      $(this).siblings('.js_main_mobile_hotels_rooms_photos').addClass('blur')
      $(this).siblings('.js_main_mobile_hotels_rooms_album_info').fadeIn(200)

    $('.js_main_mobile_hotels_rooms_album_info').on 'click', ->
      $(this).fadeOut(200)
      $(this).siblings('.js_main_mobile_hotels_rooms_photos').removeClass('blur')

    $('.js_main_mobile_hotel_show_extras_more').on 'click', ->
      $(this).parents('.js_main_mobile_hotel_show_extras').toggleClass('hotel-show-extras--more')
