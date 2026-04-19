require "test_helper"

class Shipwright::LogoComponentTest < ViewComponent::TestCase
  def test_renders_image_mark_when_src_given
    render_inline(Shipwright::LogoComponent.new(src: "/logo.png", alt: "Acme"))

    assert_selector "img[src='/logo.png'][alt='Acme']"
  end

  def test_requires_alt
    assert_raises(ArgumentError) { Shipwright::LogoComponent.new(src: "/l.png") }
    assert_raises(ArgumentError) { Shipwright::LogoComponent.new(alt: "") }
  end

  def test_renders_wordmark_when_provided
    render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme", wordmark: "Acme Inc"))

    assert_text "Acme Inc"
  end

  def test_no_wordmark_when_omitted
    render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme"))

    refute_text "Acme Inc"
  end

  def test_renders_block_content_as_custom_mark
    render_inline(Shipwright::LogoComponent.new(alt: "Acme")) do
      '<svg data-custom="true"></svg>'.html_safe
    end

    assert_selector "[role='img'][aria-label='Acme'] svg[data-custom='true']"
  end

  def test_falls_back_to_image_icon_when_no_src_or_content
    render_inline(Shipwright::LogoComponent.new(alt: "Acme"))

    assert_selector "svg"
  end

  def test_wraps_in_link_when_href_given
    render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme", href: "/"))

    assert_selector "a[href='/'] img"
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme", size: :huge))
    end
  end

  def test_all_valid_sizes_render
    %i[xs sm md lg xl].each do |size|
      render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme", size: size))
      assert_selector "img", count: 1
    end
  end

  def test_consumer_class_merges_on_wrapper
    render_inline(Shipwright::LogoComponent.new(src: "/l.png", alt: "Acme", class: "my-8"))

    assert_selector "span.my-8"
  end
end
