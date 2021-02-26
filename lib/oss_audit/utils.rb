require 'net/http'
require 'uri'

module OssAudit
  module Utils

    def get_uri(url)
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      return JSON.parse(response.body)
    rescue => e
      return e
    end

  end
end
