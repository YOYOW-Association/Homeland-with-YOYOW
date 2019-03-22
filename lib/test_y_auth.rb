require 'multi_json'
# require 'rest-client'
require 'faraday'

class TestYAuth
  class CliRequestError < Exception; end

  def initialize
    @redirect = 'http://localhost:3000/'
    # @resource = RestClient::Resource.new('localhost:3001')
    @resource = Faraday.new('http://localhost:3001')
  end
  def auth_url
    resp = @resource.get '/auth/sign'
    json = MultiJson.load resp.body, :symbolize_keys => true
    raise CliRequestError(json[:message]) if json[:code] != 0

    # puts json

    auth_data = json[:data].slice(:sign, :time, :platform)
    auth_data = auth_data.merge({state: 'localhost:3000/auth/yoyow/callback'})
    auth_url  = [json[:data][:url], '?', URI.encode_www_form(auth_data)].join('')
  rescue CliRequestError => e
    puts "Error occurs while accessing yoyow middleware: "
    puts e.message
  end

  def sign_auth(data)
    @resource.get '/auth/sign'
  end
end

i = TestYAuth.new
puts i.auth_url