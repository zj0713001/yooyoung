$ ->
  $('.js_main_registration_send_sms_captcha').on 'click', ->
    user_phone = $('.js_main_registration_user_phone').val()
    if Boolean(user_phone.length)
      $.ajax
        url: $(this).data('url')
        type: 'GET'
        dataType: 'json'
        data: 'user[phone]': user_phone
        success: (data) ->
          console.log data
