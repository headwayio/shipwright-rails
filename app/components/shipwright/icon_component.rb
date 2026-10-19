require_relative "icons"

module Shipwright
  class IconComponent < BaseComponent
    SIZES = {
      sm: "w-4 h-4",  # 16px
      md: "w-6 h-6",  # 24px — matches Feather native viewBox
      lg: "w-8 h-8"   # 32px
    }.freeze

    class << self
      # Exposed for tests / discoverability. Returns symbol keys.
      def icon_names
        @icon_names ||= Icons::DATA.keys.map(&:to_sym).freeze
      end
    end

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(name:, size: :md, class: nil, **html_attrs)
      @name = name.to_s
      @size = size
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      paths = Icons::DATA.fetch(@name) do
        raise ArgumentError, "#{self.class}: unknown icon :#{@name}. Available: #{Icons::DATA.keys.sort.join(', ')}"
      end
      size_classes = SIZES.fetch(@size) do |v|
        raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{SIZES.keys.join(', ')}"
      end

      # Icons without an explicit aria-label are decorative and hidden from
      # screen readers. When a consumer provides aria-label, treat the icon
      # as meaningful and skip aria-hidden.
      aria_label = @html_attrs[:"aria-label"] || @html_attrs[:aria_label]
      accessibility_attrs = aria_label ? {} : { "aria-hidden": "true" }

      content_tag :svg,
        paths,
        class: classes(size_classes, consumer: @class),
        xmlns: "http://www.w3.org/2000/svg",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        **accessibility_attrs,
        **@html_attrs
    end
  end
end
