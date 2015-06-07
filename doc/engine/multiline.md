# [multiline\_spec.rb:3](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/multiline_spec.rb#L3)
## Input
```haml
a |
  b |

```

## Output
### Haml, Faml
```html
a b 

```

### Hamlit
```html
a b

```

