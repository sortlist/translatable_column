# TranslatableColumn

TranslatableColumn give some facilities to select the right field in function of the locale.

Unlike the name, this gem can be also used on PORO object.
The only dependency is that the object have a getter method for all locales for all translatable attributes (`<attribute>_<locale>`).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "translatable_column", github: "sortlist/translatable_column"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install translatable_column

## Usage

Add an initializer translatable_column.rb.

```ruby
TranslatableColumn.configure do |config|
  config.locales          = ["en", "fr"]
  config.default          = Rails.configuration.i18n.default_locale.to_s # locale to use when current locale is not present in config.locales
  config.fallback         = true # use default locale when the attribute is not present in current locale
  config.only_main_locale = true # use only "en" when current locale is "en-GB"
end
```

In model

```ruby
# ## Schema Information
#
# Table name: `agencies`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`created_at`**      | `datetime`         | `not null`
# **`description_en`**  | `text`             |
# **`description_fr`**  | `string`           |
# **`id`**              | `integer`          | `not null, primary key`
# **`name_en`**         | `string`           |
# **`name_fr`**         | `string`           |
# **`updated_at`**      | `datetime`         | `not null`
class Agency < ActiveRecord::Base
  include TranslatableColumn::Translatable

  translatable :name, :description, fallback: false # fallback is optional
end

Agency.translated_attributes :name # [:name_en, :name_fr]
I18n.locale # :en-GB
TranslatableColumn.locale # "en"
Agency.first.name # "Agency"
I18n.locale = :fr
Agency.first.name # "Agence"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sortlist/translatable_column. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
