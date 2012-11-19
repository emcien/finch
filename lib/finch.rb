require 'faraday'
require 'oj'
require 'simple_oauth'

require 'finch/cursor'
require 'finch/errors'
require 'finch/utils'

module Finch

  def self.[] user
    Finch::Client.new user
  end

  class Client
    include Cursor

    def initialize user
      raise Finch::Error::InvalidUser unless user.respond_to?(:credentials)
      @user = user
    end

    def rate_limit &block
      @rate_limit = block
    end

    def get path, params={}, options={}
      request :get, path, params, options
    end

    def post path, params={}, options={}
      request :post, path, params, options
    end

    def response_status
      @response.env[:status]
    end

    def response_headers
      @response.env[:response_headers]
    end

    private

    def connection
      @_connection ||= Faraday.new('https://api.twitter.com')
    end

    def auth_headers method, uri, params, credentials
      SimpleOAuth::Header.new(method, uri, params, credentials).to_s
    rescue
      raise Finch::Error::AuthenticationError
    end

    def request method, path, params={}, options={}
      version   = options[:version] || 1.1
      uri       = "https://api.twitter.com/#{version}/#{path}.json"
      auth      = auth_headers method, uri, params, @user.credentials
      @response = connection.run_request(method, uri, nil, authorization: auth) do |request|
        request.params.update params
      end

      raise Finch::Error[response_status] unless response_status == 200
      check_rate_limit(response_headers) if @rate_limit.respond_to?(:call)

      Oj.load @response.body
    end
    use_cursor :request

    def check_rate_limit headers
      remaining, total = headers['x-rate-limit-remaining'].to_i, headers['x-rate-limit-limit'].to_i
      @rate_limit.call(remaining, total, @user)
    end
  end

end