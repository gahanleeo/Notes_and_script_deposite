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

another example

```
# add column `pos` for x axis plotting and a color code by chromosome
df <- df %>% 
  mutate(pos=seq_along(start)) %>% 
  mutate(chrcolor=if_else(as.numeric(chrom) %% 2 == 0, '#115387','#2F69BE'))

```
