module Shipwright
  # Feather Icons (https://feathericons.com) — MIT licensed, 24x24 viewBox,
  # stroke-based design. Values are the inner SVG fragment; the wrapping
  # <svg> with viewBox/stroke attributes is provided by IconComponent.
  #
  # To add an icon: copy its inner content from https://feathericons.com/
  # and paste it below. Keep icon names in kebab-case matching Figma's
  # icon name in the design file.
  ICONS = {
    "info" => %(<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>).html_safe,
    "alert-circle" => %(<circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>).html_safe,
    "alert-triangle" => %(<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>).html_safe,
    "check" => %(<polyline points="20 6 9 17 4 12"/>).html_safe,
    "check-circle" => %(<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>).html_safe,
    "x" => %(<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>).html_safe,
    "x-circle" => %(<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>).html_safe,
    "chevron-down" => %(<polyline points="6 9 12 15 18 9"/>).html_safe,
    "chevron-up" => %(<polyline points="18 15 12 9 6 15"/>).html_safe,
    "chevron-left" => %(<polyline points="15 18 9 12 15 6"/>).html_safe,
    "chevron-right" => %(<polyline points="9 18 15 12 9 6"/>).html_safe,
    "plus" => %(<line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>).html_safe,
    "minus" => %(<line x1="5" y1="12" x2="19" y2="12"/>).html_safe,
    "search" => %(<circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>).html_safe,
    "menu" => %(<line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/>).html_safe,
    "external-link" => %(<path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/>).html_safe,
    "settings" => %(<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/>).html_safe,
    "arrow-right" => %(<line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>).html_safe,
    "arrow-left" => %(<line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>).html_safe,
    "help-circle" => %(<circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/>).html_safe,
    "trash" => %(<polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>).html_safe
  }.freeze
end
