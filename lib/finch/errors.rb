module Finch
  module Error

      class InvalidUser < StandardError
      end

      class BadGateway < StandardError
      end

      class BadRequest < StandardError
      end

      class InternalServerError < StandardError
      end

      class ServiceUnavailable < StandardError
      end

      class NotFound < StandardError
      end

      class Forbidden < StandardError
      end

  end
end