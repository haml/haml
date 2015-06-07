# [text\_spec.rb:15](/spec/hamlit/engine/text_spec.rb#L15)
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


# [text\_spec.rb:99](/spec/hamlit/engine/text_spec.rb#L99)
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

