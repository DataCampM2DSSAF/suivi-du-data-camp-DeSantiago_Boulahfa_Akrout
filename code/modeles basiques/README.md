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

On filtre maintenant les données qui ont SN\_filter=0 :

    print(sum(data$SN_filter==0)/68) ## Nombre d'individus dont le SN_filter=0

    ## [1] 811

    data=data[data$SN_filter==1,]
    rownames(data)=1:108052

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
    ## -7.2108  -1.3085  -0.4448   0.3661   6.4544  
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.88410    0.01280  147.24   <2e-16 ***
    ## sequenceC    4.85090    0.06240   77.74   <2e-16 ***
    ## sequenceG    0.71265    0.02349   30.34   <2e-16 ***
    ## sequenceU    0.98895    0.03133   31.57   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.409625)
    ## 
    ##     Null deviance: 399029  on 86427  degrees of freedom
    ## Residual deviance: 383771  on 86424  degrees of freedom
    ## AIC: -139532
    ## 
    ## Number of Fisher Scoring iterations: 7

penser aux relations d’ordre 2 entre les variables !

### GLM : loi Gamma
