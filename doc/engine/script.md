# [script\_spec.rb:41](/spec/hamlit/engine/script_spec.rb#L41)
## Input
```haml
= 3.times do |i|
  = i
4

```

## Output
### Haml, Faml
```html
0
1
2
34

```

### Hamlit
```html
0
1
2
3
4

```


# [script\_spec.rb:55](/spec/hamlit/engine/script_spec.rb#L55)
## Input
```haml
%span
  = 1.times do |i|
    = i

```

## Output
### Haml, Faml
```html
<span>
0
1</span>

```

### Hamlit
```html
<span>
0
1
</span>

```


# [script\_spec.rb:87](/spec/hamlit/engine/script_spec.rb#L87)
## Input
```haml
!= '<"&>'
!= '<"&>'.tap do |str|
  -# no operation

```

## Output
### Haml, Faml
```html
<"&>
<"&>
```

### Hamlit
```html
<"&>
<"&>

```


# [script\_spec.rb:98](/spec/hamlit/engine/script_spec.rb#L98)
## Input
```haml
&= '<"&>'
&= '<"&>'.tap do |str|
  -# no operation

```

## Output
### Haml, Faml
```html
&lt;&quot;&amp;&gt;
&lt;&quot;&amp;&gt;
```

### Hamlit
```html
&lt;&quot;&amp;&gt;
&lt;&quot;&amp;&gt;

```

