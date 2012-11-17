require 'rack/utils'

require 'finch/utils'

module Cursor

  module ClassMethods
    def use_cursor method
      alias_method :request_without_cursor, :request
      alias_method :request, :request_with_cursor
    end
  end

  def self.included klass
    klass.extend ClassMethods
  end

  def next
    raise "No next parameter set" if @_next.nil?
    next_params = Finch::Utils::keys_to_sym(
      Rack::Utils.parse_nested_query(@_next.gsub('?','')))
    l = @_last_request
    request l[:method], l[:path], l[:params].merge(next_params), l[:options]
  end

  private

  def update_cursor! result
    @_next = nil
    # -- Search endpoint style pagination --------
    if result.include? "search_metadata"
      @_next = result["search_metadata"]["next_results"]
    # -- Results with actual cursors -------------
    elsif result.include? "next_cursor"
      @_next = result["next_cursor"]
    end
  end

  def request_with_cursor method, path, params, options
    params = Finch::Utils::keys_to_sym params
    @_last_request = {
      method:  method,
      path:    path,
      params:  params,
      options: options
    }
    result = request_without_cursor method, path, params, options
    update_cursor! result
    result
  end

end