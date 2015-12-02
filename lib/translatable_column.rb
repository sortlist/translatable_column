require "translatable_column/version"
require "translatable_column/translatable"
require "translatable_column/configuration"

module TranslatableColumn
  def self.configure
    yield config
  end

  def self.config
    @configuration ||= TranslatableColumn::Configuration.new
  end

  configure do |config|
    config.locales          = ["en", "fr"]
    config.fallback         = true
    config.only_main_locale = true
  end
end
