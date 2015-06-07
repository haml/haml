# old\_attributes\_spec.rb:44
## Input
```haml
%span{ class: '}}}', id: '{}}' } }{

```

## Output
### Hamlit
```html
<span class='}}}' id='{}}'>}{</span>

```

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

# old\_attributes\_spec.rb:125
## Input
```haml
.foo{ class: ['bar'] }
.foo{ class: ['bar', nil] }
.foo{ class: ['bar', 'baz'] }

```

## Output
### Hamlit
```html
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class='bar baz foo'></div>

```

### Haml
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
### Hamlit
```html
<a href='false'></a>
<a href=''></a>

```

### Haml
```html
<a></a>
<a></a>

```

### Faml
```html
<a></a>
<a></a>

```

# old\_attributes\_spec.rb:217
## Input
```haml
%a{title: "'"}
%a{title: "'\""}
%a{href: '/search?foo=bar&hoge=<fuga>'}

```

## Output
### Hamlit
```html
<a title='&#39;'></a>
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Haml
```html
<a title="'"></a>
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml
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
### Hamlit
```html
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Haml
```html
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml
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
### Hamlit
```html
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Haml
```html
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml
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
### Hamlit
```html
<span data-disable>bar</span>

```

### Haml
```html
<span data-disable>bar</span>

```

### Faml
```html
<span data-disable='true'>bar</span>

```
