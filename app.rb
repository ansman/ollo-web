require 'bundler'
Bundler.require

require 'sass'

module Sinatra
  class Base
    class << self
      def staging?;  environment == :staging  end
    end
  end
end

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :environments, %w{development test production staging}
  set :version, 'unknown'
  set :asset_version, 1 # To expire assets
  set :static, true
  set :public_folder, Proc.new { File.join(root, "public") }
  set :static_cache_control, [:public, :max_age => 525600]
  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :digest_assets, production?
  set :assets_path, Proc.new { File.join public_folder, assets_prefix }
  set :manifest_path, Dir[File.join(assets_path, 'manifest*.json')][0]
  set :logging, true
  set :manifest, manifest_path && File.exists?(manifest_path) ?
    Sprockets::Manifest.new(sprockets, manifest_path) :
    nil

  mime_type :map, 'application/json'

  configure do
    sprockets.append_path File.dirname(HamlCoffeeAssets.helpers_path)
    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'assets', 'javascripts')
    sprockets.append_path File.join(root, 'assets', 'images')
    sprockets.append_path File.join(root, 'assets', 'fonts')
    sprockets.version = asset_version

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.digest      = digest_assets
      config.prefix      = assets_prefix
      config.public_path = public_folder
      config.manifest    = manifest
      config.debug       = true if development?
    end
  end

  configure :production do
    Sprockets::Sass.options[:style] = :compressed
    # Sprockets::Helpers.configure do |config|
    #   config.protocol   = 'https'
    #   config.asset_host = 'some.cdn.com'
    # end
  end

  helpers do
    include Sprockets::Helpers
  end

  configure :development, :test do
    sprockets.append_path File.join(root, 'spec')
    sprockets.cache =   Sprockets::Cache::FileStore.new("tmp")
  end

  configure :production do
    # get '/version' do
    #   settings.version
    # end

    # thread = Thread.new do
    #   heroku  = Heroku::API.new(:api_key => "heroku-key")
    #   release = heroku.get_releases('my-heroku-app').body.last
    #   set :version, release["name"]
    # end
  end

  get '/facebook-channel' do
    haml :facebook_channel
  end

  get '/*' do
    haml :home
  end
end
