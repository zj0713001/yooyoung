$ ->
  if _.isElement($('.js_mobile_main_sessions_sign_up')[0])
    $('.js_mobile_main_sessions_sign_up').validate
      rules:
        'user[phone]':
          required: true
          isMobile: true
        'user[password]':
          required: true
          minlength: 6
        'user[password_confirmation]':
          required: true
          equalTo: '.js_mobile_main_sessions_password'
        'sms_captcha':
          required: true
          number: true
          minlength: 6
          maxlength: 6
      messages:
        'user[password_confirmation]':
          equalTo: "两次密码不一致"
        'sms_captcha':
          required: "请输入正确的验证码"
          number: "请输入正确的验证码"
          minlength: "请输入正确的验证码"
          maxlength: "请输入正确的验证码"
      errorPlacement: (error, element) ->
        $error_group = error.addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_error_message')
        $error_group.insertAfter(element)
      success: (label) ->
        $(label).closest('.js_mobile_main_sessions_new_form_error_message').remove()
      errorElement: 'div'


    $('.js_mobile_main_sessions_phone').on 'input', ->
      $(this).siblings('.js_mobile_main_sessions_new_form_error_message').remove()
    $('.js_mobile_main_sessions_phone').on 'blur', ->
      return false if $(this).hasClass('ajax_disabled')
      return false unless $(this).valid()
      user_phone = $(this).val()
      $.ajax
        url: $(this).data('url')
        type: 'POST'
        dataType: 'json'
        data: 'user[phone]': user_phone
        context: this
        beforeSend: ->
          $(this).addClass('ajax_disabled')
          $(this).siblings('.js_mobile_main_sessions_new_form_error_message').remove()
        success: (data) ->
          if data.status == false
            message = if data.error_code == 6 then '电话号码已经注册，请您登录。' else '注册出现问题，请联系网站客服处理。'
            $error_message = $('<div>').addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_error_message').text(message)
            $error_message.insertAfter $(this)
            $('.js_mobile_main_sessions_captcha_button').addClass('disabled')
          else
            $('.js_mobile_main_sessions_captcha_button').removeClass('disabled')
        complete: ->
          $(this).removeClass('ajax_disabled')

    $('.js_mobile_main_sessions_captcha_button').on 'click', ->
      return false if $(this).hasClass('ajax_disabled') || $(this).hasClass('disabled')
      return false unless $('.js_mobile_main_sessions_phone').valid()
      $.ajax
        url: $(this).data('url')
        type: 'GET'
        dataType: 'json'
        data: 'user[phone]': $('.js_mobile_main_sessions_phone').val()
        context: this
        beforeSend: ->
          $(this).addClass('ajax_disabled disabled')
          $('.js_mobile_main_sessions_new_form_captcha_message').remove()
        success: (data) ->
          if data.status == true
            $('.js_mobile_main_sessions_send_captcha').hide()
            $('.js_mobile_main_sessions_captcha_sending').show()
            count_down()
          else
            message = if data.error_code == 9 then '验证码发送超过当日限额。（每日最多发送5次）' else '验证码发送失败，请联系网站客服处理。'
            $error_message = $('<div>').addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_captcha_message').text(message)
            $('.js_mobile_main_sessions_captcha').append($error_message)
        complete: ->
          $(this).removeClass('ajax_disabled')
          $('.js_mobile_main_sessions_captcha_field').prop('disabled', false).focus()

    count_down = ->
      $time_view = $('.js_mobile_main_sessions_captcha_sending em')
      time = parseInt($time_view.data('time'))
      if time > 1
        time--
        $time_view.text(time)
        $time_view.data('time', time)
        setTimeout(count_down, 1000)
      else
        $('.js_mobile_main_sessions_captcha_sending').hide()
        $('.js_mobile_main_sessions_send_captcha').show()
        $time_view.data('time', 60)
        $('.js_mobile_main_sessions_captcha_button').removeClass('disabled')

    $('.js_mobile_main_sessions_sign_up').on 'submit', ->
      return false if $(this).hasClass('ajax_disabled')
      $('.js_mobile_main_sessions_new_form_captcha_message').remove()
      $('.js_mobile_main_sessions_captcha_field').prop('disabled', false)
      if $(this).valid()
        $.ajax
          url: $(this).attr('action')
          type: 'POST'
          dataType: 'json'
          data: $(this).serialize()
          context: this
          beforeSend: ->
            $(this).addClass('ajax_disabled')
          success: (data) ->
            if data.status == false
              message = if data.error_code == 10 then '验证码错误，请您核对，30分钟内输入有效。' else '注册出现问题，请联系网站客服处理。'
              $error_message = $('<div>').addClass('main-mobile-sessions-new-form__error-message js_mobile_main_sessions_new_form_captcha_message').text(message)
              $('.js_mobile_main_sessions_captcha').append($error_message)
            else
              Turbolinks.visit(jsvar.prev_page)
          complete: ->
            $(this).removeClass('ajax_disabled')
      false
