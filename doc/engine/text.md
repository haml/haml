# text\_spec.rb:16
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


# text\_spec.rb:75
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


# text\_spec.rb:94
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


# text\_spec.rb:103
## Input
```haml
:plain
  あ
  #{'い'}
```

## Output
### Haml, Hamlit
```html
あ
い


```

### Faml
```html
あ
い

```

