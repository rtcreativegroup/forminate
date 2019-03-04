module Forminate
  class AssociationBuilder
    def initialize(name, attrs)
      @name = name
      @attrs = attrs
    end

    def build
      if primary_key
        object = klass.find(primary_key)
        object.assign_attributes(association_attributes)
        object
      else
        klass.new(association_attributes)
      end
    end

    def attribute_keys_for_cleanup
      prefixed_attributes.keys.push(name)
    end

    private

    attr_reader :name, :attrs

    def klass
      name.to_s.classify.constantize
    end

    def prefix
      "#{name}_"
    end

    def primary_key
      return unless klass.respond_to?(:primary_key)

      value_for_nested_key(name, klass.primary_key) ||
        value_for_prefixed_key(name, klass.primary_key)
    end

    def value_for_prefixed_key(*args)
      attrs[args.join('_').to_sym]
    end

    def value_for_nested_key(*args)
      attrs.dig(*args.map(&:to_sym))
    end

    def association_attributes
      (nested_attributes || {}).reverse_merge(unprefixed_attributes)
    end

    def prefixed_attributes
      attrs.select { |k, _| k =~ /^#{prefix}/ }
    end

    def unprefixed_attributes
      prefixed_attributes.each_with_object({}) do |(name, definition), hash|
        new_key = name.to_s.sub(prefix, '').to_sym
        hash[new_key] = definition
      end
    end

    def nested_attributes
      attrs[name] if attrs[name].is_a?(Hash)
    end
  end
end
