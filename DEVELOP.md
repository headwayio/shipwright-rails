# `develop` integration branch

While individual component PRs are in review, the `develop` branch
aggregates them so that consuming apps can target a single branch to
preview the full in-flight work without juggling multiple PR branches.

## What's included

Currently integrates:

| Branch / PR | Adds |
|-------------|------|
| `fix/lookbook-button-previews` (#1) | Button & ButtonGroup fixes, Shipwright Pro tokens, Manrope, Lookbook block binding fix |
| `feat/badge-component` (#3) | BadgeComponent, utility color palette |
| `feat/icon-component` (#4) | IconComponent + Feather icon manifest |
| `feat/link-component` (#5) | LinkComponent |
| `feat/banner-component` (#6) | BannerComponent (molecule composing Icon + Link) |

## How to consume

Point your app's Gemfile at this branch:

```ruby
gem "shipwright", github: "headwayio/shipwright-rails", branch: "develop"
```

## Maintenance

### When a feature branch merges to `main`

1. `git checkout develop && git fetch origin && git merge origin/main`
2. Resolve any conflicts (usually `tailwind.css`, `components.html.erb`,
   `CHANGELOG.md`) and re-run `cd test/dummy && bundle exec rake tailwindcss:build`
3. `bundle exec rake test` — confirm still green
4. `git push origin develop`

### When a new feature branch opens

1. `git checkout develop`
2. `git merge feat/<new-branch>`
3. Resolve conflicts, rebuild Tailwind, run tests
4. Push

### When develop drifts too far from main

Once all in-flight PRs are merged, consider deleting and recreating
develop from main so it doesn't accumulate stale merge commits.

## Not intended for merging to `main`

`develop` is a preview branch. Don't merge it into `main`. Individual
feature PRs are the source of truth.
