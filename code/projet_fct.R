conversion_nucleotide=function(V){
  V=case_when(
    V==3 ~ "G", 
    V==2 ~ "C",
    V==1 ~ "U",
    V==0 ~ "A")
}

#data_filtered[data_filtered$Covariable=="nucléotide",noms]=apply(data_filtered[data_filtered$Covariable=="nucléotide",noms],FUN = conversion_nucleotide,MARGIN = 2)