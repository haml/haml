# coffee\_spec.rb:4
## Input
```haml
:coffee
  foo = ->
    alert('hello')

```

## Output
### Haml, Hamlit
```html
<script>
  (function() {
    var foo;
  
    foo = function() {
      return alert('hello');
    };
  
  }).call(this);
</script>

```

### Faml
```html
<script>
(function() {
  var foo;

  foo = function() {
    return alert('hello');
  };

}).call(this);

</script>

```


# coffee\_spec.rb:23
## Input
```haml
:coffee
  foo = ->
    alert('hello')

```

## Output
### Haml, Hamlit
```html
<script>
  (function() {
    var foo;
  
    foo = function() {
      return alert('hello');
    };
  
  }).call(this);
</script>

```

### Faml
```html
<script>
(function() {
  var foo;

  foo = function() {
    return alert('hello');
  };

}).call(this);

</script>

```


# coffee\_spec.rb:42
## Input
```haml
:coffee
  foo = ->
    alert("#{'<&>'}")

```

## Output
### Haml, Hamlit
```html
<script>
  (function() {
    var foo;
  
    foo = function() {
      return alert("<&>");
    };
  
  }).call(this);
</script>

```

### Faml
```html
<script>
(function() {
  var foo;

  foo = function() {
    return alert("<&>");
  };

}).call(this);

</script>

```

