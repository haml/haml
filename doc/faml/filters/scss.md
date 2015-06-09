# [scss\_spec.rb:3](/spec/hamlit/filters/scss_spec.rb#L3)
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
### Faml
```html
<style>
.users_controller .show_action {
  margin: 10px;
  padding: 20px; }

</style>

```

### Hamlit
```html
<style>
  .users_controller .show_action {
    margin: 10px;
    padding: 20px; }
</style>

```


# [scss\_spec.rb:21](/spec/hamlit/filters/scss_spec.rb#L21)
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
### Faml
```html
<style>
.users_controller .show_action {
  content: "<&>"; }

</style>

```

### Hamlit
```html
<style>
  .users_controller .show_action {
    content: "<&>"; }
</style>

```

