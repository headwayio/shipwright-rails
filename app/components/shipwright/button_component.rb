module Shipwright
  class ButtonComponent < BaseComponent
    # Hierarchy: visual priority. Maps to Shipwright Pro's "Hierarchy" variant.
    # Each hierarchy defines background, text, border, and focus-ring classes.
    HIERARCHIES = {
      primary: {
        bg: "bg-interactive-primary-default hover:bg-interactive-primary-hover active:bg-interactive-primary-pressed",
        text: "text-interactive-on-primary",
        border: "border-0",
        ring: "focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-offset-2 focus-visible:ring-offset-background-primary focus-visible:outline-none"
      },
      secondary: {
        bg: "bg-interactive-secondary-default hover:bg-interactive-primary-hover active:bg-interactive-primary-pressed",
        text: "text-text-primary hover:text-interactive-on-primary active:text-interactive-on-primary",
        border: "border border-border-interactive",
        ring: "focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-offset-2 focus-visible:ring-offset-background-primary focus-visible:outline-none"
      },
      tertiary: {
        bg: "bg-transparent hover:bg-interactive-disable active:bg-interactive-primary-pressed",
        text: "text-text-primary active:text-interactive-on-primary",
        border: "border-0",
        ring: "focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-offset-2 focus-visible:ring-offset-background-primary focus-visible:outline-none"
      },
      destructive: {
        bg: "bg-utility-negative-default hover:bg-utility-negative-default/90 active:bg-utility-negative-default/80",
        text: "text-utility-on-negative",
        border: "border-0",
        ring: "focus-visible:ring-2 focus-visible:ring-utility-negative-default focus-visible:ring-offset-2 focus-visible:ring-offset-background-primary focus-visible:outline-none"
      }
    }.freeze

    # Size: Shipwright Pro dimensions
    #   Small:  32h (icon-only: 32×32)
    #   Medium: 44h (icon-only: 44×44)
    #   Large:  52h (icon-only: 52×52)
    SIZES = {
      sm: { height: "h-8", padding: "px-sm", icon_only: "w-8 p-0", text: "text-sm leading-2xs" },
      md: { height: "h-11", padding: "px-sm", icon_only: "w-11 p-0", text: "text-base leading-2xs" },
      lg: { height: "h-13", padding: "px-sm", icon_only: "w-13 p-0", text: "text-base leading-2xs" }
    }.freeze

    # Shape: border-radius only
    SHAPES = {
      rounded: "rounded-md",
      pill: "rounded-full"
    }.freeze

    # Disabled state — overrides hierarchy colors regardless of variant
    DISABLED = "bg-interactive-disable text-text-disabled border-0 cursor-not-allowed hover:bg-interactive-disable hover:text-text-disabled active:bg-interactive-disable".freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. This matches HTML attribute naming conventions
    # and is the established pattern for all Shipwright components.
    def initialize(hierarchy: :primary, size: :md, shape: :rounded, icon_only: false, disabled: false, class: nil, **html_attrs)
      @hierarchy = hierarchy
      @size = size
      @shape = shape
      @icon_only = icon_only
      @disabled = disabled
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      h = HIERARCHIES.fetch(@hierarchy) { |v| raise ArgumentError, "#{self.class}: unknown hierarchy :#{v}. Valid: #{HIERARCHIES.keys.join(', ')}" }
      s = SIZES.fetch(@size) { |v| raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{SIZES.keys.join(', ')}" }
      shape_class = SHAPES.fetch(@shape) { |v| raise ArgumentError, "#{self.class}: unknown shape :#{v}. Valid: #{SHAPES.keys.join(', ')}" }

      size_classes = @icon_only ? "#{s[:height]} #{s[:icon_only]}" : "#{s[:height]} #{s[:padding]}"
      state_classes = @disabled ? DISABLED : "#{h[:bg]} #{h[:text]} #{h[:border]} #{h[:ring]}"

      attrs = @html_attrs.merge(@disabled ? { disabled: true } : {})

      content_tag :button, content,
        class: classes(
          "inline-flex items-center justify-center gap-2xs font-sans font-normal transition-colors",
          size_classes,
          s[:text],
          shape_class,
          state_classes,
          consumer: @class
        ),
        **attrs
    end
  end
end
