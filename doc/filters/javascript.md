# [javascript\_spec.rb:3](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/javascript_spec.rb#L3)
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


# [javascript\_spec.rb:32](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/javascript_spec.rb#L32)
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

