$ ->
  Dropzone.autoDiscover = false

  $('.js_admin_photos_uploader').each (index) ->
    $form = $(this).find('.js_admin_photos_form')
    max_file = if $form.data('multi') then null else 1
    $form.dropzone
      paramName: 'image'
      addRemoveLinks: true
      maxFiles: max_file
      success: (file, data) ->
        preview = file.previewElement
        if preview?
          preview.classList.add("dz-success")
          $(preview).data('photo-id', data.id)
          input_html = "<input type='hidden' class='js_admin_photos_field_#{data.id}' name=#{$form.data('field')} value=#{data.id} />"
          $('.js_admin_photos_fields').append(input_html)
      removedfile: (file) ->
        preview = file.previewElement
        if preview?
          photo_id = $(preview).data('photo-id')
          preview.parentNode.removeChild preview
          @_updateMaxFilesReachedClass()
          $(".js_admin_photos_field_#{photo_id}").remove()
