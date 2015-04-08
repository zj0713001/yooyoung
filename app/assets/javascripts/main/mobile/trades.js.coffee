$ ->
  if _.isElement($('.js_main_mobile_trades_new')[0])
    weekday_arr = ["一", "二", "三", "四", "五", "六", "日"]
    new_trade = avalon.define 'mobile_main_trade_new', (vm) ->
      vm.hotel = jsvar.hotel
      vm.selected_package = null
      vm.selected_package_text = "1、点击选择套餐类型"
      vm.selected_start_day = null
      vm.selected_end_day = null
      vm.selected_day_text = "2、点击选择入住日期"
      vm.selected_room = null
      vm.selected_room_text = "3、点击选择入住房型"
      vm.end_day_text = null
      vm.calendar_html = ''
      vm.days = vm.hotel.package.days
      vm.min_package_price = jsvar.package_min_price
      vm.people_num = 2
      vm.child_num = 0
      vm.extra_bed_num = 0
      vm.room_people_text = null
      vm.package_price = null
      vm.extra_bed_price = null
      vm.child_price = null
      vm.total_price = null
      vm.is_submitting = false
      vm.is_select_done = ->
        vm.selected_package? && vm.selected_room? && vm.selected_start_day?
      vm.opened_step = null
      vm.select_package_step = ->
        vm.selected_package ?= vm.hotel.package
        vm.opened_step = $('.js_main_mobile_trades_new_package_step')
        vm.opened_step.dimmer('setting', 'duration', 'show', 100).dimmer('setting', 'duration', 'hide', 100).dimmer('show')
        vm.select_package(vm.selected_package)
      vm.select_day_step = ->
        return unless vm.selected_package?
        vm.opened_step = $('.js_main_mobile_trades_new_day_step')
        vm.opened_step.dimmer('setting', 'duration', 'show', 100).dimmer('setting', 'duration', 'hide', 100).dimmer('show')
      vm.select_room_step = ->
        return unless vm.selected_start_day?
        vm.opened_step = $('.js_main_mobile_trades_new_room_step')
        vm.opened_step.dimmer('setting', 'duration', 'show', 100).dimmer('setting', 'duration', 'hide', 100).dimmer('show')
      vm.next = ->
        if vm.opened_step
          vm.opened_step.dimmer('hide')
          vm.opened_step = null
        else if vm.is_select_done()
          vm.is_submitting = true
      vm.select_package = (p) ->
        if vm.hotel.package.id == p.id
          vm.selected_package = vm.hotel.package
          vm.min_package_price = jsvar.package_min_price
        else
          vm.selected_package = vm.hotel.favorite_package
          vm.min_package_price = jsvar.favorite_min_price
        vm.days = vm.selected_package.days
        vm.selected_package_text = vm.selected_package.name
      vm.$watch 'days', ->
        vm.select_start_day(vm.selected_start_day) if vm.selected_start_day?
      vm.select_start_day = (day) ->
        vm.selected_start_day = moment(day).format('L')
      vm.$watch 'selected_start_day', (day) ->
        vm.selected_end_day = moment(day).add(vm.days, 'days').format('L')
        vm.selected_day_text = "#{vm.selected_start_day}（星期#{weekday_arr[moment(day).weekday()]}）"
        vm.end_day_text = "入住#{vm.days}晚，退房日期为 #{vm.selected_end_day}（星期#{weekday_arr[moment(vm.selected_end_day).weekday()]}）"
        $.ajax
          url: $('.js_main_mobile_trades_new_day_step').data('price-url')
          type: 'GET'
          dataType: 'json'
          context: this
          data: { start_day: vm.selected_start_day, hotel_id: vm.hotel.to_param }
          success: (data) ->
            if data.status == true
              vm.hotel.rooms = _.map vm.hotel.rooms, (room) ->
                room_data = _.find data.data, (r) ->
                  r.id == room.id
                _.extend room, room_data
                if vm.selected_package.favorite
                  room.disabled = room.favorite_package_disabled
                  room.prices = room.favorite_package_prices
                else
                  room.disabled = room.package_disabled
                  room.prices = room.package_prices
                room.is_price_loaded = true
                if vm.selected_room == room
                  vm.select_room(room)
                room
      vm.redraw_total_price = ->
        vm.total_price = vm.package_price+(vm.extra_bed_price*vm.extra_bed_num*vm.days)+(vm.child_price*vm.child_num*vm.days)
      vm.select_room = (room) ->
        return if room.disabled || _.isEmpty(vm.selected_start_day)
        vm.selected_room = room
        vm.selected_room_text = room.chinese
        if room.is_price_loaded
          vm.package_price = room.prices.sale_price
          vm.extra_bed_price = room.prices.extra_bed_price.items[0].price
          vm.child_price = room.prices.child_price.items[0].price
          vm.redraw_total_price()
          vm.redraw_room_people_text()
      vm.$watch 'people_num', (num) ->
        return unless num?
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
        vm.redraw_total_price()
        vm.redraw_room_people_text()
        vm.attendences = _.times num, ->
          { name: '', phone: '' }
      vm.people_num_minus = ->
        vm.people_num-- if vm.people_num > 1
      vm.people_num_plus = ->
        vm.people_num++ if (vm.selected_room.population+vm.selected_room.prices.extra_bed_price.limit) > vm.people_num
      vm.child_num_minus = ->
        vm.child_num-- if vm.child_num > 0
      vm.child_num_plus = ->
        vm.child_num++ if vm.selected_room.prices.child_price.limit > vm.child_num
      vm.$watch 'child_num', (num) ->
        return unless num?
        num = parseInt(num)
        num = if _.isNaN(num) then 0 else num
        if vm.selected_room && vm.selected_room.is_price_loaded
          num = _.min [num, vm.selected_room.prices.child_price.limit]
        vm.child_num = num
        vm.redraw_total_price()
        vm.redraw_room_people_text()
      vm.redraw_room_people_text = ->
        return null unless vm.selected_room?
        people_text = "成人 #{vm.people_num} 人"
        extra_text = "，需加床 #{vm.extra_bed_num} 人"
        child_text = "，儿童 #{vm.child_num} 人"
        text = people_text
        text += extra_text if vm.extra_bed_num > 0
        text += child_text if vm.child_num > 0
        vm.room_people_text = text
      vm.communicate = { name: '', phone: '', email: '' }
      vm.copy_communicate_name = ->
        vm.attendences[0].name = vm.communicate.name
      vm.copy_communicate_phone = ->
        vm.attendences[0].phone = vm.communicate.phone
      vm.attendences = _.times vm.people_num, ->
        { name: '', phone: '' }
      vm.submit = ->
        $('.js_main_mobile_trades_new_form').submit()

    $('.js_main_mobile_trades_new').on
      click: ->
        return false if $(this).parent('.day').hasClass('past')
        new_trade.select_start_day($(this).data('day'))
        redraw_canlendar_selected_day($(this).data('day'), new_trade.days)
    , '.js_main_mobile_trades_new_day'

    $('.js_main_mobile_trades_new').on
      click: ->
        redraw_canlendar($(this).attr('href'))
        false
    , '.js_main_mobile_trades_new_month_href'

    redraw_canlendar_selected_day = (start_day, days) ->
      return false if _.isEmpty(start_day)
      start_day = moment(start_day)
      end_day = moment(start_day).add(days, 'days')
      selected_day = _.each $('.js_main_mobile_trades_new_day'), (item) ->
        item_day = moment($(item).data('day'))
        $(item).removeClass('check-in check-out')
        $(item).addClass('check-in') if start_day <= item_day && item_day < end_day
        $(item).addClass('check-out') if item_day.format('L') == end_day.format('L')
    redraw_canlendar = (url) ->
      $.ajax
        url: url
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          if data.status == true
            new_trade.calendar_html = data.data
            redraw_canlendar_selected_day(new_trade.selected_start_day, new_trade.days)

    redraw_canlendar($('.js_main_mobile_trades_new_day_step').data('calendar-url'))

    avalon.scan()

    $('.js_main_mobile_trades_new_form').validate
      ignore: ''
      rules:
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
      errorPlacement: (error, element) ->
        ''
      errorElement: 'div'
