# [silent\_script\_spec.rb:79](/spec/hamlit/engine/silent_script_spec.rb#L79)
## Input
```haml
%span
  - if false
  - elsif false

```

## Output
### Faml
```html
SyntaxError: (eval):4: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```

### Hamlit
```html
<span>
</span>

```


# [silent\_script\_spec.rb:90](/spec/hamlit/engine/silent_script_spec.rb#L90)
## Input
```haml
%span
  - if false
    ng
  - else

```

## Output
### Faml
```html
SyntaxError: (eval):5: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```

### Hamlit
```html
<span>
</span>

```


# [silent\_script\_spec.rb:102](/spec/hamlit/engine/silent_script_spec.rb#L102)
## Input
```haml
%span
  - case
  - when false

```

## Output
### Faml
```html
SyntaxError: (eval):4: syntax error, unexpected end-of-input, expecting keyword_end
; _buf << ("</span>\n".freeze); _buf = _buf.join
                                                ^
```

### Hamlit
```html
<span>
</span>

```


# [silent\_script\_spec.rb:190](/spec/hamlit/engine/silent_script_spec.rb#L190)
## Input
```haml
- foo = [',  
     ']
= foo
```

## Output
### Faml
```html
[&quot;,\n     &quot;]

```

### Hamlit
```html
[&quot;, &quot;]

```

