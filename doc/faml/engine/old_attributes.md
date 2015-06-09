# [old\_attributes\_spec.rb:43](/spec/hamlit/engine/old_attributes_spec.rb#L43)
## Input
```haml
%span{ class: '}}}', id: '{}}' } }{

```

## Output
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
.foo{ class: ['bar', nil] }
.foo{ class: ['bar', 'baz'] }

```

## Output
### Faml
```html
<div class='bar foo'></div>
<div class=' bar foo'></div>
<div class='bar baz foo'></div>

```

### Hamlit
```html
<div class='bar foo'></div>
<div class='bar foo'></div>
<div class='bar baz foo'></div>

```


# [old\_attributes\_spec.rb:201](/spec/hamlit/engine/old_attributes_spec.rb#L201)
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
### Faml
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


# [old\_attributes\_spec.rb:273](/spec/hamlit/engine/old_attributes_spec.rb#L273)
## Input
```haml
%span{ data: { disable: true } } bar

```

## Output
### Faml
```html
<span data-disable='true'>bar</span>

```

### Hamlit
```html
<span data-disable>bar</span>

```

