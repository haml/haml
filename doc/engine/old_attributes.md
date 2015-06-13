# [old\_attributes\_spec.rb:43](/spec/hamlit/engine/old_attributes_spec.rb#L43)
## Input
```haml
%span{ class: '}}}', id: '{}}' } }{

```

## Output
### Haml
```html
Haml::SyntaxError: (haml):1: syntax error, unexpected tSTRING_DEND, expecting ')'
...l,  class: ')}>}}', id: '{}}' } }{</span>\n";;_erbout
...                               ^
(haml):1: unterminated regexp meets end of file
```

### Faml
```html
Faml::Compiler::UnparsableRubyCode: Unparsable Ruby code is given to attributes:  class: '
```

### Hamlit
```html
<span class='}}}' id='{}}'>}{</span>

```


# [old\_attributes\_spec.rb:124](/spec/hamlit/engine/old_attributes_spec.rb#L124)
## Input
```haml
.foo{ class: ['bar'] }
.foo{ class: ['bar', 'foo'] }
.foo{ class: ['bar', nil] }
.foo{ class: ['bar', 'baz'] }

```

## Output
### Haml, Hamlit
```html
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class='bar baz foo'></div>

```

### Faml
```html
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class=' bar foo'></div>
<div class='bar baz foo'></div>

```


# [old\_attributes\_spec.rb:203](/spec/hamlit/engine/old_attributes_spec.rb#L203)
## Input
```haml
/ wontfix: Non-boolean attributes are not escaped for optimization.
- val = false
%a{ href: val }
- val = nil
%a{ href: val }

/ Boolean attributes are escaped correctly.
- val = false
%a{ disabled: val }
- val = nil
%a{ disabled: val }

```

## Output
### Haml, Faml
```html
<!-- wontfix: Non-boolean attributes are not escaped for optimization. -->
<a></a>
<a></a>
<!-- Boolean attributes are escaped correctly. -->
<a></a>
<a></a>

```

### Hamlit
```html
<!-- wontfix: Non-boolean attributes are not escaped for optimization. -->
<a href='false'></a>
<a href=''></a>
<!-- Boolean attributes are escaped correctly. -->
<a></a>
<a></a>

```


# [old\_attributes\_spec.rb:228](/spec/hamlit/engine/old_attributes_spec.rb#L228)
## Input
```haml
%a{title: "'"}
%a{title: "'\""}
%a{href: '/search?foo=bar&hoge=<fuga>'}

```

## Output
### Haml
```html
<a title="'"></a>
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml, Hamlit
```html
<a title='&#39;'></a>
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```


# [old\_attributes\_spec.rb:240](/spec/hamlit/engine/old_attributes_spec.rb#L240)
## Input
```haml
- title = "'\""
- href  = '/search?foo=bar&hoge=<fuga>'
%a{title: title}
%a{href: href}

```

## Output
### Haml
```html
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml, Hamlit
```html
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```


# [old\_attributes\_spec.rb:252](/spec/hamlit/engine/old_attributes_spec.rb#L252)
## Input
```haml
- title = { title: "'\"" }
- href  = { href:  '/search?foo=bar&hoge=<fuga>' }
%a{ title }
%a{ href }

```

## Output
### Haml
```html
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml, Hamlit
```html
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```


# [old\_attributes\_spec.rb:275](/spec/hamlit/engine/old_attributes_spec.rb#L275)
## Input
```haml
%span{ data: { disable: true } } bar

```

## Output
### Haml, Hamlit
```html
<span data-disable>bar</span>

```

### Faml
```html
<span data-disable='true'>bar</span>

```

