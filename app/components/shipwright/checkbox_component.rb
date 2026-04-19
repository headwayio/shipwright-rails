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
  # Indeterminate state: the component emits data-indeterminate="true" on the
  # label wrapper for CSS targeting, but the DOM `input.indeterminate`
  # property is JS-only. Consuming apps should call
  #   document.querySelectorAll('[data-indeterminate="true"] input').forEach(i => i.indeterminate = true)
  # after render (Stimulus controller, MutationObserver, etc.) if they need
  # the native `:indeterminate` pseudo-class to apply. The visual treatment
  # works via the data-indeterminate attribute regardless.
  class CheckboxComponent < BaseComponent
    VARIANTS = {
      default: {
        bg: "bg-interactive-primary-default",
        border: "border-interactive-primary-default",
        ring: "focus-visible:ring-interactive-primary-default"
      },
      destructive: {
        bg: "bg-utility-negative-default",
        border: "border-utility-negative-default",
        ring: "focus-visible:ring-utility-negative-default"
      }
    }.freeze

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
      unless VARIANTS.key?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.keys.join(', ')}"
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

    def variant_classes
      VARIANTS.fetch(@variant)
    end

    def label_classes
      classes(
        "inline-flex items-start gap-2 font-sans text-sm leading-5 text-text-primary",
        @label_position == :left ? "flex-row-reverse justify-end" : nil,
        @disabled ? "cursor-not-allowed opacity-70" : "cursor-pointer",
        consumer: @class
      )
    end

    # The visual "box" element styled via peer-* selectors on the hidden native
    # input. Uses CSS to flip between unchecked/checked/indeterminate/disabled
    # visuals without JavaScript (except for native `:indeterminate` pseudo-
    # class which requires setting input.indeterminate in JS).
    def visual_classes
      v = variant_classes
      [
        "relative flex items-center justify-center shrink-0",
        "w-5 h-5 rounded-md",
        # Unchecked border
        "border-2 #{v[:border]} bg-transparent",
        # Checked/indeterminate: fill with variant bg
        "peer-checked:#{v[:bg]} peer-indeterminate:#{v[:bg]}",
        # Focused ring (via peer-focus-visible on hidden input)
        "peer-focus-visible:ring-2 peer-focus-visible:ring-offset-2 peer-focus-visible:ring-offset-background-primary #{v[:ring]}",
        # Disabled: dim to interactive-disable
        "peer-disabled:bg-interactive-disable peer-disabled:border-interactive-disable",
        # Transition
        "transition-colors"
      ].join(" ")
    end
  end
end
