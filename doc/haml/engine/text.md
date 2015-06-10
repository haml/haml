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
### Haml
```html
Haml::SyntaxError: Illegal element: classes and ids must have values.
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

