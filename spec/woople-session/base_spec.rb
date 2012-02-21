require 'spec_helper'
require 'woople-session'
require 'cgi'

describe Woople::Session do
  before do
    @controller = stub( session: {} )
  end
  describe "#new" do
    context "with an invalid token" do
      subject { Woople::Session.new(@controller, 'bad_token') }
      it { should_not be_valid }
      it 'should have an error message' do
        subject.valid?
        subject.errors.full_messages.should include("Token could not be decrypted")
      end
    end

    context "with a valid token" do
      subject { Woople::Session.new(@controller, generate_valid_token) }
      it { should be_valid }
    end

    context "with an expired token" do
      subject { Woople::Session.new(@controller, generate_expired_token) }

      it { should_not be_valid }
      it 'should have an error message' do
        subject.valid?
        subject.errors.full_messages.should include("Token has expired")
      end
    end

    context "without an expires key" do
      subject { Woople::Session.new(@controller, generate_token_without_expires) }

      it { should_not be_valid }
      it 'should have an error message' do
        subject.valid?
        subject.errors.full_messages.should include("Token has expired")
      end

    end
  end

  describe "#find" do
    context "retrieving a previously saved session" do
      subject { Woople::Session.find(stub_controller) }

      it "should have a name" do
        subject[:name].should == 'bob'
      end
    end
  end

  describe "#save" do
    context "with a valid token" do
      before do
        @session = Woople::Session.new(@controller, generate_valid_token)
      end

      it "should be true" do
        @session.save.should be_true
      end

      it "should save the session" do
        @session.save
        @controller.session.should have_key :sso
      end
    end

    context "with an invalid token" do
      subject { Woople::Session.new(@controller, generate_expired_token).save }
      it { should be_false }
    end
  end

  def generate_token_without_expires
    token(:expires => nil)
  end

  def generate_expired_token
    token(:expires => 10.minutes.ago.to_s)
  end

  def generate_valid_token
    token(:name => 'Bob Smith')
  end

  def token(data = {})
    CGI.unescape(
      Woople::Tokenizer.new(
        ENV['WOOPLE_KEY'], ENV['WOOPLE_SECRET'], data
      ).sso_token
    )

  end

  def stub_controller
    stub(:session => { :sso => { :name => 'bob' } })
  end
end
