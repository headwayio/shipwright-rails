# Changelog

## [0.2.2] - 2026-10-27

### Security

- Raised the `view_component` floor to `>= 4.14`, for
  [GHSA-8qw7-6phv-7q6p](https://github.com/ViewComponent/view_component/security/advisories/GHSA-8qw7-6phv-7q6p)
  — slot and `with_content` state leaking across reused component instances, an
  incomplete fix for CVE-2026-54497. Every version below 4.14.0 is affected,
  including the whole 3.x line.

  The old `>= 3.0` constraint already ALLOWED a patched version, so a consumer
  could fix this themselves with `bundle update view_component`. Raising the
  floor is what stops a fresh `bundle install` resolving a vulnerable one.

  Shipwright's own lockfiles moved 4.6.0 → 4.20.0. The 385-test suite passes
  unchanged on it; no component API Shipwright uses has altered.

  **This drops support for ViewComponent 3.x.** Shipwright already requires
  Rails >= 8.1, where 4.x is the current line, so the practical reach is small.

## [0.2.1] - 2026-10-20

### Fixed

- Defined `--color-background-inverse`, `--color-background-tertiary` and
  `--color-text-secondary`. Modal and slideout already referenced all three, so
  their backdrops, the modal's close-button hover state, both subtitles and the
  slideout's inactive tab labels compiled to nothing and rendered unstyled.
- `test/dummy/config/storage.yml` was missing, so the dummy app could not boot
  in any environment that eager-loads ActiveStorage.

### Added

- A `test` workflow running the suite, the Tailwind build, a production boot
  and `gem build` on pushes and PRs to `main` and `develop`.
- `Shipwright::TokenReferenceTest`, which fails when a component names a colour
  token `engine.css` does not define.

### Removed

- `test/dummy/config/master.key` and `credentials.yml.enc` are no longer
  tracked. They held only a generated `secret_key_base`, which Rails derives on
  its own in development and test.

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
