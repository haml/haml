# new\_attribute\_spec.rb:21
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


# new\_attribute\_spec.rb:33
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

