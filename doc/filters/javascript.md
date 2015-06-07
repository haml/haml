# javascript\_spec.rb:4
## Input
```haml
before
:javascript
after

```

## Output
### Hamlit
```html
before
<script>

</script>
after

```

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
### Hamlit
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

### Faml
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
