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

    # @label Grid
    def grid
      render_with_template
    end
  end
end
