# [new\_attribute\_spec.rb:19](/spec/hamlit/engine/new_attribute_spec.rb#L19)
## Input
```haml
%span(a=__LINE__
 b=__LINE__)
= __LINE__

```

## Output
### Haml
```html
<span a='1' b='1'></span>
3

```

### Faml, Hamlit
```html
<span a='1' b='2'></span>
3

```


# [new\_attribute\_spec.rb:47](/spec/hamlit/engine/new_attribute_spec.rb#L47)
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


# [new\_attribute\_spec.rb:59](/spec/hamlit/engine/new_attribute_spec.rb#L59)
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

