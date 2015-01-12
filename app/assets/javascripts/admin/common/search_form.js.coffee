$ ->
  $('.js_admin_search_form').submit ->
    $(this).parent().addClass('loading')
    $(this).find("input[name$='[like]']").each ->
      $(this).val('%' + $(this).val() + '%') if !$(this).val().match(/\%|^\s*$/)
    $(this).find(':input').each ->
      $(this).attr('disabled', true) if $(this).val().match(/^\s*$/)
