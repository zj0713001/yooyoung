$ ->
  $('.js_main_payment_new').on 'click', ->
    $(this).parents('.js_main_my_index_trades_item').find('.js_main_payment_services').slideDown()

  $('.js_main_payment_pay').on 'click', ->
    $(this).parents('.js_main_payment_services').find('.js_main_payment_paying').show()

  check_success = (that, success, failure) ->
    $.ajax
      url: $(that).data('url')
      type: 'GET'
      dataType: 'json'
      beforeSend: ->
        $(that).addClass('ajax_disabled')
      success: (data) ->
        if data.status == true
          success(that)
        else
          failure(that)
      complete: ->
        $(that).removeClass('ajax_disabled')

  $('.js_main_payment_success').on 'click', ->
    check_success(this, (that) ->
      location.href = $(that).data('url')
    , (that) ->
      $(that).parents('.js_main_payment_paying').find('.js_main_payment_error').show()
    )
  $('.js_main_payment_failure').on 'click', ->
    check_success(this, (that) ->
      location.href = $(that).data('url')
    , (that) ->
      $(that).parents('.js_main_payment_paying').hide()
    )
