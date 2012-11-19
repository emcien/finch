module Finch
  class Error < StandardError

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

    class Client < Error; end
    class Server < Error; end

    class AuthenticationError < Client; end

    def self.[] status
      name = RESPONSE_CODES[status] || 'Unexpected Error'
      base = if 400 <= status && status < 500
        Client 
      elsif 500 <= status && status < 600
        Server
      else
        Error
      end
      klass = Finch::Error.const_set(name.gsub(/\s+/, ''), Class.new(base))
      raise klass.new("#{name} (#{status})")
    end
  end

end