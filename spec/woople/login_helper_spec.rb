require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require_relative '../../lib/woople/tokenizer'
require_relative '../../lib/woople/login_helper'

class FeatureStep
  include Woople::LoginHelper
end

describe FeatureStep do
  it "visits sso path" do
    time = Time.current + 1.hour
    user_info = { name: 'Cameron', expires_at: time }

    token = stub(sso_token: 'token')
    sso_path = stub
    unescaped_token = stub

    Woople::Tokenizer.should_receive(:new).with(ENV['WOOPLE_KEY'], ENV['WOOPLE_SECRET'], user_info) { token }
    CGI.should_receive(:unescape).with(token.sso_token) { unescaped_token }

    subject.should_receive(:sso_path).with(:token => unescaped_token ).and_return(sso_path)
    subject.should_receive(:visit).with(sso_path)

    subject.login_as(user_info)
  end
end
