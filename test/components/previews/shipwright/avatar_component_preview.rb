module Shipwright
  class AvatarComponentPreview < Lookbook::Preview
    # @label Image
    def image
      render Shipwright::AvatarComponent.new(
        src: "https://i.pravatar.cc/150?img=12",
        alt: "Portrait"
      )
    end

    # @label Initials
    def initials
      render Shipwright::AvatarComponent.new(initials: "WS")
    end

    # @label Icon fallback (no src / no initials)
    def icon_fallback
      render Shipwright::AvatarComponent.new(alt: "Anonymous user")
    end

    # @label All Sizes
    def sizes
      render_with_template
    end

    # @label Content Types
    def content_types
      render_with_template
    end

    # @label Status Indicators
    def status
      render_with_template
    end

    # @label With Name + Subtitle
    def with_meta
      render_with_template
    end
  end
end
