# multiline\_spec.rb:4
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

