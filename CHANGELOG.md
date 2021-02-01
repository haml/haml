# Change Log

All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning](http://semver.org/). This change log is based upon
[keep-a-changelog](https://github.com/olivierlacan/keep-a-changelog).

## [2.14.4](https://github.com/k0kubun/hamlit/compare/v2.14.3...v2.14.4) - 2021-02-01

### Fixed

- Prevent another SEGV in a C extension after `GC.compact` [#177](https://github.com/k0kubun/hamlit/issues/177)
  *Thanks to @stanhu*

## [2.14.3](https://github.com/k0kubun/hamlit/compare/v2.14.2...v2.14.3) - 2021-01-24

### Fixed

- Ensure the Rails initializer is called before `:load_config_initializers` [#176](https://github.com/k0kubun/hamlit/issues/176)
  *Thanks to @sunny*

## [2.14.2](https://github.com/k0kubun/hamlit/compare/v2.14.1...v2.14.2) - 2021-01-21

### Fixed

- Prevent SEGV in a C extension after `GC.compact` [#171](https://github.com/k0kubun/hamlit/issues/171)
  *Thanks to @stanhu*

## [2.14.1](https://github.com/k0kubun/hamlit/compare/v2.14.0...v2.14.1) - 2021-01-07

### Added

- Add `-c` option to `hamlit compile` that works like `haml -c` [#166](https://github.com/k0kubun/hamlit/issues/166)
  *Thanks to @knightq*

## [2.14.0](https://github.com/k0kubun/hamlit/compare/v2.13.2...v2.14.0) - 2021-01-07

### Changed

- CLI changes
  - Remove `-c` shorthand of `--color`.
  - Make `--color` default. Please use `--no-color` to disable it.
  - `--color` uses IRB instead of Pry for syntax highlight.
     - Syntax highlight of `hamlit compile` is enabled only with IRB of Ruby 2.7+.
     - Syntax highlight of `hamlit parse` / `hamlit temple` is enabled only with IRB of Ruby 3.1+.

## [2.13.2](https://github.com/k0kubun/hamlit/compare/v2.13.1...v2.13.2) - 2020-12-27

### Added

- Speed up `hamlit` commands [#166](https://github.com/k0kubun/hamlit/issues/166)
  *Thanks to @knightq*

## [2.13.1](https://github.com/k0kubun/hamlit/compare/v2.13.0...v2.13.1) - 2020-12-27

### Added

- Support [multiline attributes](https://github.com/haml/haml/pull/1043) of Haml 5.2.1.

## [2.13.0](https://github.com/k0kubun/hamlit/compare/v2.12.0...v2.13.0) - 2020-10-02

### Added

- Support `--enable-frozen-string-literal` [#162](https://github.com/k0kubun/hamlit/issues/162).
  *Thanks to @aliismayilov*

### Changed

- Upgrade the Haml parser from Haml 4.0 to 5.2 [#163](https://github.com/k0kubun/hamlit/issues/163).
  - Allow `@` as tag's class name.
  - Fix NameError on an `InvalidAttributeNameError` reference introduced at Hamlit v2.12.0.
  - You can no longer specify `ugly` option, which has had no effect.

## [2.12.0](https://github.com/k0kubun/hamlit/compare/v2.11.1...v2.12.0) - 2020-09-30

### Changed

- Class names are no longer ordered alphabetically.
  *Thanks to @aliismayilov*
  - This is compatible with [Haml 5.2](https://github.com/haml/haml/blob/v5.2.0/CHANGELOG.md#52)

## [2.11.1](https://github.com/k0kubun/hamlit/compare/v2.11.0...v2.11.1) - 2020-08-25

### Fixed

- Fix a line number on an error after filters like preserve, plain, and ruby.
  *Thanks to @rgisiger*

## [2.11.0](https://github.com/k0kubun/hamlit/compare/v2.10.1...v2.11.0) - 2019-12-12

### Added

- Support Haml's _revealed_ conditional comment feature on `/![if !IE]` [#153](https://github.com/k0kubun/hamlit/issues/153).
  *Thanks to @esb*

## [2.10.1](https://github.com/k0kubun/hamlit/compare/v2.10.0...v2.10.1) - 2019-11-28

### Added

- Register `Hamlit::Template` to Tilt as :hamlit as well, in addition to :haml

## [2.10.0](https://github.com/k0kubun/hamlit/compare/v2.9.5...v2.10.0) - 2019-09-15

### Added

- Optimize template rendering by string interpolation [#146](https://github.com/k0kubun/hamlit/issues/146)
  - Exploiting pre-allocation of string interpolation introduced in Ruby 2.5 [ruby/ruby#1626](https://github.com/ruby/ruby/pull/1626)

### Changed

- Require temple.gem >= 0.8.2

## [2.9.5](https://github.com/k0kubun/hamlit/compare/v2.9.4...v2.9.5) - 2019-09-08

### Added

- Supported `:plain` filter in truffleruby

## [2.9.4](https://github.com/k0kubun/hamlit/compare/v2.9.3...v2.9.4) - 2019-09-08

### Added

- Experimental support of truffleruby [#145](https://github.com/k0kubun/hamlit/issues/145).

## [2.9.3](https://github.com/k0kubun/hamlit/compare/v2.9.2...v2.9.3) - 2019-04-09

### Fixed

- Fix deprecation warning on Rails 6 [#138](https://github.com/k0kubun/hamlit/issues/138).
  *Thanks to @r7kamura*

## [2.9.2](https://github.com/k0kubun/hamlit/compare/v2.9.1...v2.9.2) - 2018-11-30

### Fixed

- Fix possible `autoload` failure of dependency [#131](https://github.com/k0kubun/hamlit/issues/131).
  *Thanks to @wimrijnders*

## [2.9.1](https://github.com/k0kubun/hamlit/compare/v2.9.0...v2.9.1) - 2018-11-01

### Added

- Start supporting JRuby [#100](https://github.com/k0kubun/hamlit/issues/100).

## [2.9.0](https://github.com/k0kubun/hamlit/compare/v2.8.10...v2.9.0) - 2018-10-16

### Added

- Consider aria attribute as another attribute that supports hyphenation and boolean like data attribute
  [#57](https://github.com/k0kubun/hamlit/pull/57). *Thanks to @francesco-loreti*

## [2.8.10](https://github.com/k0kubun/hamlit/compare/v2.8.9...v2.8.10) - 2018-09-05

### Fixed

- Fix uninitialized constant error introduced in v2.8.9
  [#125](https://github.com/k0kubun/hamlit/pull/125). *Thanks to @vovchynniko*

## [2.8.9](https://github.com/k0kubun/hamlit/compare/v2.8.8...v2.8.9) - 2018-09-05 [YANKED]

### Fixed

- Don't raise an error on UTF-8 BOM [#117](https://github.com/k0kubun/hamlit/pull/117)
  [#124](https://github.com/k0kubun/hamlit/pull/124). *Thanks to @southwolf*

## [2.8.8](https://github.com/k0kubun/hamlit/compare/v2.8.7...v2.8.8) - 2018-04-06

### Fixed

- Don't require Tilt dependencies if unregistered
  [#121](https://github.com/k0kubun/hamlit/pull/121). *Thanks to @michaelglass*

## [2.8.7](https://github.com/k0kubun/hamlit/compare/v2.8.6...v2.8.7) - 2018-02-17

### Fixed

- Fix parser error on string interpolation in attributes

## [2.8.6](https://github.com/k0kubun/hamlit/compare/v2.8.5...v2.8.6) - 2017-12-22

### Fixed

- Fix some unused-variable / method-redefinition warnings

## [2.8.5](https://github.com/k0kubun/hamlit/compare/v2.8.4...v2.8.5) - 2017-11-06

### Fixed

- Fix lexer to work with Ripper of Ruby 2.5

## [2.8.4](https://github.com/k0kubun/hamlit/compare/v2.8.3...v2.8.4) - 2017-06-23

### Added

- Allow filename `-` to read input from STDIN for `hamlit [parse|temple|compile|render]`
  [#113](https://github.com/k0kubun/hamlit/issues/113). *Thanks to @gfx*

## [2.8.3](https://github.com/k0kubun/hamlit/compare/v2.8.2...v2.8.3) - 2017-06-19

### Added

- Add `--color` option to `hamlit parse` and `hamlit temple` commands too.

## [2.8.2](https://github.com/k0kubun/hamlit/compare/v2.8.1...v2.8.2) - 2017-06-19

### Added

- Add `--color` option to opt-in coloring in `hamlit compile` command
  [#111](https://github.com/k0kubun/hamlit/issues/111).

## [2.8.1](https://github.com/k0kubun/hamlit/compare/v2.8.0...v2.8.1) - 2017-04-03

### Fixed

- Fix SEGV caused by nil in old attributes
  [#101](https://github.com/k0kubun/hamlit/issues/101). *Thanks to @FND*

## [2.8.0](https://github.com/k0kubun/hamlit/compare/v2.7.5...v2.8.0) - 2017-02-12

### Changed

- Support Temple >= 0.8.0 and change to use StaticAnalyzer in Temple
- Optimize attribute building code a little

## [2.7.5](https://github.com/k0kubun/hamlit/compare/v2.7.4...v2.7.5) - 2016-10-15

### Fixed

- Resurrect `Hamlit::RailsTemplate.set_options` dropped in v2.7.4 unexpectedly.

## [2.7.4](https://github.com/k0kubun/hamlit/compare/v2.7.3...v2.7.4) - 2016-10-15 [YANKED]

### Fixed

- Compile template as xhtml when ActionView regards template as text/xml
  [#92](https://github.com/k0kubun/hamlit/issues/92). *Thank to @shmargum*

## [2.7.3](https://github.com/k0kubun/hamlit/compare/v2.7.2...v2.7.3) - 2016-10-12

### Fixed

- Regard download as an boolean attribute
  [#91](https://github.com/k0kubun/hamlit/pull/91). *Thank to @pushcx*

## [2.7.2](https://github.com/k0kubun/hamlit/compare/v2.7.1...v2.7.2) - 2016-09-19

### Fixed

- Fix engine option warning
  [#90](https://github.com/k0kubun/hamlit/issues/90). *Thank to @kikonen*

## [2.7.1](https://github.com/k0kubun/hamlit/compare/v2.7.0...v2.7.1) - 2016-09-19

### Fixed

- Fix Rails handler to use `ActionView::OutputBuffer` instead of `ActionView::SafeBuffer` to justify encoding
  [#89](https://github.com/k0kubun/hamlit/pull/89). *Thanks to @akelmanson*

## [2.7.0](https://github.com/k0kubun/hamlit/compare/v2.6.2...v2.7.0) - 2016-08-31

### Changed

- Don't escape interpolated content in plain filter
  [#87](https://github.com/k0kubun/hamlit/pull/87). *Thanks to @shmargum*

## [2.6.2](https://github.com/k0kubun/hamlit/compare/v2.6.1...v2.6.2) - 2016-08-27

### Added

- Add cdata filter
  [#84](https://github.com/k0kubun/hamlit/issues/84). *Thanks to @shmargum*
- Minimize string allocation on template comipilation using `# frozen_string_literal: true`

## [2.6.1](https://github.com/k0kubun/hamlit/compare/v2.6.0...v2.6.1) - 2016-08-18

### Fixed

- For Rails, escape attributes even if it's html\_safe
  - This is the same fix as Rails for [CVE-2016-6316](https://groups.google.com/forum/#!topic/ruby-security-ann/8B2iV2tPRSE)

## [2.6.0](https://github.com/k0kubun/hamlit/compare/v2.5.0...v2.6.0) - 2016-08-14

### Changed

- Stop using [houdini](https://github.com/vmg/houdini) and rewrite HTML escape function to resolve building or packaging problems [#82](https://github.com/k0kubun/hamlit/pull/82).
  - No behavior is changed

## [2.5.0](https://github.com/k0kubun/hamlit/compare/v2.4.2...v2.5.0) - 2016-06-04

### Changed

- Don't escape the result of `preserve` helper in Rails

## [2.4.2](https://github.com/k0kubun/hamlit/compare/v2.4.1...v2.4.2) - 2016-06-04

### Fixed

- Regard cygwin and bccwin as Windows environment too

## [2.4.1](https://github.com/k0kubun/hamlit/compare/v2.4.0...v2.4.1) - 2016-06-03

### Fixed

- Fix C extension builder to work with Ruby 2.3 on Windows
  [#69](https://github.com/k0kubun/hamlit/issues/69). *Thanks to @francesco-loreti*

## [2.4.0](https://github.com/k0kubun/hamlit/compare/v2.3.1...v2.4.0) - 2016-05-13

### Added

- Add `Hamlit::Helpers.preserve` method for Tilt templates

## [2.3.1](https://github.com/k0kubun/hamlit/compare/v2.3.0...v2.3.1) - 2016-05-09

### Fixed

- Specify Ruby version dependency on gemspec
  [#67](https://github.com/k0kubun/hamlit/issues/67). *Thanks to @grosser*

## [2.3.0](https://github.com/k0kubun/hamlit/compare/v2.2.3...v2.3.0) - 2016-04-24

### Added

- Add `Hamlit::Filters.remove_filter` method
  [#66](https://github.com/k0kubun/hamlit/issues/66). *Thanks to @connorshea*

### Changed

- `:coffeescript` filter's internal class name is changed from `Coffee` to `CoffeeScript`

## [2.2.4](https://github.com/k0kubun/hamlit/compare/v2.2.3...v2.2.4) - 2017-12-05

### Fixed

- Fix to work with Ruby 2.5. This version is usable with both 2.0 and 2.5.

## [2.2.3](https://github.com/k0kubun/hamlit/compare/v2.2.2...v2.2.3) - 2016-03-10

### Added

- Add `hamlit version` subcommand
  [#60](https://github.com/k0kubun/hamlit/pull/60). *Thanks to @timoschilling*

### Fixed

- Fix load path for CLI
  [#61](https://github.com/k0kubun/hamlit/pull/61). *Thanks to @timoschilling*

## [2.2.2](https://github.com/k0kubun/hamlit/compare/v2.2.1...v2.2.2) - 2016-02-21

### Added

- Optimize performance of plain filter

### Fixed

- Escape only interpolated text for plain filter
  [#58](https://github.com/k0kubun/hamlit/issues/58). *Thanks to @shaneog*

## [2.2.1](https://github.com/k0kubun/hamlit/compare/v2.2.0...v2.2.1) - 2016-02-06

### Added

- Support Windows
  [#54](https://github.com/k0kubun/hamlit/issues/54). *Thanks to @francesco-loreti*

## [2.2.0](https://github.com/k0kubun/hamlit/compare/v2.1.2...v2.2.0) - 2015-12-24

### Added

- Optimize inline script inside a tag
- Optimize string interpolation recursively

## [2.1.2](https://github.com/k0kubun/hamlit/compare/v2.1.1...v2.1.2) - 2015-12-16

### Fixed

- Fix rendering failure for static integer
  [#50](https://github.com/k0kubun/hamlit/pull/50). *Thanks to @yatmsu*

## [2.1.1](https://github.com/k0kubun/hamlit/compare/v2.1.0...v2.1.1) - 2015-12-15

### Fixed

- Use faster HTML-escape method for compiling
- Show proper line number for unbalanced brackets error

## [2.1.0](https://github.com/k0kubun/hamlit/compare/v2.0.2...v2.1.0) - 2015-12-14

### Added

- `-I` and `-r` options are added to `hamlit render` command
  [#37](https://github.com/k0kubun/hamlit/issues/37). *Thanks to @jhurliman*

### Changed

- Dropped obsolete `escape_utils` gem dependency
  [#48](https://github.com/k0kubun/hamlit/pull/48). *Thanks to @eagletmt*

### Fixed

- Accept NUL character in attribute keys
  [#49](https://github.com/k0kubun/hamlit/pull/49). *Thanks to @eagletmt*

## [2.0.2](https://github.com/k0kubun/hamlit/compare/v2.0.1...v2.0.2) - 2015-12-12

### Fixed
- Fix a crash in compiling with CLI
  [#46](https://github.com/k0kubun/hamlit/pull/46). *Thanks to @walf443*
- Use default engine options properly in CLI commands

## [2.0.1](https://github.com/k0kubun/hamlit/compare/v2.0.0...v2.0.1) - 2015-11-30

### Fixed
- Fix build failure of native extension

## [2.0.0](https://github.com/k0kubun/hamlit/compare/v1.7.2...v2.0.0) - 2015-11-30 [YANKED]
### Added
- Support object reference

### Changed
- Full scratch of internal implementation
  - Rendering is strongly optimized
     - Static analyzer is introduced
     - Built with C extension for runtime rendering
     - Optimized compilation for 5 types of attributes
  - Compilation became faster too
  - Many rendering incompatibilities are resolved
- [**breaking**] Replaced parser with original Haml's one
  - Incompatible parsing error will never happen, but we can no longer parse
    attributes with Ripper
- [**breaking**] Unified behavior for both static and dynamic attributes, see
  [5 types of attributes](REFERENCE.md#5-types-of-attributes)
  - Though inconsistent behavior is removed, we can no longer rely on
    completely-Haml-compatible behavior of static attributes and pass haml-spec
- [**breaking**] Added :escape\_attrs option
  - You should specify HTML-escaping availability for script and attrs
    separately.

## [1.7.2](https://github.com/k0kubun/hamlit/compare/v1.7.1...v1.7.2) - 2015-07-22

### Fixed
- Bugfix about parsing a content of tag
  - This was introduced in v1.6.6.

## [1.7.1](https://github.com/k0kubun/hamlit/compare/v1.7.0...v1.7.1) - 2015-07-21

### Fixed
- Don't escape a block content of some helpers
  [#35](https://github.com/k0kubun/hamlit/issues/35). *Thanks to @felixbuenemann*

## [1.7.0](https://github.com/k0kubun/hamlit/compare/v1.6.7...v1.7.0) - 2015-07-09

### Added
- Support Ruby 2.2.0 hash syntax
  - like `{ "hyphened-key": "value" }`

## [1.6.7](https://github.com/k0kubun/hamlit/compare/v1.6.6...v1.6.7) - 2015-06-27

### Fixed
- Remove unused variables and avoid shadowing
  - To suppress warnings in application using `rspec --warnings`

## [1.6.6](https://github.com/k0kubun/hamlit/compare/v1.6.5...v1.6.6) - 2015-06-24

### Added
- Allow hyphenated HTML-style attributes
  [pull #29](https://github.com/k0kubun/hamlit/pull/29). *thanks to @babelfish*

## [1.6.5](https://github.com/k0kubun/hamlit/compare/v1.6.4...v1.6.5) - 2015-06-13

### Fixed
- Don't duplicate element class and attribute class
- Raise an error for an empty tag name

## [1.6.4](https://github.com/k0kubun/hamlit/compare/v1.6.3...v1.6.4) - 2015-06-13

### Changed
- Show human-friendly error messages

### Fixed
- Fix line number of runtime syntax error
- Increase the number of checked cases for illegal nesting.
  *Thanks to @eagletmt*

## [1.6.3](https://github.com/k0kubun/hamlit/compare/v1.6.2...v1.6.3) - 2015-06-13

### Fixed
- Fix ! and & parsing inside a tag
  [#27](https://github.com/k0kubun/hamlit/issues/27#issuecomment-111593458).
  *Thanks to @leesmith*

## [1.6.2](https://github.com/k0kubun/hamlit/compare/v1.6.1...v1.6.2) - 2015-06-11

### Fixed
- Reject a content for self-closing tags
- Reject nesing within self-closing tags

## [1.6.1](https://github.com/k0kubun/hamlit/compare/v1.6.0...v1.6.1) - 2015-06-11

### Fixed
- Parse N-space indentation
  [#26](https://github.com/k0kubun/hamlit/issues/26). *Thanks to @eagletmt*

## [1.6.0](https://github.com/k0kubun/hamlit/compare/v1.5.9...v1.6.0) - 2015-06-11

### Fixed
- Fix line number of compiled code for new attributes
- Render HTML entities normally for plain text
  [#27](https://github.com/k0kubun/hamlit/issues/27). *Thanks to @jeffblake*

## [1.5.9](https://github.com/k0kubun/hamlit/compare/v1.5.8...v1.5.9) - 2015-06-08

### Fixed
- Reject silent script after a tag

## [1.5.8](https://github.com/k0kubun/hamlit/compare/v1.5.7...v1.5.8) - 2015-06-08

### Fixed
- Fix parsing inline script for != and &=

## [1.5.7](https://github.com/k0kubun/hamlit/compare/v1.5.6...v1.5.7) - 2015-06-08

### Fixed
- Fix the behavior for multi-line script

## [1.5.6](https://github.com/k0kubun/hamlit/compare/v1.5.5...v1.5.6) - 2015-06-07

### Added
- Raise error for unbalanced brackets

### Changed
- Don't render newline after block script

## [1.5.5](https://github.com/k0kubun/hamlit/compare/v1.5.4...v1.5.5) - 2015-06-07

### Added
- Support &, &== operator

### Changed
- Depend on v0.7.6 of temple for refactoring

### Fixed
- Fix a trivial diff of rendering multiline operator

## [1.5.4](https://github.com/k0kubun/hamlit/compare/v1.5.3...v1.5.4) - 2015-06-07

### Changed
- Recursively remove whitespace inside a tag

### Fixed
- Fix ! operator immediately before whitespace

## [1.5.3](https://github.com/k0kubun/hamlit/compare/v1.5.2...v1.5.3) - 2015-06-06

### Added
- Support !, !=, !==, &= and ~ as inline operators

## [1.5.2](https://github.com/k0kubun/hamlit/compare/v1.5.1...v1.5.2) - 2015-06-06

### Changed
- Disable html escaping in CSS and JavaScript filter

## [1.5.1](https://github.com/k0kubun/hamlit/compare/v1.5.0...v1.5.1) - 2015-06-05

### Changed
- Remove outer whitespace in the block

## [1.5.0](https://github.com/k0kubun/hamlit/compare/v1.4.7...v1.5.0) - 2015-06-03

### Changed
- Remake implementation of outer whitespace removal

## [1.4.7](https://github.com/k0kubun/hamlit/compare/v1.4.6...v1.4.7) - 2015-06-03

### Changed
- Sort static old attributes by name

### Fixed
- Bugfix for old array attributes with class element

## [1.4.6](https://github.com/k0kubun/hamlit/compare/v1.4.5...v1.4.6) - 2015-06-03

### Added
- Support `!==`, `==` operator

### Fixed
- Avoid regarding spaced block as multiline

## [1.4.5](https://github.com/k0kubun/hamlit/compare/v1.4.4...v1.4.5) - 2015-06-02

### Fixed
- Support Ruby 2.0 and 2.1 for v1.4.4

## [1.4.4](https://github.com/k0kubun/hamlit/compare/v1.4.3...v1.4.4) - 2015-06-02 [YANKED]

### Fixed
- Fix old attribute parser to be more flexible
  - Accept multiple hashes as old attributes
  - Accept old attributes with hash and literal

## [1.4.3](https://github.com/k0kubun/hamlit/compare/v1.4.2...v1.4.3) - 2015-06-02

### Changed
- Allow `when` to have multiple candidates
- Allow `rescue` to specify an error variable

## [1.4.2](https://github.com/k0kubun/hamlit/compare/v1.4.1...v1.4.2) - 2015-05-31

### Added
- Support `!` operator
  - It disables html escaping for interpolated text

## [1.4.1](https://github.com/k0kubun/hamlit/compare/v1.4.0...v1.4.1) - 2015-05-31

### Fixed
- Fix code mistake in 1.4.0

## [1.4.0](https://github.com/k0kubun/hamlit/compare/v1.3.2...v1.4.0) - 2015-05-31 [YANKED]

### Added
- Escape interpolated string in plain text

## [1.3.2](https://github.com/k0kubun/hamlit/compare/v1.3.1...v1.3.2) - 2015-05-30

- Render `begin`, `rescue` and `ensure`

## [1.3.1](https://github.com/k0kubun/hamlit/compare/v1.3.0...v1.3.1) - 2015-05-30

### Fixed
- Bugfix about a backslash-only comment
- Don't strip a plain text

## [1.3.0](https://github.com/k0kubun/hamlit/compare/v1.2.1...v1.3.0) - 2015-05-16

### Added
- Resurrect escape\_html option
  [#25](https://github.com/k0kubun/hamlit/issues/25).
  *Thanks to @resistorsoftware*
  - Still enabled by default
  - This has been dropped since v0.6.0

## [1.2.1](https://github.com/k0kubun/hamlit/compare/v1.2.0...v1.2.1) - 2015-05-15

### Fixed
- Fix the list of boolean attributes
  [#24](https://github.com/k0kubun/hamlit/issues/24). *Thanks to @jeffblake*

## [1.2.0](https://github.com/k0kubun/hamlit/compare/v1.1.1...v1.2.0) - 2015-05-06

Added
- Support `succeed`, `precede` and `surround`
  [#22](https://github.com/k0kubun/hamlit/issues/22). *Thanks to @sneakernets*

## [1.1.1](https://github.com/k0kubun/hamlit/compare/v1.1.0...v1.1.1) - 2015-05-06

### Fixed
- Bugfix of rendering array attributes

## [1.1.0](https://github.com/k0kubun/hamlit/compare/v1.0.0...v1.1.0) - 2015-05-06

### Fixed
- Join id and class attributes
  [#23](https://github.com/k0kubun/hamlit/issues/23).
  *Thanks to @felixbuenemann*

## [1.0.0](https://github.com/k0kubun/hamlit/compare/v0.6.2...v1.0.0) - 2015-04-12

### Added
- Use escape\_utils gem for faster escape\_html

## [0.6.2](https://github.com/k0kubun/hamlit/compare/v0.6.1...v0.6.2) - 2015-04-12

### Fixed
- Don't render falsy attributes
  [#2](https://github.com/k0kubun/hamlit/issues/2). *Thanks to @eagletmt*

## [0.6.1](https://github.com/k0kubun/hamlit/compare/v0.6.0...v0.6.1) - 2015-04-12

### Fixed
- Bugfix of line numbers for better error backtrace
  [pull #19](https://github.com/k0kubun/hamlit/pull/19)

## [0.6.0](https://github.com/k0kubun/hamlit/compare/v0.5.3...v0.6.0) - 2015-04-12

### Added
- Automatically escape html in all situations
  [pull #18](https://github.com/k0kubun/hamlit/pull/18)

## [0.5.3](https://github.com/k0kubun/hamlit/compare/v0.5.2...v0.5.3) - 2015-04-12

### Fixed
- Bugfix for syntax error in data attribute hash
  [#17](https://github.com/k0kubun/hamlit/issues/17).  *Thanks to @eagletmt*

## [0.5.2](https://github.com/k0kubun/hamlit/compare/v0.5.1...v0.5.2) - 2015-04-12

### Fixed
- Bugfix for silent script without block
  [#16](https://github.com/k0kubun/hamlit/issues/16).  *Thanks to @eagletmt*

## [0.5.1](https://github.com/k0kubun/hamlit/compare/v0.5.0...v0.5.1) - 2015-04-12

### Fixed
- Bugfix about duplicated id and class
  [#4](https://github.com/k0kubun/hamlit/issues/4).  *Thanks to @os0x*

## [0.5.0](https://github.com/k0kubun/hamlit/compare/v0.4.3...v0.5.0) - 2015-04-12

### Fixed
- Escape special characters in attribute values
  [#10](https://github.com/k0kubun/hamlit/issues/10). *Thanks to @mono0x,
  @eagletmt*

## [0.4.3](https://github.com/k0kubun/hamlit/compare/v0.4.2...v0.4.3) - 2015-04-12

### Fixed
- Allow empty else statement [#14](https://github.com/k0kubun/hamlit/issues/14).
  *Thanks to @jeffblake*
- Accept comment-only script [#13](https://github.com/k0kubun/hamlit/issues/13).
  *Thanks to @jeffblake*

## [0.4.2](https://github.com/k0kubun/hamlit/compare/v0.4.1...v0.4.2) - 2015-04-05

### Fixed
- Bugfix about parsing nested attributes
  [#12](https://github.com/k0kubun/hamlit/issues/12). *Thanks to @creasty*

## [0.4.1](https://github.com/k0kubun/hamlit/compare/v0.4.0...v0.4.1) - 2015-04-05

### Removed
- Automatic escape html is sintara, consult `README.md`.

### Fixed
- Escape haml operators by backslash
  [#11](https://github.com/k0kubun/hamlit/issues/11).  *Thanks to @mono0x*

## [0.4.0](https://github.com/k0kubun/hamlit/compare/v0.3.4...v0.4.0) - 2015-04-05 [YANKED]

### Added
- Automatically escape html in sinatra

## [0.3.4](https://github.com/k0kubun/hamlit/compare/v0.3.3...v0.3.4) - 2015-04-02

### Fixed
- Allow tab indentation [#9](https://github.com/k0kubun/hamlit/issues/9).
  *Thanks to @tdtds*

## [0.3.3](https://github.com/k0kubun/hamlit/compare/v0.3.2...v0.3.3) - 2015-04-01

### Fixed
- Accept multi byte parsing [#8](https://github.com/k0kubun/hamlit/issues/8).
  *Thanks to @machu*

## [0.3.2](https://github.com/k0kubun/hamlit/compare/v0.3.1...v0.3.2) - 2015-03-31

### Fixed
- Bugfix for compiling old attributes [#7](https://github.com/k0kubun/hamlit/issues/7).
  *Thanks to @creasty*

## [0.3.1](https://github.com/k0kubun/hamlit/compare/v0.3.0...v0.3.1) - 2015-03-31

### Fixed
- Hyphenate data attributes [#5](https://github.com/k0kubun/hamlit/issues/5).
  *Thanks to @os0x*

## [0.3.0](https://github.com/k0kubun/hamlit/compare/v0.2.0...v0.3.0) - 2015-03-31

### Added
- Specify a version in dependency of temple

## [0.2.0](https://github.com/k0kubun/hamlit/compare/v0.1.3...v0.2.0) - 2015-03-30

### Added
- Allow comments in script [#3](https://github.com/k0kubun/hamlit/issues/3).
  *Thanks to @eagletmt*

## [0.1.3](https://github.com/k0kubun/hamlit/compare/v0.1.2...v0.1.3) - 2015-03-30

### Fixed
- Bugfix for [#1](https://github.com/k0kubun/hamlit/issues/1) attribute nesting
  on runtime. *Thanks to @eagletmt*

## [0.1.2](https://github.com/k0kubun/hamlit/compare/v0.1.1...v0.1.2) - 2015-03-30

### Fixed
- Ignore false or nil values in attributes
  - Partial fix for [#2](https://github.com/k0kubun/hamlit/issues/2).
    *Thanks to @eagletmt*

## [0.1.1](https://github.com/k0kubun/hamlit/compare/v0.1.0...v0.1.1) - 2015-03-30

### Removed
- Drop obsolete `--ugly` option for CLI
  - Currently pretty mode is not implemented #2

## [0.1.0](https://github.com/k0kubun/hamlit/compare/9cf8216...v0.1.0) - 2015-03-30

- Initial release
  - Passing haml-spec with ugly mode
