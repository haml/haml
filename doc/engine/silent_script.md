# silent\_script\_spec.rb:80
## Input
```haml
%span
  - if false
  - elsif false

```

## Output
### Haml, Hamlit
```html
<span>
</span>

```

### Faml
```html
SyntaxError: (eval):4: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```


# silent\_script\_spec.rb:91
## Input
```haml
%span
  - if false
    ng
  - else

```

## Output
### Haml, Hamlit
```html
<span>
</span>

```

### Faml
```html
SyntaxError: (eval):5: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```


# silent\_script\_spec.rb:103
## Input
```haml
%span
  - case
  - when false

```

## Output
### Haml, Hamlit
```html
<span>
</span>

```

### Faml
```html
SyntaxError: (eval):4: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```


# silent\_script\_spec.rb:191
## Input
```haml
- foo = [',  
     ']
= foo
```

## Output
### Haml, Hamlit
```html
[&quot;, &quot;]

```

### Faml
```html
[&quot;,\n     &quot;]

```

