require 'faraday'
require 'oj'
require 'simple_oauth'

require 'finch/cursor'
require 'finch/errors'

module Finch
  @@rate_blocks = []

  def self.rate_limit &blk
    @@rate_blocks << blk
  end
  
  def self._run_rate_limit(remaining,total,user,path)
    @@rate_blocks.each do |blk|
      blk.call(remaining,total,user,path) if blk.respond_to?(:call)
    end
  end

  def self.[] user
    Finch::Client.new user
  end

  class Client
    include Cursor
    
    def initialize user
      @user        = user
      @credentials = user.credentials
      %w{ token token_secret consumer_key consumer_secret }.each do |key|
        raise unless @credentials[key.to_sym].present?
      end
    rescue
      raise Finch::Error::AuthenticationError.new 'Malformed user credentials.'
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

    def auth_headers method, uri, params
      SimpleOAuth::Header.new(method, uri, params, @credentials).to_s
    rescue
      raise Finch::Error::AuthenticationError.new 'Unable to sign OAuth request. Please verify your credentials'
    end

    def request method, path, params={}, options={}
      version   = options[:version] || 1.1
      uri       = "https://api.twitter.com/#{version}/#{path}.json"
      auth      = auth_headers method, uri, params
      @response = connection.run_request(method, uri, nil, authorization: auth) do |request|
        request.params.update params
      end

      raise Finch::Error[response_status] unless response_status == 200
      
      check_rate_limit(response_headers,path)

      Oj.load @response.body
    end
    use_cursor

    def check_rate_limit headers, path
      return unless headers.include? 'x-rate-limit-remaining'
      remaining, total = headers['x-rate-limit-remaining'].to_i, headers['x-rate-limit-limit'].to_i
      
      if @rate_limit.respond_to?(:call)
        @rate_limit.call(remaining, total, @user, path)
      end
      
      Finch._run_rate_limit(remaining,total,@user,path)
    end
  end

end