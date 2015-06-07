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
