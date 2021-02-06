conversion_nucleotide=function(V){
  V=case_when(
    V==3 ~ "G", 
    V==2 ~ "C",
    V==1 ~ "U",
    V==0 ~ "A")
}

#data_filtered[data_filtered$Covariable=="nucléotide",noms]=apply(data_filtered[data_filtered$Covariable=="nucléotide",noms],FUN = conversion_nucleotide,MARGIN = 2)

extraction_vect=function(clef){
  tamp=(data_filtered[data_filtered[,2]==clef,])
  tamp= tamp %>% dplyr::select(-c(Position, Covariable))
  m = as.matrix(tamp)
  res = c()
  for (i in seq(1:nrow(m))){
    res = c(res, m[i,])
  }
  names(res)=NULL
  return(res)
}
# Permet de récupérer toutes les valeurs 
# pour tout le monde et toutes les nucléotides de ce que l'on souhaite.
# Ex: La liste de tous les nucléotides.