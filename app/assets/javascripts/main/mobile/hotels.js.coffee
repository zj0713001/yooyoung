$ ->
  if _.isElement($('.js_main_mobile_hotels_show')[0])
    $('.js_main_mobile_hotels_photo').on 'click', ->
      $.facebox
        div: '#main_mobile_hotels_album'
      $('#facebox .js_main_mobile_hotels_album').slick
        autoplay: true
        arrows: false
        lazyLoad: 'progressive'
        dots: true
        variableWidth: true
        infinite: false
      _.delay ->
        $('#facebox .js_main_mobile_hotels_album').fadeIn()
      , 100

    package_item_description_fadein = (index)->
      $('#facebox .js_main_mobile_photo_album_description').html($('#facebox .js_main_mobile_photo_album .slick-active').data('description')).fadeIn()
    package_item_description_fadeout = ->
      $('#facebox .js_main_mobile_photo_album_description').fadeOut()

    $('.js_main_mobile_package_photo').on 'click', ->
      $.facebox
        div: '#main_mobile_photo_album'

      $('#facebox .js_main_mobile_photo_album').slick
        arrows: false
        lazyLoad: 'progressive'
        dots: true
        variableWidth: true
        infinite: false
        onBeforeChange: ->
          package_item_description_fadeout()
        onAfterChange: ->
          package_item_description_fadein()
        onInit: ->
          _.delay ->
            package_item_description_fadein()
          , 100
      _.delay ->
        $('#facebox .js_main_mobile_photo_album').fadeIn()
      , 100
  $('body').on 'afterClose.facebox', ->
    $('#facebox').fadeOut ->
      $('#facebox .js_main_mobile_hotels_album').unslick()
      $('#facebox .js_main_mobile_photo_album').unslick()
      $('#facebox').remove()
      return
