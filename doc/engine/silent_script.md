# [silent\_script\_spec.rb:79](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/silent_script_spec.rb#L79)
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


# [silent\_script\_spec.rb:90](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/silent_script_spec.rb#L90)
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


# [silent\_script\_spec.rb:102](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/silent_script_spec.rb#L102)
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


# [silent\_script\_spec.rb:190](https://github.com/k0kubun/hamlit/blob/master/spec/hamlit/engine/silent_script_spec.rb#L190)
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

