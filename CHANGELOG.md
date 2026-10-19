# Changelog

## [0.2.0] - Unreleased

### Breaking Changes

- Renamed `variant:` to `hierarchy:` on `ButtonComponent`
- Replaced `outline` hierarchy with `tertiary`, added `destructive`
- Added `shape:` (`:rounded` / `:pill`), `icon_only:` (bool), `disabled:` (bool) params
- Replaced placeholder color tokens with Shipwright Pro's semantic namespace:
  - `bg-primary` → `bg-interactive-primary-default`
  - `bg-secondary` → `bg-interactive-secondary-default`
  - `text-white` → `text-text-inverse`
  - etc.
- Default font family changed from Inter to Manrope
- Removed `ToastComponent.init_script_html`, `ModalComponent.init_script_html` and
  `SlideoutComponent.init_script_html`. The init script is now rendered by the
  components themselves so it can carry a CSP nonce; the JavaScript body is
  available as `INIT_SCRIPT_BODY` if you need to render it yourself.

### Added

- Full Shipwright Pro token palette (interactive, text, border, utility, background)
- Hover/pressed/focused states on all button hierarchies
- Icon-only button support with square dimensions (32/44/52)
- Disabled state with dedicated styling

### Fixed

- Inline init scripts now carry the host app's CSP nonce when one is configured
  (#32). Previously `ToastComponent`, `ModalComponent`, `SlideoutComponent`,
  `DropdownComponent` and `FileUploadComponent` emitted a nonce-less inline
  `<script>`, which an app with a nonce-based `script-src` refuses — the markup
  rendered but none of the behaviour wired up, with no error on the Rails side.
  Apps without a nonce generator are unaffected: the attribute is omitted.

## [0.1.0] - 2026-04-15

- Initial scaffold: engine, BaseComponent, ButtonComponent, Lookbook previews
