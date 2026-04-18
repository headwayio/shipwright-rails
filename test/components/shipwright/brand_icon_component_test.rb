require "test_helper"

class Shipwright::BrandIconComponentTest < ViewComponent::TestCase
  setup do
    Shipwright::BrandIconComponent.asset_path = Pathname.new(__dir__).join("../../fixtures/brand_icons").expand_path
    Shipwright::BrandIconComponent.reset_cache!
  end

  teardown do
    Shipwright::BrandIconComponent.asset_path = Shipwright::BrandIconComponent::DEFAULT_ASSET_PATH
    Shipwright::BrandIconComponent.reset_cache!
  end

  def test_renders_svg_from_fixture
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder))

    assert_selector "svg"
    assert_selector "svg rect[data-testid='placeholder-rect']"
  end

  def test_default_size_is_h_6
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder))

    assert_selector "svg.h-6"
  end

  def test_small_size_is_h_4
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder, size: :sm))

    assert_selector "svg.h-4"
  end

  def test_large_size_is_h_8
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder, size: :lg))

    assert_selector "svg.h-8"
  end

  def test_width_auto_preserves_aspect_ratio
    render_inline(Shipwright::BrandIconComponent.new(name: :"wide-brand"))

    assert_selector "svg.w-auto"
  end

  def test_intrinsic_width_and_height_are_stripped
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder))

    html = rendered_content
    refute_match(/<svg[^>]+\swidth="38"/, html)
    refute_match(/<svg[^>]+\sheight="38"/, html)
  end

  def test_brand_colors_preserved
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder))

    assert_includes rendered_content, "#206ac7"
  end

  def test_aria_hidden_by_default
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder))

    assert_selector "svg[aria-hidden='true']"
  end

  def test_aria_label_removes_aria_hidden
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder, "aria-label": "Brand logo"))

    assert_selector "svg[aria-label='Brand logo']"
    assert_no_selector "svg[aria-hidden='true']"
  end

  def test_consumer_class_merges
    render_inline(Shipwright::BrandIconComponent.new(name: :placeholder, class: "rounded-full"))

    assert_selector "svg.rounded-full"
    assert_selector "svg.h-6"
  end

  def test_raises_on_unknown_icon
    err = assert_raises(ArgumentError) do
      render_inline(Shipwright::BrandIconComponent.new(name: :"does-not-exist"))
    end
    assert_includes err.message, "unknown brand icon"
  end

  def test_raises_on_invalid_size
    assert_raises(ArgumentError) do
      render_inline(Shipwright::BrandIconComponent.new(name: :placeholder, size: :xl))
    end
  end

  def test_icon_names_lists_fixtures
    names = Shipwright::BrandIconComponent.icon_names
    assert_includes names, :placeholder
    assert_includes names, :"wide-brand"
  end

  def test_empty_directory_raises_with_helpful_hint
    Shipwright::BrandIconComponent.asset_path = Pathname.new(Dir.mktmpdir)
    Shipwright::BrandIconComponent.reset_cache!

    err = assert_raises(ArgumentError) do
      render_inline(Shipwright::BrandIconComponent.new(name: :anything))
    end
    assert_includes err.message, "No brand icons loaded"
    assert_includes err.message, "script/export_brand_icons.rb"
  end
end
