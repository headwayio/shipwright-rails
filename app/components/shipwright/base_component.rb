module Shipwright
  class BaseComponent < ViewComponent::Base
    # Class-level merger singleton — avoids cold cache per component instance.
    # Configured with Shipwright Pro's custom theme tokens so tailwind_merge
    # recognizes conflicts within color/radius groups (e.g., bg-interactive-primary-default
    # and bg-utility-negative-default are both color utilities and should conflict).
    MERGER = TailwindMerge::Merger.new(config: {
      theme: {
        "color" => %w[
          interactive-primary-default
          interactive-primary-hover
          interactive-primary-pressed
          interactive-secondary-default
          interactive-disable
          border-interactive
          border-inverse
          border-primary
          utility-neutral-default
          utility-information-default
          utility-positive-default
          utility-negative-default
          utility-warning-default
          text-primary
          text-inverse
          text-disabled
          background-primary
          background-secondary
        ],
        "radius" => %w[md]
      }
    }).freeze

    private

    # Renders a component's one-time init <script>.
    #
    # Carries the host application's CSP nonce when one is configured. An app
    # with a nonce-based `script-src` refuses inline <script> that has no
    # nonce, and the failure is silent from Rails' side: the markup renders,
    # the JavaScript never runs, and the component simply does nothing.
    #
    #   init_script_tag("data-shipwright-toast-init", ToastComponent::INIT_SCRIPT_BODY)
    #
    # or, from a template, with the body as a block:
    #
    #   <%= init_script_tag("data-shipwright-dropdown-init") do %>
    #     (function () { ... })();
    #   <% end %>
    #
    # @param marker [String] the `data-shipwright-*-init` attribute used to
    #   identify the tag; kept as a hook for debugging and for hosts that want
    #   to find or allow-list these scripts.
    def init_script_tag(marker, body = nil, &block)
      body = capture(&block) if block
      content_tag(:script, body.to_s.html_safe, marker => "", "nonce" => csp_nonce)
    end

    # The request's CSP nonce, or nil when the app has not configured a nonce
    # generator — in which case the attribute is omitted and behaviour is
    # exactly as it was before.
    def csp_nonce
      helpers.content_security_policy_nonce
    rescue NoMethodError
      # Rendered without a request (standalone render, some preview setups).
      nil
    end


    # Merges component default classes with consumer overrides.
    # Consumer class is always applied LAST so it wins over defaults and conditionals.
    #
    # @param defaults [String] one or more class strings to merge
    # @param consumer [String, nil] consumer-provided class override (always wins)
    # @param conditionals [Hash] class_string => boolean pairs
    #
    # Usage:
    #   classes("px-sm py-2xs bg-interactive-primary-default", consumer: @class)
    #   classes("px-sm", "bg-interactive-primary-default": active?, consumer: @class)
    def classes(*defaults, consumer: nil, **conditionals)
      conditional = conditionals.select { |_, v| v }.keys.map(&:to_s).join(" ")
      combined = [*defaults.compact, conditional, consumer].reject { |s| s.to_s.strip.empty? }.join(" ")
      MERGER.merge(combined)
    end
  end
end
