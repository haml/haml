# [tag\_spec.rb:271](/spec/hamlit/engine/tag_spec.rb#L271)
## Input
```haml
%div<
  #{'hello'}
  world

```

## Output
### Haml
```html
<div>helloworld</div>

```

### Faml, Hamlit
```html
<div>hello
world</div>

```


# [tag\_spec.rb:282](/spec/hamlit/engine/tag_spec.rb#L282)
## Input
```haml
.bar<
  - 1.times do
    = '1'
    = '2'

```

## Output
### Haml
```html
<div class='bar'>12</div>

```

### Faml, Hamlit
```html
<div class='bar'>1
2</div>

```

