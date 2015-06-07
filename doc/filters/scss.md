# [scss\_spec.rb:3](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/scss_spec.rb#L3)
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


# [scss\_spec.rb:21](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/scss_spec.rb#L21)
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

