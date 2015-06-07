# [old\_attributes\_spec.rb:43](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L43)
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


# [old\_attributes\_spec.rb:124](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L124)
## Input
```haml
.foo{ class: ['bar'] }
.foo{ class: ['bar', nil] }
.foo{ class: ['bar', 'baz'] }

```

## Output
### Haml, Hamlit
```html
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class='bar baz foo'></div>

```

### Faml
```html
<div class='bar foo'></div>
<div class=' bar foo'></div>
<div class='bar baz foo'></div>

```


# [old\_attributes\_spec.rb:201](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L201)
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


# [old\_attributes\_spec.rb:226](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L226)
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


# [old\_attributes\_spec.rb:238](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L238)
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


# [old\_attributes\_spec.rb:250](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L250)
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


# [old\_attributes\_spec.rb:273](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/old_attributes_spec.rb#L273)
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

