# text\_spec.rb:16
## Input
```haml
.
.*
#
#+

```

## Output
### Hamlit
```html
.
.*
#
#+

```

### Haml
```html
Illegal element: classes and ids must have values.
```

### Faml
```html
<div></div>
<div>*</div>
<div></div>
<div>+</div>

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
### Hamlit
```html
aaa&lt;a&gt;
aaa<a>
aaa<a>
aaa<a>
!aa

```

### Haml
```html
aaa&lt;a&gt;
!aaa&lt;a&gt;
aaa<a>
aaa<a>
!!aa

```

### Faml
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
### Hamlit
```html
1#{2

```

### Haml
```html
Unbalanced brackets.
```

### Faml
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
### Hamlit
```html
あ
い


```

### Haml
```html
あ
い


```

### Faml
```html
あ
い

```
