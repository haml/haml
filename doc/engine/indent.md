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

