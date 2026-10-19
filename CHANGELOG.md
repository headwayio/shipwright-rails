# Changelog

## [Unreleased]

### Fixed

- The pressed destructive button kept its white label below AA (4.5:1) on mid-tone negative
  colors (#B34124: 3.9:1 at the 80% fill). Pressed now uses the same 90% fill as hover.

## [0.2.0] - 2026-10-19

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
- `ToastContainerComponent.new(flash: flash)` renders flash toasts as children
  of the container (#37). Rendering `shipwright_flash_toasts` as a sibling put
  them outside the fixed-position wrapper, where they laid out at body flow
  position — in the DOM, correctly styled, and off-screen.
- Per-surface foreground tokens, one per filled surface (#33):
  `--color-interactive-on-primary`, `--color-utility-on-neutral`,
  `--color-utility-on-information`, `--color-utility-on-positive`,
  `--color-utility-on-negative`, `--color-utility-on-warning`. Every filled
  surface previously labelled itself with `--color-text-inverse`, so a brand
  with a light primary could not set a readable on-primary without breaking
  destructive buttons, badge fills and toast icons. Stock values are
  unchanged, so rendered colours are identical; only the class names moved.

### Fixed

- Inline init scripts now carry the host app's CSP nonce when one is configured
  (#32). Previously `ToastComponent`, `ModalComponent`, `SlideoutComponent`,
  `DropdownComponent` and `FileUploadComponent` emitted a nonce-less inline
  `<script>`, which an app with a nonce-based `script-src` refuses — the markup
  rendered but none of the behaviour wired up, with no error on the Rails side.
  Apps without a nonce generator are unaffected: the attribute is omitted.
- `shipwright_flash_toasts` now passes the message as `body:` rather than
  `title:` (#38). `title` is styled `truncate`, so any flash longer than one
  line was clipped with an ellipsis and the rest was unreachable.
- `ToastComponent` accepts a body with no title (previously `title:` was
  required), and no longer renders an empty heading element above it.
- A toast's icon circle now takes its label colour from the variant that fills
  it, rather than from the primary foreground. `:success`, `:error` and
  `:warning` circles are filled with utility colours, so a brand with a dark
  on-primary was painting dark icons onto saturated green and red.

## [0.1.0] - 2026-04-15

- Initial scaffold: engine, BaseComponent, ButtonComponent, Lookbook previews
