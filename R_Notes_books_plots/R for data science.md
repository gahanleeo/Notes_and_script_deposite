- [R for data science, has detailed functions data loading sorting](https://r4ds.had.co.nz/index.html)
- https://socviz.co/index.html#what-you-will-learn
---
- # Mutate()
	add column to the dataset, ex:
```
# add column `pos` for x axis plotting and a color code by chromosome
df <- df %>% 
  mutate(pos=seq_along(start)) %>% 
  mutate(chrcolor=if_else(as.numeric(chrom) %% 2 == 0, '#115387','#2F69BE'))

```

---

## How to deal with duplicate value

https://www.datanovia.com/en/lessons/identify-and-remove-duplicate-data-in-r/


```
library(dplyr)

# find dup in data based on sepcific column
my_data[duplicated(my_data$Sepal.Width), ]

# remove dup
nodup <- my_data[!duplicated(my_data$Sample.ID),]

```

