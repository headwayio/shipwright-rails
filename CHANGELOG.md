# Changelog

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

### Added

- Full Shipwright Pro token palette (interactive, text, border, utility, background)
- Hover/pressed/focused states on all button hierarchies
- Icon-only button support with square dimensions (32/44/52)
- Disabled state with dedicated styling

## [0.1.0] - 2026-04-15

- Initial scaffold: engine, BaseComponent, ButtonComponent, Lookbook previews
