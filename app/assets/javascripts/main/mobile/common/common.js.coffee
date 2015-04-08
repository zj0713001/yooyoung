$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:restore', ->
  NProgress.remove()
$(document).on 'page:change', ->
  NProgress.done()
  FastClick.attach(document.body)
  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"
