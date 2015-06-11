# [indent\_spec.rb:3](/spec/hamlit/engine/indent_spec.rb#L3)
## Input
```haml
%p
	%a

```

## Output
### Faml
```html
<p></p>
%a

```

### Hamlit
```html
<p>
<a></a>
</p>

```


# [indent\_spec.rb:28](/spec/hamlit/engine/indent_spec.rb#L28)
## Input
```haml
%p
	%span
		foo

```

## Output
### Faml
```html
<p></p>
%span
foo

```

### Hamlit
```html
<p>
<span>
foo
</span>
</p>

```

