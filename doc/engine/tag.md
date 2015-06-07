# [tag\_spec.rb:228](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/tag_spec.rb#L228)
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

