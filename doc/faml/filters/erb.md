# [erb\_spec.rb:3](/spec/hamlit/filters/erb_spec.rb#L3)
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
### Faml
```html
Faml::FilterCompilers::NotFound: Unable to find compiler for erb
```

### Hamlit
```html
ok

```

