# [new\_attribute\_spec.rb:19](/spec/hamlit/engine/new_attribute_spec.rb#L19)
## Input
```haml
%span(a=__LINE__
 b=__LINE__)
= __LINE__

```

## Output
### Haml
```html
<span a='1' b='1'></span>
3

```

### Faml, Hamlit
```html
<span a='1' b='2'></span>
3

```

