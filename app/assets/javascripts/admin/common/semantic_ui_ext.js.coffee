$ ->
  $(document).on 'page:change', ->
    $('.js_admin_menu').first().sidebar('attach events', '.js_admin_toggle_menu')
    $('.ui.dropdown').dropdown()
    $('.ui.checkbox').checkbox
      onChange: ->
        $input = $(this)
        $checkbox = $input.parents('.checkbox')
        $.ajax
          url: $input.data('url')
          type: 'PUT'
          dataType: 'json'
          data: published: $checkbox.checkbox('is').enabled()
          success: (data) ->
            unless _.isBoolean(data.status)
              alert '操作失败！请联系管理员'
    true
