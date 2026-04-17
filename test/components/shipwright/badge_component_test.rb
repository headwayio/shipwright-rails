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
    assert_selector "span.text-text-inverse"
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
end
