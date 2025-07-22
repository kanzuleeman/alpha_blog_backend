require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AplhaBlog
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    # ✅ Enable sessions and cookies for API
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_alpha_blog_session'

    # config.api_only = true
  end
end
