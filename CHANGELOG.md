## v1.6.1

- Parse N-space indentation

## v1.6.0

- Fix line number of compiled code for new attributes
- Render HTML entities normally for plain text
  - https://github.com/k0kubun/hamlit/issues/27
  - Thanks to @jeffblake

## v1.5.9

- Reject silent script after a tag

## v1.5.8

- Fix parsing inline script for != and &=

## v1.5.7

- Fix the behavior for multi-line script

## v1.5.6

- Raise error for unbalanced brackets
- Don't render newline after block script

## v1.5.5

- Support &, &== operator
- Depend on v0.7.6 of temple for refactoring
- Fix a trivial diff of rendering multiline operator

## v1.5.4

- Recursively remove whitespace inside a tag
- Fix ! operator immediately before whitespace

## v1.5.3

- Support !, !=, !==, &= and ~ as inline operators

## v1.5.2

- Disable html escaping in CSS and JavaScript filter

## v1.5.1

- Remove outer whitespace in the block

## v1.5.0

- Remake implementation of outer whitespace removal

## v1.4.7

- Sort static old attributes by name
- Bugfix for old array attributes with class element

## v1.4.6

- Support `!==`, `==` operator
- Avoid regarding spaced block as multiline

## v1.4.5

- Support Ruby 2.0 and 2.1 for v1.4.4

## v1.4.4 (yanked)

- Fix old attribute parser to be more flexible
  - Accept multiple hashes as old attributes
  - Accept old attributes with hash and literal

## v1.4.3

- Allow `when` to have multiple candidates
- Allow `rescue` to specify an error variable

## v1.4.2

- Support `!` operator
  - It disables html escaping for interpolated text

## v1.4.1

- Fix code mistake in 1.4.0

## v1.4.0 (yanked)

- Escape interpolated string in plain text

## v1.3.2

- Render `begin`, `rescue` and `ensure`

## v1.3.1

- Bugfix about a backslash-only comment
- Don't strip a plain text

## v1.3.0

- Resurrect escape\_html option
  - Still enabled by default
  - This has been dropped since v0.6.0
  - https://github.com/k0kubun/hamlit/issues/25
  - Thanks to @resistorsoftware

## v1.2.1

- Fix the list of boolean attributes
  - https://github.com/k0kubun/hamlit/issues/24
  - Thanks to @jeffblake

## v1.2.0

- Support `succeed`, `precede` and `surround`
  - https://github.com/k0kubun/hamlit/issues/22
  - Thanks to @sneakernets

## v1.1.1

- Bugfix of rendering array attributes

## v1.1.0

- Join id and class attributes
  - https://github.com/k0kubun/hamlit/issues/23
  - Thanks to @felixbuenemann

## v1.0.0

- Use escape\_utils gem for faster escape\_html

## v0.6.2

- Don't render falsy attributes
  - https://github.com/k0kubun/hamlit/issues/2
  - Thanks to @eagletmt

## v0.6.1

- Bugfix of line numbers for better error backtrace
  - https://github.com/k0kubun/hamlit/pull/19

## v0.6.0

- Automatically escape html in all situations
  - https://github.com/k0kubun/hamlit/pull/18

## v0.5.3

- Bugfix for syntax error in data attribute hash
  - https://github.com/k0kubun/hamlit/issues/17
  - Thanks to @eagletmt

## v0.5.2

- Bugfix for silent script without block
  - https://github.com/k0kubun/hamlit/issues/16
  - Thanks to @eagletmt

## v0.5.1

- Bugfix about duplicated id and class
  - https://github.com/k0kubun/hamlit/issues/4
  - Thanks to @os0x

## v0.5.0

- Escape special characters in attribute values
 - https://github.com/k0kubun/hamlit/issues/10
 - Thanks to @mono0x, @eagletmt

## v0.4.3

- Allow empty else statement
  - https://github.com/k0kubun/hamlit/issues/14
  - Thanks to @jeffblake
- Accept comment-only script
  - https://github.com/k0kubun/hamlit/issues/13
  - Thanks to @jeffblake

## v0.4.2

- Bugfix about parsing nested attributes
  - https://github.com/k0kubun/hamlit/issues/12
  - Thanks to @creasty

## v0.4.1

- Escape haml operators by backslash
  - https://github.com/k0kubun/hamlit/issues/11
  - Thanks to @mono0x

## v0.4.0 (yanked)

- Automatically escape html in sinatra
  - This behavior is not compatible with Haml.
  - Removed from next version.

## v0.3.4

- Allow tab indentation
  - https://github.com/k0kubun/hamlit/issues/9
  - Thanks to @tdtds

## v0.3.3

- Accept multi byte parsing
  - https://github.com/k0kubun/hamlit/issues/8
  - Thanks to @machu

## v0.3.2

- Bugfix for compiling old attributes
  - https://github.com/k0kubun/hamlit/issues/7
  - Thanks to @creasty

## v0.3.1

- Hyphenate data attributes
  - https://github.com/k0kubun/hamlit/issues/5
  - Thanks to @os0x

## v0.3.0

- Specify a version in dependency of temple

## v0.2.0

- Allow comments in script
  - https://github.com/k0kubun/hamlit/issues/3
  - Thanks to @eagletmt

## v0.1.3

- Bugfix for attribute nesting on runtime
  - https://github.com/k0kubun/hamlit/issues/1
  - Thanks to @eagletmt

## v0.1.2

- Ignore false or nil values in attributes
  - Partial fix for https://github.com/k0kubun/hamlit/issues/2
  - Thanks to @eagletmt

## v0.1.1

- Drop obsolete `--ugly` option for CLI
  - Currently pretty mode is not implemented.

## v0.1.0

- Initial release
  - Passing haml-spec with ugly mode.
