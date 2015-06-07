# scss\_spec.rb:4
## Input
```haml
:scss
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
    padding: 20px; }
</style>

```

### Faml
```html
<style>
.users_controller .show_action {
  margin: 10px;
  padding: 20px; }

</style>

```


# scss\_spec.rb:22
## Input
```haml
:scss
  .users_controller {
    .show_action {
      content: "#{'<&>'}";
    }
  }

```

## Output
### Haml, Hamlit
```html
<style>
  .users_controller .show_action {
    content: "<&>"; }
</style>

```

### Faml
```html
<style>
.users_controller .show_action {
  content: "<&>"; }

</style>

```

