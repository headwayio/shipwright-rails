require "test_helper"

class Shipwright::BadgeComponentTest < ViewComponent::TestCase
  def test_renders_neutral_dot_by_default
    render_inline(Shipwright::BadgeComponent.new)

    assert_selector "span.bg-utility-neutral-default"
    assert_selector "span.rounded-full"
  end

  def test_renders_informative_sentiment
    render_inline(Shipwright::BadgeComponent.new(sentiment: :informative))
    assert_selector "span.bg-utility-information-default"
  end

  def test_renders_positive_sentiment
    render_inline(Shipwright::BadgeComponent.new(sentiment: :positive))
    assert_selector "span.bg-utility-positive-default"
  end

  def test_renders_negative_sentiment
    render_inline(Shipwright::BadgeComponent.new(sentiment: :negative))
    assert_selector "span.bg-utility-negative-default"
  end

  def test_renders_warning_sentiment
    render_inline(Shipwright::BadgeComponent.new(sentiment: :warning))
    assert_selector "span.bg-utility-warning-default"
  end

  def test_dot_size_small
    render_inline(Shipwright::BadgeComponent.new(size: :sm))
    assert_selector "span.w-2.h-2"
  end

  def test_dot_size_medium
    render_inline(Shipwright::BadgeComponent.new(size: :md))
    assert_selector "span.w-3.h-3"
  end

  def test_dot_size_large
    render_inline(Shipwright::BadgeComponent.new(size: :lg))
    assert_selector "span.w-5.h-5"
  end

  def test_renders_text_badge_when_content_given
    render_inline(Shipwright::BadgeComponent.new(sentiment: :informative)) { "20" }

    assert_selector "span", text: "20"
    assert_selector "span.text-utility-on-information"
    # Text badge should not use dot dimensions (no fixed w-3 h-3)
    assert_no_selector "span.w-3.h-3"
  end

  def test_text_badge_applies_text_size_classes
    render_inline(Shipwright::BadgeComponent.new(size: :lg)) { "99" }

    assert_selector "span.h-6"
    assert_selector "span.px-2"
  end

  def test_consumer_class_overrides_defaults
    render_inline(Shipwright::BadgeComponent.new(class: "bg-utility-warning-default"))

    assert_selector "span.bg-utility-warning-default"
    assert_no_selector "span.bg-utility-neutral-default"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::BadgeComponent.new(id: "notif-badge", data: { count: "3" })) { "3" }

    assert_selector "span#notif-badge[data-count='3']"
  end

  def test_raises_on_invalid_sentiment
    assert_raises(ArgumentError) do
      render_inline(Shipwright::BadgeComponent.new(sentiment: :purple))
    end
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::BadgeComponent.new(size: :xl))
    end
  end

  def test_includes_rounded_full_and_border
    render_inline(Shipwright::BadgeComponent.new)

    assert_selector "span.rounded-full"
    assert_selector "span.border-2"
  end

  # Saturated sentiment fills stay dark whatever the brand's primary is, so
  # their label must not follow --color-interactive-on-primary. See #33.
  #
  # Each fill carries its OWN foreground rather than a shared sentiment token:
  # bg-utility-negative-default is also the destructive button's fill, and if
  # the two read different tokens a brand can make identical red surfaces
  # disagree about their label color.
  FILL_AND_LABEL = {
    neutral:     [ "bg-utility-neutral-default",     "text-utility-on-neutral" ],
    informative: [ "bg-utility-information-default", "text-utility-on-information" ],
    positive:    [ "bg-utility-positive-default",    "text-utility-on-positive" ],
    negative:    [ "bg-utility-negative-default",    "text-utility-on-negative" ],
    warning:     [ "bg-utility-warning-default",     "text-utility-on-warning" ]
  }.freeze

  def test_each_sentiment_pairs_its_fill_with_its_own_label_color
    FILL_AND_LABEL.each do |sentiment, (bg, fg)|
      render_inline(Shipwright::BadgeComponent.new(sentiment: sentiment)) { "Label" }

      assert_selector "span.#{bg}.#{fg}"
      assert_no_selector "span.text-interactive-on-primary"
    end
  end
end
