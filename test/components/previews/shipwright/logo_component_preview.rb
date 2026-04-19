module Shipwright
  class LogoComponentPreview < Lookbook::Preview
    # @label Default (image fallback)
    def default
      render(Shipwright::LogoComponent.new(alt: "Acme"))
    end

    # @label With wordmark
    def with_wordmark
      render(Shipwright::LogoComponent.new(alt: "Acme", wordmark: "Acme"))
    end

    # @label With image source
    def with_image
      src = "data:image/svg+xml;utf8," + ERB::Util.url_encode(
        %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 40"><rect width="40" height="40" rx="8" fill="#2563eb"/><text x="20" y="27" text-anchor="middle" fill="white" font-size="20" font-weight="700" font-family="system-ui">A</text></svg>)
      )
      render(Shipwright::LogoComponent.new(src: src, alt: "Acme", wordmark: "Acme", size: :lg))
    end

    # @label Custom inline SVG mark
    def custom_svg
      render(Shipwright::LogoComponent.new(alt: "Headway", wordmark: "Headway", size: :lg)) do
        <<~SVG.html_safe
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-full h-full text-interactive-primary-default">
            <circle cx="12" cy="12" r="10"/>
            <text x="12" y="16" text-anchor="middle" fill="white" font-size="12" font-weight="700" font-family="system-ui">H</text>
          </svg>
        SVG
      end
    end

    # @label Linked logo
    def linked
      render(Shipwright::LogoComponent.new(alt: "Acme", wordmark: "Acme", href: "#", size: :md))
    end

    # @label Sizes
    def sizes
      render_with_template
    end
  end
end
