# [coffee\_spec.rb:3](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/coffee_spec.rb#L3)
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


# [coffee\_spec.rb:22](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/coffee_spec.rb#L22)
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


# [coffee\_spec.rb:41](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/filters/coffee_spec.rb#L41)
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

