require "test_helper"

class Shipwright::AvatarComponentTest < ViewComponent::TestCase
  def test_renders_image_when_src_given
    render_inline(Shipwright::AvatarComponent.new(src: "/john.jpg", alt: "John Legend"))

    assert_selector "img[src='/john.jpg'][alt='John Legend']"
  end

  def test_image_uses_object_cover_and_rounded_full
    render_inline(Shipwright::AvatarComponent.new(src: "/a.jpg", alt: "A"))

    assert_selector "img.object-cover"
    assert_selector ".rounded-full"
  end

  def test_renders_initials_when_no_src
    render_inline(Shipwright::AvatarComponent.new(initials: "WS"))

    assert_no_selector "img"
    assert_text "WS"
  end

  def test_initials_styled_as_dark_with_inverse_text
    render_inline(Shipwright::AvatarComponent.new(initials: "WS"))

    assert_selector ".bg-interactive-primary-default"
    assert_selector ".text-text-inverse"
  end

  def test_falls_back_to_user_icon_when_neither_src_nor_initials
    render_inline(Shipwright::AvatarComponent.new)

    assert_no_selector "img"
    # User icon from IconComponent
    assert_selector "svg"
  end

  def test_default_size_is_medium_40
    render_inline(Shipwright::AvatarComponent.new(initials: "WS"))

    assert_selector ".w-10.h-10"
  end

  def test_size_xxsm_is_16
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", size: :xxsm))
    assert_selector ".w-4.h-4"
  end

  def test_size_xsm_is_24
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", size: :xsm))
    assert_selector ".w-6.h-6"
  end

  def test_size_sm_is_32
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", size: :sm))
    assert_selector ".w-8.h-8"
  end

  def test_size_lg_is_56
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", size: :lg))
    assert_selector ".w-14.h-14"
  end

  def test_status_indicator_renders_when_status_given
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", status: :online))

    assert_selector "[data-avatar-status]"
    assert_selector "[data-avatar-status].bg-utility-positive-default"
  end

  def test_no_status_indicator_by_default
    render_inline(Shipwright::AvatarComponent.new(initials: "WS"))

    assert_no_selector "[data-avatar-status]"
  end

  def test_status_away_uses_warning_color
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", status: :away))
    assert_selector "[data-avatar-status].bg-utility-warning-default"
  end

  def test_status_busy_uses_negative_color
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", status: :busy))
    assert_selector "[data-avatar-status].bg-utility-negative-default"
  end

  def test_status_offline_uses_neutral_color
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", status: :offline))
    assert_selector "[data-avatar-status].bg-utility-neutral-default"
  end

  def test_consumer_class_merges
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", class: "ring-2 ring-interactive-primary-default"))

    assert_selector ".ring-2"
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::AvatarComponent.new(initials: "WS", size: :giant))
    end
  end

  def test_raises_on_invalid_status
    assert_raises(ArgumentError) do
      render_inline(Shipwright::AvatarComponent.new(initials: "WS", status: :unknown))
    end
  end

  def test_image_requires_alt
    assert_raises(ArgumentError) do
      render_inline(Shipwright::AvatarComponent.new(src: "/john.jpg"))
    end
  end

  def test_initials_normalized_to_uppercase_and_truncated
    render_inline(Shipwright::AvatarComponent.new(initials: "Wendy Sullivan"))

    # Component should derive "WS" from the input — first letter of each word, max 2 chars
    assert_text "WS"
  end

  def test_passes_html_attributes
    render_inline(Shipwright::AvatarComponent.new(initials: "WS", id: "me", data: { user_id: "42" }))

    assert_selector "[id='me'][data-user-id='42']"
  end
end
