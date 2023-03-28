# frozen_string_literal: true

require 'net/http'

# Requests URLs and follows redirects
#
# Usage:
# response = Request.new(url).resolve
# request.body # => return the body of the request
class Request
  class TooManyRedirects < StandardError
  end

  attr_accessor :url, :body, :redirect_limit, :response

  def initialize(url, limit = 5)
    @url = url
    @redirect_limit = limit
  end

  def resolve
    raise TooManyRedirects if redirect_limit.negative?

    self.response = Net::HTTP.get_response(URI.parse(url))

    if response.is_a?(Net::HTTPRedirection)
      self.url = redirect_url
      self.redirect_limit -= 1

      resolve
    end

    self.body = response.body
    self
  end

  def redirect_url
    if response['location'].nil?
      response.body.match(/<a href="([^>]+)">/i)[1]
    else
      response['location']
    end
  end
end
