$ ->
  $('.js_main_registrations_send_sms_captcha').on 'click', ->
    user_phone = $('.js_main_registrations_phone_field').val()
    if $(this).hasClass('ajax_disabled')
      return false
    if !_.isEmpty($('.js_main_registrations_phone_field').val()) && $('.js_main_registrations_phone_field').valid()
      $.ajax
        url: $(this).data('url')
        type: 'GET'
        dataType: 'json'
        data: 'user[phone]': user_phone
        context: this
        beforeSend: ->
          $(this).addClass('ajax_disabled')
          $('.js_main_form_error_captcha').remove()
        success: (data) ->
          if data.status == true
            $('.js_main_registration_sms_captcha_button').hide()
            $('.js_main_registration_sms_captcha_sending').show()
            count_down()
          else
            message = if data.error_code == 9 then '验证码发送超过当日限额。（每日最多发送5次）' else '验证码发送失败，请联系网站客服处理。'
            $error_group = $('<div></div>').addClass('main-form__error-group-clearfix js_main_form_error_captcha').append($('<div></div>').addClass('main-form__error-group').append($('<div></div>').addClass('main-form__error-arrow')).append($('<div></div>').addClass('main-form__error-message').text(message)))
            $error_group.insertAfter $('.js_main_registrations_sms_captcha_field')
        complete: ->
          $(this).removeClass('ajax_disabled')
          $('.js_main_registrations_sms_captcha_field').prop('disabled', false).focus()
  count_down = ->
    $time_view = $('.js_main_registration_sms_captcha_sending em')
    time = parseInt($time_view.data('time'))
    if time > 1
      time--
      $time_view.text(time)
      $time_view.data('time', time)
      setTimeout(count_down, 1000)
    else
      $('.js_main_registration_sms_captcha_sending').hide()
      $('.js_main_registration_sms_captcha_button').show()
      $time_view.data('time', 60)
      $('.js_main_registrations_send_sms_captcha').removeClass('ajax_disabled')

  $('.js_main_registrations_new_form').validate
    rules:
      'user[phone]':
        required: true
        isMobile: true
      'user[password]':
        required: true
        minlength: 6
      'user[password_confirmation]':
        required: true
        equalTo: '.js_main_registrations_password_field'
      'sms_captcha':
        required: true
        number: true
        minlength: 6
        maxlength: 6
      'agree_me':
        required: true
    messages:
      'user[password_confirmation]':
        equalTo: "两次密码不一致"
      'sms_captcha':
        required: "请输入正确的验证码"
        number: "请输入正确的验证码"
        minlength: "请输入正确的验证码"
        maxlength: "请输入正确的验证码"
    errorPlacement: (error, element) ->
      if $(element).data('no-error-message') == true
        return true
      $error_group = $('<div></div>').addClass('main-form__error-group-clearfix js_main_form_error_group').append($('<div></div>').addClass('main-form__error-group').append($('<div></div>').addClass('main-form__error-arrow')).append(error.addClass('main-form__error-message')))
      $error_group.insertAfter(element)
    success: (label) ->
      $(label).closest('.js_main_form_error_group').remove()
    errorElement: 'div'

  $('.js_main_registrations_phone_field').on 'blur', ->
    if !_.isEmpty(user_phone = $('.js_main_registrations_phone_field').val()) && $('.js_main_registrations_phone_field').valid()
      $('.js_main_registrations_password_field').trigger 'focus'
      return false if $(this).hasClass('ajax_disabled')
      $.ajax
        url: $(this).data('url')
        type: 'POST'
        dataType: 'json'
        data: 'user[phone]': user_phone
        context: this
        beforeSend: ->
          $(this).addClass('ajax_disabled')
          $(this).siblings('.js_main_form_error_duplicate').remove()
        success: (data) ->
          if data.status == false
            message = if data.error_code == 6 then '电话号码已经注册，请您登录。' else '注册出现问题，请联系网站客服处理。'
            $error_group = $('<div></div>').addClass('main-form__error-group-clearfix js_main_form_error_duplicate').append($('<div></div>').addClass('main-form__error-group').append($('<div></div>').addClass('main-form__error-arrow')).append($('<div></div>').addClass('main-form__error-message').text(message)))
            $error_group.insertAfter $(this)
        complete: ->
          $(this).removeClass('ajax_disabled')
    else
      $(this).trigger 'focus'

  $('.js_main_registrations_password_field').on 'focus', ->
    if !_.isEmpty($('.js_main_registrations_phone_field').val()) && $('.js_main_registrations_phone_field').valid()
      $('.js_main_registrations_password_confirmation').show()

  $('.js_main_registrations_password_field').on 'blur', ->
    if !_.isEmpty($('.js_main_registrations_password_field').val()) && $('.js_main_registrations_password_field').valid()
      $('.js_main_registrations_password_confirmation_field').trigger 'focus'

  $('.js_main_registrations_password_confirmation_field').on 'focus', ->
    if !_.isEmpty($('.js_main_registrations_password_field').val()) && $('.js_main_registrations_password_field').valid()
      $('.js_main_registrations_captcha').show()

  $('.js_main_registrations_new_form').on 'submit', ->
    return false if $(this).hasClass('ajax_disabled')
    $('.js_main_form_error_captcha').remove()
    $('.js_main_registrations_sms_captcha_field').prop('disabled', false)
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
            $error_group = $('<div></div>').addClass('main-form__error-group-clearfix js_main_form_error_captcha').append($('<div></div>').addClass('main-form__error-group').append($('<div></div>').addClass('main-form__error-arrow')).append($('<div></div>').addClass('main-form__error-message').text(message)))
            $error_group.insertAfter $('.js_main_registrations_sms_captcha_field')
          else
            location.href = location.origin + jsvar.prev_page
        complete: ->
          $(this).removeClass('ajax_disabled')
    false
