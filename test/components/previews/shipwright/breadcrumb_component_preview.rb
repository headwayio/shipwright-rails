module Shipwright
  class BreadcrumbComponentPreview < Lookbook::Preview
    # @label Default (chevron separator)
    def default
      render_with_template
    end

    # @label Slash separator
    def slash_separator
      render_with_template
    end

    # @label Single item
    def single_item
      render(Shipwright::BreadcrumbComponent.new) do |crumb|
        crumb.with_item(href: "/", icon: :home) { "Home" }
      end
    end

    # @label Without icons
    def no_icons
      render_with_template
    end

    # @label Long trail
    def long_trail
      render_with_template
    end

    # @label With avatar item
    def with_avatar
      render(Shipwright::BreadcrumbComponent.new) do |crumb|
        crumb.with_item(href: "/", icon: :home) { "Home" }
        crumb.with_item(href: "/people", avatar: { initials: "JD" }) { "John Doe" }
        crumb.with_item { "Profile" }
      end
    end

    # @label With logo item
    def with_logo
      render(Shipwright::BreadcrumbComponent.new) do |crumb|
        crumb.with_item(href: "/", logo: { alt: "Acme" }) { "Acme" }
        crumb.with_item(href: "/projects") { "Projects" }
        crumb.with_item { "Widget" }
      end
    end
  end
end
