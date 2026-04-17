module Shipwright
  class BadgeComponentPreview < Lookbook::Preview
    # @label Neutral Dot (default)
    def neutral_dot
      render Shipwright::BadgeComponent.new
    end

    # @label All Sentiments (dots)
    def all_sentiments
      render_with_template
    end

    # @label All Sizes (dots)
    def all_sizes
      render_with_template
    end

    # @label Text Badges
    def text_badges
      render_with_template
    end

    # @label Count Notifications
    def count_notifications
      render_with_template
    end
  end
end
