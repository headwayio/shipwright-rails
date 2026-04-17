module Shipwright
  class LinkComponent < BaseComponent
    # Decoration controls the text-decoration (underline). Maps to Figma's
    # "Decoration" variant (Yes/No).
    DECORATIONS = {
      underline: "underline underline-offset-2",
      none: "no-underline"
    }.freeze

    # Default state classes. Hover/active/focus states use Tailwind pseudo-class
    # modifiers so browser events drive the visual changes, matching Figma's
    # State variants (Default/Hover/Pressed/Focused).
    ENABLED_CLASSES = [
      "text-interactive-primary-default",
      "hover:text-interactive-primary-hover",
      "active:text-interactive-primary-pressed",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-offset-2 focus-visible:ring-offset-background-primary",
      "transition-colors"
    ].join(" ").freeze

    # Disabled state — uses interactive-disable (matches Figma's Disabled
    # variant which resolved to Interactive/Disable=#eaeaea).
    DISABLED_CLASSES = "text-interactive-disable cursor-not-allowed".freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(href: nil, decoration: :underline, disabled: false, class: nil, **html_attrs)
      @href = href
      @decoration = decoration
      @disabled = disabled
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      decoration_class = DECORATIONS.fetch(@decoration) do |v|
        raise ArgumentError, "#{self.class}: unknown decoration :#{v}. Valid: #{DECORATIONS.keys.join(', ')}"
      end

      attrs = @html_attrs.dup
      if @disabled
        # Drop href so the link isn't navigable; signal state to AT.
        attrs[:"aria-disabled"] = "true"
        attrs[:tabindex] = "-1"
      else
        attrs[:href] = @href if @href
      end

      content_tag :a, content,
        class: classes(
          "inline text-sm font-sans font-normal leading-4",
          decoration_class,
          @disabled ? DISABLED_CLASSES : ENABLED_CLASSES,
          consumer: @class
        ),
        **attrs
    end
  end
end
