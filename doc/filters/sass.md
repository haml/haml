# sass\_spec.rb:4
## Input
```haml
:sass
  .users_controller
    .show_action
      margin: 10px
      padding: 20px

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


# sass\_spec.rb:20
## Input
```haml
:sass
  .users_controller
    .show_action
      content: "#{'<&>'}"

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

