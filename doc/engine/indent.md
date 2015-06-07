# indent\_spec.rb:4
## Input
```haml
%p
	%a

```

## Output
### Hamlit
```html
<p>
<a></a>
</p>

```

### Haml
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
