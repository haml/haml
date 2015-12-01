# Change Log

All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning].

## [Unreleased]

## [2.0.1] - 2015-11-30

- Fix build failure of native extension

## [2.0.0] - 2015-11-30 [YANKED] due to gemspec mistake

- Full scratch of internal implementation
  - Rendering is strongly optimized
     - Static analyzer is introduced
     - Built with C extension for runtime rendering
     - Optimized compilation for 5 types of attributes
  - Compilation became faster too
  - Many rendering incompatibilities are resolved
  - Object reference support
  - Breaking changes:
     - Replaced parser with original Haml's one
         - Incompatible parsing error will never happen, but we can no longer
           parse attributes with Ripper
     - Unified behavior for both static and dynamic attributes, see [5 types of
       attributes](REFERENCE.md#5-types-of-attributes)
         - Though inconsistent behavior is removed, we can no longer rely on
           completely-Haml-compatible behavior of static attributes and pass
           haml-spec
     - Added :escape\_attrs option
         - You should specify HTML-escaping availability for script and attrs
           separately.

## [1.7.2] - 2015-07-22

- Bugfix about parsing a content of tag
  - This was introduced in v1.6.6.

## [1.7.1] - 2015-07-21

- Don't escape a block content of some helpers
  - https://github.com/k0kubun/hamlit/issues/35
  - Thanks to @felixbuenemann

## [1.7.0] - 2015-07-09

- Support Ruby 2.2.0 hash syntax
  - like `{ "hyphened-key": "value" }`

## [1.6.7] - 2015-06-27

- Remove unused variables and avoid shadowing
  - To suppress warnings in application using `rspec --warnings`

## [1.6.6] - 2015-06-24

- Allow hyphenated HTML-style attributes
  - https://github.com/k0kubun/hamlit/pull/29
  - Thanks to @babelfish

## [1.6.5] - 2015-06-13

- Don't duplicate element class and attribute class
- Raise an error for an empty tag name

## [1.6.4] - 2015-06-13

- Show human-friendly error messages
- Fix line number of runtime syntax error
- Increase the number of checked cases for illegal nesting
  - Thanks to @eagletmt

## [1.6.3] - 2015-06-13

- Fix ! and & parsing inside a tag
  - https://github.com/k0kubun/hamlit/issues/27#issuecomment-111593458
  - Thanks to @leesmith

## [1.6.2] - 2015-06-11

- Reject a content for self-closing tags
- Reject nesing within self-closing tags

## [1.6.1] - 2015-06-11

- Parse N-space indentation
  - https://github.com/k0kubun/hamlit/issues/26
  - Thanks to @eagletmt

## [1.6.0] - 2015-06-11

- Fix line number of compiled code for new attributes
- Render HTML entities normally for plain text
  - https://github.com/k0kubun/hamlit/issues/27
  - Thanks to @jeffblake

## [1.5.9] - 2015-06-08

- Reject silent script after a tag

## [1.5.8] - 2015-06-08

- Fix parsing inline script for != and &=

## [1.5.7] - 2015-06-08

- Fix the behavior for multi-line script

## [1.5.6] - 2015-06-07

- Raise error for unbalanced brackets
- Don't render newline after block script

## [1.5.5] - 2015-06-07

- Support &, &== operator
- Depend on v0.7.6 of temple for refactoring
- Fix a trivial diff of rendering multiline operator

## [1.5.4] - 2015-06-07

- Recursively remove whitespace inside a tag
- Fix ! operator immediately before whitespace

## [1.5.3] - 2015-06-06

- Support !, !=, !==, &= and ~ as inline operators

## [1.5.2] - 2015-06-06

- Disable html escaping in CSS and JavaScript filter

## [1.5.1] - 2015-06-05

- Remove outer whitespace in the block

## [1.5.0] - 2015-06-03

- Remake implementation of outer whitespace removal

## [1.4.7] - 2015-06-03

- Sort static old attributes by name
- Bugfix for old array attributes with class element

## [1.4.6] - 2015-06-03

- Support `!==`, `==` operator
- Avoid regarding spaced block as multiline

## [1.4.5] - 2015-06-02

- Support Ruby 2.0 and 2.1 for v1.4.4

## [1.4.4] - 2015-06-02 [YANKED]

- Fix old attribute parser to be more flexible
  - Accept multiple hashes as old attributes
  - Accept old attributes with hash and literal

## [1.4.3] - 2015-06-02

- Allow `when` to have multiple candidates
- Allow `rescue` to specify an error variable

## [1.4.2] - 2015-05-31

- Support `!` operator
  - It disables html escaping for interpolated text

## [1.4.1] - 2015-05-31

- Fix code mistake in 1.4.0

## [1.4.0] - 2015-05-31 [YANKED]

- Escape interpolated string in plain text

## [1.3.2] - 2015-05-30

- Render `begin`, `rescue` and `ensure`

## [1.3.1] - 2015-05-30

- Bugfix about a backslash-only comment
- Don't strip a plain text

## [1.3.0] - 2015-05-16

- Resurrect escape\_html option
  - Still enabled by default
  - This has been dropped since v0.6.0
  - https://github.com/k0kubun/hamlit/issues/25
  - Thanks to @resistorsoftware

## [1.2.1] - 2015-05-15

- Fix the list of boolean attributes
  - https://github.com/k0kubun/hamlit/issues/24
  - Thanks to @jeffblake

## [1.2.0] - 2015-05-06

- Support `succeed`, `precede` and `surround`
  - https://github.com/k0kubun/hamlit/issues/22
  - Thanks to @sneakernets

## [1.1.1] - 2015-05-06

- Bugfix of rendering array attributes

## [1.1.0] - 2015-05-06

- Join id and class attributes
  - https://github.com/k0kubun/hamlit/issues/23
  - Thanks to @felixbuenemann

## [1.0.0] - 2015-04-12

- Use escape\_utils gem for faster escape\_html

## [0.6.2] - 2015-04-12

- Don't render falsy attributes
  - https://github.com/k0kubun/hamlit/issues/2
  - Thanks to @eagletmt

## [0.6.1] - 2015-04-12

- Bugfix of line numbers for better error backtrace
  - https://github.com/k0kubun/hamlit/pull/19

## [0.6.0] - 2015-04-12

- Automatically escape html in all situations
  - https://github.com/k0kubun/hamlit/pull/18

## [0.5.3] - 2015-04-12

- Bugfix for syntax error in data attribute hash
  - https://github.com/k0kubun/hamlit/issues/17
  - Thanks to @eagletmt

## [0.5.2] - 2015-04-12

- Bugfix for silent script without block
  - https://github.com/k0kubun/hamlit/issues/16
  - Thanks to @eagletmt

## [0.5.1] - 2015-04-12

- Bugfix about duplicated id and class
  - https://github.com/k0kubun/hamlit/issues/4
  - Thanks to @os0x

## [0.5.0] - 2015-04-12

- Escape special characters in attribute values
 - https://github.com/k0kubun/hamlit/issues/10
 - Thanks to @mono0x, @eagletmt

## [0.4.3] - 2015-04-12

- Allow empty else statement
  - https://github.com/k0kubun/hamlit/issues/14
  - Thanks to @jeffblake
- Accept comment-only script
  - https://github.com/k0kubun/hamlit/issues/13
  - Thanks to @jeffblake

## [0.4.2] - 2015-04-05

- Bugfix about parsing nested attributes
  - https://github.com/k0kubun/hamlit/issues/12
  - Thanks to @creasty

## [0.4.1] - 2015-04-05

- Escape haml operators by backslash
  - https://github.com/k0kubun/hamlit/issues/11
  - Thanks to @mono0x

## [0.4.0] - 2015-04-05 [YANKED]

- Automatically escape html in sinatra
  - This behavior is not compatible with Haml.
  - Removed from next version.

## [0.3.4] - 2015-04-02

- Allow tab indentation
  - https://github.com/k0kubun/hamlit/issues/9
  - Thanks to @tdtds

## [0.3.3] - 2015-04-01

- Accept multi byte parsing
  - https://github.com/k0kubun/hamlit/issues/8
  - Thanks to @machu

## [0.3.2] - 2015-03-31

- Bugfix for compiling old attributes
  - https://github.com/k0kubun/hamlit/issues/7
  - Thanks to @creasty

## [0.3.1] - 2015-03-31

- Hyphenate data attributes
  - https://github.com/k0kubun/hamlit/issues/5
  - Thanks to @os0x

## [0.3.0] - 2015-03-31

- Specify a version in dependency of temple

## [0.2.0]- 2015-03-30

- Allow comments in script
  - https://github.com/k0kubun/hamlit/issues/3
  - Thanks to @eagletmt

## [0.1.3]- 2015-03-30

- Bugfix for attribute nesting on runtime
  - https://github.com/k0kubun/hamlit/issues/1
  - Thanks to @eagletmt

## [0.1.2] - 2015-03-30

- Ignore false or nil values in attributes
  - Partial fix for https://github.com/k0kubun/hamlit/issues/2
  - Thanks to @eagletmt

## [0.1.1] - 2015-03-30

- Drop obsolete `--ugly` option for CLI
  - Currently pretty mode is not implemented #2.

## [0.1.0] - 2015-03-30

- Initial release
  - Passing haml-spec with ugly mode.

[Semantic Versioning]: http://semver.org/
[Unreleased]: https://github.com/k0kubun/hamlit/compare/v2.0.1...HEAD
[0.1.0]: https://github.com/k0kubun/hamlit/compare/9cf8216...v0.1.0
[0.1.1]: https://github.com/k0kubun/hamlit/compare/v0.1.0...v0.1.1
[0.1.2]: https://github.com/k0kubun/hamlit/compare/v0.1.1...v0.1.2
[0.1.3]: https://github.com/k0kubun/hamlit/compare/v0.1.2...v0.1.3
[0.2.0]: https://github.com/k0kubun/hamlit/compare/v0.1.3...v0.2.0
[0.3.0]: https://github.com/k0kubun/hamlit/compare/v0.2.0...v0.3.0
[0.3.1]: https://github.com/k0kubun/hamlit/compare/v0.3.0...v0.3.1
[0.3.2]: https://github.com/k0kubun/hamlit/compare/v0.3.1...v0.3.2
[0.3.3]: https://github.com/k0kubun/hamlit/compare/v0.3.2...v0.3.3
[0.3.4]: https://github.com/k0kubun/hamlit/compare/v0.3.3...v0.3.4
[0.4.0]: https://github.com/k0kubun/hamlit/compare/v0.3.4...v0.4.0
[0.4.1]: https://github.com/k0kubun/hamlit/compare/v0.4.0...v0.4.1
[0.4.2]: https://github.com/k0kubun/hamlit/compare/v0.4.1...v0.4.2
[0.4.3]: https://github.com/k0kubun/hamlit/compare/v0.4.2...v0.4.3
[0.5.0]: https://github.com/k0kubun/hamlit/compare/v0.4.3...v0.5.0
[0.5.1]: https://github.com/k0kubun/hamlit/compare/v0.5.0...v0.5.1
[0.5.2]: https://github.com/k0kubun/hamlit/compare/v0.5.1...v0.5.2
[0.5.3]: https://github.com/k0kubun/hamlit/compare/v0.5.2...v0.5.3
[0.6.0]: https://github.com/k0kubun/hamlit/compare/v0.5.3...v0.6.0
[0.6.1]: https://github.com/k0kubun/hamlit/compare/v0.6.0...v0.6.1
[0.6.2]: https://github.com/k0kubun/hamlit/compare/v0.6.1...v0.6.2
[1.0.0]: https://github.com/k0kubun/hamlit/compare/v0.6.2...v1.0.0
[1.1.0]: https://github.com/k0kubun/hamlit/compare/v1.0.0...v1.1.0
[1.1.1]: https://github.com/k0kubun/hamlit/compare/v1.1.0...v1.1.1
[1.2.0]: https://github.com/k0kubun/hamlit/compare/v1.1.1...v1.2.0
[1.2.1]: https://github.com/k0kubun/hamlit/compare/v1.2.0...v1.2.1
[1.3.0]: https://github.com/k0kubun/hamlit/compare/v1.2.1...v1.3.0
[1.3.1]: https://github.com/k0kubun/hamlit/compare/v1.3.0...v1.3.1
[1.3.2]: https://github.com/k0kubun/hamlit/compare/v1.3.1...v1.3.2
[1.4.0]: https://github.com/k0kubun/hamlit/compare/v1.3.2...v1.4.0
[1.4.1]: https://github.com/k0kubun/hamlit/compare/v1.4.0...v1.4.1
[1.4.2]: https://github.com/k0kubun/hamlit/compare/v1.4.1...v1.4.2
[1.4.3]: https://github.com/k0kubun/hamlit/compare/v1.4.2...v1.4.3
[1.4.4]: https://github.com/k0kubun/hamlit/compare/v1.4.3...v1.4.4
[1.4.5]: https://github.com/k0kubun/hamlit/compare/v1.4.4...v1.4.5
[1.4.6]: https://github.com/k0kubun/hamlit/compare/v1.4.5...v1.4.6
[1.4.7]: https://github.com/k0kubun/hamlit/compare/v1.4.6...v1.4.7
[1.5.0]: https://github.com/k0kubun/hamlit/compare/v1.4.7...v1.5.0
[1.5.1]: https://github.com/k0kubun/hamlit/compare/v1.5.0...v1.5.1
[1.5.2]: https://github.com/k0kubun/hamlit/compare/v1.5.1...v1.5.2
[1.5.3]: https://github.com/k0kubun/hamlit/compare/v1.5.2...v1.5.3
[1.5.4]: https://github.com/k0kubun/hamlit/compare/v1.5.3...v1.5.4
[1.5.5]: https://github.com/k0kubun/hamlit/compare/v1.5.4...v1.5.5
[1.5.6]: https://github.com/k0kubun/hamlit/compare/v1.5.5...v1.5.6
[1.5.7]: https://github.com/k0kubun/hamlit/compare/v1.5.6...v1.5.7
[1.5.8]: https://github.com/k0kubun/hamlit/compare/v1.5.7...v1.5.8
[1.5.9]: https://github.com/k0kubun/hamlit/compare/v1.5.8...v1.5.9
[1.6.0]: https://github.com/k0kubun/hamlit/compare/v1.5.9...v1.6.0
[1.6.1]: https://github.com/k0kubun/hamlit/compare/v1.6.0...v1.6.1
[1.6.2]: https://github.com/k0kubun/hamlit/compare/v1.6.1...v1.6.2
[1.6.3]: https://github.com/k0kubun/hamlit/compare/v1.6.2...v1.6.3
[1.6.4]: https://github.com/k0kubun/hamlit/compare/v1.6.3...v1.6.4
[1.6.5]: https://github.com/k0kubun/hamlit/compare/v1.6.4...v1.6.5
[1.6.6]: https://github.com/k0kubun/hamlit/compare/v1.6.5...v1.6.6
[1.6.7]: https://github.com/k0kubun/hamlit/compare/v1.6.6...v1.6.7
[1.7.0]: https://github.com/k0kubun/hamlit/compare/v1.6.7...v1.7.0
[1.7.1]: https://github.com/k0kubun/hamlit/compare/v1.7.0...v1.7.1
[1.7.2]: https://github.com/k0kubun/hamlit/compare/v1.7.1...v1.7.2
[2.0.0]: https://github.com/k0kubun/hamlit/compare/v1.7.2...v2.0.0
[2.0.1]: https://github.com/k0kubun/hamlit/compare/v2.0.0...v2.0.1
