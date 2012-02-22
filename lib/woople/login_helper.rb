module Woople
  module LoginHelper
    def login_as(object = {})
      token = Woople::Tokenizer.new(ENV['WOOPLE_KEY'], ENV['WOOPLE_SECRET'], object)
      visit sso_path(:token => CGI.unescape(token.sso_token))
    end
  end
end

