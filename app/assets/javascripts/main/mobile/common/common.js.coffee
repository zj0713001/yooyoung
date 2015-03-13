$(document).on 'page:fetch', ->
  NProgress.inc()
$(document).on 'page:restore', ->
  NProgress.remove()
$(document).on 'page:change', ->
  NProgress.done()
