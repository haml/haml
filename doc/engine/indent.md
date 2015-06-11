# [indent\_spec.rb:3](/spec/hamlit/engine/indent_spec.rb#L3)
## Input
```haml
%p
	%a

```

## Output
### Haml, Hamlit
```html
<p>
<a></a>
</p>

```

### Faml
```html
<p></p>
%a

```


# [indent\_spec.rb:28](/spec/hamlit/engine/indent_spec.rb#L28)
## Input
```haml
%p
	%span
		foo

```

## Output
### Haml, Hamlit
```html
<p>
<span>
foo
</span>
</p>

```

### Faml
```html
<p></p>
%span
foo

```

