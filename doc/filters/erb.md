# erb\_spec.rb:4
## Input
```haml
:erb
  <% if true %>
  ok
  <% else %>
  ng
  <% end %>

```

## Output
### Hamlit
```html
ok

```

### Haml
```html
ok


```

### Faml
```html
Faml::FilterCompilers::NotFound: Unable to find compiler for erb
```
