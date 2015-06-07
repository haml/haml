# [new\_attribute\_spec.rb:20](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/new_attribute_spec.rb#L20)
## Input
```haml
%a(title="'")
%a(title = "'\"")
%a(href='/search?foo=bar&hoge=<fuga>')

```

## Output
### Haml
```html
<a title="'"></a>
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml, Hamlit
```html
<a title='&#39;'></a>
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```


# [new\_attribute\_spec.rb:32](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/new_attribute_spec.rb#L32)
## Input
```haml
- title = "'\""
- href  = '/search?foo=bar&hoge=<fuga>'
%a(title=title)
%a(href=href)

```

## Output
### Haml
```html
<a title='&#x0027;"'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

### Faml, Hamlit
```html
<a title='&#39;&quot;'></a>
<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>

```

