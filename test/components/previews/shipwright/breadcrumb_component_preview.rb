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
  end
end
