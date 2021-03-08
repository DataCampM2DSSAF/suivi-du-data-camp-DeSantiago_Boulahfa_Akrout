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

## Séparation train/test
train_test_split=function(data,proportion=0.8){
  N=dim(data)[1]
  idx=sample.int(N/68)
  nb_individu_prop=floor(N/68*proportion)
  
  res=rep(0,nb_individu_prop*68)
  for (i in 1:nb_individu_prop){
    res[((i-1)*68+1):(i*68)]=seq( ((idx[i]-1)*68+1) , (idx[i]*68) )
  }
  train=data[res,]
  val=data[-res,]
  return(list("train"=train,"val"=val, index_train = res))
  
}

## Elastic-net choix du alpha (avec calcul parallèle)
alpha_opti_enet_parallel <- function(data_train, data_val,
                                     y_true_train, y_true_val,
                                     liste_alpha = seq(0, 1, 0.1),
                                     cores = detectCores() - 1)
{
  registerDoParallel(cores = cores)
  
  # Initialisation
  errors_recherche_alpha = NaN
  
  # Prédictions et calculs d'erreurs
  for(alpha in liste_alpha)
  {
    print(alpha)
    model_pen_Elast = cv.glmnet(data_train, y_true_train,
                                type.measure = "mse",
                                alpha = alpha,
                                parallel = TRUE)
    
    y_pred_train = predict(model_pen_Elast,data_train,type="response",s="lambda.min")
    y_pred_val = predict(model_pen_Elast,data_val,type="response",s="lambda.min")
    
    MSE_train = mean((y_pred_train-y_true_train)^2,na.rm=TRUE)
    MSE_val = mean((y_pred_val-y_true_val)^2,na.rm=TRUE)
    
    errors_recherche_alpha = rbind(errors_recherche_alpha, c(alpha, MSE_train, MSE_val))
  }
  
  colnames(errors_recherche_alpha) = c("alpha", "MSE_train", "MSE_val")
  errors_recherche_alpha = unnest(data.frame(errors_recherche_alpha[-1,]),
                                  cols = c(alpha, MSE_train, MSE_val))
  
  # alpha optimal = celui qui minimise le MSE sur la validation
  indice_alpha_opti = as.double(apply(errors_recherche_alpha[, 3], 2, which.min))
  alpha_opti = errors_recherche_alpha$alpha[indice_alpha_opti]
  
  return(alpha_opti)
}

## Elastic-net choix du alpha (sans calcul parallèle)
alpha_opti_enet <- function(data_train, data_val,
                            y_true_train, y_true_val,
                            liste_alpha = seq(0, 1, 0.1))
{

  # Initialisation
  errors_recherche_alpha = NaN
  
  # Prédictions et calculs d'erreurs
  for(alpha in liste_alpha)
  {
    print(alpha)
    model_pen_Elast = cv.glmnet(data_train, y_true_train,
                                type.measure = "mse",
                                alpha = alpha)
    
    y_pred_train = predict(model_pen_Elast,data_train,type="response",s="lambda.min")
    y_pred_val = predict(model_pen_Elast,data_val,type="response",s="lambda.min")
    
    MSE_train = mean((y_pred_train-y_true_train)^2,na.rm=TRUE)
    MSE_val = mean((y_pred_val-y_true_val)^2,na.rm=TRUE)
    
    errors_recherche_alpha = rbind(errors_recherche_alpha, c(alpha, MSE_train, MSE_val))
  }
  
  colnames(errors_recherche_alpha) = c("alpha", "MSE_train", "MSE_val")
  errors_recherche_alpha = unnest(data.frame(errors_recherche_alpha[-1,]),
                                  cols = c(alpha, MSE_train, MSE_val))
  
  # alpha optimal = celui qui minimise le MSE sur la validation
  indice_alpha_opti = as.double(apply(errors_recherche_alpha[, 3], 2, which.min))
  alpha_opti = errors_recherche_alpha$alpha[indice_alpha_opti]
  
  return(alpha_opti)
}