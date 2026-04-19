module Shipwright
  # A brand logo — image or inline SVG mark with an optional wordmark label.
  # The consuming app provides the actual mark (image src or SVG string) and
  # the wordmark text; this component handles sizing, layout, and the optional
  # link wrapper.
  #
  # Matches Shipwright Pro's Logo atom (mark + optional wordmark) across five
  # size steps (xs/sm/md/lg/xl).
  #
  # Usage:
  #   <%= render Shipwright::LogoComponent.new(src: "/logo.png", alt: "Acme") %>
  #   <%= render Shipwright::LogoComponent.new(src: "/logo.png", alt: "Acme", wordmark: "Acme", size: :lg) %>
  #   <%= render Shipwright::LogoComponent.new(alt: "Acme", wordmark: "Acme") do %>
  #     <svg ...>...</svg>  <%# custom inline mark %>
  #   <% end %>
  #   <%= render Shipwright::LogoComponent.new(src: "/logo.png", alt: "Acme", href: "/") %>
  class LogoComponent < BaseComponent
    # Size tokens mirror AvatarComponent for visual consistency.
    # Mark dimensions map 1:1 with Avatar; wordmark type scales alongside.
    SIZES = {
      xs: {
        mark: "w-4 h-4",
        wordmark: "text-xs",
        gap: "gap-1.5"
      },
      sm: {
        mark: "w-6 h-6",
        wordmark: "text-sm",
        gap: "gap-2"
      },
      md: {
        mark: "w-8 h-8",
        wordmark: "text-base",
        gap: "gap-2"
      },
      lg: {
        mark: "w-10 h-10",
        wordmark: "text-lg",
        gap: "gap-2.5"
      },
      xl: {
        mark: "w-14 h-14",
        wordmark: "text-xl",
        gap: "gap-3"
      }
    }.freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(src: nil, alt: nil, wordmark: nil, size: :md, href: nil, class: nil, **html_attrs)
      raise ArgumentError, "LogoComponent: alt is required" if alt.nil? || alt.to_s.strip.empty?

      @src = src
      @alt = alt
      @wordmark = wordmark
      @size = size
      @href = href
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      size = SIZES.fetch(@size) do |v|
        raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{SIZES.keys.join(', ')}"
      end

      body = content_tag(:span,
        class: classes("inline-flex items-center shrink-0", size[:gap], consumer: @class),
        **@html_attrs) do
        safe_join([mark_element(size), wordmark_element(size)].compact)
      end

      if @href
        link_to(@href, class: "inline-flex items-center no-underline text-text-primary hover:opacity-80 transition-opacity") { body }
      else
        body
      end
    end

    private

    def mark_element(size)
      if content.present?
        content_tag :span,
          class: "#{size[:mark]} inline-flex items-center justify-center shrink-0",
          "aria-label": @alt,
          role: "img" do
          content
        end
      elsif @src
        content_tag :img, nil,
          src: @src,
          alt: @alt,
          loading: "lazy",
          class: "#{size[:mark]} object-contain shrink-0"
      else
        Shipwright::IconComponent.new(name: :image, size: :md, class: "#{size[:mark]} text-text-disabled shrink-0").render_in(self)
      end
    end

    def wordmark_element(size)
      return nil if @wordmark.nil? || @wordmark.to_s.strip.empty?

      content_tag :span, @wordmark,
        class: "font-sans font-semibold text-text-primary #{size[:wordmark]} truncate"
    end
  end
end
