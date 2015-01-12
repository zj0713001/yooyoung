$ ->
  $('.js_main_registration_send_sms_captcha').on 'click', ->
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
        success: (data) ->
          if data.status == true
            $('.js_main_registration_sms_captcha_button').hide()
            $('.js_main_registration_sms_captcha_sending').show()
            count_down()
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
      $('.js_main_registration_send_sms_captcha').removeClass('ajax_disabled')

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
    if !_.isEmpty($('.js_main_registrations_phone_field').val()) && $('.js_main_registrations_phone_field').valid()
      $('.js_main_registrations_password_field').trigger 'focus'
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