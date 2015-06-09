# [coffee\_spec.rb:3](/spec/hamlit/filters/coffee_spec.rb#L3)
## Input
```haml
:coffee
  foo = ->
    alert('hello')

```

## Output
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

### Hamlit
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


# [coffee\_spec.rb:22](/spec/hamlit/filters/coffee_spec.rb#L22)
## Input
```haml
:coffee
  foo = ->
    alert('hello')

```

## Output
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

### Hamlit
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


# [coffee\_spec.rb:41](/spec/hamlit/filters/coffee_spec.rb#L41)
## Input
```haml
:coffee
  foo = ->
    alert("#{'<&>'}")

```

## Output
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

### Hamlit
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

