#= require jquery
#= require jquery_ujs
#= require jquery.turbolinks
#= require turbolinks
#= require underscore
#= require jquery.validate
#= require jquery.validate.additional-methods
#= require jquery.validate.localization/messages_zh
#= require 3rd/jquery.validate.methods
#= require 3rd/jquery.scrollTo
#= require 3rd/jquery.browser
#= require 3rd/jquery.lazyload
#= require 3rd/jquery.mousewheel
#= require 3rd/jquery.easing
#= require 3rd/jquery.sticky
#= require 3rd/jquery.placeholders
#= require 3rd/slick
#= require 3rd/velocity
#= require 3rd/velocity.ui
#= require main/3rd/jquery.validate.default
#= require main/common/redraw_font_size

#= require bootstrap/scrollspy
#= require bootstrap/tab

#= require main/devise/registrations
#= require main/devise/sessions
#= require main/hotels

# Turbolinks always on the last
#= require turbolinks

$ ->
  $(document).on 'page:change', ->
    $('img.lazy').lazyload
      threshold: 300
      effect: "fadeIn"
