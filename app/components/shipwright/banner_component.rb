module Shipwright
  class BannerComponent < BaseComponent
    # Optional leading visual — exactly one of icon, avatar, or logo.
    #   banner.with_icon(name: :info)
    #   banner.with_avatar(src: "/u.jpg", alt: "User")
    #   banner.with_logo(src: "/l.png", alt: "Acme")
    renders_one :icon, IconComponent
    renders_one :avatar, AvatarComponent
    renders_one :logo, LogoComponent

    # Optional trailing link action.
    #   banner.with_link(href: "#") { "Link" }
    renders_one :link, LinkComponent

    def leading_visual
      icon || avatar || logo
    end

    def leading_visual?
      icon? || avatar? || logo?
    end

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(header: nil, class: nil, **html_attrs)
      @header = header
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def header_present?
      @header.present? || leading_visual?
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
