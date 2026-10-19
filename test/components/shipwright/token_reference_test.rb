require "test_helper"

# A Tailwind class that names a token `engine.css` doesn't define compiles to
# nothing. There is no error, no warning, and the element simply renders
# unstyled — which is how modal and slideout shipped with `bg-background-inverse`
# backdrops that were never visible.
#
# This walks every component source for color utilities in Shipwright's own
# namespaces and asserts the token behind each one exists.
class Shipwright::TokenReferenceTest < ActiveSupport::TestCase
  ENGINE_CSS = Shipwright::Engine.root.join("app/assets/tailwind/shipwright/engine.css")
  COMPONENT_GLOB = Shipwright::Engine.root.join("app/components/shipwright/**/*.{rb,erb}")

  # Only Shipwright's own color namespaces — `text-sm` and `border-2` are not
  # color utilities and have no token behind them.
  NAMESPACES = %w[interactive utility text background border].freeze

  # Utility prefix, then the token name, with optional `/40` opacity modifier.
  CLASS_PATTERN = /
    (?:^|[\s"'`:])                       # start, whitespace, quote, or variant colon
    (?:bg|text|border|ring|ring-offset)- # the utility
    (#{Regexp.union(NAMESPACES)}-[a-z0-9-]+?)
    (?:\/\d+)?                           # optional opacity modifier
    (?=["'`\s]|$)
  /x

  def test_every_color_utility_names_a_token_that_exists
    defined_tokens = ENGINE_CSS.read.scan(/^\s*--color-([a-z0-9-]+):/).flatten.to_set

    missing = Hash.new { |h, k| h[k] = [] }
    Dir.glob(COMPONENT_GLOB).sort.each do |path|
      File.read(path).scan(CLASS_PATTERN).flatten.uniq.each do |token|
        missing[token] << File.basename(path) unless defined_tokens.include?(token)
      end
    end

    assert_empty missing,
      "These components reference color tokens that engine.css does not define, " \
      "so the utilities compile to nothing and the elements render unstyled:\n" +
      missing.map { |token, files| "  --color-#{token} (#{files.uniq.join(', ')})" }.join("\n")
  end

  # Guards the guard: the pattern has to actually see the classes, or the test
  # above passes by finding nothing at all.
  def test_pattern_finds_the_tokens_components_really_use
    found = Dir.glob(COMPONENT_GLOB).flat_map { |p| File.read(p).scan(CLASS_PATTERN).flatten }.uniq

    assert_includes found, "interactive-primary-default"
    assert_includes found, "utility-on-positive"
    assert_includes found, "background-inverse", "opacity modifiers like /40 must be stripped"
    assert_operator found.size, :>, 15
  end
end
