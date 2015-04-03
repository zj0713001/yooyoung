$ ->
  if _.isElement($('.js_mobile_main_sessions_sign_in')[0])
    $('.js_mobile_main_sessions_sign_in').validate
      rules:
        'user[phone]':
          required: true
          isMobile: true
        'user[password]':
          required: true
          minlength: 6
      errorPlacement: (error, element) ->
        $error_group = error.addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_error_message')
        $error_group.insertAfter(element)
      success: (label) ->
        $(label).closest('.js_mobile_main_sessions_new_form_error_message').remove()
      errorElement: 'div'

    $('.js_mobile_main_sessions_sign_in').on 'submit', ->
      return false if $(this).hasClass('ajax_disabled')
      if $(this).valid()
        $.ajax
          url: $(this).attr('action')
          type: 'POST'
          dataType: 'json'
          data: $(this).serialize()
          context: this
          beforeSend: ->
            $(this).addClass('ajax_disabled')
            $('.js_mobile_main_sessions_new_form_error_message').remove()
          success: (data) ->
            if data.status == false
              $error_message = $('<div>').addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_error_message').text('用户名或密码错误')
              $('.js_mobile_main_sessions_phone').after($error_message)
            else
              Turbolinks.visit(jsvar.prev_page)
          complete: ->
            $(this).removeClass('ajax_disabled')
      false
