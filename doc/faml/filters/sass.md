# [sass\_spec.rb:3](/spec/hamlit/filters/sass_spec.rb#L3)
## Input
```haml
:sass
  .users_controller
    .show_action
      margin: 10px
      padding: 20px

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


# [sass\_spec.rb:19](/spec/hamlit/filters/sass_spec.rb#L19)
## Input
```haml
:sass
  .users_controller
    .show_action
      content: "#{'<&>'}"

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

