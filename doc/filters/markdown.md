# [markdown\_spec.rb:15](/spec/hamlit/filters/markdown_spec.rb#L15)
## Input
```haml
- project = '<Hamlit>'
:markdown
  # #{project}
  #{'<&>'}
  Yet another haml implementation

```

## Output
### Haml
```html
<h1><Hamlit></h1>

<p>&lt;&amp;&gt;
Yet another haml implementation</p>


```

### Faml, Hamlit
```html
<h1><Hamlit></h1>

<p>&lt;&amp;&gt;
Yet another haml implementation</p>

```

