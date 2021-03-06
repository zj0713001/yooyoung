(function( factory ) {
  if ( typeof define === "function" && define.amd ) {
    define( ["jquery", "../jquery.validate"], factory );
  } else {
    factory( jQuery );
  }
}(function( $ ) {
  $.extend($.validator.messages, {
    required: "此项不能为空",
    remote: "请修改此项内容",
    email: "请输入有效的电子邮件",
    url: "请输入有效的网址",
    date: "请输入有效的日期",
    dateISO: "请输入有效的日期 (YYYY-MM-DD)",
    number: "请输入正确的数字",
    digits: "只可输入数字",
    creditcard: "请输入有效的信用卡号码",
    equalTo: "两次输入不相同",
    extension: "请输入有效的后缀",
    maxlength: $.validator.format("最多输入 {0} 个字符"),
    minlength: $.validator.format("最少输入 {0} 个字符"),
    rangelength: $.validator.format("请输入长度为 {0} 至 {1} 之间的字符"),
    range: $.validator.format("请输入 {0} 至 {1} 之间的数字"),
    max: $.validator.format("请输入不大于 {0} 的数字"),
    min: $.validator.format("请输入不小于 {0} 的数字")
  });
}));
