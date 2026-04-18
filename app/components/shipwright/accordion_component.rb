module Shipwright
  # A single collapsible section. Uses native <details>/<summary> for
  # toggle behavior, keyboard support, and accessibility — no JavaScript
  # required. Stack multiple AccordionComponents to build a group.
  #
  # Usage:
  #   <%= render(Shipwright::AccordionComponent.new(title: "FAQ question")) do %>
  #     Answer content here.
  #   <% end %>
  #
  #   <%# Initially open %>
  #   <%= render(Shipwright::AccordionComponent.new(title: "T", open: true)) { "..." } %>
  class AccordionComponent < BaseComponent
    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(title:, open: false, class: nil, **html_attrs)
      @title = title
      @open = open
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :title, :html_attrs

    def open_attr
      @open
    end

    def container_classes
      classes(
        "group block border border-border-primary rounded-md overflow-hidden font-sans",
        consumer: @class
      )
    end

    # Classes applied to <summary>. Hides the default marker cross-browser,
    # adds padding, typography, and interactive state visuals.
    def summary_classes
      [
        "flex items-center gap-3 px-4 py-3 cursor-pointer select-none",
        "text-base leading-5 text-interactive-primary-default",
        "transition-colors",
        "hover:bg-background-secondary hover:text-interactive-primary-hover",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-interactive-primary-default focus-visible:ring-inset",
        "list-none [&::-webkit-details-marker]:hidden"
      ].join(" ")
    end

    def body_classes
      "px-4 pb-3 pt-0 text-sm leading-5 text-text-primary"
    end

    def chevron_classes
      "transition-transform duration-200 group-open:rotate-180"
    end
  end
end
