$ ->
  $('.js_admin_menu').first().sidebar('attach events', '.js_admin_toggle_menu')
  $('.ui.dropdown').dropdown()
  publish_ajax = (checkbox, published) ->

  $('.js_admin_pulish_checkbox').checkbox
    onChange: ->
      $.ajax
        url: $(this).data('url')
        type: 'PUT'
        dataType: 'json'
        data: published:       $(this).parents('.js_admin_pulish_checkbox').hasClass('checked')
        success: (data) ->
          unless _.isBoolean(data.status)
            alert '操作失败！请联系管理员'
  true
