module Shipwright
  # Renders a multi-color brand SVG (payment method, social platform, etc.)
  # exported from Shipwright Pro's Figma source.
  #
  # Brand icons differ from Feather icons (rendered by IconComponent) in
  # that they preserve the brand's own colors rather than inheriting via
  # currentColor. The component loads SVGs from a directory, strips their
  # intrinsic width/height, and applies a Tailwind height class — width
  # auto-scales so non-square icons (e.g., Visa) keep their aspect ratio.
  #
  # Populate the SVG directory by running:
  #
  #   FIGMA_ACCESS_TOKEN=xxx ruby script/export_brand_icons.rb
  #
  # Available names are discoverable via `BrandIconComponent.icon_names`.
  class BrandIconComponent < BaseComponent
    # Default SVG directory — overridable for tests via the asset_path class setting.
    DEFAULT_ASSET_PATH = Pathname.new(__dir__).join("../../assets/images/shipwright/brand").expand_path.freeze

    SIZES = {
      sm: "h-4",  # 16px
      md: "h-6",  # 24px
      lg: "h-8"   # 32px
    }.freeze

    class << self
      attr_writer :asset_path

      def asset_path
        @asset_path ||= DEFAULT_ASSET_PATH
      end

      # Scan the asset directory and return a hash of name => inline SVG string.
      # Memoized per-asset-path so tests can swap paths cleanly.
      def icons
        @icons ||= {}
        @icons[asset_path.to_s] ||= begin
          pattern = asset_path.join("*.svg")
          Dir.glob(pattern).each_with_object({}) do |file, hash|
            name = File.basename(file, ".svg")
            hash[name] = File.read(file)
          end.freeze
        end
      end

      def icon_names
        icons.keys.map(&:to_sym).sort.freeze
      end

      # Allow tests to reset the memoization.
      def reset_cache!
        @icons = nil
      end
    end

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(name:, size: :md, class: nil, **html_attrs)
      @name = name.to_s
      @size = size
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    def call
      raw_svg = self.class.icons.fetch(@name) do
        available = self.class.icon_names
        hint = if available.empty?
          " No brand icons loaded — run `ruby script/export_brand_icons.rb` with a FIGMA_ACCESS_TOKEN to populate app/assets/images/shipwright/brand/."
        else
          " Available: #{available.join(', ')}"
        end
        raise ArgumentError, "#{self.class}: unknown brand icon :#{@name}.#{hint}"
      end

      size_class = SIZES.fetch(@size) do |v|
        raise ArgumentError, "#{self.class}: unknown size :#{v}. Valid: #{SIZES.keys.join(', ')}"
      end

      # Strip intrinsic dimensions so CSS controls size; w-auto preserves aspect ratio.
      normalized = raw_svg
        .sub(/\swidth="[^"]*"/, "")
        .sub(/\sheight="[^"]*"/, "")

      merged_class = classes("#{size_class} w-auto", consumer: @class)

      # Inject / merge our class attribute into the root <svg>.
      if normalized =~ /<svg([^>]*)\sclass="([^"]*)"/
        normalized = normalized.sub(/<svg([^>]*)\sclass="([^"]*)"/) do
          pre = Regexp.last_match(1)
          existing = Regexp.last_match(2)
          %(<svg#{pre} class="#{existing} #{merged_class}")
        end
      else
        normalized = normalized.sub("<svg", %(<svg class="#{merged_class}"))
      end

      # aria-hidden by default unless consumer supplies aria-label.
      aria_label = @html_attrs[:"aria-label"] || @html_attrs[:aria_label]
      unless aria_label
        normalized = normalized.sub("<svg", %(<svg aria-hidden="true"))
      end

      # Pass-through html attributes: append to the root <svg>.
      attr_str = @html_attrs.map { |k, v| %(#{k.to_s.tr('_', '-')}="#{ERB::Util.html_escape(v)}") }.join(" ")
      if !attr_str.empty?
        normalized = normalized.sub("<svg", %(<svg #{attr_str}))
      end

      normalized.html_safe
    end
  end
end
