module Shipwright
  class LinkComponentPreview < Lookbook::Preview
    # @label Default (underlined)
    def default
      render(Shipwright::LinkComponent.new(href: "#")) { "Link" }
    end

    # @label No decoration
    def no_decoration
      render(Shipwright::LinkComponent.new(href: "#", decoration: :none)) { "Link" }
    end

    # @label Disabled
    def disabled
      render(Shipwright::LinkComponent.new(href: "#", disabled: true)) { "Link" }
    end

    # @label All States
    def all_states
      render_with_template
    end

    # @label External Link
    def external
      render(Shipwright::LinkComponent.new(href: "https://example.com", target: "_blank", rel: "noopener")) { "External" }
    end
  end
end
