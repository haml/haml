# multiline\_spec.rb:4
## Input
```haml
a |
  b |

```

## Output
### Hamlit
```html
a b

```

### Haml
```html
a b 

```

### Faml
```html
a b 

```
