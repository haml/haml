# [text\_spec.rb:15](/spec/hamlit/engine/text_spec.rb#L15)
## Input
```haml
.
.*
..
#
#+
##

```

## Output
### Faml
```html
<div></div>
<div>*</div>
<div></div>
<div></div>
<div>+</div>
<div></div>

```

### Hamlit
```html
.
.*
..
#
#+
##

```


# [text\_spec.rb:118](/spec/hamlit/engine/text_spec.rb#L118)
## Input
```haml
&nbsp;
\&nbsp;
!hello
\!hello

```

## Output
### Faml
```html
nbsp;
&nbsp;
hello
!hello

```

### Hamlit
```html
&nbsp;
&nbsp;
!hello
!hello

```

