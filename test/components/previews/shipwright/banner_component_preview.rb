module Shipwright
  class BannerComponentPreview < Lookbook::Preview
    # @label Default (icon + header + body + link)
    def default
      render_with_template
    end

    # @label Body only
    def body_only
      render(Shipwright::BannerComponent.new) do
        "Place holder text for notifications. Enter text into this container."
      end
    end

    # @label Icon + body
    def icon_and_body
      render_with_template
    end

    # @label Body + link (no icon)
    def body_and_link
      render_with_template
    end

    # @label Header + body (no icon)
    def header_and_body
      render(Shipwright::BannerComponent.new(header: "Alert")) do
        "Place holder text for notifications."
      end
    end
  end
end
