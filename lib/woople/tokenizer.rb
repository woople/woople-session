require "rubygems"
require "ezcrypto"
require "base64"
require "json"
require 'active_support/hash_with_indifferent_access'

module Woople
  class Tokenizer
    def initialize( importer_key, api_key, data = {} )
      # create the signed key
      signed_key = EzCrypto::Key.with_password( importer_key, api_key )

      # create the data-object, using the required fields
      defaults = {
        :expires => 10.minutes.from_now.to_s # expires 10 minutes from now
      }

      data = defaults.merge(data)

      # encode the data-object to JSON, and encrypt
      encrypted_data = signed_key.encrypt( data.to_json )

      # generate the SSO-Token
      @sso_token = CGI.escape( Base64.encode64( encrypted_data ).gsub(/\n/, "") )
    end

    def sso_token
      @sso_token
    end

    def self.decrypt( importer_key, api_key, encrypted_token )
      # encrypted token must have been run through CGI.unescape() before coming into this method

      # create the signed key
      signed_key = EzCrypto::Key.with_password( importer_key, api_key )

      # decode the data-object
      decoded = signed_key.decrypt( Base64.decode64( encrypted_token ) )

      # convert the object to a hash
      HashWithIndifferentAccess.new( ActiveSupport::JSON.decode(decoded) )
    end
  end
end
