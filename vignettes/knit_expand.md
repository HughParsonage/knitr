<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Templating with knit_expand()}
-->

# Demos of `knit_expand()`

A few simple examples:


```r
library(knitr)
knit_expand(text = 'The value of pi is {{pi}}.')
```

```
## [1] "The value of pi is 3.14159265358979"
```

```r
knit_expand(text = 'The value of a is {{a}}, so a + 1 is {{a+1}}.', a = rnorm(1))
```

```
## [1] "The value of a is -0.835066779925572, so a + 1 is 0.164933220074428"
```

```r
knit_expand(text = 'The area of a circle with radius {{r}} is {{pi*r^2}}', r = 5)
```

```
## [1] "The area of a circle with radius 5 is 78.5398163397448"
```

Any number of variables:


```r
knit_expand(text = 'a is {{a}} and b is {{b}}, with my own pi being {{pi}} instead of {{base::pi}}', a=1, b=2, pi=3)
```

```
## [1] "a is 1 and b is 2, with my own pi being 3 instead of 3.14159265358979"
```

Custom delimiter `<% %>`:


```r
knit_expand(text = 'I do not like curly braces, so use % with <> instead: a is <% a %>.', a = 8, delim = c("<%", "%>"))
```

```
## [1] "I do not like curly braces, so use % with <> instead: a is 8"
```

The pyexpander delimiter:


```r
knit_expand(text = 'hello $(LETTERS[24]) and $(pi)!', delim = c("$(", ")"))
```

```
## [1] "hello X and 3.14159265358979"
```

Arbitrary R code:


```r
knit_expand(text = 'you cannot see the value of x {{x=rnorm(1)}}but it is indeed created: x = {{x}}')
```

```
## [1] "you cannot see the value of x but it is indeed created: x = -0.214868842264195"
```

```r
res = knit_expand(text = c(' x | x^2', '{{x=1:5;paste(sprintf("%2d | %3d", x, x^2), collapse = "\n")}}'))
cat(res)
```

```
##  x | x^2
##  1 |   1
##  2 |   4
##  3 |   9
##  4 |  16
##  5 |  25
```

The m4 example: <http://en.wikipedia.org/wiki/M4_(computer_language)>


```r
res = knit_expand(text = c('{{i=0;h2=function(x){i<<-i+1;sprintf("<h2>%d. %s</h2>", i, x)} }}<html>',
'{{h2("First Section")}}', '{{h2("Second Section")}}', '{{h2("Conclusion")}}', '</html>'))
cat(res)
```

```
## <html>
## <h2>1. First Section</h2>
## <h2>2. Second Section</h2>
## <h2>3. Conclusion</h2>
## </html>
```

Build regression models based on a template; loop through all variables in `mtcars`:


```r
src = lapply(names(mtcars)[-1], function(i) {
knit_expand(text=c("# Regression on {{i}}", '```{r lm-{{i}}}', 'lm(mpg~{{i}}, data=mtcars)', '```'))
})
# knit the source
res = knit_child(text = unlist(src))
res = paste('<pre><code>', gsub('^\\s*|\\s*$', '', res), '</code></pre>', sep = '')
```
<pre><code># Regression on cyl

```r
lm(mpg~cyl, data=mtcars)
```

```
## 
## Call:
## lm(formula = mpg ~ cyl, data = mtcars)
## 
## Coefficients:
## (Intercept)          cyl  
##      37.885       -2.876
```
# Regression on disp}

```r
lm(mpg~disp}, data=mtcars)
```

```
## Error: <text>:1:12: unexpected '}'
## 1: lm(mpg~disp}
##                ^
```
# Regression on hp

```r
lm(mpg~hp, data=mtcars)
```

```
## 
## Call:
## lm(formula = mpg ~ hp, data = mtcars)
## 
## Coefficients:
## (Intercept)           hp  
##    30.09886     -0.06823
```
# Regression on drat}

```r
lm(mpg~drat}, data=mtcars)
```

```
## Error: <text>:1:12: unexpected '}'
## 1: lm(mpg~drat}
##                ^
```
# Regression on wt

```r
lm(mpg~wt, data=mtcars)
```

```
## 
## Call:
## lm(formula = mpg ~ wt, data = mtcars)
## 
## Coefficients:
## (Intercept)           wt  
##      37.285       -5.344
```
# Regression on qsec}

```r
lm(mpg~qsec}, data=mtcars)
```

```
## Error: <text>:1:12: unexpected '}'
## 1: lm(mpg~qsec}
##                ^
```
# Regression on vs

```r
lm(mpg~vs, data=mtcars)
```

```
## 
## Call:
## lm(formula = mpg ~ vs, data = mtcars)
## 
## Coefficients:
## (Intercept)           vs  
##       16.62         7.94
```
# Regression on am

```r
lm(mpg~am, data=mtcars)
```

```
## 
## Call:
## lm(formula = mpg ~ am, data = mtcars)
## 
## Coefficients:
## (Intercept)           am  
##      17.147        7.245
```
# Regression on gear}

```r
lm(mpg~gear}, data=mtcars)
```

```
## Error: <text>:1:12: unexpected '}'
## 1: lm(mpg~gear}
##                ^
```
# Regression on carb}

```r
lm(mpg~carb}, data=mtcars)
```

```
## Error: <text>:1:12: unexpected '}'
## 1: lm(mpg~carb}
##                ^
```</code></pre>
