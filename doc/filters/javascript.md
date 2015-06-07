# javascript\_spec.rb:4
## Input
```haml
before
:javascript
after

```

## Output
### Haml
```html
before
<script>
  
</script>
after

```

### Faml
```html
before
after

```

### Hamlit
```html
before
<script>

</script>
after

```


# javascript\_spec.rb:33
## Input
```haml
:javascript
 if {
  alert('hello');
   }
:javascript
   if {
    alert('hello');
     }

```

## Output
### Haml
```html
<script>
  if {
   alert('hello');
    }
</script>
<script>
    if {
     alert('hello');
      }
</script>

```

### Faml, Hamlit
```html
<script>
  if {
   alert('hello');
    }
</script>
<script>
  if {
   alert('hello');
    }
</script>

```

