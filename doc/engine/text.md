# [text\_spec.rb:15](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L15)
## Input
```haml
.
.*
#
#+

```

## Output
### Haml
```html
Haml::SyntaxError: Illegal element: classes and ids must have values.
```

### Faml
```html
<div></div>
<div>*</div>
<div></div>
<div>+</div>

```

### Hamlit
```html
.
.*
#
#+

```


# [text\_spec.rb:74](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L74)
## Input
```haml
aaa#{'<a>'}
!aaa#{'<a>'}
! aaa#{'<a>'}
!  aaa#{'<a>'}
!!aa

```

## Output
### Haml
```html
aaa&lt;a&gt;
!aaa&lt;a&gt;
aaa<a>
aaa<a>
!!aa

```

### Faml, Hamlit
```html
aaa&lt;a&gt;
aaa<a>
aaa<a>
aaa<a>
!aa

```


# [text\_spec.rb:93](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L93)
## Input
```haml
1#{2
```

## Output
### Haml
```html
Haml::SyntaxError: Unbalanced brackets.
```

### Faml
```html
Faml::TextCompiler::InvalidInterpolation: 1#{2
```

### Hamlit
```html
1#{2

```

