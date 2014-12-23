$ ->
  zh_length = (value) ->
    length = 0
    i = 0
    while i < value.length
      if value.charCodeAt(i) < 128
        length += 0.5
      else
        length += 1
        i++
    length

  jQuery.validator.addMethod "isMobile", ((value, element) ->
    length = value.length
    mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/
    @optional(element) or (length is 11 and mobile.test(value))
), "请输入正确的手机号码"
  jQuery.validator.addMethod "isTelephone", ((value, element) ->
    tel = /^\d{3,4}-?\d{7,9}$/ #电话号码格式010-12345678
    @optional(element) or (tel.test(value))
), "请输入正确的电话号码"
  jQuery.validator.addMethod "isPhone", ((value, element) ->
    length = value.length
    mobile = mobile = /^(((13[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0-9]{1}))+\d{8})$/
    tel = /^\d{3,4}-?\d{7,9}$/
    @optional(element) or (tel.test(value) or mobile.test(value))
), "请正确填写您的联系电话"
  jQuery.validator.addMethod "zhRangeLength", ((value, element, param) ->
    length = zh_length(value)
    @optional(element) or (length >= param[0] and length <= param[1])
), jQuery.validator.format("请确保输入的值在 {0}-{1} 个字符之间(英文计半个字符)")
  jQuery.validator.addMethod "zhMinLength", ((value, element, param) ->
    length = zh_length(value)
    @optional(element) or (length >= param)
), jQuery.validator.format("请确保输入的值大于 {0} 个字符(英文计半个字符)")
  jQuery.validator.addMethod "zhMaxLength", ((value, element, param) ->
    length = zh_length(value)
    @optional(element) or (length <= param)
), jQuery.validator.format("请确保输入的值小于{0}个字符(英文计半个字符)")
  jQuery.validator.addMethod "checkDataMax", ((value, element, param) ->
    int_value = +value
    max_value = +$(element).data(param)
    check_max = isNaN(max_value) or max_value is 0 or int_value <= max_value
    @optional(element) or (check_max)
), jQuery.validator.format("超过允许的最大值，请重新输入")
