module TranslatableColumn
  module Translatable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def translatable(*fields)
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

      private

      def define_translation(field)
        define_method(field.to_sym) do
          if send("#{field}_#{::Translatable.locale}").present?
            send "#{field}_#{::Translatable.locale}"
          elsif ::TranslatableColumn.config.fallback
            send "#{field}_#{::TranslatableColumn.config.default}"
          else
            send "#{field}_#{::Translatable.locale}"
          end
        end
      end

      def define_column_name(field)
        define_singleton_method "#{field}_localized_column".to_sym do
          "#{field}_#{::Translatable.locale}".to_sym
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
