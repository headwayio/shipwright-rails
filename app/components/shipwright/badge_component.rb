module Shipwright
  class BadgeComponent < BaseComponent
    # Sentiment maps to a utility color token, matching the Figma "Sentiment" variant.
    SENTIMENTS = {
      neutral: "bg-utility-neutral-default",
      informative: "bg-utility-information-default",
      positive: "bg-utility-positive-default",
      negative: "bg-utility-negative-default",
      warning: "bg-utility-warning-default"
    }.freeze

    # Dot dimensions (used when no content block is given). Shipwright Pro spec:
    #   sm = 8px, md = 12px, lg = 20px.
    DOT_SIZES = {
      sm: "w-2 h-2",
      md: "w-3 h-3",
      lg: "w-5 h-5"
    }.freeze

    # Text badge dimensions (used when a content block is given). Minimum width
    # matches the height so single-char badges stay circular; padding lets them
    # grow for 2+ chars. Text is always inverse (white on the sentiment color).
    TEXT_SIZES = {
      sm: "h-4 min-w-4 px-1 text-[10px] leading-none",
      md: "h-5 min-w-5 px-1.5 text-xs leading-none",
      lg: "h-6 min-w-6 px-2 text-xs leading-none"
    }.freeze

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(sentiment: :neutral, size: :md, class: nil, **html_attrs)
      @sentiment = sentiment
      @size = size
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      sentiment_bg = SENTIMENTS.fetch(@sentiment) { |s| raise ArgumentError, "#{self.class}: unknown sentiment :#{s}. Valid: #{SENTIMENTS.keys.join(', ')}" }
      size_classes = (content.present? ? TEXT_SIZES : DOT_SIZES).fetch(@size) { |v| raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{DOT_SIZES.keys.join(', ')}" }

      content_tag :span, content,
        class: classes(
          "inline-flex items-center justify-center rounded-full border-2 border-border-inverse font-sans font-normal",
          sentiment_bg,
          size_classes,
          content.present? ? "text-text-inverse" : nil,
          consumer: @class
        ),
        **@html_attrs
    end
  end
end
