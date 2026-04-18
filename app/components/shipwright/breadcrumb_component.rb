module Shipwright
  # Breadcrumb navigation — a horizontal list of page ancestors, with the
  # final item marked as the current page. Matches Shipwright Pro's
  # Breadcrumb atom.
  #
  # Usage:
  #   <%= render Shipwright::BreadcrumbComponent.new do |crumb| %>
  #     <% crumb.with_item(href: "/", icon: :home) { "Home" } %>
  #     <% crumb.with_item(href: "/products") { "Products" } %>
  #     <% crumb.with_item { "Widget" } %>   # no href = current page
  #   <% end %>
  class BreadcrumbComponent < BaseComponent
    SEPARATORS = %i[chevron slash].freeze

    # Sub-component used only as a data holder for each slotted item.
    # Inherits from ViewComponent::Base so the parent's Slot wrapper
    # delegates method calls (href, icon, label, link?) to it via
    # Slot#method_missing. The call method returns an empty string because
    # rendering is driven by the parent template, not the slot itself.
    class Item < ViewComponent::Base
      attr_reader :href, :icon, :label

      def initialize(href: nil, icon: nil, label: nil)
        @href = href
        @icon = icon
        @label = label
      end

      def link?
        !href.nil?
      end

      def call
        ""
      end
    end

    renders_many :items, ->(href: nil, icon: nil, &block) {
      label = block ? view_context.capture(&block) : ""
      Item.new(href: href, icon: icon, label: label)
    }

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(separator: :chevron, class: nil, **html_attrs)
      unless SEPARATORS.include?(separator)
        raise ArgumentError, "#{self.class}: unknown separator :#{separator}. Valid: #{SEPARATORS.join(', ')}"
      end
      @separator = separator
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :separator, :html_attrs

    def nav_classes
      classes("font-sans text-sm leading-5", consumer: @class)
    end

    def link_classes
      "inline-flex items-center gap-1 text-interactive-primary-default " \
        "hover:text-interactive-primary-hover active:text-interactive-primary-pressed " \
        "hover:underline transition-colors " \
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-offset-2 rounded-sm"
    end

    def current_classes
      "inline-flex items-center gap-1 text-text-primary font-medium"
    end

    def separator_slash?
      @separator == :slash
    end
  end
end
