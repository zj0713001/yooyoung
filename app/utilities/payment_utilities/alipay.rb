require "singleton"

module PaymentUtilities
  class Alipay
    include Singleton

    def initialize
      @config = Settings.payment.alipay
    end

    def common_options(options)
      options.merge!({
        :seller_email => @config.email,
        :partner => @config.account,
        :_input_charset => "utf-8",
      })

      options.merge!({
        :sign_type => "MD5",
        :sign => md5(options),
      })

      options
    end

    def md5(options)
      Digest::MD5.hexdigest(CGI.unescape(Hash[options.sort].to_query)+@config.key)
    end

    def wap_md5(wap_options)
      Digest::MD5.hexdigest(CGI.unescape(wap_options.map{|k, v| "#{k}=#{v}"}.join('&'))+@config.key)
    end
  end
end
