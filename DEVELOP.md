# Branches and releases

| Branch | What it is |
|--------|------------|
| `main` | Released code. Every release is tagged here. |
| `develop` | Integration branch. Feature and fix PRs land here, and it is promoted to `main` at each release. |

## Consuming Shipwright

Pin a tag:

```ruby
gem "shipwright", github: "headwayio/shipwright-rails", tag: "v0.2.1"
```

That is what an application should use. A tag is reviewable (the CHANGELOG
tells you what moved between two of them), and `bundle update` cannot drag you
onto unreleased work.

`develop` is available if you need something that hasn't been released yet:

```ruby
gem "shipwright", github: "headwayio/shipwright-rails", branch: "develop"
```

Prefer a `ref:` SHA over `branch:` if you do — a branch ref means any
`bundle install` can pick up work in progress, and dependency scanners flag it.
Treat it as temporary and move back to a tag once the work ships.

## Contributing a change

1. Branch from `develop`.
2. Open a PR against `develop`.
3. Add a CHANGELOG entry under the current `Unreleased` heading, in the
   `Added` / `Fixed` / `Breaking Changes` section that fits.
4. `bundle exec rake test` must pass. If you touched component classes or
   tokens, also run `cd test/dummy && bundle exec rake tailwindcss:build` and
   confirm the utilities you used actually compiled — a `@theme` token does not
   always produce the utility you expect.

Don't open PRs against `main`. It only moves at release time.

## Cutting a release

1. Confirm `develop` is green and the CHANGELOG's `Unreleased` section
   describes everything that landed.
2. On `develop`: bump `lib/shipwright/version.rb`, date the CHANGELOG heading,
   and point the README's install snippet at the new tag. One PR, merged last.
3. Open a PR from `develop` to `main`. `main` is always an ancestor of
   `develop`, so there is nothing to resolve — the PR exists to be reviewed,
   not to be merged into shape.
4. Merge it, then tag `main`:

   ```bash
   git checkout main && git pull
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push origin vX.Y.Z
   ```

5. Add a new `## [Unreleased]` heading to the CHANGELOG on `develop`.

## History

Until October 2026 this file described `develop` as a preview branch that must
*not* be merged to `main`, with individual feature PRs as the source of truth.
That stopped reflecting reality: `main` sat at 2 components while `develop`
accumulated 76 commits and all 23, the feature PRs fanned out from a single
long-lived branch rather than stacking, and consuming apps pinned SHAs on
`develop` because it was the only branch with the library on it.

`develop` was promoted to `main` for `v0.2.0`, and the April-era feature PRs
were superseded by that promotion rather than replayed. See
[#39](https://github.com/headwayio/shipwright-rails/issues/39).
