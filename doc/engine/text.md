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


# [text\_spec.rb:113](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L113)
## Input
```haml
%span!#{'<nyaa>'}
%span! #{'<nyaa>'}
!#{'<nyaa>'}
! #{'<nyaa>'}

```

## Output
### Haml
```html
<span><nyaa></span>
<span><nyaa></span>
!&lt;nyaa&gt;
<nyaa>

```

### Faml, Hamlit
```html
<span><nyaa></span>
<span><nyaa></span>
<nyaa>
<nyaa>

```


# [text\_spec.rb:139](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L139)
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

