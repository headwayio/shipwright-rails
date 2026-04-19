module Shipwright
  # Checkbox form control with optional label + caption. Tri-state support
  # (unchecked / checked / indeterminate) and destructive variant matching
  # Shipwright Pro's Checkbox atom.
  #
  # Usage:
  #   <%= render Shipwright::CheckboxComponent.new(name: "terms", label: "Accept") %>
  #   <%= render Shipwright::CheckboxComponent.new(name: "x", label: "Yes", caption: "Opt-in") %>
  #   <%= render Shipwright::CheckboxComponent.new(name: "danger", label: "Delete", variant: :destructive) %>
  #
  # Styling strategy: the <label> is a Tailwind `.group` and carries
  # `data-indeterminate="true"` when applicable. Descendants react to state
  # via `group-has-checked:` and `group-data-[indeterminate=true]:` arbitrary
  # variants. Using literal class strings (not interpolated) so Tailwind's
  # scanner picks them up.
  #
  # Indeterminate state: the component emits data-indeterminate="true" on the
  # label wrapper for CSS targeting. The native `input.indeterminate` DOM
  # property is JS-only; consuming apps can bootstrap it with a small script
  # if they need the `:indeterminate` pseudo-class to apply. The visual
  # treatment works via the data-indeterminate attribute without JS.
  class CheckboxComponent < BaseComponent
    VARIANTS = %i[default destructive].freeze
    LABEL_POSITIONS = %i[right left].freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(
      name: nil,
      value: "1",
      label: nil,
      caption: nil,
      checked: false,
      indeterminate: false,
      disabled: false,
      variant: :default,
      label_position: :right,
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

      @name = name
      @value = value
      @label_text = label
      @caption = caption
      @checked = checked
      @indeterminate = indeterminate
      @disabled = disabled
      @variant = variant
      @label_position = label_position
      @id = id || name
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :value, :label_text, :caption, :id, :html_attrs, :label_position

    def checked?
      @checked
    end

    def disabled?
      @disabled
    end

    def indeterminate?
      @indeterminate
    end

    def destructive?
      @variant == :destructive
    end

    def label_classes
      classes(
        "group inline-flex items-start gap-2 font-sans text-sm leading-5 text-text-primary",
        @label_position == :left ? "flex-row-reverse justify-end" : nil,
        @disabled ? "cursor-not-allowed opacity-70" : "cursor-pointer",
        consumer: @class
      )
    end

    # Classes on the visual "box". Two complete class strings per variant —
    # literal (no Ruby interpolation) so Tailwind's source scanner picks them
    # up and generates the corresponding CSS rules.
    def visual_classes
      base = "relative flex items-center justify-center shrink-0 w-5 h-5 rounded-md border-2 bg-transparent transition-colors " \
             "peer-focus-visible:ring-2 peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background-primary " \
             "peer-disabled:bg-interactive-disable peer-disabled:border-interactive-disable"

      variant_styles = if destructive?
        "border-utility-negative-default " \
          "group-has-checked:bg-utility-negative-default group-has-checked:border-utility-negative-default " \
          "group-data-[indeterminate=true]:bg-utility-negative-default group-data-[indeterminate=true]:border-utility-negative-default " \
          "peer-focus-visible:ring-utility-negative-default"
      else
        "border-interactive-primary-default " \
          "group-has-checked:bg-interactive-primary-default group-has-checked:border-interactive-primary-default " \
          "group-data-[indeterminate=true]:bg-interactive-primary-default group-data-[indeterminate=true]:border-interactive-primary-default " \
          "peer-focus-visible:ring-interactive-primary-default"
      end

      "#{base} #{variant_styles}"
    end
  end
end
