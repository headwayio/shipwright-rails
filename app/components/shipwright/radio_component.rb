module Shipwright
  # Radio button form control with optional label + caption. Matches
  # Shipwright Pro's Radio atom.
  #
  # Usage (single radio):
  #   <%= render Shipwright::RadioComponent.new(
  #     name: "plan", value: "pro", label: "Pro", caption: "Most popular"
  #   ) %>
  #
  # Radios with the same `name:` form a mutually-exclusive group. For a
  # labeled group with "(required)" marker + vertical/horizontal layout,
  # prefer Shipwright::RadioGroupComponent — it's a thin slot-based wrapper
  # around this component.
  #
  # Styling strategy: the <label> is a Tailwind `.group` wrapping a hidden
  # native <input type="radio"> (peer) and a visual circle. Descendants
  # react to state via `group-has-checked:` to reveal the filled dot.
  # Using literal class strings (not interpolated) so Tailwind's scanner
  # picks them up.
  class RadioComponent < BaseComponent
    VARIANTS = %i[default destructive].freeze
    LABEL_POSITIONS = %i[right left].freeze
    SIZES = %i[sm md].freeze

    def initialize(
      name:,
      value:,
      label: nil,
      caption: nil,
      checked: false,
      disabled: false,
      variant: :default,
      label_position: :right,
      size: :sm,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.include?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.join(', ')}"
      end
      unless LABEL_POSITIONS.include?(label_position)
        raise ArgumentError, "#{self.class}: unknown label_position :#{label_position}. Valid: #{LABEL_POSITIONS.join(', ')}"
      end
      unless SIZES.include?(size)
        raise ArgumentError, "#{self.class}: unknown size :#{size}. Valid: #{SIZES.join(', ')}"
      end

      @name = name
      @value = value
      @label_text = label
      @caption = caption
      @checked = checked
      @disabled = disabled
      @variant = variant
      @label_position = label_position
      @size = size
      # Rails convention: auto-derive id as "name_value" so multiple radios
      # sharing a name get unique ids and <label for=...> targets the
      # correct one.
      @id = id || "#{name}_#{value}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :value, :label_text, :caption, :id, :html_attrs, :label_position, :size

    def checked?
      @checked
    end

    def disabled?
      @disabled
    end

    def destructive?
      @variant == :destructive
    end

    def large?
      @size == :md
    end

    def label_classes
      classes(
        "group inline-flex items-start gap-2 font-sans text-sm leading-5 text-text-primary",
        @label_position == :left ? "flex-row-reverse justify-end" : nil,
        @disabled ? "cursor-not-allowed opacity-70" : "cursor-pointer",
        consumer: @class
      )
    end

    # Visual circle. Two complete class strings per variant (literal, no
    # interpolation) so the Tailwind scanner picks them up. The inner dot
    # is a separate <span> hidden until `group-has-checked:` reveals it.
    def visual_classes
      sizing = large? ? "w-6 h-6" : "w-5 h-5"

      base = "relative flex items-center justify-center shrink-0 #{sizing} rounded-full border-2 bg-transparent transition-colors " \
             "peer-focus-visible:ring-2 peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background-primary " \
             "peer-disabled:bg-interactive-disable peer-disabled:border-interactive-disable"

      variant_styles = if destructive?
        "border-utility-negative-default " \
          "group-has-checked:border-utility-negative-default " \
          "peer-focus-visible:ring-utility-negative-default"
      else
        "border-interactive-primary-default " \
          "group-has-checked:border-interactive-primary-default " \
          "peer-focus-visible:ring-interactive-primary-default"
      end

      "#{base} #{variant_styles}"
    end

    # Classes for the inner filled dot. Shown only when the group has a
    # checked input. Variant determines color.
    def dot_classes
      dot_size = large? ? "w-3 h-3" : "w-2.5 h-2.5"
      color = destructive? ? "bg-utility-negative-default" : "bg-interactive-primary-default"
      "hidden group-has-checked:block rounded-full #{dot_size} #{color} group-has-[:disabled]:bg-interactive-disable"
    end
  end
end
