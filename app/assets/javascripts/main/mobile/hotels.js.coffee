$ ->
  if _.isElement($('.js_main_mobile_hotels_show')[0])
    $('.js_main_mobile_hotels_album').slick
      autoplay: false
      arrows: false
      lazyLoad: 'progressive'
      dots: true
      infinite: false
      variableWidth: true

    $('.js_main_mobile_hotels_photo').on 'click', ->
      $('.js_main_mobile_hotels_album').slick('slickGoTo', 0, true)
      $('.js_main_mobile_hotels_photos_modal').dimmer('setting', 'transition', 'fade up').dimmer('show')

    package_item_description_fadein = (index)->
      $('.js_main_mobile_photo_album_description').html($('.js_main_mobile_photo_album .slick-active').data('description')).fadeIn()
    package_item_description_fadeout = ->
      $('.js_main_mobile_photo_album_description').fadeOut()

    $('.js_main_mobile_photo_album').on
      beforeChange: ->
        package_item_description_fadeout()
      afterChange: ->
        package_item_description_fadein()

    $('.js_main_mobile_photo_album').slick
      autoplay: false
      arrows: false
      lazyLoad: 'progressive'
      dots: true
      variableWidth: true
      infinite: false

    $('.js_main_mobile_package_photo').on 'click', ->
      $('.js_main_mobile_photo_album').slick('slickGoTo', 0, true)
      $('.js_main_mobile_hotels_package_modal').dimmer('setting', 'transition', 'fade up').dimmer('show')
      package_item_description_fadein()

    $('.js_main_mobile_hotels_package_modal').on 'click', (e) ->
      $(this).dimmer('hide')
      e.stopPropagation()

    $('.js_main_mobile_favorite_photo').slick
      autoplay: false
      arrows: false
      lazyLoad: 'progressive'
      dots: true
      variableWidth: true
      infinite: false

    $('.js_main_mobile_hotels_favorite_day').on 'click', ->
      $(this).find('.js_main_mobile_favorite_photo').slick('slickGoTo', 0, true)
      $(this).find('.js_main_mobile_hotels_favorite_day_modal').dimmer('setting', 'transition', 'fade up').dimmer('show')

    $('.js_main_mobile_hotels_favorite_day_modal').on 'click', (e) ->
      $(this).dimmer('hide')
      e.stopPropagation()
