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
Faml::IndentTracker::HardTabNotAllowed: Indentation with hard tabs are not allowed :-p
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
Faml::IndentTracker::HardTabNotAllowed: Indentation with hard tabs are not allowed :-p
```

