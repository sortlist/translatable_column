require "translatable_column/version"
require "translatable_column/translatable"
require "translatable_column/configuration"

module TranslatableColumn
  def self.locale
    locale = I18n.locale.to_s
    locale = locale.split("-").first if ::TranslatableColumn.config.only_main_locale
    if ::TranslatableColumn.config.locales.any? { |authorized_locale| authorized_locale.to_s == locale }
      locale
    else
      ::TranslatableColumn.config.default
    end
  end

  def self.configure
    yield config
  end

  def self.config
    @configuration ||= TranslatableColumn::Configuration.new
  end

  configure do |config|
    config.locales          = ["en", "fr"]
    config.default          = "en"
    config.fallback         = true
    config.only_main_locale = true
  end
end
