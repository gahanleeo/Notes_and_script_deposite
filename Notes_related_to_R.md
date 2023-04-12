# Notes related to R about some useful command/infromation

### related to R plotting margin:
```
par()
```
https://r-charts.com/base-r/margins/

- save image in R 
  
    https://stackoverflow.com/questions/7144118/how-to-save-a-plot-as-image-on-the-disk

- plot and output pdf files, keywords: ```pdf()``` and ```dev.off()``` at the end of script
  
    https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html


### Regex cheat sheet in R 

https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf


- Regex ```|``` in R: 

``` | => either or ```

Two regular expressions may be joined by the infix operator ‘⁠|⁠’; the resulting regular expression matches any string matching either subexpression. For example, ‘⁠abba|cde⁠’ matches either the string abba or the string cde. Note that alternation does not work inside character classes, where ‘⁠|⁠’ has its literal meaning.
ex" ```ab|d``` ==> it will match  **ab**c**d**e 


### How to remove “NA” value in data frame? 

https://stackoverflow.com/questions/4862178/remove-rows-with-all-or-some-nas-missing-values-in-data-frame



### if else loop, if ( statement  == TRUE) {excuse this} else {if is FALSE, excuse this}


- if else loop example of how to play with data
```
for(i in 1:nrow(df)){
  if(df[i,17] %in% tar){
    df$fusionid[i] = 'fg3_fusion'}
  else{df$fusionid[i] = 'no_fusion'}
}
```

- example to add column using if else loop 
use ```ifelse()``` function is powerful

```data$newvar <- ifelse(data$x==1, 'control', 'experiment')```



### How to create a data frame and append certain row into that data frame. Important takeaway:

 ***assign the empty data frame need to be OUTSIDE of the the loop


### How to deal when X and dots added to column names when creating a data.frame (duplicate columns)

When you create a data.frame, by default it has the option check.names = TRUE. This mean R will check the names provided are syntactically valid names, and using X ``` check.names =  FALSE,``` but hard to use data...

### order() function to sort multiple column :

https://chartio.com/resources/tutorials/how-to-sort-a-data-frame-by-multiple-columns-in-r/

- Reorder rows using custom order:

https://stackoverflow.com/questions/11977102/order-data-frame-rows-according-to-vector-with-specific-order/11977256#11977256


### very detailed ggplot2:

https://ggplot2.tidyverse.org/reference/geom_bar.html

- the ```position_dodge2()``` is cancel the default stacking in the gemo_barplot


### extract specific columns from a data frame

https://stackoverflow.com/questions/10085806/extracting-specific-columns-from-a-data-frame

```T1 = select(f1,hgnc_symbol,target)```


### how to select row from multiple duplication dataset 

Use the function``` distinct()```
```
library(dplyr)

f3 = f2 %>% distinct(Isolate, .keep_all = TRUE)
```
- Remove data in memory 
```
rm()
```

### How to extracting information related to a list of gene names from a file, this is ***super*** useful

use ```%in``` and ``` which ``` 

```Selection<-file1[file1$"Gene name" %in% file2$"Gene Name",]```

```f.set <- f.straglr[ which(f.straglr$read %in% f$read), ]```

 
- for loop in R using a list of strings as variables - with and without quotes


- use double \\ to escape “()” sign in R 
```
pp.uniq$gp = gsub("\\([0-9]+\\)","",pp.uniq$genotype)
```
### Create column based on presence of string pattern and ifelse

``` grepl() ```

```
if (grepl('SRR.*',ff$read_id[i])){ ...} 
```

https://stackoverflow.com/questions/25372082/create-column-based-on-presence-of-string-pattern-and-ifelse




### Reshaping dataset when have same row/column!!!
https://mgimond.github.io/ES218/Week03b.html

The link probably down...

but the reshape2 lib in R is also useful:

https://seananderson.ca/2013/10/19/reshape/

long to wide dataset: 
```dcast(aql, month ~ variable)```

------

### the assign() function

useful when need to create multiple objects in R

assign() function can use as assign the data frame to a new object with the name obtained in gsub() output, which is 'chr5'

the code simplify: assign('chr5',read.csv(GenomeWideSNP_6.na35.annot_13032018_Chr5.csv))

```
for (i in 1:length(ls_files)) assign(gsub("*.*GenomeWideSNP_6.na35.annot_13032018_|.csv", "", ls_files[i]), read.csv(ls_files[i]))
```
once done, there's a dataframe called ```chr5``` in your R global environment




