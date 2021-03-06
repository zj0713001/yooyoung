$ ->
  if _.isElement($('.js_main_trade_new')[0])
    trade = avalon.define 'main_trade_new', (vm) ->
      vm.hotel = jsvar.hotel
      vm.selected_room = null
      vm.start_day = ''
      vm.end_day = ''
      vm.days = vm.hotel.packages[0].days
      vm.end_day_weekday = ''
      vm.selected_package = null
      vm.selected_extras = []
      vm.$watch 'start_day', (day) ->
        return if _.isEmpty(vm.start_day)
        vm.select_package(vm.hotel.packages[0]) if !vm.selected_package
        end_day = moment(day).add(vm.days, 'days')
        weekday_arr = ["一", "二", "三", "四", "五", "六", "日"]
        vm.end_day = end_day.format('L')
        vm.end_day_weekday = "（星期#{weekday_arr[end_day.weekday()]}）"
        $.ajax
          url: $('.js_main_trade_new_form').data('price-url')
          type: 'GET'
          dataType: 'json'
          context: this
          data: { start_day: vm.start_day, hotel_id: vm.hotel.to_param }
          success: (data) ->
            if data.status == true
              vm.hotel.rooms = _.map vm.hotel.rooms, (room) ->
                room_data = _.find data.data.room_prices, (r) ->
                  r.id == room.id
                _.extend room, room_data
                room.is_price_loaded = true
                if vm.selected_room == room
                  vm.select_room(room)
                room
              $('.js_main_trade_new_room_photos').slick
                fade: true
                arrows: false
                lazyLoad: 'progressive'
                pauseOnHover: true
                dots: true
              $('.js_main_trade_new_room_photo_slick_prev').on 'click', ->
                $(this).siblings('.js_main_trade_new_room_photos').slick('slickPrev')
              $('.js_main_trade_new_room_photo_slick_next').on 'click', ->
                $(this).siblings('.js_main_trade_new_room_photos').slick('slickNext')
              vm.hotel.extra_services = _.map vm.hotel.extra_services, (extra_service) ->
                extra_service_data = _.find data.data.extra_prices, (ex) ->
                  ex.id == extra_service.id
                _.extend extra_service, extra_service_data
                extra_service
      vm.select_package = (p) ->
        vm.selected_package = p
        vm.days = p.days
        vm.calculate_price() if vm.selected_room?
      vm.$watch 'days', ->
        vm.$fire("start_day", vm.start_day, vm.start_day)
      vm.select_room = (room) ->
        return if _.isEmpty(vm.start_day)
        vm.selected_room = room
        vm.calculate_price()
      vm.is_selected_extra = (extra) ->
        _.contains vm.selected_extras, extra
      vm.select_extra = (extra) ->
        vm.selected_extras = if vm.is_selected_extra(extra)
          _.without vm.selected_extras, extra
        else
          _.union vm.selected_extras, [extra]
        vm.calculate_extra_price()
      vm.calculate_extra_price = ->
        extra_prices = _.map vm.selected_extras, (extra) ->
          extra.price * (parseInt(vm.people_num) + parseInt(vm.child_num))
        vm.extra_price = _.reduce extra_prices, (a, b) ->
          a + b
        , 0
      vm.calculate_price = ->
        room = vm.selected_room
        if room.is_price_loaded
          package_prices = _.find room.prices.package_prices, (prices) ->
            parseInt(prices.id) == parseInt(vm.selected_package.id)
          vm.package_price = package_prices.sale_price
          vm.extra_bed_price = room.prices.extra_bed_price.items[0].price
      vm.people_num = 2
      vm.child_num = 0
      vm.extra_bed_num = 0
      vm.$watch 'people_num', (num) ->
        return if _.isEmpty(num)
        num = parseInt(num)
        num = if _.isNaN(num) then 0 else num
        if vm.selected_room.population
          if vm.selected_room.population < num
            vm.extra_bed_num = num - vm.selected_room.population
          else
            vm.extra_bed_num = 0
          if vm.selected_room.is_price_loaded
            num = _.min [num, vm.selected_room.population+vm.selected_room.prices.extra_bed_price.limit]
        vm.people_num = num
        vm.calculate_extra_price()
        vm.attendences = _.times num, ->
          { name: '', phone: '' }
      vm.people_num_minus = ->
        vm.people_num-- if vm.people_num > 2
      vm.people_num_plus = ->
        vm.people_num++ if (vm.selected_room.population+vm.selected_room.prices.extra_bed_price.limit) > vm.people_num
      vm.child_num_minus = ->
        vm.child_num-- if vm.child_num > 0
      vm.child_num_plus = ->
        vm.child_num++ if vm.selected_room.prices.child_price.limit > vm.child_num
      vm.$watch 'child_num', (num) ->
        return if _.isEmpty(num)
        num = parseInt(num)
        num = if _.isNaN(num) then 0 else num
        if vm.selected_room && vm.selected_room.is_price_loaded
          num = _.min [num, vm.selected_room.prices.child_price.limit]
        vm.child_num = num
        vm.calculate_extra_price()
      vm.communicate = { name: '', phone: '', email: '' }
      vm.copy_communicate_name = ->
        vm.attendences[0].name = vm.communicate.name
      vm.copy_communicate_phone = ->
        vm.attendences[0].phone = vm.communicate.phone
      vm.attendences = _.times vm.people_num, ->
        { name: '', phone: '' }
      vm.package_price = null
      vm.extra_bed_price = null
      vm.extra_price = 0
    avalon.scan()
    $('.js_main_trade_new_form').validate
      ignore: ''
      rules:
        'trade[start_day]':
          required: true
        'trade[end_day]':
          required: true
        'trade[room_id]':
          required: true
        'trade[people_num]':
          required: true
        'trade[communicate_attributes][name]':
          required: true
        'trade[communicate_attributes][phone]':
          required: true
          isMobile: true
        'trade[communicate_attributes][email]':
          required: true
          email: true
        'trade.attendences_attributes.name':
          required: true
        'trade.attendences_attributes.phone':
          required: true
          isMobile: true
      errorClass: 'trade-new-form__error'
      errorPlacement: (error, element) ->
        $(element).parents('.main-form__group').append(error)
      errorElement: 'div'
    _.each $('.js_main_trade_new_attendences_name'), (element) ->
      $(element).rules 'add',
        required: true
    _.each $('.js_main_trade_new_attendences_phone'), (element) ->
      $(element).rules 'add',
        required: true
        isMobile: true
    $('.js_main_trade_new_bill').sticky
      topSpacing: 20
  # Trade Cancel
  $('.js_main_trade_cancel').on 'click', ->
    $.ajax
      url: $(this).data('url')
      type: 'DELETE'
      dataType: 'json'
      context: this
      beforeSend: ->
        $(this).addClass('ajax_disabled')
      success: (data) ->
        if data.status == true
          location.href = $(this).data('url')
        else
          $(this).siblings('.js_main_trade_cancel_message').show()
      complete: ->
        $(this).removeClass('ajax_disabled')
