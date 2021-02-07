############ Visualisation ############ 

conversion_nucleotide=function(V){
  V=case_when(
    V==3 ~ "G", 
    V==2 ~ "C",
    V==1 ~ "U",
    V==0 ~ "A")
}

#data_filtered[data_filtered$Covariable=="nucléotide",noms]=apply(data_filtered[data_filtered$Covariable=="nucléotide",noms],FUN = conversion_nucleotide,MARGIN = 2)

extraction_vect=function(df,clef){
  tamp=(df[df[,2]==clef,])
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


############ Modèles simples ############ 


train_test_split=function(data,proportion=0.8){
  N=dim(data)[1]
  idx=sample.int(N/68)
  nb_individu_prop=floor(N/68*proportion)
  
  res=rep(0,nb_individu_prop*68)
  for (i in 1:floor(nb_individu_prop)){
    res[((i-1)*68+1):(i*68)]=seq((idx[i]*68+1),(idx[i]*68)+68)
  }
  train=data[res,]
  val=data[-res,]
  return(list("train"=train,"val"=val))
  
}