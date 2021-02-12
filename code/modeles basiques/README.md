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

    ##   X             id sequence index_sequence seq_be seq_af structure
    ## 1 0 id_001f94081_0        G              1      O      G         .
    ## 2 1 id_001f94081_1        G              2      G      A         .
    ## 3 2 id_001f94081_2        A              3      G      A         .
    ## 4 3 id_001f94081_3        A              4      A      A         .
    ## 5 4 id_001f94081_4        A              5      A      A         .
    ## 6 5 id_001f94081_5        A              6      A      G         (
    ##   predicted_loop_type signal_to_noise SN_filter reactivity deg_Mg_pH10 deg_pH10
    ## 1                   E           6.894         1     0.3297      0.7556   2.3375
    ## 2                   E           6.894         1     1.5693      2.9830   3.5060
    ## 3                   E           6.894         1     1.1227      0.2526   0.3008
    ## 4                   E           6.894         1     0.8686      1.3789   1.0108
    ## 5                   E           6.894         1     0.7217      0.6376   0.2635
    ## 6                   S           6.894         1     0.4384      0.3313   0.3403
    ##   deg_Mg_50C deg_50C
    ## 1     0.3581  0.6382
    ## 2     2.9683  3.4773
    ## 3     0.2589  0.9988
    ## 4     1.4552  1.3228
    ## 5     0.7244  0.7877
    ## 6     0.4971  0.5890

    data=data[,-1]
    head(data)

    ##               id sequence index_sequence seq_be seq_af structure
    ## 1 id_001f94081_0        G              1      O      G         .
    ## 2 id_001f94081_1        G              2      G      A         .
    ## 3 id_001f94081_2        A              3      G      A         .
    ## 4 id_001f94081_3        A              4      A      A         .
    ## 5 id_001f94081_4        A              5      A      A         .
    ## 6 id_001f94081_5        A              6      A      G         (
    ##   predicted_loop_type signal_to_noise SN_filter reactivity deg_Mg_pH10 deg_pH10
    ## 1                   E           6.894         1     0.3297      0.7556   2.3375
    ## 2                   E           6.894         1     1.5693      2.9830   3.5060
    ## 3                   E           6.894         1     1.1227      0.2526   0.3008
    ## 4                   E           6.894         1     0.8686      1.3789   1.0108
    ## 5                   E           6.894         1     0.7217      0.6376   0.2635
    ## 6                   S           6.894         1     0.4384      0.3313   0.3403
    ##   deg_Mg_50C deg_50C
    ## 1     0.3581  0.6382
    ## 2     2.9683  3.4773
    ## 3     0.2589  0.9988
    ## 4     1.4552  1.3228
    ## 5     0.7244  0.7877
    ## 6     0.4971  0.5890

    data=data %>% mutate(sequence = as.factor(sequence)) %>% 
      mutate(index_sequence = as.factor(index_sequence)) %>% 
      mutate(seq_be = as.factor(seq_be)) %>% 
      mutate(seq_af = as.factor(seq_af)) %>% 
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

    p=dim(data)[2]
    sum(data[,(p-4):p]<0)

    ## [1] 9918

    for (i in (p-4):p){
      data[which(data[,i]<0),i]=0
    } 
    sum(data[,(p-4):p]<0)

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

    #rm(tamp,data)

Test sur les lois
-----------------

    M=mean(data_train$reactivity,na.rm = TRUE)
    S=var(data_train$reactivity,na.rm = TRUE)
    print(M)

    ## [1] 0.3793095

    print(S)

    ## [1] 0.2053505

    ks.test(data_train$reactivity,"pexp",1/M)

    ## Warning in ks.test(data_train$reactivity, "pexp", 1/M): ties should not be
    ## present for the Kolmogorov-Smirnov test

    ## 
    ##  One-sample Kolmogorov-Smirnov test
    ## 
    ## data:  data_train$reactivity
    ## D = 0.11471, p-value < 2.2e-16
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
    ## D = 0.96908, p-value < 2.2e-16
    ## alternative hypothesis: two-sided

Modèles simples : GLM : loi Gamma et inverse.gaussian
-----------------------------------------------------

On prédira la variable + un bruit (1e-12) pour que le support de la
densité des labels soit dans ℝ<sub>+</sub><sup>\*</sup>.

### Reactivity

#### Loi Gamma

Ici on fera énormément de tests pour essayer de voir quels variables
apportent des informations utiles.

    model=glm(reactivity+1e-12~sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 12.02296

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 11.99108

    model=glm(reactivity+1e-12~(sequence+seq_be+seq_af),family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 18.80148

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 18.75824

    model=glm(reactivity+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 13.74437

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 13.72801

    model=glm(reactivity+1e-12~sequence+predicted_loop_type+index_sequence,family = Gamma,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 21.57679

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.47871

    model=glm(reactivity+1e-12~sequence+structure+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 21.43747

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 21.56182

#### Inverse.gaussian

    model=glm(reactivity+1e-12~sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 8.337738

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 8.329617

    model=glm(reactivity+1e-12~(sequence+seq_be+seq_af),family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 24.90513

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 24.90236

    model=glm(reactivity+1e-12~sequence+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 13.46915

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 13.47544

    model=glm(reactivity+1e-12~sequence+predicted_loop_type,family = inverse.gaussian,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 20.2104

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 20.10753

    model=glm(reactivity+1e-12~sequence+structure,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$reactivity)^2,na.rm=TRUE)

    ## [1] 24.4113

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$reactivity)^2,na.rm=TRUE)

    ## [1] 24.4963

### deg\_Mg\_pH10

#### Loi Gamma

Ici on fera énormément de tests pour essayer de voir quels variables
apportent des informations utiles.

    model=glm(deg_Mg_pH10+1e-12~sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 3.680898

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 3.670963

    model=glm(deg_Mg_pH10+1e-12~(sequence+seq_be+seq_af),family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 7.521336

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 7.522252

    model=glm(deg_Mg_pH10+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.579362

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.57964

    model=glm(deg_Mg_pH10+1e-12~sequence+predicted_loop_type+index_sequence,family = Gamma,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 5.953057

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 5.94597

    model=glm(deg_Mg_pH10+1e-12~sequence+structure+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 5.763643

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 5.790756

#### Inverse.gaussian

    model=glm(deg_Mg_pH10+1e-12~sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 1.948504

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 1.949362

    model=glm(deg_Mg_pH10+1e-12~(sequence+seq_be),family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 2.108732

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 2.113999

    model=glm(deg_Mg_pH10+1e-12~sequence+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 3.443317

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 3.43943

    model=glm(deg_Mg_pH10+1e-12~sequence+predicted_loop_type,family = inverse.gaussian,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.593201

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.557434

    model=glm(deg_Mg_pH10+1e-12~sequence+structure,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.555989

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_pH10)^2,na.rm=TRUE)

    ## [1] 4.586902

### deg\_pH10

#### Loi Gamma

Ici on fera énormément de tests pour essayer de voir quels variables
apportent des informations utiles.

    model=glm(deg_pH10+1e-12~sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 4.217365

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 4.205623

    model=glm(deg_pH10+1e-12~(sequence+seq_be+seq_af),family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.893332

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.880424

    model=glm(deg_pH10+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.734225

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.739131

    model=glm(deg_pH10+1e-12~sequence+predicted_loop_type+index_sequence,family = Gamma,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.733194

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.699415

    model=glm(deg_pH10+1e-12~sequence+structure+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.592837

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 8.625661

#### Inverse.gaussian

    model=glm(deg_pH10+1e-12~sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 3.411292

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 3.416569

    model=glm(deg_pH10+1e-12~(sequence+seq_be),family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 3.849347

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 3.854777

    model=glm(deg_pH10+1e-12~index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 7.313954

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 7.319523

    model=glm(deg_pH10+1e-12~sequence+predicted_loop_type,family = inverse.gaussian,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.997524

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.942711

    model=glm(deg_pH10+1e-12~sequence+structure,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.697292

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_pH10)^2,na.rm=TRUE)

    ## [1] 6.728102

### deg\_Mg\_50C

#### Loi Gamma

Ici on fera énormément de tests pour essayer de voir quels variables
apportent des informations utiles.

    model=glm(deg_Mg_50C+1e-12~sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 5.321542

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 5.293586

    model=glm(deg_Mg_50C+1e-12~(sequence+seq_be+seq_af),family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 11.3232

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 11.29588

    model=glm(deg_Mg_50C+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 7.140879

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 7.125759

    model=glm(deg_Mg_50C+1e-12~sequence+predicted_loop_type+index_sequence,family = Gamma,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 10.10931

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 10.04813

    model=glm(deg_Mg_50C+1e-12~sequence+structure+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 9.924031

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 9.992342

#### Inverse.gaussian

    model=glm(deg_Mg_50C+1e-12~sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 3.109125

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 3.098026

    model=glm(deg_Mg_50C+1e-12~(sequence+seq_be),family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 3.825205

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 3.81769

    model=glm(deg_Mg_50C+1e-12~sequence+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 6.584612

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 6.575979

    model=glm(deg_Mg_50C+1e-12~sequence+predicted_loop_type,family = inverse.gaussian,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 7.804246

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 7.730081

    model=glm(deg_Mg_50C+1e-12~sequence+structure+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 9.591823

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_Mg_50C)^2,na.rm=TRUE)

    ## [1] 9.646229

### deg\_50C

#### Loi Gamma

Ici on fera énormément de tests pour essayer de voir quels variables
apportent des informations utiles.

    model=glm(deg_50C+1e-12~sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 4.563267

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 4.544686

    model=glm(deg_50C+1e-12~(sequence+seq_be+seq_af),family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 9.492388

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 9.479388

    model=glm(deg_50C+1e-12~sequence+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 5.941369

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 5.934548

    model=glm(deg_50C+1e-12~sequence+predicted_loop_type+index_sequence,family = Gamma,data = data_train)
    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.78534

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.747274

    model=glm(deg_50C+1e-12~sequence+structure+index_sequence,family = Gamma,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.661802

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.700668

#### Inverse.gaussian

    model=glm(deg_50C+1e-12~sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 5.262118

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 5.244166

    model=glm(deg_50C+1e-12~(sequence+seq_be+seq_af),family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 31.20511

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 31.21666

    model=glm(deg_50C+1e-12~sequence+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 10.06391

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 10.07142

    model=glm(deg_50C+1e-12~sequence+predicted_loop_type+index_sequence,family = inverse.gaussian,data = data_train)

    ## Warning in sqrt(eta): production de NaN

    ## Warning: step size truncated due to divergence

    ## Warning: glm.fit: algorithm stopped at boundary value

    #summary(model)
    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.238696

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 7.215836

    model=glm(deg_50C+1e-12~sequence+structure+index_sequence,family = inverse.gaussian,data = data_train)
    #summary(model)

    y_pred=predict.glm(model,data_val)
    mean((y_pred-data_val$deg_50C)^2,na.rm=TRUE)

    ## [1] 13.7483

    y_pred=predict.glm(model,data_train)
    mean((y_pred-data_train$deg_50C)^2,na.rm=TRUE)

    ## [1] 13.79685

Première soumission :
---------------------

    data_test=read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_test.csv")
    data_test= data_test%>% mutate(sequence = as.factor(sequence)) %>% 
      mutate(index_sequence = as.factor(index_sequence)) %>% 
      mutate(seq_be = as.factor(seq_be)) %>% 
      mutate(seq_af = as.factor(seq_af)) %>% 
      mutate(structure = as.factor(structure)) %>% 
      mutate(predicted_loop_type = as.factor(predicted_loop_type))
    head(data_test)

    ##   X             id sequence index_sequence seq_be seq_af structure
    ## 1 0 id_00073f8be_0        G              1      O      G         .
    ## 2 1 id_00073f8be_1        G              2      G      A         .
    ## 3 2 id_00073f8be_2        A              3      G      A         .
    ## 4 3 id_00073f8be_3        A              4      A      A         .
    ## 5 4 id_00073f8be_4        A              5      A      A         .
    ## 6 5 id_00073f8be_5        A              6      A      G         .
    ##   predicted_loop_type
    ## 1                   E
    ## 2                   E
    ## 3                   E
    ## 4                   E
    ## 5                   E
    ## 6                   E

    model_reactivity=glm(reactivity+1e-12~sequence,family = inverse.gaussian,data = data)
    model_deg_Mg_pH10=glm(deg_Mg_pH10+1e-12~sequence,family = inverse.gaussian,data = data)
    model_deg_pH10=glm(deg_pH10+1e-12~sequence,family = inverse.gaussian,data = data)
    model_deg_Mg_50C=glm(deg_Mg_50C+1e-12~sequence,family = inverse.gaussian,data = data)
    model_deg_50C=glm(deg_50C+1e-12~sequence,family = inverse.gaussian,data = data)

    y_test_pred=read.csv(file = "~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/sample_submission.csv")
    y_test_pred[,2]=predict.glm(model_reactivity,data_test)
    y_test_pred[,3]=predict.glm(model_deg_Mg_pH10,data_test)
    y_test_pred[,4]=predict.glm(model_deg_pH10,data_test)
    y_test_pred[,5]=predict.glm(model_deg_Mg_50C,data_test)
    y_test_pred[,6]=predict.glm(model_deg_50C,data_test)

    head(y_test_pred)

    ##        id_seqpos reactivity deg_Mg_pH10  deg_pH10 deg_Mg_50C  deg_50C
    ## 1 id_00073f8be_0   1.351874   0.7894411 0.4492231  0.8928703 1.280937
    ## 2 id_00073f8be_1   1.351874   0.7894411 0.4492231  0.8928703 1.280937
    ## 3 id_00073f8be_2   1.663876   1.2873679 1.9747282  1.4861878 2.179224
    ## 4 id_00073f8be_3   1.663876   1.2873679 1.9747282  1.4861878 2.179224
    ## 5 id_00073f8be_4   1.663876   1.2873679 1.9747282  1.4861878 2.179224
    ## 6 id_00073f8be_5   1.663876   1.2873679 1.9747282  1.4861878 2.179224

    #write.csv(y_test_pred,file = "sample_submission_2.csv",row.names=FALSE)
    #tamp=read.csv(file = "sample_submission_2.csv")
    #head(tamp)
