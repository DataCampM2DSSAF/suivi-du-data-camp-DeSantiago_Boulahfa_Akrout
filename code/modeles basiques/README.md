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

    ##   X             id sequence structure predicted_loop_type signal_to_noise
    ## 1 0 id_001f94081_1        G         .                   E           6.894
    ## 2 1 id_001f94081_2        G         .                   E           6.894
    ## 3 2 id_001f94081_3        A         .                   E           6.894
    ## 4 3 id_001f94081_4        A         .                   E           6.894
    ## 5 4 id_001f94081_5        A         .                   E           6.894
    ## 6 5 id_001f94081_6        A         (                   S           6.894
    ##   SN_filter reactivity deg_Mg_pH10 deg_pH10 deg_Mg_50C deg_50C
    ## 1         1     0.3297      0.7556   2.3375     0.3581  0.6382
    ## 2         1     1.5693      2.9830   3.5060     2.9683  3.4773
    ## 3         1     1.1227      0.2526   0.3008     0.2589  0.9988
    ## 4         1     0.8686      1.3789   1.0108     1.4552  1.3228
    ## 5         1     0.7217      0.6376   0.2635     0.7244  0.7877
    ## 6         1     0.4384      0.3313   0.3403     0.4971  0.5890

    data=data[,-1]
    head(data)

    ##               id sequence structure predicted_loop_type signal_to_noise
    ## 1 id_001f94081_1        G         .                   E           6.894
    ## 2 id_001f94081_2        G         .                   E           6.894
    ## 3 id_001f94081_3        A         .                   E           6.894
    ## 4 id_001f94081_4        A         .                   E           6.894
    ## 5 id_001f94081_5        A         .                   E           6.894
    ## 6 id_001f94081_6        A         (                   S           6.894
    ##   SN_filter reactivity deg_Mg_pH10 deg_pH10 deg_Mg_50C deg_50C
    ## 1         1     0.3297      0.7556   2.3375     0.3581  0.6382
    ## 2         1     1.5693      2.9830   3.5060     2.9683  3.4773
    ## 3         1     1.1227      0.2526   0.3008     0.2589  0.9988
    ## 4         1     0.8686      1.3789   1.0108     1.4552  1.3228
    ## 5         1     0.7217      0.6376   0.2635     0.7244  0.7877
    ## 6         1     0.4384      0.3313   0.3403     0.4971  0.5890

    data=data %>% mutate(sequence = as.factor(sequence)) %>% 
      mutate(sequence = as.factor(sequence)) %>% 
      mutate(structure = as.factor(structure)) %>% 
      mutate(predicted_loop_type = as.factor(predicted_loop_type))

On filtre maintenant les données qui ont SN\_filter=0 :

    print(sum(data$SN_filter==0)/68) ## Nombre d'individus dont le SN_filter=0

    ## [1] 811

    data=data[data$SN_filter==1,]
    rownames(data)=NULL#1:108052

    sum(data[,7:11]<0)

    ## [1] 9918

    for (i in 7:11){
      data[which(data[,i]<0),i]=0
    } 
    sum(data[,7:11]<0)

    ## [1] 0

Création de la base train/validation :
--------------------------------------

    tamp=train_test_split(data)
    data_train=tamp$train
    data_val=tamp$val
    rm(tamp,data)

Modèles simples :
-----------------

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
    ## -7.2092  -1.3499  -0.4633   0.3659   6.4742  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.90591    0.01316  144.79   <2e-16 ***
    ## sequenceC    4.86485    0.06380   76.25   <2e-16 ***
    ## sequenceG    0.72008    0.02415   29.82   <2e-16 ***
    ## sequenceU    1.08314    0.03299   32.83   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.455863)
    ## 
    ##     Null deviance: 417687  on 86359  degrees of freedom
    ## Residual deviance: 402490  on 86356  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: -154945
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 12.15227

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 12.36544

    model=glm(reactivity+1e-12~sequence+predicted_loop_type,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + predicted_loop_type, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2671  -1.1540  -0.4084   0.3179   7.3083  
    ## 
    ## Coefficients:
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.41778    0.04217  33.619  < 2e-16 ***
    ## sequenceC             2.72287    0.06134  44.389  < 2e-16 ***
    ## sequenceG            -0.13009    0.02050  -6.347 2.21e-10 ***
    ## sequenceU            -0.09976    0.02747  -3.632 0.000282 ***
    ## predicted_loop_typeE  0.01883    0.04403   0.428 0.668920    
    ## predicted_loop_typeH -0.03474    0.04455  -0.780 0.435513    
    ## predicted_loop_typeI  0.76558    0.05212  14.688  < 2e-16 ***
    ## predicted_loop_typeM  0.25569    0.05582   4.581 4.64e-06 ***
    ## predicted_loop_typeS  4.08874    0.05375  76.065  < 2e-16 ***
    ## predicted_loop_typeX  0.47169    0.05738   8.220  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.39113)
    ## 
    ##     Null deviance: 417687  on 86359  degrees of freedom
    ## Residual deviance: 376448  on 86350  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: -163297
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 21.74287

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.85649

    model=glm(reactivity+1e-12~sequence+structure,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ sequence + structure, family = Gamma, 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2472  -1.1620  -0.4167   0.3167   7.0593  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.54851    0.01202 128.822  < 2e-16 ***
    ## sequenceC    2.74674    0.06123  44.861  < 2e-16 ***
    ## sequenceG   -0.10117    0.02065  -4.899 9.63e-07 ***
    ## sequenceU   -0.08264    0.02751  -3.004  0.00266 ** 
    ## structure(   3.61977    0.04533  79.847  < 2e-16 ***
    ## structure)   4.30064    0.05089  84.500  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.388129)
    ## 
    ##     Null deviance: 417687  on 86359  degrees of freedom
    ## Residual deviance: 377382  on 86354  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: -162997
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.95029

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 21.8413

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.95029

    model=glm(reactivity+1e-12~(sequence+predicted_loop_type)^2,family = Gamma,data = data_train)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = reactivity + 1e-12 ~ (sequence + predicted_loop_type)^2, 
    ##     family = Gamma, data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2856  -1.1420  -0.3987   0.3206   6.9218  
    ## 
    ## Coefficients:
    ##                                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                     1.40331    0.05152  27.236  < 2e-16 ***
    ## sequenceC                       1.44899    0.22019   6.581 4.71e-11 ***
    ## sequenceG                      -0.07116    0.11341  -0.627  0.53035    
    ## sequenceU                       0.13009    0.12258   1.061  0.28858    
    ## predicted_loop_typeE            0.14257    0.05496   2.594  0.00948 ** 
    ## predicted_loop_typeH           -0.07328    0.05555  -1.319  0.18714    
    ## predicted_loop_typeI            0.63041    0.06625   9.516  < 2e-16 ***
    ## predicted_loop_typeM            0.29843    0.06935   4.303 1.68e-05 ***
    ## predicted_loop_typeS            3.45970    0.08175  42.321  < 2e-16 ***
    ## predicted_loop_typeX            0.51040    0.07140   7.149 8.84e-13 ***
    ## sequenceC:predicted_loop_typeE  0.54816    0.25340   2.163  0.03053 *  
    ## sequenceG:predicted_loop_typeE -0.37941    0.11693  -3.245  0.00118 ** 
    ## sequenceU:predicted_loop_typeE  0.08587    0.14309   0.600  0.54845    
    ## sequenceC:predicted_loop_typeH -0.32768    0.23457  -1.397  0.16244    
    ## sequenceG:predicted_loop_typeH  0.31069    0.12135   2.560  0.01046 *  
    ## sequenceU:predicted_loop_typeH -0.17255    0.12985  -1.329  0.18389    
    ## sequenceC:predicted_loop_typeI  1.12180    0.29949   3.746  0.00018 ***
    ## sequenceG:predicted_loop_typeI  0.21134    0.13207   1.600  0.10957    
    ## sequenceU:predicted_loop_typeI  0.29387    0.16462   1.785  0.07425 .  
    ## sequenceC:predicted_loop_typeM  0.63791    0.33998   1.876  0.06062 .  
    ## sequenceG:predicted_loop_typeM -0.03098    0.15166  -0.204  0.83812    
    ## sequenceU:predicted_loop_typeM -0.36287    0.15796  -2.297  0.02161 *  
    ## sequenceC:predicted_loop_typeS  3.98727    0.25205  15.819  < 2e-16 ***
    ## sequenceG:predicted_loop_typeS  0.69686    0.14003   4.976 6.49e-07 ***
    ## sequenceU:predicted_loop_typeS -0.08032    0.14950  -0.537  0.59109    
    ## sequenceC:predicted_loop_typeX  0.89023    0.34942   2.548  0.01084 *  
    ## sequenceG:predicted_loop_typeX  0.10769    0.15781   0.682  0.49500    
    ## sequenceU:predicted_loop_typeX -0.50334    0.15902  -3.165  0.00155 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.357517)
    ## 
    ##     Null deviance: 417687  on 86359  degrees of freedom
    ## Residual deviance: 374690  on 86332  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: -163844
    ## 
    ## Number of Fisher Scoring iterations: 7

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 26.299

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 26.52275

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
    ## (Intercept)  1.65615    0.01779   93.10   <2e-16 ***
    ## sequenceC    4.36739    0.05623   77.67   <2e-16 ***
    ## sequenceG   -0.29673    0.02335  -12.71   <2e-16 ***
    ## sequenceU    0.35179    0.03230   10.89   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 3.34674)
    ## 
    ##     Null deviance: 5.773e+15  on 86359  degrees of freedom
    ## Residual deviance: 5.773e+15  on 86356  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: 1518963
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 8.22108

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 8.381501

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
    ##                      Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.21136    0.06235  19.428  < 2e-16 ***
    ## sequenceC             3.88797    0.07637  50.907  < 2e-16 ***
    ## sequenceG            -0.46374    0.03023 -15.340  < 2e-16 ***
    ## sequenceU            -0.54778    0.03536 -15.493  < 2e-16 ***
    ## predicted_loop_typeE  0.10668    0.06484   1.645   0.0999 .  
    ## predicted_loop_typeH -0.06007    0.06413  -0.937   0.3489    
    ## predicted_loop_typeI  0.94197    0.07620  12.362  < 2e-16 ***
    ## predicted_loop_typeM  0.83118    0.10147   8.192 2.61e-16 ***
    ## predicted_loop_typeS  3.43535    0.06848  50.163  < 2e-16 ***
    ## predicted_loop_typeX  1.39428    0.11162  12.492  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.102904)
    ## 
    ##     Null deviance: 5.773e+15  on 86359  degrees of freedom
    ## Residual deviance: 5.773e+15  on 86350  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: 1518975
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 18.92863

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 19.11309

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
    ## (Intercept)  1.41820    0.02119   66.92   <2e-16 ***
    ## sequenceC    3.67541    0.07587   48.45   <2e-16 ***
    ## sequenceG   -0.47786    0.03009  -15.88   <2e-16 ***
    ## sequenceU   -0.43609    0.03808  -11.45   <2e-16 ***
    ## structure(   2.13385    0.03945   54.09   <2e-16 ***
    ## structure)   5.65062    0.06526   86.58   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.184415)
    ## 
    ##     Null deviance: 5.773e+15  on 86359  degrees of freedom
    ## Residual deviance: 5.773e+15  on 86354  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: 1518967
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 23.91191

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 23.73905

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 23.91191

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
    ##                                 Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                     1.059261   0.083694  12.656  < 2e-16 ***
    ## sequenceC                       2.664401   0.430177   6.194 5.90e-10 ***
    ## sequenceG                      -0.069149   0.185963  -0.372  0.71001    
    ## sequenceU                       0.321057   0.223228   1.438  0.15037    
    ## predicted_loop_typeE            0.416500   0.091803   4.537 5.72e-06 ***
    ## predicted_loop_typeH            0.005120   0.091485   0.056  0.95537    
    ## predicted_loop_typeI            1.016843   0.112996   8.999  < 2e-16 ***
    ## predicted_loop_typeM            1.007162   0.140922   7.147 8.94e-13 ***
    ## predicted_loop_typeS            3.112932   0.108952  28.572  < 2e-16 ***
    ## predicted_loop_typeX            1.535778   0.152070  10.099  < 2e-16 ***
    ## sequenceC:predicted_loop_typeE  4.117225   0.586767   7.017 2.29e-12 ***
    ## sequenceG:predicted_loop_typeE -0.759993   0.192162  -3.955 7.66e-05 ***
    ## sequenceU:predicted_loop_typeE -0.006908   0.265926  -0.026  0.97928    
    ## sequenceC:predicted_loop_typeH -1.879375   0.442908  -4.243 2.21e-05 ***
    ## sequenceG:predicted_loop_typeH  0.054886   0.196514   0.279  0.78002    
    ## sequenceU:predicted_loop_typeH -0.338550   0.236582  -1.431  0.15243    
    ## sequenceC:predicted_loop_typeI  1.020304   0.534473   1.909  0.05627 .  
    ## sequenceG:predicted_loop_typeI -0.450008   0.211894  -2.124  0.03369 *  
    ## sequenceU:predicted_loop_typeI  0.535079   0.307329   1.741  0.08168 .  
    ## sequenceC:predicted_loop_typeM  2.543782   0.779688   3.263  0.00110 ** 
    ## sequenceG:predicted_loop_typeM -0.492857   0.276346  -1.783  0.07451 .  
    ## sequenceU:predicted_loop_typeM -0.937936   0.312090  -3.005  0.00265 ** 
    ## sequenceC:predicted_loop_typeS  9.787797   0.461562  21.206  < 2e-16 ***
    ## sequenceG:predicted_loop_typeS  1.418238   0.208328   6.808 9.98e-12 ***
    ## sequenceU:predicted_loop_typeS -1.864796   0.237714  -7.845 4.39e-15 ***
    ## sequenceC:predicted_loop_typeX  6.486076   1.026350   6.320 2.64e-10 ***
    ## sequenceG:predicted_loop_typeX -0.453821   0.294669  -1.540  0.12354    
    ## sequenceU:predicted_loop_typeX -1.026843   0.349015  -2.942  0.00326 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for inverse.gaussian family taken to be 4.402705)
    ## 
    ##     Null deviance: 5.773e+15  on 86359  degrees of freedom
    ## Residual deviance: 5.773e+15  on 86332  degrees of freedom
    ##   (68 observations deleted due to missingness)
    ## AIC: 1519011
    ## 
    ## Number of Fisher Scoring iterations: 2

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 50.87498

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 51.70544
