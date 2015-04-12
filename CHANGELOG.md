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
