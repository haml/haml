# script\_spec.rb:42
## Input
```haml
= 3.times do |i|
  = i
4

```

## Output
### Hamlit
```html
0
1
2
3
4

```

### Haml
```html
0
1
2
34

```

### Faml
```html
0
1
2
34

```

# script\_spec.rb:56
## Input
```haml
%span
  = 1.times do |i|
    = i

```

## Output
### Hamlit
```html
<span>
0
1
</span>

```

### Haml
```html
<span>
0
1</span>

```

### Faml
```html
<span>
0
1</span>

```

# script\_spec.rb:88
## Input
```haml
!= '<"&>'
!= '<"&>'.tap do |str|
  -# no operation

```

## Output
### Hamlit
```html
<"&>
<"&>

```

### Haml
```html
<"&>
<"&>
```

### Faml
```html
<"&>
<"&>
```

# script\_spec.rb:99
## Input
```haml
&= '<"&>'
&= '<"&>'.tap do |str|
  -# no operation

```

## Output
### Hamlit
```html
&lt;&quot;&amp;&gt;
&lt;&quot;&amp;&gt;

```

### Haml
```html
&lt;&quot;&amp;&gt;
&lt;&quot;&amp;&gt;
```

### Faml
```html
&lt;&quot;&amp;&gt;
&lt;&quot;&amp;&gt;
```
