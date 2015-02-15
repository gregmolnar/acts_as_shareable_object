module ActionView
  module ShareableObject
    module ViewHelpers
      def social_meta_tags_for(object, overrides = {})
        raise "You need to add acts_as_shareable_object to your #{object.class} model." unless object.respond_to?(:social_meta_properties)
        parse_tags(object.social_meta_properties).join("\n").html_safe
      end

      private

      def parse_tags(properties, namespace = nil)
        tags = []
        Array(properties).each do |key, value|
          if value.is_a?(Hash)
            tags << parse_tags(value, [namespace, key].compact.join(':'))
          else
            name = [namespace, key].join(':')
            tags << tag(:meta, {name: name, property: name, content: value}, true)
          end
        end
        tags
      end
    end
  end
end
