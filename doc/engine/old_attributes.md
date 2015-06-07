# old\_attributes\_spec.rb:44
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


# old\_attributes\_spec.rb:125
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


# old\_attributes\_spec.rb:203
## Input
```haml
- val = false
%a{ href: val }
- val = nil
%a{ href: val }

```

## Output
### Haml, Faml
```html
<a></a>
<a></a>

```

### Hamlit
```html
<a href='false'></a>
<a href=''></a>

```


# old\_attributes\_spec.rb:217
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


# old\_attributes\_spec.rb:229
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


# old\_attributes\_spec.rb:241
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


# old\_attributes\_spec.rb:264
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

