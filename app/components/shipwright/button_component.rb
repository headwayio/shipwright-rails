module Shipwright
  class ButtonComponent < BaseComponent
    VARIANTS = {
      primary: "bg-primary text-white hover:bg-primary/90",
      secondary: "bg-secondary text-white hover:bg-secondary/90",
      outline: "border border-primary text-primary hover:bg-primary/10"
    }.freeze

    SIZES = {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base",
      lg: "px-6 py-3 text-lg"
    }.freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. This matches HTML attribute naming conventions
    # and is the established pattern for all Shipwright components.
    def initialize(variant: :primary, size: :md, class: nil, **html_attrs)
      @variant = variant
      @size = size
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      content_tag :button, content,
        class: classes(
          "inline-flex items-center justify-center rounded-default font-medium transition-colors",
          VARIANTS.fetch(@variant) { |v| raise ArgumentError, "#{self.class}: unknown variant :#{v}. Valid: #{VARIANTS.keys.join(', ')}" },
          SIZES.fetch(@size) { |s| raise ArgumentError, "#{self.class}: unknown size :#{s}. Valid: #{SIZES.keys.join(', ')}" },
          consumer: @class
        ),
        **@html_attrs
    end
  end
end
