$(document).on 'page:change', ->
  $.facebox.settings.inited = false
  $('a[rel*=facebox]').facebox()
