module Shipwright
  # A user avatar — image, initials, or icon fallback — with optional
  # status indicator dot. Matches Shipwright Pro's Avatar atom
  # (Figma node 2013:5694).
  #
  # Usage:
  #   <%= render Shipwright::AvatarComponent.new(src: "/john.jpg", alt: "John Legend") %>
  #   <%= render Shipwright::AvatarComponent.new(initials: "WS") %>
  #   <%= render Shipwright::AvatarComponent.new %>  # user icon fallback
  #   <%= render Shipwright::AvatarComponent.new(src: ..., alt: ..., status: :online) %>
  class AvatarComponent < BaseComponent
    # Size tokens matching Shipwright Pro's five-step scale.
    SIZES = {
      xxsm: {
        container: "w-4 h-4",
        text: "text-[8px]",
        icon: :sm,
        status: "w-1.5 h-1.5 border"
      },
      xsm: {
        container: "w-6 h-6",
        text: "text-[10px]",
        icon: :sm,
        status: "w-2 h-2 border"
      },
      sm: {
        container: "w-8 h-8",
        text: "text-xs",
        icon: :sm,
        status: "w-2.5 h-2.5 border-2"
      },
      md: {
        container: "w-10 h-10",
        text: "text-sm",
        icon: :md,
        status: "w-3 h-3 border-2"
      },
      lg: {
        container: "w-14 h-14",
        text: "text-lg",
        icon: :lg,
        status: "w-4 h-4 border-2"
      }
    }.freeze

    # Status → background color mapping. Maps semantic status to utility palette.
    STATUSES = {
      online: "bg-utility-positive-default",
      away: "bg-utility-warning-default",
      busy: "bg-utility-negative-default",
      offline: "bg-utility-neutral-default"
    }.freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(src: nil, alt: nil, initials: nil, size: :md, status: nil, class: nil, **html_attrs)
      raise ArgumentError, "AvatarComponent: alt is required when src is provided" if src && alt.nil?

      @src = src
      @alt = alt
      @initials = initials ? derive_initials(initials) : nil
      @size = size
      @status = status
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      size = SIZES.fetch(@size) do |v|
        raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{SIZES.keys.join(', ')}"
      end
      if @status
        STATUSES.fetch(@status) do |s|
          raise ArgumentError, "#{self.class}: unknown status :#{s}. Valid: #{STATUSES.keys.join(', ')}"
        end
      end

      content_tag :span,
        class: classes(
          "relative inline-flex items-center justify-center shrink-0 overflow-visible",
          size[:container],
          consumer: @class
        ),
        **@html_attrs do
        safe_join([inner_content(size), status_indicator(size)].compact)
      end
    end

    private

    # Derive 1-2 letter initials from an input string. "Wendy Sullivan" → "WS".
    # If the input is already short (<= 2 chars), uppercase it as-is.
    def derive_initials(input)
      str = input.to_s.strip
      return str.upcase if str.length <= 2

      str.split(/\s+/).first(2).map { |word| word[0] }.join.upcase
    end

    def inner_content(size)
      if @src
        content_tag :img, nil,
          src: @src,
          alt: @alt,
          loading: "lazy",
          class: "w-full h-full object-cover rounded-full"
      elsif @initials
        content_tag :span, @initials,
          class: "w-full h-full flex items-center justify-center rounded-full bg-interactive-primary-default text-interactive-on-primary font-sans font-medium #{size[:text]}"
      else
        content_tag :span, nil,
          class: "w-full h-full flex items-center justify-center rounded-full bg-interactive-primary-default text-interactive-on-primary",
          "aria-label": @alt do
          Shipwright::IconComponent.new(name: :user, size: size[:icon], class: "w-3/5 h-3/5").render_in(self)
        end
      end
    end

    def status_indicator(size)
      return nil unless @status

      content_tag :span, nil,
        class: classes(
          "absolute bottom-0 right-0 rounded-full border-border-inverse",
          size[:status],
          STATUSES.fetch(@status)
        ),
        "data-avatar-status": @status
    end
  end
end
