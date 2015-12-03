module TranslatableColumn
  class Configuration
    include ActiveSupport::Configurable
    config_accessor :locales
    config_accessor :default
    config_accessor :fallback
    config_accessor :only_main_locale
  end
end
