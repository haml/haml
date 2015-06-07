# less\_spec.rb:4
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
### Hamlit
```html
<style>
  .users_controller .show_action {
    margin: 10px;
    padding: 20px;
  }
</style>

```

### Haml
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

# less\_spec.rb:23
## Input
```haml
:less
  .foo {
    content: "#{'<&>'}";
  }

```

## Output
### Hamlit
```html
<style>
  .foo {
    content: "<&>";
  }
</style>

```

### Haml
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
