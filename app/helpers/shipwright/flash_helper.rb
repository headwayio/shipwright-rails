module Shipwright
  # View helpers for rendering Rails flash messages as toasts.
  #
  # In your application layout (typically near </body>):
  #
  #   <%= render Shipwright::ToastContainerComponent.new %>
  #   <%= shipwright_flash_toasts %>
  #
  # Then set flash in controllers as usual:
  #
  #   flash[:notice]  = "Profile updated"   # → :success variant
  #   flash[:alert]   = "Not found"         # → :error variant
  #   flash[:warning] = "Quota nearly full" # → :warning variant
  #   flash[:info]    = "Account verified"  # → :info variant
  #
  # Custom key → variant mapping can be supplied:
  #
  #   <%= shipwright_flash_toasts(mapping: { my_key: :success }) %>
  module FlashHelper
    DEFAULT_FLASH_MAPPING = {
      "notice" => :success,
      "success" => :success,
      "alert" => :error,
      "error" => :error,
      "warning" => :warning,
      "info" => :info
    }.freeze

    # Render one ToastComponent per flash entry whose key is in `mapping`.
    # Unrecognized keys (e.g., flash[:form_id]) are ignored by default.
    def shipwright_flash_toasts(flash_hash = flash, mapping: DEFAULT_FLASH_MAPPING, **toast_opts)
      normalized = mapping.transform_keys(&:to_s)
      safe_join(flash_hash.map { |key, value|
        next if value.blank?
        variant = normalized[key.to_s]
        next unless variant
        render Shipwright::ToastComponent.new(
          title: value.to_s,
          variant: variant,
          **toast_opts
        )
      }.compact)
    end
  end
end
