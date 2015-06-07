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

