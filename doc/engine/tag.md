# tag\_spec.rb:229
## Input
```haml
%span!#{'<nyaa>'}
%span! #{'<nyaa>'}
!#{'<nyaa>'}
! #{'<nyaa>'}

```

## Output
### Haml
```html
<span><nyaa></span>
<span><nyaa></span>
!&lt;nyaa&gt;
<nyaa>

```

### Faml, Hamlit
```html
<span><nyaa></span>
<span><nyaa></span>
<nyaa>
<nyaa>

```

