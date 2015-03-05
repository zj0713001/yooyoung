class BrowserChecker
  MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                        'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'

  def initialize(request)
    @request = request
  end

  def mobile?
    agent_str = @request.user_agent.to_s.downcase
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

  def weixin_browser?
    !!@request.user_agent.to_s.match('MicroMessenger')
  end

  def android?
    agent_str = @request.user_agent.to_s.downcase
    agent_str =~ /android/
  end

  def ios?
    agent_str = @request.user_agent.to_s.downcase
    agent_str =~ /ipad/ || agent_str=~ /iphone/
  end

  def hidden_header?
    self.weixin_browser?
  end
end
