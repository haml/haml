# markdown\_spec.rb:16
## Input
```haml
- project = '<Hamlit>'
:markdown
  # #{project}
  #{'<&>'}
  Yet another haml implementation

```

## Output
### Hamlit
```html
<h1><Hamlit></h1>

<p>&lt;&amp;&gt;
Yet another haml implementation</p>

```

### Haml
```html
<h1><Hamlit></h1>

<p>&lt;&amp;&gt;
Yet another haml implementation</p>


```

### Faml
```html
<h1><Hamlit></h1>

<p>&lt;&amp;&gt;
Yet another haml implementation</p>

```
