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

    # @label Avatar + header + body
    def with_avatar
      render(Shipwright::BannerComponent.new(header: "From John Doe")) do |banner|
        banner.with_avatar(initials: "JD", size: :xsm)
        "New comment on the design review thread."
      end
    end

    # @label Logo + header + body
    def with_logo
      render(Shipwright::BannerComponent.new(header: "Acme announcement")) do |banner|
        banner.with_logo(alt: "Acme", size: :xs)
        "New features available in the latest release."
      end
    end
  end
end
