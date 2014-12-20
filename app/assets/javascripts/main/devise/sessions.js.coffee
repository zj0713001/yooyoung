$ ->
  $('.js_main_sessions_new_form').validate
    rules:
      'user[phone]':
        required: true
        isMobile: true
      'user[password]':
        required: true
        minlength: 6
    errorPlacement: (error, element) ->
      $error_group = $('<div></div>').addClass('main-form__error-group-clearfix js_main_form_error_group').append($('<div></div>').addClass('main-form__error-group').append($('<div></div>').addClass('main-form__error-arrow')).append(error.addClass('main-form__error-message')))
      $error_group.insertAfter(element)
    success: (label) ->
      $(label).closest('.js_main_form_error_group').remove()
    errorElement: 'div'
