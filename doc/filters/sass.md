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
### Hamlit
```html
<style>
  .users_controller .show_action {
    margin: 10px;
    padding: 20px; }
</style>

```

### Haml
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
### Hamlit
```html
<style>
  .users_controller .show_action {
    content: "<&>"; }
</style>

```

### Haml
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
