module Finch
  class Error < StandardError

    class Client     < Error; end
    class Server     < Error; end
    class Unexpected < Error; end

    RESPONSE_CODES = {
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      406 => 'Not Acceptable',
      422 => 'Unprocessable Entity',
      429 => 'Too Many Requests',
      500 => 'Internal Server Error',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout'
    }

    REV_CODES = RESPONSE_CODES.inject({}) { |h,(k,v)| h[ v.gsub(/\s+/, '') ] = k; h }

    RESPONSE_CODES.each do |status, msg|
      base = if 400 <= status && status < 500
        Client
      elsif 500 <= status && status < 600
        Server
      else
        Error
      end
      Finch::Error.const_set(msg.gsub(/\s+/, ''), Class.new(base))
    end

    class AuthenticationError < Client; end

    class ParseError < StandardError
      attr_accessor :original_error
      attr_accessor :original_data
    end

    def initialize(headers={})
      @status = self.class.name.match(/::([^:]+)$/)[1]
      @text   = RESPONSE_CODES[ @status ]

      super "#{@text} (#{@status})"

      @headers = headers
    end

    def headers
      @headers
    end

    def self.[] status
      name = RESPONSE_CODES[status].gsub(/\s+/, '') || 'Unexpected'
      klass = "Finch::Error::#{name}".constantize rescue Finch::Error::Unexpected
      return klass
    end
  end

end
