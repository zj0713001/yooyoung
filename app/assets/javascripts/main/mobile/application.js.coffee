#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require underscore
#= require semantic-ui

#= require 3rd/jquery.lazyload
#= require 3rd/jquery.sticky
#= require 3rd/slick
#= require 3rd/nprogress
#= require 3rd/velocity
#= require 3rd/velocity.ui
#= require main/mobile/3rd/fastclick


#= require main/mobile/common/common
#= require main/mobile/common/nav

#= require main/mobile/home
#= require main/mobile/hotels

#= require turbolinks

$(document).on 'page:change', ->
  $('img.lazy').lazyload
    threshold: 300
    effect: "fadeIn"
