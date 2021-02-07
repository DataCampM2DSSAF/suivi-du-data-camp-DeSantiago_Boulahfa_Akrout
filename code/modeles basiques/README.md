Chargement des librairies et des données.
-----------------------------------------

    library(ggplot2)
    library(tidyverse)

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ tibble  3.0.4     ✓ dplyr   1.0.2
    ## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
    ## ✓ readr   1.4.0     ✓ forcats 0.5.0
    ## ✓ purrr   0.3.4

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

    source("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/projet_fct.R")

    data = read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_train.csv")
    head(data)

    ##   X             id sequence index_sequence structure predicted_loop_type
    ## 1 0 id_001f94081_1        G              1         .                   E
    ## 2 1 id_001f94081_2        G              2         .                   E
    ## 3 2 id_001f94081_3        A              3         .                   E
    ## 4 3 id_001f94081_4        A              4         .                   E
    ## 5 4 id_001f94081_5        A              5         .                   E
    ## 6 5 id_001f94081_6        A              6         (                   S
    ##   signal_to_noise SN_filter reactivity deg_Mg_pH10 deg_pH10 deg_Mg_50C deg_50C
    ## 1           6.894         1     0.3297      0.7556   2.3375     0.3581  0.6382
    ## 2           6.894         1     1.5693      2.9830   3.5060     2.9683  3.4773
    ## 3           6.894         1     1.1227      0.2526   0.3008     0.2589  0.9988
    ## 4           6.894         1     0.8686      1.3789   1.0108     1.4552  1.3228
    ## 5           6.894         1     0.7217      0.6376   0.2635     0.7244  0.7877
    ## 6           6.894         1     0.4384      0.3313   0.3403     0.4971  0.5890

    data=data[,-1]
    head(data)

    ##               id sequence index_sequence structure predicted_loop_type
    ## 1 id_001f94081_1        G              1         .                   E
    ## 2 id_001f94081_2        G              2         .                   E
    ## 3 id_001f94081_3        A              3         .                   E
    ## 4 id_001f94081_4        A              4         .                   E
    ## 5 id_001f94081_5        A              5         .                   E
    ## 6 id_001f94081_6        A              6         (                   S
    ##   signal_to_noise SN_filter reactivity deg_Mg_pH10 deg_pH10 deg_Mg_50C deg_50C
    ## 1           6.894         1     0.3297      0.7556   2.3375     0.3581  0.6382
    ## 2           6.894         1     1.5693      2.9830   3.5060     2.9683  3.4773
    ## 3           6.894         1     1.1227      0.2526   0.3008     0.2589  0.9988
    ## 4           6.894         1     0.8686      1.3789   1.0108     1.4552  1.3228
    ## 5           6.894         1     0.7217      0.6376   0.2635     0.7244  0.7877
    ## 6           6.894         1     0.4384      0.3313   0.3403     0.4971  0.5890

    data=data %>% mutate(sequence = as.factor(sequence)) %>% 
      #mutate(index_sequence = as.factor(index_sequence)) %>% 
      mutate(sequence = as.factor(sequence)) %>% 
      mutate(structure = as.factor(structure)) %>% 
      mutate(predicted_loop_type = as.factor(predicted_loop_type))

On filtre maintenant les données qui ont SN\_filter=0 :

    print(sum(is.na(data)))

    ## [1] 0

    print(sum(data$SN_filter==0)/68) ## Nombre d'individus dont le SN_filter=0

    ## [1] 811

    data=data[data$SN_filter==1,]
    rownames(data)=NULL#1:108052

    sum(data[,8:12]<0)

    ## [1] 9918

    for (i in 8:12){
      data[which(data[,i]<0),i]=0
    } 
    sum(data[,8:12]<0)

    ## [1] 0

Création de la base train/validation :
--------------------------------------

    tamp=train_test_split(data)
    data_train=tamp$train
    data_val=tamp$val

    sum(is.na(data_train))

    ## [1] 0

    sum(is.na(data_val))

    ## [1] 0

    dim(data_train)[1]+dim(data_val)[1]-dim(data)[1]

    ## [1] 0

    rm(tamp,data)

Modèles simples :
-----------------

    M=mean(data_train$reactivity,na.rm = TRUE)
    S=var(data_train$reactivity,na.rm = TRUE)
    print(M)

    ## [1] 0.3808293

    print(S)

    ## [1] 0.2052291

    ks.test(data_train$reactivity,"pexp",1/M)

    ## Warning in ks.test(data_train$reactivity, "pexp", 1/M): ties should not be
    ## present for the Kolmogorov-Smirnov test

    ## 
    ##  One-sample Kolmogorov-Smirnov test
    ## 
    ## data:  data_train$reactivity
    ## D = 0.11438, p-value < 2.2e-16
    ## alternative hypothesis: two-sided

    alpha_LoiGamma=(M^2)/(S-M^2)
    beta_LoiGamma=(S-M^2)/M
    ks.test(data_train$reactivity,"pgamma",alpha_LoiGamma,beta_LoiGamma)

    ## Warning in ks.test(data_train$reactivity, "pgamma", alpha_LoiGamma,
    ## beta_LoiGamma): ties should not be present for the Kolmogorov-Smirnov test

    ## 
    ##  One-sample Kolmogorov-Smirnov test
    ## 
    ## data:  data_train$reactivity
    ## D = 0.97349, p-value < 2.2e-16
    ## alternative hypothesis: two-sided

### GLM : loi Gamma

    model=glm(reactivity+1e-12~sequence,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence, family = Gamma, 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2104  -1.3272  -0.4435   0.3694   6.6006  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.88874    0.01291  146.34   <2e-16 ***
    ## sequenceC    4.84865    0.06219   77.96   <2e-16 ***
    ## sequenceG    0.72955    0.02368   30.81   <2e-16 ***
    ## sequenceU    1.00427    0.03167   31.71   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.415217)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 397553  on 86424  degrees of freedom
    ## AIC: -150215
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 12.03907

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 11.8369

    model=glm(reactivity+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + index_sequence, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2727  -1.2994  -0.4063   0.3710   6.2324  
    ## 
    ## Coefficients:
    ##                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    1.085950   0.016208   67.00   <2e-16 ***
    ## sequenceC      4.603734   0.060383   76.24   <2e-16 ***
    ## sequenceG      0.703576   0.022296   31.56   <2e-16 ***
    ## sequenceU      0.835956   0.030369   27.53   <2e-16 ***
    ## index_sequence 0.029336   0.000506   57.97   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.332379)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 392906  on 86423  degrees of freedom
    ## AIC: -151689
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 13.02915

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 12.84319

    model=glm(reactivity+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + index_sequence, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2727  -1.2994  -0.4063   0.3710   6.2324  
    ## 
    ## Coefficients:
    ##                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    1.085950   0.016208   67.00   <2e-16 ***
    ## sequenceC      4.603734   0.060383   76.24   <2e-16 ***
    ## sequenceG      0.703576   0.022296   31.56   <2e-16 ***
    ## sequenceU      0.835956   0.030369   27.53   <2e-16 ***
    ## index_sequence 0.029336   0.000506   57.97   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.332379)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 392906  on 86423  degrees of freedom
    ## AIC: -151689
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 13.02915

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 12.84319

    model=glm(reactivity+1e-12~sequence+predicted_loop_type,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + predicted_loop_type, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2647  -1.1405  -0.3947   0.3209   7.1397  
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.45421    0.04273  34.035  < 2e-16 ***
    ## sequenceC             2.82104    0.06005  46.976  < 2e-16 ***
    ## sequenceG            -0.09684    0.02026  -4.779 1.77e-06 ***
    ## sequenceU            -0.11126    0.02655  -4.191 2.78e-05 ***
    ## predicted_loop_typeE -0.04979    0.04455  -1.118    0.264    
    ## predicted_loop_typeH -0.06789    0.04503  -1.508    0.132    
    ## predicted_loop_typeI  0.70276    0.05209  13.491  < 2e-16 ***
    ## predicted_loop_typeM  0.23175    0.05593   4.143 3.43e-05 ***
    ## predicted_loop_typeS  3.84530    0.05334  72.085  < 2e-16 ***
    ## predicted_loop_typeX  0.46284    0.05790   7.994 1.32e-15 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.35203)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 372926  on 86418  degrees of freedom
    ## AIC: -158192
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 20.72796

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 20.92752

    model=glm(reactivity+1e-12~sequence+structure,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + structure, family = Gamma, 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2472  -1.1511  -0.4036   0.3193   6.8860  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.54052    0.01182 130.364  < 2e-16 ***
    ## sequenceC    2.84391    0.05995  47.439  < 2e-16 ***
    ## sequenceG   -0.07334    0.02042  -3.592 0.000328 ***
    ## sequenceU   -0.09286    0.02661  -3.489 0.000484 ***
    ## structure(   3.42065    0.04328  79.038  < 2e-16 ***
    ## structure)   4.10802    0.04883  84.126  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.349477)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 373868  on 86422  degrees of freedom
    ## AIC: -157886
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.04261

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 20.83038

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.04261

    model=glm(reactivity+1e-12~(sequence+predicted_loop_type)^2,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ (sequence + predicted_loop_type)^2, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2847  -1.1310  -0.3853   0.3259   6.7660  
    ## 
    ## Coefficients:
    ##                                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                     1.44060    0.05177  27.828  < 2e-16 ***
    ## sequenceC                       1.47906    0.22667   6.525 6.83e-11 ***
    ## sequenceG                      -0.09373    0.11688  -0.802 0.422615    
    ## sequenceU                       0.17307    0.12529   1.381 0.167169    
    ## predicted_loop_typeE            0.06701    0.05508   1.217 0.223789    
    ## predicted_loop_typeH           -0.09863    0.05565  -1.772 0.076317 .  
    ## predicted_loop_typeI            0.58541    0.06568   8.913  < 2e-16 ***
    ## predicted_loop_typeM            0.27673    0.06918   4.000 6.34e-05 ***
    ## predicted_loop_typeS            3.20303    0.07930  40.390  < 2e-16 ***
    ## predicted_loop_typeX            0.51137    0.07159   7.143 9.22e-13 ***
    ## sequenceC:predicted_loop_typeE  0.73265    0.25872   2.832 0.004629 ** 
    ## sequenceG:predicted_loop_typeE -0.31115    0.12023  -2.588 0.009656 ** 
    ## sequenceU:predicted_loop_typeE -0.02599    0.14234  -0.183 0.855121    
    ## sequenceC:predicted_loop_typeH -0.32041    0.24051  -1.332 0.182796    
    ## sequenceG:predicted_loop_typeH  0.33427    0.12432   2.689 0.007173 ** 
    ## sequenceU:predicted_loop_typeH -0.22727    0.13210  -1.720 0.085358 .  
    ## sequenceC:predicted_loop_typeI  1.01808    0.29771   3.420 0.000627 ***
    ## sequenceG:predicted_loop_typeI  0.24814    0.13436   1.847 0.064768 .  
    ## sequenceU:predicted_loop_typeI  0.17158    0.16303   1.052 0.292578    
    ## sequenceC:predicted_loop_typeM  0.73190    0.34647   2.112 0.034648 *  
    ## sequenceG:predicted_loop_typeM  0.01084    0.15346   0.071 0.943698    
    ## sequenceU:predicted_loop_typeM -0.42223    0.15848  -2.664 0.007718 ** 
    ## sequenceC:predicted_loop_typeS  3.97180    0.25539  15.552  < 2e-16 ***
    ## sequenceG:predicted_loop_typeS  0.80263    0.14064   5.707 1.15e-08 ***
    ## sequenceU:predicted_loop_typeS -0.09597    0.14934  -0.643 0.520478    
    ## sequenceC:predicted_loop_typeX  0.95917    0.35338   2.714 0.006643 ** 
    ## sequenceG:predicted_loop_typeX  0.13715    0.16085   0.853 0.393860    
    ## sequenceU:predicted_loop_typeX -0.59221    0.16110  -3.676 0.000237 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.319714)
    ## 
    ##     Null deviance: 412890  on 86427  degrees of freedom
    ## Residual deviance: 371216  on 86400  degrees of freedom
    ## AIC: -158727
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 25.06465

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 25.22244

### GLM : loi gaussienne inverse

    model=glm(reactivity+1e-12~sequence,family = inverse.gaussian,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence, family = inverse.gaussian, 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##    Min      1Q  Median      3Q     Max  
    ## -1e+06  -4e+00  -1e+00   0e+00   4e+00  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.68486    0.01812  92.990   <2e-16 ***
    ## sequenceC    4.43360    0.05638  78.638   <2e-16 ***
    ## sequenceG   -0.31290    0.02360 -13.259   <2e-16 ***
    ## sequenceU    0.26619    0.03201   8.316   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 3.306347)
    ## 
    ##     Null deviance: 5.716e+15  on 86427  degrees of freedom
    ## Residual deviance: 5.716e+15  on 86424  degrees of freedom
    ## AIC: 1528985
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 8.512683

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 8.334633

    model=glm(reactivity+1e-12~sequence+predicted_loop_type,family = inverse.gaussian,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + predicted_loop_type, 
    ##     family = inverse.gaussian, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##    Min      1Q  Median      3Q     Max  
    ## -1e+06  -4e+00  -1e+00   0e+00   4e+00  
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.308426   0.065623  19.939  < 2e-16 ***
    ## sequenceC             3.945655   0.075231  52.447  < 2e-16 ***
    ## sequenceG            -0.454782   0.030437 -14.942  < 2e-16 ***
    ## sequenceU            -0.613459   0.034301 -17.885  < 2e-16 ***
    ## predicted_loop_typeE -0.007874   0.067904  -0.116   0.9077    
    ## predicted_loop_typeH -0.118771   0.067311  -1.765   0.0776 .  
    ## predicted_loop_typeI  0.926198   0.079533  11.645  < 2e-16 ***
    ## predicted_loop_typeM  0.777724   0.102776   7.567 3.85e-14 ***
    ## predicted_loop_typeS  3.248329   0.071248  45.592  < 2e-16 ***
    ## predicted_loop_typeX  1.377212   0.114049  12.076  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.017043)
    ## 
    ##     Null deviance: 5.716e+15  on 86427  degrees of freedom
    ## Residual deviance: 5.716e+15  on 86418  degrees of freedom
    ## AIC: 1528997
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 18.64159

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 18.64405

    model=glm(reactivity+1e-12~sequence+structure,family = inverse.gaussian,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + structure, family = inverse.gaussian, 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##    Min      1Q  Median      3Q     Max  
    ## -1e+06  -4e+00  -1e+00   0e+00   4e+00  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.44304    0.02143   67.33   <2e-16 ***
    ## sequenceC    3.75581    0.07496   50.10   <2e-16 ***
    ## sequenceG   -0.48384    0.03016  -16.04   <2e-16 ***
    ## sequenceU   -0.50264    0.03697  -13.60   <2e-16 ***
    ## structure(   2.04481    0.03856   53.03   <2e-16 ***
    ## structure)   5.52119    0.06417   86.04   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.097235)
    ## 
    ##     Null deviance: 5.716e+15  on 86427  degrees of freedom
    ## Residual deviance: 5.716e+15  on 86422  degrees of freedom
    ## AIC: 1528989
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 23.51589

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 23.37254

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 23.51589

    model=glm(reactivity+1e-12~(sequence+predicted_loop_type)^2,family = inverse.gaussian,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ (sequence + predicted_loop_type)^2, 
    ##     family = inverse.gaussian, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##    Min      1Q  Median      3Q     Max  
    ## -1e+06  -4e+00  -1e+00   0e+00   5e+00  
    ## 
    ## Coefficients:
    ##                                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                     1.14980    0.08813  13.047  < 2e-16 ***
    ## sequenceC                       2.84254    0.46008   6.178 6.51e-10 ***
    ## sequenceG                      -0.09439    0.20184  -0.468 0.640029    
    ## sequenceU                       0.36298    0.23335   1.556 0.119824    
    ## predicted_loop_typeE            0.30735    0.09611   3.198 0.001384 ** 
    ## predicted_loop_typeH           -0.05668    0.09556  -0.593 0.553090    
    ## predicted_loop_typeI            1.04445    0.11812   8.843  < 2e-16 ***
    ## predicted_loop_typeM            0.95276    0.14320   6.653 2.88e-11 ***
    ## predicted_loop_typeS            3.02110    0.11252  26.848  < 2e-16 ***
    ## predicted_loop_typeX            1.50672    0.15398   9.785  < 2e-16 ***
    ## sequenceC:predicted_loop_typeE  4.29608    0.59868   7.176 7.24e-13 ***
    ## sequenceG:predicted_loop_typeE -0.72780    0.20754  -3.507 0.000454 ***
    ## sequenceU:predicted_loop_typeE -0.20341    0.26824  -0.758 0.448269    
    ## sequenceC:predicted_loop_typeH -2.05221    0.47178  -4.350 1.36e-05 ***
    ## sequenceG:predicted_loop_typeH  0.12996    0.21214   0.613 0.540152    
    ## sequenceU:predicted_loop_typeH -0.40924    0.24576  -1.665 0.095870 .  
    ## sequenceC:predicted_loop_typeI  0.62750    0.55255   1.136 0.256114    
    ## sequenceG:predicted_loop_typeI -0.48430    0.22723  -2.131 0.033068 *  
    ## sequenceU:predicted_loop_typeI  0.22073    0.30921   0.714 0.475314    
    ## sequenceC:predicted_loop_typeM  2.78064    0.80763   3.443 0.000576 ***
    ## sequenceG:predicted_loop_typeM -0.52449    0.28143  -1.864 0.062369 .  
    ## sequenceU:predicted_loop_typeM -0.95217    0.32193  -2.958 0.003101 ** 
    ## sequenceC:predicted_loop_typeS  9.15644    0.48806  18.761  < 2e-16 ***
    ## sequenceG:predicted_loop_typeS  1.44645    0.22257   6.499 8.13e-11 ***
    ## sequenceU:predicted_loop_typeS -2.05342    0.24698  -8.314  < 2e-16 ***
    ## sequenceC:predicted_loop_typeX  6.57622    1.02164   6.437 1.23e-10 ***
    ## sequenceG:predicted_loop_typeX -0.31914    0.31189  -1.023 0.306194    
    ## sequenceU:predicted_loop_typeX -1.15256    0.35494  -3.247 0.001166 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.30825)
    ## 
    ##     Null deviance: 5.716e+15  on 86427  degrees of freedom
    ## Residual deviance: 5.716e+15  on 86400  degrees of freedom
    ## AIC: 1529033
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 48.93385

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 48.54993
