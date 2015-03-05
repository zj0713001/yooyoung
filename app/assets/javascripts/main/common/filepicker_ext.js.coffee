$ ->
  $("input[type='file']").each ->
    ui = null
    $(this).filepicker
      renderUI: (element, button, input, preview) ->
        if !ui
          ui = $('<div></div>').addClass('filepicker')
          ui.append preview
          ui.append $(button).addClass('filepicker__button')
          $(element).parent().prepend ui
        $(button).text $(element).data('label')
        false
      renderThumbnail: (img, file) ->
        $('.js_main_file_upload_preview').remove()
        $(img).wrap $('<div></div>').addClass('filepicker__preview')
        false
    return
