module TranslatableColumn
  module Translatable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def translatable(*fields, fallback: ::TranslatableColumn.config.fallback)
        self.fallback = fallback
        fields.each do |field|
          define_translation field
          define_column_name field
          define_used_methods field
        end
      end

      def translated_attributes(*names)
        ::TranslatableColumn.config.locales.reduce([]) do |attrs, locale|
          attrs + names.map do |name|
            "#{name}_#{locale}".to_sym
          end
        end
      end

      attr_reader :fallback

      private

      attr_writer :fallback

      def define_translation(field)
        define_method(field.to_sym) do
          if send("#{field}_#{::TranslatableColumn.locale}").present?
            send "#{field}_#{::TranslatableColumn.locale}"
          elsif self.class.fallback
            send "#{field}_#{::TranslatableColumn.config.default}"
          else
            send "#{field}_#{::TranslatableColumn.locale}"
          end
        end
      end

      def define_column_name(field)
        define_singleton_method "#{field}_localized_column".to_sym do
          "#{field}_#{::TranslatableColumn.locale}".to_sym
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
