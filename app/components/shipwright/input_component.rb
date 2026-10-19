module Shipwright
  # Single-line text input with optional leading and trailing icons,
  # label, caption, and three state variants (default / success / destructive).
  # Maps to Shipwright Pro's Input atom.
  #
  # For multi-line text entry, use TextareaComponent (separate component).
  #
  # Usage:
  #   <%= render Shipwright::InputComponent.new(
  #     name: "email", type: :email, label: "Email",
  #     placeholder: "giorgio@armani.com",
  #     leading_icon: :search, trailing_icon: :"arrow-right",
  #     caption: "We never share your address."
  #   ) %>
  #
  #   <%= render Shipwright::InputComponent.new(
  #     name: "email", value: "invalid@", variant: :destructive,
  #     error: "Please enter a valid email"
  #   ) %>
  #
  # ## HTML5 client-side validation
  #
  # Any keyword arg the component doesn't explicitly consume is forwarded to
  # the underlying `<input>` element, so you get native HTML5 validation for
  # free when the input is inside a `<form>`:
  #
  #   # Required + min length + pattern (regex)
  #   <%= render Shipwright::InputComponent.new(
  #     name: "username", type: :text, label: "Username",
  #     required: true,
  #     minlength: 3, maxlength: 24,
  #     pattern: '[a-z0-9_]+',
  #     title: "Lowercase letters, numbers, and underscores only"
  #   ) %>
  #
  #   # Email with autocomplete hint
  #   <%= render Shipwright::InputComponent.new(
  #     name: "email", type: :email, label: "Email",
  #     required: true, autocomplete: "email", inputmode: "email"
  #   ) %>
  #
  #   # Numeric range + step
  #   <%= render Shipwright::InputComponent.new(
  #     name: "age", type: :number, label: "Age",
  #     min: 13, max: 120, step: 1, required: true
  #   ) %>
  #
  # Common HTML5 validation attrs (forwarded via `**html_attrs`):
  # - `required`, `readonly`, `disabled`   — also have dedicated props
  # - `pattern: "regex"`                    — regex the value must match
  # - `minlength: N`, `maxlength: N`        — string length bounds
  # - `min:`, `max:`, `step:`               — numeric/date bounds
  # - `title: "..."`                        — tooltip shown on constraint violation
  # - `autocomplete: "email" | "off" | ...` — browser autofill hint
  # - `inputmode: "numeric" | "email" | ...` — on-screen keyboard hint
  # - `multiple: true`                      — for type=email (comma-separated)
  # - `spellcheck: false`
  #
  # On submit, the browser runs the validity checks automatically and
  # focuses the first invalid field. To style invalid inputs, use the
  # `:invalid` CSS pseudo-class or read `input.validity` in JS. The
  # `error:` prop here is for *server-reported* errors (after submit);
  # it forces the destructive variant and wires `aria-invalid` +
  # `aria-describedby` for screen readers.
  #
  # To suppress browser validation entirely, pass `formnovalidate: true`
  # on the submit button, or `novalidate: true` on the `<form>`.
  class InputComponent < BaseComponent
    VARIANTS = %i[default success destructive].freeze

    # The subset of <input type="..."> values that make sense here.
    # Specialized inputs (file, checkbox, radio, etc.) have their own components.
    TYPES = %i[text email password url search tel number date time datetime-local].freeze

    def initialize(
      name:,
      type: :text,
      value: nil,
      label: nil,
      caption: nil,
      placeholder: nil,
      leading_icon: nil,
      trailing_icon: nil,
      variant: :default,
      disabled: false,
      readonly: false,
      required: false,
      error: nil,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.include?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.join(', ')}"
      end
      unless TYPES.include?(type)
        raise ArgumentError, "#{self.class}: unknown type :#{type}. Valid: #{TYPES.join(', ')}"
      end

      @name = name
      @type = type
      @value = value
      @label_text = label
      @caption = caption
      @placeholder = placeholder
      @leading_icon = leading_icon
      @trailing_icon = trailing_icon
      # Passing an `error:` implies destructive regardless of variant arg.
      @variant = (error && !error.to_s.strip.empty?) ? :destructive : variant
      @disabled = disabled
      @readonly = readonly
      @required = required
      @error = error
      @id = id || "shipwright-input-#{name.to_s.gsub(/[^a-z0-9]/i, '_')}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :type, :value, :label_text, :caption, :placeholder,
      :leading_icon, :trailing_icon, :error, :id, :html_attrs

    def disabled?
      @disabled
    end

    def readonly?
      @readonly
    end

    def required?
      @required
    end

    def success?
      @variant == :success
    end

    def destructive?
      @variant == :destructive
    end

    def wrapper_classes
      classes("font-sans flex flex-col gap-1", consumer: @class)
    end

    def field_row_classes
      base = "flex items-center gap-2 px-3 rounded-md border bg-background-primary transition-colors " \
             "focus-within:ring-2 focus-within:ring-offset-1 focus-within:ring-offset-background-primary"
      state = if disabled?
        "border-border-primary bg-interactive-disable"
      elsif destructive?
        "border-utility-negative-default focus-within:ring-utility-negative-default"
      elsif success?
        "border-utility-positive-default focus-within:ring-utility-positive-default"
      else
        "border-border-primary hover:border-interactive-primary-default focus-within:border-interactive-primary-default focus-within:ring-interactive-primary-default"
      end
      "#{base} #{state}"
    end

    def input_classes
      base = "flex-1 min-w-0 py-2 bg-transparent text-sm leading-5 border-0 outline-none placeholder:text-text-disabled"
      color = if disabled?
        "text-text-disabled cursor-not-allowed"
      elsif destructive?
        "text-utility-negative-default"
      else
        "text-text-primary"
      end
      "#{base} #{color}"
    end

    def icon_classes
      if disabled?
        "shrink-0 text-text-disabled"
      elsif destructive?
        "shrink-0 text-utility-negative-default"
      elsif success?
        "shrink-0 text-utility-positive-default"
      else
        "shrink-0 text-text-primary"
      end
    end

    def caption_classes
      base = "text-xs leading-4"
      if destructive?
        "#{base} text-utility-negative-default"
      elsif success?
        "#{base} text-utility-positive-default"
      else
        "#{base} text-text-disabled"
      end
    end

    def message_text
      error.presence || caption
    end
  end
end
