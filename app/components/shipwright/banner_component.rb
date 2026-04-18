module Shipwright
  class BannerComponent < BaseComponent
    # Optional leading icon. Consumer-facing API:
    #   banner.with_icon(name: :info)
    renders_one :icon, IconComponent

    # Optional trailing link action.
    #   banner.with_link(href: "#") { "Link" }
    renders_one :link, LinkComponent

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(header: nil, class: nil, **html_attrs)
      @header = header
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def header_present?
      @header.present? || icon?
    end

    attr_reader :header, :html_attrs

    def container_classes
      classes(
        "flex items-start gap-0 p-4 bg-background-secondary font-sans",
        consumer: @class
      )
    end
  end
end
