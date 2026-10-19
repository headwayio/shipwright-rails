module Shipwright
  class DropdownComponentPreview < Lookbook::Preview
    # @label Default (empty)
    def default
      render(Shipwright::DropdownComponent.new(name: "d1", label: "Label", caption: "Caption")) do |d|
        d.with_item(value: "folders",   icon: :folder, primary: "Folders",   secondary: "Organize your files")
        d.with_item(value: "starred",   icon: :star,   primary: "Starred",   secondary: "Your favorites")
        d.with_item(value: "trash",     icon: :trash,  primary: "Trash",     secondary: "Deleted items")
        d.with_item(value: "settings",  icon: :settings, primary: "Settings", secondary: "Preferences & config")
      end
    end

    # @label With initial value
    def with_value
      render(Shipwright::DropdownComponent.new(name: "d2", label: "Category", value: "starred", caption: "Current selection shown in trigger")) do |d|
        d.with_item(value: "folders", icon: :folder, primary: "Folders")
        d.with_item(value: "starred", icon: :star,   primary: "Starred")
        d.with_item(value: "trash",   icon: :trash,  primary: "Trash")
      end
    end

    # @label Without icons
    def no_icons
      render(Shipwright::DropdownComponent.new(name: "d3", label: "Country")) do |d|
        d.with_item(value: "us", primary: "United States")
        d.with_item(value: "ca", primary: "Canada")
        d.with_item(value: "uk", primary: "United Kingdom")
        d.with_item(value: "au", primary: "Australia")
      end
    end

    # @label Disabled
    def disabled
      render(Shipwright::DropdownComponent.new(name: "d4", label: "Label", caption: "Caption", disabled: true, placeholder: "Unavailable"))
    end

    # @label Destructive
    def destructive
      render(Shipwright::DropdownComponent.new(name: "d5", label: "Label", value: "a", variant: :destructive, caption: "Something went wrong")) do |d|
        d.with_item(value: "a", primary: "Primary Text")
        d.with_item(value: "b", primary: "Other option")
      end
    end

    # @label With avatars (users)
    def with_avatars
      render(Shipwright::DropdownComponent.new(name: "d6", label: "Assignee", placeholder: "Select teammate")) do |d|
        d.with_item(value: "john",   avatar: { initials: "JD" }, primary: "John Doe",   secondary: "john@acme.com")
        d.with_item(value: "wendy",  avatar: { initials: "WS" }, primary: "Wendy Sullivan", secondary: "wendy@acme.com")
        d.with_item(value: "alex",   avatar: { initials: "AL" }, primary: "Alex Lee",   secondary: "alex@acme.com")
      end
    end

    # @label With logos (workspaces)
    def with_logos
      render(Shipwright::DropdownComponent.new(name: "d7", label: "Workspace", placeholder: "Select workspace")) do |d|
        d.with_item(value: "acme",    logo: { alt: "Acme" },    primary: "Acme Inc")
        d.with_item(value: "headway", logo: { alt: "Headway" }, primary: "Headway")
        d.with_item(value: "shipwright", logo: { alt: "Shipwright" }, primary: "Shipwright Pro")
      end
    end

    # @label Grid
    def grid
      render_with_template
    end
  end
end
