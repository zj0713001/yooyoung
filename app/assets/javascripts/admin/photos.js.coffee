$ ->
  admin_delete_photo = (url) ->
    $.ajax
      url: url
      type: 'DELETE'
      dataType: 'json'
  $('.js_admin').on 'click', '.js_admin_upload_file_remove', ->
    $file_field = $(this).parents('.js_admin_upload_file')
    admin_delete_photo("/admin/photos/#{$(this).data('image-id')}")
    $file_field.remove()

  # Add class .js_admin_upload to the body or form
  $('.js_admin').on 'click', '.js_admin_upload_field', ->
    return if $(this).data('fileuploaded')
    $(this).data('fileuploaded', true);
    $(this).prop('multiple', true) if $(this).data('multiple') == true
    $(this).fileupload
      url: $(this).data('url')
      dataType: 'json'
      autoUpload: false
      previewMaxWidth: 500
      previewMaxHeight: 500
    .on 'fileuploadadd', (e, data) ->
      $uploader = $(this).parents('.js_admin_uploader')
      if $(this).data('multiple') == false
        if data.image_id
          admin_delete_photo($(this).data('delete-url').replace('%23id', data.image_id))
        $uploader.find('.js_admin_upload_file').remove()
      data.context = $("<div/>").addClass("photo-uploader__file field js_admin_upload_file").appendTo($uploader.find('.js_admin_upload_files'))
      $.each data.files, (index, file) ->
        data.context.append($("<div/>").addClass('photo-uploader__file-name').text(file.name).prepend($("<i/>").addClass("black icon file image outline")))
        data.context.append $("<div/>").addClass('photo-uploader__file-size').text("#{file.size / 1000}kb").prepend($("<i/>").addClass("black icon info"))
        # data.context.append $("<textarea/>", {placeholder: '图片说明', wrap: false}).addClass('js_admin_upload_file_description')
        upload_button = $("<a/>").addClass("ui teal label large js_admin_upload_file_start").prop("disabled", true).text("上传").on "click", ->
          $this = $(this)
          button_data = $this.data()
          $this.off("click").removeClass('teal js_admin_upload_file_start').addClass('black').text("取消").on "click", ->
            $this.remove()
            button_data.abort()
          button_data.submit().always ->
            $this.remove()
        data.context.append upload_button.data(data)
        return
    .on 'fileuploadprocessalways', (e, data) ->
      index = data.index
      file = data.files[index]
      data.context.prepend($("<div/>").addClass('photo-uploader__file-preview').append(file.preview))
    .on 'fileuploadsubmit', (e, data) ->
      # data.formData = { image: data.files[0], description: data.context.find('.js_admin_upload_file_description').val() }
      data.formData = { image: data.files[0] }
    .on 'fileuploaddone', (e, data) ->
      unless data.image_id
        data.context.find('.js_admin_upload_file_description').remove()
        data.context.append $('<div/>').addClass('photo-uploader__file-url').text(data.result.image.image.url).prepend($("<i/>").addClass("black icon linkify"))
        # data.context.append $('<div/>').addClass('photo-uploader__file-description').text(data.result.description).prepend($("<i/>").addClass("black icon tag"))
        remove_button = $("<a/>").addClass("ui red label large js_admin_upload_file_remove").text("删除").data('image-id': data.result.id)
        data.context.append remove_button
        data.context.append $("<input/>", {'type': 'hidden', 'name': $(this).data('field'), 'value': data.result.id})
        data.image_id = data.result.id

  $('.js_admin').on 'click', '.js_admin_upload_start_all', ->
    $(this).siblings('.js_admin_upload_files').find('.js_admin_upload_file_start').trigger('click')
