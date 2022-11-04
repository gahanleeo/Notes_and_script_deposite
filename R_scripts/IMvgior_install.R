# list of install needed

library(IMvigor210CoreBiologies)
library(dplyr)

# load data
data(cds)
# raw count data
raw = as.data.frame((counts(cds)))
raw$entrez_id = row.names(raw)
raw = raw[,c(349,1:348)]
#ID informarion 
ID.inf = as.data.frame((fData(cds)))
ID.inf = ID.inf[,c(1,2)]
# join column
new = dplyr::inner_join(ID.inf,raw,by='entrez_id')
new = new[,-1]

# patient infromatoin
pat.ifo = as.data.frame((pData(cds)))
pat.ifo$patient_ID = row.names(pat.ifo)
pat.ifo= pat.ifo[,c(26,1:25)]


# Need add column of gene name in raw count
# merge raw count to the pat_inf

