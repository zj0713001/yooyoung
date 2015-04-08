module Main::Mobile::TradesHelper
  def calendar_title
    ->(start_date) { content_tag :span, "#{start_date.year}年 #{I18n.t("date.abbr_month_names")[start_date.month]}" }
  end

  def calendar_previous_link
    ->(param, date_range) do
      link_to raw(content_tag(:div, '', class: ['iconfont', 'icon-arrow-left'])), { param => (date_range.first - 1.day) }, class: 'previous js_main_mobile_trades_new_month_href'
    end
  end

  def calendar_next_link
    ->(param, date_range) do
      link_to raw(content_tag(:div, '', class: ['iconfont', 'icon-arrow-right'])), { param => (date_range.last + 1.day) }, class: 'next js_main_mobile_trades_new_month_href'
    end
  end
end
