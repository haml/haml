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


# [text\_spec.rb:99](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L99)
## Input
```haml
&nbsp;
\&nbsp;
!hello
\!hello

```

## Output
### Haml
```html
&nbsp;
&nbsp;
!hello
!hello

```

### Faml, Hamlit
```html
nbsp;
&nbsp;
hello
!hello

```


# [text\_spec.rb:163](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/text_spec.rb#L163)
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

