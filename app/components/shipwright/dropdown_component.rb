module Shipwright
  # Dropdown form control — custom styled trigger + menu with icon and
  # primary/secondary text per item. Uses native <details>/<summary> for
  # open/close (no JS required for toggle). A tiny inline script handles
  # item selection: updates the trigger display, writes the chosen value
  # to a hidden <input>, and closes the menu.
  #
  # Matches Shipwright Pro's Dropdown atom.
  #
  # Usage:
  #   <%= render Shipwright::DropdownComponent.new(
  #     name: "category", label: "Category", caption: "Choose one",
  #     placeholder: "Select...", value: "folders"
  #   ) do |dropdown| %>
  #     <% dropdown.with_item(value: "folders", icon: :folder, primary: "Folders") %>
  #     <% dropdown.with_item(value: "starred", icon: :star, primary: "Starred", secondary: "Your favorites") %>
  #   <% end %>
  class DropdownComponent < BaseComponent
    VARIANTS = %i[default destructive].freeze

    # Lambda slot returning an Item component so the parent template can
    # access per-item attributes via method_missing delegation.
    #
    # Each item may render ONE leading visual — an icon, an avatar, or a logo.
    # Pass exactly one of `icon:`, `avatar:`, or `logo:`. `avatar:` and `logo:`
    # accept a hash of props forwarded to Avatar/LogoComponent respectively.
    class Item < ViewComponent::Base
      attr_reader :value, :icon, :avatar, :logo, :primary, :secondary

      def initialize(value:, primary:, icon: nil, avatar: nil, logo: nil, secondary: nil)
        if [icon, avatar, logo].compact.size > 1
          raise ArgumentError, "DropdownComponent item: pass only one of :icon, :avatar, :logo"
        end

        @value = value
        @icon = icon
        @avatar = avatar
        @logo = logo
        @primary = primary
        @secondary = secondary
      end

      def call
        ""
      end
    end

    renders_many :items, ->(value:, primary:, icon: nil, avatar: nil, logo: nil, secondary: nil) {
      Item.new(value: value, primary: primary, icon: icon, avatar: avatar, logo: logo, secondary: secondary)
    }

    # `class:` is a Ruby reserved word used as a keyword arg — requires
    # binding.local_variable_get. Shipwright convention.
    def initialize(
      name: nil,
      value: nil,
      label: nil,
      caption: nil,
      placeholder: "Dropdown Menu",
      disabled: false,
      variant: :default,
      id: nil,
      class: nil,
      **html_attrs
    )
      unless VARIANTS.include?(variant)
        raise ArgumentError, "#{self.class}: unknown variant :#{variant}. Valid: #{VARIANTS.join(', ')}"
      end

      @name = name
      @value = value
      @label_text = label
      @caption = caption
      @placeholder = placeholder
      @disabled = disabled
      @variant = variant
      @id = id || name || "shipwright-dropdown-#{object_id}"
      @class = binding.local_variable_get(:class)
      @html_attrs = html_attrs
    end

    attr_reader :name, :value, :label_text, :caption, :placeholder, :id, :html_attrs

    def disabled?
      @disabled
    end

    def destructive?
      @variant == :destructive
    end

    # The label that appears in the trigger. Uses the selected item's
    # primary text if value matches one; otherwise the placeholder.
    def display_label
      return placeholder if value.nil?
      selected = items.find { |i| i.value.to_s == value.to_s }
      selected ? selected.primary : placeholder
    end

    def value_present?
      !value.nil? && items.any? { |i| i.value.to_s == value.to_s }
    end

    def wrapper_classes
      classes("font-sans flex flex-col gap-1", consumer: @class)
    end

    def trigger_classes
      base = "flex items-center justify-between gap-2 w-full px-3 py-2 rounded-md border bg-background-primary text-sm leading-5 cursor-pointer select-none transition-colors " \
             "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-offset-background-primary " \
             "list-none [&::-webkit-details-marker]:hidden"

      state = if @disabled
        "border-border-primary text-text-disabled cursor-not-allowed bg-interactive-disable"
      elsif destructive?
        "border-utility-negative-default text-utility-negative-default focus-visible:ring-utility-negative-default"
      else
        "border-border-primary text-text-primary hover:border-interactive-primary-default focus-visible:ring-interactive-primary-default"
      end

      "#{base} #{state}"
    end

    def display_text_classes
      if @disabled
        "text-text-disabled"
      elsif destructive?
        "text-utility-negative-default"
      elsif value_present?
        "text-text-primary"
      else
        "text-text-disabled"
      end
    end

    def menu_classes
      "absolute left-0 right-0 top-full mt-1 max-h-60 overflow-y-auto rounded-md border border-border-primary bg-background-primary shadow-lg z-10"
    end

    def item_classes
      "w-full flex items-start gap-2 px-3 py-2 text-left text-sm leading-5 text-text-primary " \
        "hover:bg-background-secondary focus-visible:bg-background-secondary focus-visible:outline-none " \
        "transition-colors cursor-pointer"
    end
  end
end
