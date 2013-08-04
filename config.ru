require './app'

class CrossSiteSettings
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    headers['Access-Control-Allow-Origin'] = 'https://ollo.herokuapp.com'
    headers['Access-Control-Allow-Methods'] = 'GET'
    [status, headers, response]
  end
end

use Rack::Deflater
use CrossSiteSettings

configure :development do
  require 'rack-livereload'
  use Rack::LiveReload

  map App.assets_prefix do
    run App.sprockets
  end
end

configure :production do
  require 'rack-ssl-enforcer'
  use Rack::SslEnforcer
end

map "/" do
  run App
end
