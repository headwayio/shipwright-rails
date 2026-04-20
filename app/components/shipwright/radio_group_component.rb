module Shipwright
  # A labeled group of radio buttons sharing a single `name:`. Renders a
  # `<fieldset>` with a `<legend>`, a "(required)" marker when appropriate,
  # and a configurable vertical or horizontal layout.
  #
  # Usage:
  #   <%= render Shipwright::RadioGroupComponent.new(
  #     name: "plan", label: "Plan", required: true, layout: :vertical
  #   ) do |group| %>
  #     <% group.with_option(value: "free", label: "Free") %>
  #     <% group.with_option(value: "pro", label: "Pro", caption: "Most popular", checked: true) %>
  #     <% group.with_option(value: "team", label: "Team", disabled: true) %>
  #   <% end %>
  #
  # Radio options are rendered as `Shipwright::RadioComponent` instances
  # sharing the group's `name:`. Any option-specific prop (caption, disabled,
  # variant, size, label_position) is forwarded to the child Radio.
  class RadioGroupComponent < BaseComponent
    LAYOUTS = %i[horizontal vertical].freeze

    # Lambda slot — each call captures option props; the group template
    # instantiates a RadioComponent per option with the group's name.
    class Option < ViewComponent::Base
      attr_reader :value, :label, :caption, :checked, :disabled, :variant, :size, :label_position

      def initialize(value:, label: nil, caption: nil, checked: false, disabled: false,
                     variant: :default, size: :sm, label_position: :right)
        @value = value
        @label = label
        @caption = caption
        @checked = checked
        @disabled = disabled
        @variant = variant
        @size = size
        @label_position = label_position
      end

      def call
        ""
      end
    end

    renders_many :options, Option

    def initialize(
      name:,
      label: nil,
      required: false,
      layout: :horizontal,
      variant: :default,
      size: :sm,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless LAYOUTS.include?(layout)
        raise ArgumentError, "#{self.class}: unknown layout :#{layout}. Valid: #{LAYOUTS.join(', ')}"
      end

      @name = name
      @label_text = label
      @required = required
      @layout = layout
      @variant = variant
      @size = size
      @id = id || "shipwright-radio-group-#{name.to_s.gsub(/[^a-z0-9]/i, '_')}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :label_text, :id, :html_attrs

    def required?
      @required
    end

    def horizontal?
      @layout == :horizontal
    end

    def group_variant
      @variant
    end

    def group_size
      @size
    end

    def fieldset_classes
      classes("font-sans flex flex-col gap-2 border-0 p-0 m-0", consumer: @class)
    end

    def legend_classes
      "text-sm font-medium text-text-primary"
    end

    def options_layout_classes
      horizontal? ? "flex flex-row flex-wrap gap-6" : "flex flex-col gap-2"
    end
  end
end
