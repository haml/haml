# [less\_spec.rb:3](/spec/hamlit/filters/less_spec.rb#L3)
## Input
```haml
:less
  .users_controller {
    .show_action {
      margin: 10px;
      padding: 20px;
    }
  }

```

## Output
### Haml, Hamlit
```html
<style>
  .users_controller .show_action {
    margin: 10px;
    padding: 20px;
  }
</style>

```

### Faml
```html
Faml::FilterCompilers::NotFound: Unable to find compiler for less
```


# [less\_spec.rb:22](/spec/hamlit/filters/less_spec.rb#L22)
## Input
```haml
:less
  .foo {
    content: "#{'<&>'}";
  }

```

## Output
### Haml, Hamlit
```html
<style>
  .foo {
    content: "<&>";
  }
</style>

```

### Faml
```html
Faml::FilterCompilers::NotFound: Unable to find compiler for less
```

