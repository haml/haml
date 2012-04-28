# Haml

Haml is a templating engine for HTML. It's designed to make it both easier and
more pleasant to write HTML documents, by eliminating redundancy, reflecting the
underlying structure that the document represents, and providing an elegant syntax
that's both powerful and easy to understand.

## Basic Usage

Haml can be used from the command line or as part of a Ruby web framework. The
first step is to install the gem:

    gem install haml

After you write some Haml, you can run

    haml document.haml

to compile it to HTML. For more information on these commands, check out

    haml --help

To use Haml programatically, check out the [YARD
documentation](http://haml-lang.com/docs/yardoc/).

## Using Haml with Rails

To use Haml with Rails, simply add Haml to your Gemfile and run `bundle`.

If you'd like to replace Rails's Erb-based generators with Haml, add
[haml-rails](https://github.com/indirect/haml-rails) to your Gemfile as well.

## Formatting

The most basic element of Haml is a shorthand for creating HTML:

    %tagname{:attr1 => 'value1', :attr2 => 'value2'} Contents

No end-tag is needed; Haml handles that automatically. If you prefer HTML-style
attributes, you can also use:

    %tagname(attr1='value1' attr2='value2') Contents

Adding `class` and `id` attributes is even easier. Haml uses the same syntax as
the CSS that styles the document:

    %tagname#id.class

In fact, when you're using the `<div>` tag, it becomes _even easier_. Because
`<div>` is such a common element, a tag without a name defaults to a div. So

    #foo Hello!

becomes

    <div id='foo'>Hello!</div>

Haml uses indentation to bring the individual elements to represent the HTML
structure. A tag's children are indented beneath than the parent tag. Again, a
closing tag is automatically added. For example:

    %ul
      %li Salt
      %li Pepper

becomes:

    <ul>
      <li>Salt</li>
      <li>Pepper</li>
    </ul>

You can also put plain text as a child of an element:

    %p
      Hello,
      World!

It's also possible to embed Ruby code into Haml documents. An equals sign, `=`,
will output the result of the code. A hyphen, `-`, will run the code but not
output the result. You can even use control statements like `if` and `while`:

    %p
      Date/Time:
      - now = DateTime.now
      %strong= now
      - if now > DateTime.parse("December 31, 2006")
        = "Happy new " + "year!"

Haml provides far more tools than those presented here. Check out the [reference
documentation](http://beta.haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html)
for full details.

### Indentation

Haml's indentation can be made up of one or more tabs or spaces. However,
indentation must be consistent within a given document. Hard tabs and spaces
can't be mixed, and the same number of tabs or spaces must be used throughout.

## Contributing

Contributions are welcomed, but before you get started please read the
[guidelines](http://haml-lang.com/development.html#contributing).

After forking and then cloning the repo locally, install Bundler and then use it
to install the development gem dependecies:

    gem install bundler
    bundle install

Once this is complete, you should be able to run the test suite:

    rake

You'll get a warning that you need to install haml-spec, so run this:

    git submodule update --init

At this point `rake` should run without error or warning and you are ready to
start working on your patch!

## Authors

Haml was created by [Hampton Catlin](http://hamptoncatlin.com), the author of
the original implementation. However, Hampton doesn't even know his way around
the code anymore and now just occasionally consults on the language issues.

[Nathan Weizenbaum](http://nex-3.com) was for many years the primary developer
and architect of the "modern" Ruby implementation of Haml. His hard work
endlessly answering forum posts, fixing bugs, refactoring, finding speed
improvements, writing documentation, and implementing new features is what has
kept the project alive.

[Norman Clarke](http://github.com/norman), the author of Haml Spec and the Haml
implementation in Lua, took over as maintainer in April 2012.

## License

Some of Nathan's work on Haml was supported by Unspace Interactive.

Beyond that, the implementation is licensed under the MIT License.

Copyright (c) 2006-2009 Hampton Catlin and Nathan Weizenbaum

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
