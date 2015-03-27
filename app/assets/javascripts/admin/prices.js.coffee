$(document).on 'page:change', ->
  if _.isElement($('.js_admin_price_update')[0])
    avalon.filters.by_date = (data, date) ->
      _.find data, (d) ->
        d.date == date
    avalon.filters.to_local_price = (data) ->
      if _.isNull(data.prices.local_price)
        '-'
      else
        data.prices.local_price
    avalon.filters.to_price_unit = (data) ->
      if _.isNull(data.prices.price_unit)
        '-'
      else
        data.prices.price_unit
    avalon.filters.to_cost_price = (data) ->
      if _.isNull(data.prices.cost_price)
        '-'
      else
        data.prices.cost_price
    avalon.filters.to_sale_price = (data) ->
      if _.isNull(data.prices.sale_price)
        '-'
      else
        data.prices.sale_price

    avalon.filters.to_date = (data) ->
      data.date

    prices = avalon.define 'admin_prices', (vm) ->
      vm.data = {}
      vm.start_date = {}
      vm.is_exist = (date) ->
        date_by_date = _.find vm.data, (d) ->
          d.date == date
        date_by_date.exist
      vm.selecting = false
      vm.click_item = ->
        vm.selecting = !vm.selecting
        if vm.selecting
          $('.js_admin_calendar_day_item').removeClass('day-item--selected day-item--selected-start')
          $(this).addClass('day-item--selected-start')
          vm.start_date = $(this)
          vm.select_item()
        else
          $('.js_admin_calendar_day_item').removeClass('day-item--selected day-item--selected-start')
          $('.js_admin_price_update_modal').modal('show')
      vm.select_item = ->
        if vm.selecting
          start_week = _.min([$(vm.start_date).data('week'), $(this).data('week')])
          end_week = _.max([$(vm.start_date).data('week'), $(this).data('week')])
          start_day = _.min([$(vm.start_date).data('day'), $(this).data('day')])
          end_day = _.max([$(vm.start_date).data('day'), $(this).data('day')])
          selected = _.filter $('.js_admin_calendar_day_item'), (item) ->
            $(item).data('week') >= start_week && $(item).data('week') <= end_week && $(item).data('day') >= start_day && $(item).data('day') <= end_day
          $('.js_admin_calendar_day_item').removeClass('day-item--selected day-item--selected-start')
          $(selected).addClass('day-item--selected')
          vm.selected_items = _.map $(selected), (item) ->
            _.find vm.data, (d) ->
              d.date == $(item).data('date')
      vm.selected_items = []
      vm.local_price = ''
      vm.price_unit = ''
      vm.cost_price = ''
      vm.sale_price = ''
      vm.update_price = ->
        dates = _.map vm.selected_items, (item) ->
          item.date
        $.ajax
          url: $(this).data('url')
          type: 'POST'
          dataType: 'json'
          context: this
          data: { 'dates[]': dates, local_price: vm.local_price, price_unit: vm.price_unit, cost_price: vm.cost_price, sale_price: vm.sale_price }
          success: (data) ->
            if data.status == true
              _.each data.data, (item) ->
                date_by_date = _.find vm.data, (d) ->
                  d.date == item.date
                date_by_date.prices = item.prices
      vm.calculate_sale_price = ->
        vm.sale_price = parseInt(vm.cost_price) * parseInt($(this).data('multiple')) / 100 + parseInt(vm.cost_price)

    $.ajax
      url: location.href
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        if data.status == true
          prices.data = data.data
          _.each $('.js_admin_calendar_day_item'), (item) ->
            date_by_date = _.find data.data, (d) ->
              d.date == $(item).data('date')
            $(item).find('.js_admin_calendar_day').addClass('red') if !date_by_date.exist
        else
          alert "#{data.message} code: #{data.error_code}"

    avalon.scan()

    $('.js_admin_room_price_update').on 'submit', ->
      $.ajax
        url: $(this).attr('action')
        type: 'POST'
        context: this
        dataType: 'json'
        data: $(this).serialize()
        beforeSend: ->
          $('.js_admin_price_update_message').removeClass('success error').hide().text('')
          $(this).addClass('loading')
        success: (data) ->
          if data.status == true
            $('.js_admin_price_update_message').addClass('success').text('修改成功！').show()
          else
            $('.js_admin_price_update_message').addClass('error').text('修改失败！').show()
          $(this).removeClass('loading')
      false
