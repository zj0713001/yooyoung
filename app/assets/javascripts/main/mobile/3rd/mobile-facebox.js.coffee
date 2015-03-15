(($) ->
  init = (settings) ->
    $('body').trigger 'init.facebox'
    imageTypes = $.facebox.settings.imageTypes.join('|')
    $.facebox.settings.imageTypesRegexp = new RegExp('\\.(' + imageTypes + ')(\\?.*)?$', 'i')
    if settings
      $.extend $.facebox.settings, settings
    $('body').append $.facebox.settings.faceboxHtml
    return

  fillFaceboxFromHref = (href, klass) ->
    # div
    if href.match(/#/)
      url = window.location.href.split('#')[0]
      target = href.replace(url, '')
      if target == '#'
        return
      $.facebox.reveal $(target).html(), klass
      # image
    else if href.match($.facebox.settings.imageTypesRegexp)
      fillFaceboxFromImage href, klass
      # ajax
    else
      fillFaceboxFromAjax href, klass
    return

  fillFaceboxFromImage = (href, klass) ->
    image = new Image

    image.onload = ->
      $.facebox.reveal '<div class="image"><img src="' + image.src + '" /></div>', klass
      return

    image.src = href
    return

  fillFaceboxFromAjax = (href, klass) ->
    $.facebox.jqxhr = $.get(href, (data) ->
      $.facebox.reveal data, klass
      return
    )
    return

  skipOverlay = ->
    $.facebox.settings.overlay == false or $.facebox.settings.opacity == null

  showOverlay = ->
    if skipOverlay()
      return
    if $('#facebox_overlay').length == 0
      $('body').append '<div id="facebox_overlay" class="facebox_hide"></div>'
    $('#facebox_overlay').hide().addClass('facebox_overlayBG').css('opacity', $.facebox.settings.opacity).click(->
      $('body').trigger 'close.facebox'
      return
    ).fadeIn 200
    false

  hideOverlay = ->
    if skipOverlay()
      return
    $('#facebox_overlay').fadeOut 200, ->
      $('#facebox_overlay').removeClass 'facebox_overlayBG'
      $('#facebox_overlay').addClass 'facebox_hide'
      $('#facebox_overlay').remove()
      return
    false

  scrollTop = null
  bodyElements = null

  $.facebox = (data, klass) ->
    if $('body>:visible:not(#facebox)').length == 0
      return
    $.facebox.loading data.settings or []
    if data.ajax
      fillFaceboxFromAjax data.ajax, klass
    else if data.image
      fillFaceboxFromImage data.image, klass
    else if data.div
      fillFaceboxFromHref data.div, klass
    else if $.isFunction(data)
      data.call $
    else
      $.facebox.reveal data, klass
    return

  ###
  # Public, $.facebox methods
  ###

  $.extend $.facebox,
    settings:
      opacity: 0.2
      overlay: false
      loadingImage: '/facebox/loading.gif'
      closeImage: '/facebox/closelabel.png'
      imageTypes: [
        'png'
        'jpg'
        'jpeg'
        'gif'
      ]
      faceboxHtml: '    <div id="facebox" style="display:none;">       <div class="popup">         <div class="content">         </div>       </div>     </div>'
    loading: ->
      init()
      if $('#facebox .loading').length == 1
        return true
      showOverlay()
      $('#facebox .content').empty().append '<div class="loading"></div>'
      $('#facebox').show().css
        top: 0
        left: $(window).width() / 2 - ($('#facebox .popup').outerWidth() / 2)
      $('body').on 'keydown.facebox', (e) ->
        if e.keyCode == 27
          $.facebox.close()
        true
      $('body').trigger 'loading.facebox'
      return
    reveal: (data, klass) ->
      $('body').trigger 'beforeReveal.facebox'
      if klass
        $('#facebox .content').addClass klass
      $('#facebox .content').empty().append data
      $('#facebox .popup').children().show 'normal'
      $('#facebox').css 'left', $(window).width() / 2 - ($('#facebox .popup').outerWidth() / 2)
      scrollTop = $(window).scrollTop()
      bodyElements = $('body>:visible:not(#facebox)')
      bodyElements.hide()
      $(window).scrollTop(0)
      $('#facebox').on 'click', ->
        $('body').trigger 'close.facebox'
      $('body').trigger('reveal.facebox').trigger 'afterReveal.facebox'
      return
    close: ->
      $('body').trigger 'close.facebox'
      false

  ###
  # Public, $.fn methods
  ###

  $.fn.facebox = (settings) ->
    init settings

  ###
  # Bindings
  ###

  $('body').on 'close.facebox', ->
    if $.facebox.jqxhr
      $.facebox.jqxhr.abort()
      $.facebox.jqxhr = null
    $('body').unbind 'keydown.facebox'
    bodyElements.show()
    $(window).scrollTop(scrollTop)
    $('body').trigger 'afterClose.facebox'
    $('#facebox .content').children().trigger('afterClose.facebox')
    hideOverlay()
    return
  return
) jQuery
