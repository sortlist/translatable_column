module TranslatableColumn
  module Translatable
    extend ActiveSupport::Concern

    included do
    end

    module LocalInstanceMethods
      def locale
        self.class.locale
      end

      private

      def used_locale?
        ::TranslatableColumn.config.locales.include?(locale)
      end
    end

    module ClassMethods
      def translatable(*fields)
        fields.each do |field|
          define_translation field
          define_column_name field
          define_used_methods field
        end

        include ::TranslatableColumn::Translatable::LocalInstanceMethods
      end

      def translated_attributes(*names)
        ::TranslatableColumn.config.locales.reduce([]) do |attrs, locale|
          attrs + names.map do |name|
            "#{name}_#{locale}".to_sym
          end
        end
      end

      def locale
        locale = I18n.locale.to_s
        locale = locale.split("-").first if ::TranslatableColumn.config.only_main_locale

        if ::TranslatableColumn.config.locales.any? { |authorized_locale| authorized_locale.to_s == locale }
          locale
        else
          ::TranslatableColumn.config.fallback
        end
      end

      private

      def define_translation(field)
        define_method(field.to_sym) do
          if used_locale? && send("#{field}_#{locale}").present?
            send "#{field}_#{locale}"
          else
            ""
          end
        end
      end

      def define_column_name(field)
        define_singleton_method "#{field}_localized_column".to_sym do
          if used_locale?
            "#{field}_#{locale}".to_sym
          else
            ""
          end
        end
      end

      def define_used_methods(field)
        define_singleton_method "localized_#{field.to_s.pluralize}".to_sym do
          ::TranslatableColumn.config.locales.map { |locale| "#{field}_#{locale}".to_sym }
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, TranslatableColumn::Translatable
