namespace :baidu do
  desc '提交酒店链接到百度'
  task put: :environment do
    include Rails.application.routes.url_helpers
    default_url_options[:host] = "www.yooyoung.cn"

    urls = Hotel.published.map{|h| url_for(h)}
    uri = URI.parse('http://data.zz.baidu.com/urls?site=www.yooyoung.cn&token=B1qJSVF80mERKi0A')
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = urls.join("\n")
    req.content_type = 'text/plain'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
    puts res.body
  end
end
