#= require jquery
#= require jquery_ujs
#= require underscore
#= require jquery.validate
#= require jquery.validate.additional-methods
#= require 3rd/jquery.validate.methods
#= require 3rd/jquery.validate.zh-CN
#= require 3rd/jquery.scrollTo
#= require 3rd/jquery.browser
#= require 3rd/jquery.lazyload
#= require 3rd/jquery.mousewheel
#= require 3rd/jquery.easing
#= require 3rd/datepicker/bootstrap-datepicker
#= require 3rd/datepicker/bootstrap-datepicker.zh-CN
#= require 3rd/jquery.sticky
#= require 3rd/jquery.placeholders
#= require 3rd/slick
#= require 3rd/velocity
#= require 3rd/velocity.ui
#= require 3rd/moment
#= require 3rd/moment.zh-cn
#= require 3rd/jquery.filepicker
#= require 3rd/jquery.tooltipster

#= require main/3rd/jquery.validate.default
#= require main/common/redraw_font_size
#= require main/common/datepocker_ext
#= require main/common/filepicker_ext
#= require main/common/footer
#= require avalon.shim

#= require bootstrap/scrollspy
#= require bootstrap/tab

#= require main/devise/registrations
#= require main/devise/sessions
#= require main/devise/passwords
#= require main/trades
#= require main/hotels
#= require main/payments

$ ->
  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"
