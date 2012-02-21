require 'cgi'
require 'active_model'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/conversions'

module Woople
  class Session
    include ActiveModel::Validations

    validate :token_decryptable, :token_expiration

    # Class
    def self.find(controller)
      controller.session[:sso]
    end

    # Instance
    def initialize(controller, token)
      @controller = controller
      @token = token
    end

    def save
      if valid?
        @controller.session[:sso] = get_token
        return true
      else
        return false
      end
    end

    private

    def token_expiration
      token = get_token
      return if token.nil?

      if token[:expires].nil? || DateTime.now >= token[:expires].to_datetime
        errors.add(:token, "has expired")
      end
    end

    def token_decryptable
      token = get_token

      if token.nil?
        errors.add(:token, "could not be decrypted")
      end
    end

    def get_token
      begin
        Woople::Tokenizer.decrypt(
          ENV['WOOPLE_KEY'], ENV['WOOPLE_SECRET'], @token
        )
      rescue OpenSSL::Cipher::CipherError
        return nil
      end
    end
  end
end
