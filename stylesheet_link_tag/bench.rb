require 'rails'
require 'sprockets/rails'

# https://github.com/rails/sprockets-rails/blob/v3.2.1/lib/sprockets/railtie.rb#L234-L252
ActiveSupport.on_load(:action_view) do
  include Sprockets::Rails::Helper

  self.debug_assets      = false
  self.digest_assets     = true
  self.assets_prefix     = '/assets'
  self.assets_precompile = [Sprockets::Railtie::LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js)$/]

  self.assets_environment = nil
  self.assets_manifest = Sprockets::Manifest.new(nil, File.expand_path('./public/assets', __dir__), nil)

  self.resolve_assets_with = [:manifest]

  self.check_precompiled_asset = true
  self.unknown_asset_fallback  = false
  self.precompiled_asset_checker = -> logical_path { app.asset_precompiled? logical_path } # not called
end

env = Rack::MockRequest.env_for('/posts/1', method: Rack::GET)
controller = ActionController::Base.new
controller.set_request!(ActionDispatch::Request.new(env))

controller.render_to_body(inline: "<% #{<<~"begin;"}\n#{<<~"end;"} %>", type: :erb)
begin;
  if RubyVM::MJIT.enabled?
    # --jit-wait
    i = 0
    while i < 10000
      stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
      i += 1
    end
  end
  puts stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'

  puts "=="

  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  i = 0
  while i < 100000
    stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    i += 1
  end
  puts(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t)
end;
