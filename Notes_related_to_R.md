# Notes related to R about some useful command/infromation

### related to R plotting margin:
```
par()
```
https://r-charts.com/base-r/margins/



### Regex cheat sheet in R 

https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf


#### Regex ```|``` in R: 

``` | => either or ```

Two regular expressions may be joined by the infix operator ‘⁠|⁠’; the resulting regular expression matches any string matching either subexpression. For example, ‘⁠abba|cde⁠’ matches either the string abba or the string cde. Note that alternation does not work inside character classes, where ‘⁠|⁠’ has its literal meaning.
ex" ```ab|d``` ==> it will match  **ab**c**d**e 
