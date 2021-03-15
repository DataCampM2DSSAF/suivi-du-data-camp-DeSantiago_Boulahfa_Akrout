
# Data Camp Open Vaccine: Modèles basiques

### AKROUT Leyth, BOULAHFA Jawad, DE SANTIAGO Kylliann

#### M2 Data Science: Santé, Assurance, Finance

#### Université d’Evry Val d’Essonne

### 7 mars 2021

> [Premier chargement des données](#data1)

> [Séparation train/validation](#split1)

> [GLM: loi Gamma](#glm)

> [Soumission GLM](#soumission1)

> [Second chargement des données](#data2)

> [Séparation train/validation](#split2)

> [Random Forest](#rf)

> [Soumission Random Forest](#soumission2)

<a id="data1"></a>

# Premier chargement des données

Chargement du jeu de données.

``` r
# data = read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_train.csv")
data = read.csv("data_train.csv")
head(data) # une colonne en trop
```

    ##   X             id sequence index_sequence seq_be seq_af structure struct_be
    ## 1 0 id_001f94081_0        G              1      O      G         .         O
    ## 2 1 id_001f94081_1        G              2      G      A         .         .
    ## 3 2 id_001f94081_2        A              3      G      A         .         .
    ## 4 3 id_001f94081_3        A              4      A      A         .         .
    ## 5 4 id_001f94081_4        A              5      A      A         .         .
    ## 6 5 id_001f94081_5        A              6      A      G         (         .
    ##   struct_af predicted_loop_type loop_type_be loop_type_af bpps_0 bpps_1 bpps_2
    ## 1         .                   E            O            E      0      0      0
    ## 2         .                   E            E            E      0      0      0
    ## 3         .                   E            E            E      0      0      0
    ## 4         .                   E            E            E      0      0      0
    ## 5         (                   E            E            S      0      0      0
    ## 6         (                   S            E            S      0      0      0
    ##   bpps_3 bpps_4 bpps_5 bpps_6     bpps_7     bpps_8     bpps_9    bpps_10
    ## 1      0      0      0      0 0.00655413 0.00922102 0.00809437 0.02178570
    ## 2      0      0      0      0 0.01820530 0.00511209 0.03865270 0.00000000
    ## 3      0      0      0      0 0.00000000 0.02759040 0.00000000 0.00000000
    ## 4      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 5      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 6      0      0      0      0 0.00000000 0.00310716 0.00000000 0.00117008
    ##   bpps_11 bpps_12 bpps_13 bpps_14 bpps_15    bpps_16 bpps_17 bpps_18 bpps_19
    ## 1       0       0       0       0       0 0.00112002       0       0       0
    ## 2       0       0       0       0       0 0.00000000       0       0       0
    ## 3       0       0       0       0       0 0.00000000       0       0       0
    ## 4       0       0       0       0       0 0.00000000       0       0       0
    ## 5       0       0       0       0       0 0.00000000       0       0       0
    ## 6       0       0       0       0       0 0.00000000       0       0       0
    ##   bpps_20 bpps_21 bpps_22    bpps_23    bpps_24 bpps_25 bpps_26 bpps_27 bpps_28
    ## 1       0       0       0 0.00465301 0.00241507       0       0       0       0
    ## 2       0       0       0 0.00432340 0.00000000       0       0       0       0
    ## 3       0       0       0 0.00000000 0.00000000       0       0       0       0
    ## 4       0       0       0 0.00000000 0.00127806       0       0       0       0
    ## 5       0       0       0 0.00000000 0.00284297       0       0       0       0
    ## 6       0       0       0 0.00000000 0.06989900       0       0       0       0
    ##      bpps_29    bpps_30 bpps_31    bpps_32 bpps_33 bpps_34 bpps_35    bpps_36
    ## 1 0.01146960 0.00492862       0 0.00353196       0       0       0 0.00000000
    ## 2 0.00856126 0.00000000       0 0.00113814       0       0       0 0.00000000
    ## 3 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00000000
    ## 4 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00105140
    ## 5 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00702873
    ## 6 0.00000000 0.00685149       0 0.00000000       0       0       0 0.00000000
    ##      bpps_37    bpps_38    bpps_39    bpps_40 bpps_41 bpps_42 bpps_43 bpps_44
    ## 1 0.00000000 0.00000000 0.00159406 0.00629747       0       0       0       0
    ## 2 0.00000000 0.00144827 0.01117350 0.00000000       0       0       0       0
    ## 3 0.00132569 0.01070460 0.00000000 0.00000000       0       0       0       0
    ## 4 0.00947066 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 5 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 6 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ##   bpps_45 bpps_46 bpps_47 bpps_48 bpps_49 bpps_50 bpps_51 bpps_52 bpps_53
    ## 1       0       0       0       0       0       0       0       0       0
    ## 2       0       0       0       0       0       0       0       0       0
    ## 3       0       0       0       0       0       0       0       0       0
    ## 4       0       0       0       0       0       0       0       0       0
    ## 5       0       0       0       0       0       0       0       0       0
    ## 6       0       0       0       0       0       0       0       0       0
    ##   bpps_54 bpps_55    bpps_56    bpps_57    bpps_58 bpps_59    bpps_60 bpps_61
    ## 1       0       0 0.00000000 0.00529590 0.00605378       0 0.00000000       0
    ## 2       0       0 0.00515096 0.00579555 0.00000000       0 0.00000000       0
    ## 3       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 4       0       0 0.00000000 0.00000000 0.00000000       0 0.00132209       0
    ## 5       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 6       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ##     bpps_62   bpps_63 bpps_64 bpps_65    bpps_66 bpps_67 bpps_68 bpps_69
    ## 1 0.0012753 0.0136668       0       0 0.00152313       0       0       0
    ## 2 0.0133479 0.0000000       0       0 0.00000000       0       0       0
    ## 3 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 4 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 5 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 6 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ##   bpps_70 bpps_71 bpps_72 bpps_73 bpps_74 bpps_75    bpps_76    bpps_77 bpps_78
    ## 1       0       0       0       0       0       0 0.00000000 0.00141133       0
    ## 2       0       0       0       0       0       0 0.00000000 0.00443669       0
    ## 3       0       0       0       0       0       0 0.00287931 0.00000000       0
    ## 4       0       0       0       0       0       0 0.00000000 0.00000000       0
    ## 5       0       0       0       0       0       0 0.00140816 0.00000000       0
    ## 6       0       0       0       0       0       0 0.04401610 0.00000000       0
    ##      bpps_79    bpps_80    bpps_81   bpps_82 bpps_83 bpps_84    bpps_85 bpps_86
    ## 1 0.00275790 0.00598010 0.00597894 0.0138868       0       0 0.00152801       0
    ## 2 0.00969451 0.00376965 0.02291480 0.0000000       0       0 0.00000000       0
    ## 3 0.00000000 0.01750240 0.00000000 0.0000000       0       0 0.00000000       0
    ## 4 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 5 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 6 0.00000000 0.00235197 0.00000000 0.0000000       0       0 0.00000000       0
    ##   bpps_87 bpps_88 bpps_89 bpps_90 bpps_91 bpps_92 bpps_93    bpps_94 bpps_95
    ## 1       0       0       0       0       0       0       0 0.00952557       0
    ## 2       0       0       0       0       0       0       0 0.00578259       0
    ## 3       0       0       0       0       0       0       0 0.00000000       0
    ## 4       0       0       0       0       0       0       0 0.00000000       0
    ## 5       0       0       0       0       0       0       0 0.00000000       0
    ## 6       0       0       0       0       0       0       0 0.00000000       0
    ##   bpps_96    bpps_97 bpps_98 bpps_99   bpps_100 bpps_101 bpps_102   bpps_103
    ## 1       0 0.01114590       0       0 0.01163650        0        0 0.01053770
    ## 2       0 0.00633638       0       0 0.00603195        0        0 0.00563282
    ## 3       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 4       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 5       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 6       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ##   bpps_104 bpps_105   bpps_106 signal_to_noise SN_filter reactivity deg_Mg_pH10
    ## 1        0        0 0.01467360           6.894         1     0.3297      0.7556
    ## 2        0        0 0.00620374           6.894         1     1.5693      2.9830
    ## 3        0        0 0.00000000           6.894         1     1.1227      0.2526
    ## 4        0        0 0.00000000           6.894         1     0.8686      1.3789
    ## 5        0        0 0.00000000           6.894         1     0.7217      0.6376
    ## 6        0        0 0.00000000           6.894         1     0.4384      0.3313
    ##   deg_pH10 deg_Mg_50C deg_50C
    ## 1   2.3375     0.3581  0.6382
    ## 2   3.5060     2.9683  3.4773
    ## 3   0.3008     0.2589  0.9988
    ## 4   1.0108     1.4552  1.3228
    ## 5   0.2635     0.7244  0.7877
    ## 6   0.3403     0.4971  0.5890

``` r
data = data[,-1]
head(data)
```

    ##               id sequence index_sequence seq_be seq_af structure struct_be
    ## 1 id_001f94081_0        G              1      O      G         .         O
    ## 2 id_001f94081_1        G              2      G      A         .         .
    ## 3 id_001f94081_2        A              3      G      A         .         .
    ## 4 id_001f94081_3        A              4      A      A         .         .
    ## 5 id_001f94081_4        A              5      A      A         .         .
    ## 6 id_001f94081_5        A              6      A      G         (         .
    ##   struct_af predicted_loop_type loop_type_be loop_type_af bpps_0 bpps_1 bpps_2
    ## 1         .                   E            O            E      0      0      0
    ## 2         .                   E            E            E      0      0      0
    ## 3         .                   E            E            E      0      0      0
    ## 4         .                   E            E            E      0      0      0
    ## 5         (                   E            E            S      0      0      0
    ## 6         (                   S            E            S      0      0      0
    ##   bpps_3 bpps_4 bpps_5 bpps_6     bpps_7     bpps_8     bpps_9    bpps_10
    ## 1      0      0      0      0 0.00655413 0.00922102 0.00809437 0.02178570
    ## 2      0      0      0      0 0.01820530 0.00511209 0.03865270 0.00000000
    ## 3      0      0      0      0 0.00000000 0.02759040 0.00000000 0.00000000
    ## 4      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 5      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 6      0      0      0      0 0.00000000 0.00310716 0.00000000 0.00117008
    ##   bpps_11 bpps_12 bpps_13 bpps_14 bpps_15    bpps_16 bpps_17 bpps_18 bpps_19
    ## 1       0       0       0       0       0 0.00112002       0       0       0
    ## 2       0       0       0       0       0 0.00000000       0       0       0
    ## 3       0       0       0       0       0 0.00000000       0       0       0
    ## 4       0       0       0       0       0 0.00000000       0       0       0
    ## 5       0       0       0       0       0 0.00000000       0       0       0
    ## 6       0       0       0       0       0 0.00000000       0       0       0
    ##   bpps_20 bpps_21 bpps_22    bpps_23    bpps_24 bpps_25 bpps_26 bpps_27 bpps_28
    ## 1       0       0       0 0.00465301 0.00241507       0       0       0       0
    ## 2       0       0       0 0.00432340 0.00000000       0       0       0       0
    ## 3       0       0       0 0.00000000 0.00000000       0       0       0       0
    ## 4       0       0       0 0.00000000 0.00127806       0       0       0       0
    ## 5       0       0       0 0.00000000 0.00284297       0       0       0       0
    ## 6       0       0       0 0.00000000 0.06989900       0       0       0       0
    ##      bpps_29    bpps_30 bpps_31    bpps_32 bpps_33 bpps_34 bpps_35    bpps_36
    ## 1 0.01146960 0.00492862       0 0.00353196       0       0       0 0.00000000
    ## 2 0.00856126 0.00000000       0 0.00113814       0       0       0 0.00000000
    ## 3 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00000000
    ## 4 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00105140
    ## 5 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00702873
    ## 6 0.00000000 0.00685149       0 0.00000000       0       0       0 0.00000000
    ##      bpps_37    bpps_38    bpps_39    bpps_40 bpps_41 bpps_42 bpps_43 bpps_44
    ## 1 0.00000000 0.00000000 0.00159406 0.00629747       0       0       0       0
    ## 2 0.00000000 0.00144827 0.01117350 0.00000000       0       0       0       0
    ## 3 0.00132569 0.01070460 0.00000000 0.00000000       0       0       0       0
    ## 4 0.00947066 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 5 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 6 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ##   bpps_45 bpps_46 bpps_47 bpps_48 bpps_49 bpps_50 bpps_51 bpps_52 bpps_53
    ## 1       0       0       0       0       0       0       0       0       0
    ## 2       0       0       0       0       0       0       0       0       0
    ## 3       0       0       0       0       0       0       0       0       0
    ## 4       0       0       0       0       0       0       0       0       0
    ## 5       0       0       0       0       0       0       0       0       0
    ## 6       0       0       0       0       0       0       0       0       0
    ##   bpps_54 bpps_55    bpps_56    bpps_57    bpps_58 bpps_59    bpps_60 bpps_61
    ## 1       0       0 0.00000000 0.00529590 0.00605378       0 0.00000000       0
    ## 2       0       0 0.00515096 0.00579555 0.00000000       0 0.00000000       0
    ## 3       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 4       0       0 0.00000000 0.00000000 0.00000000       0 0.00132209       0
    ## 5       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 6       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ##     bpps_62   bpps_63 bpps_64 bpps_65    bpps_66 bpps_67 bpps_68 bpps_69
    ## 1 0.0012753 0.0136668       0       0 0.00152313       0       0       0
    ## 2 0.0133479 0.0000000       0       0 0.00000000       0       0       0
    ## 3 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 4 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 5 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 6 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ##   bpps_70 bpps_71 bpps_72 bpps_73 bpps_74 bpps_75    bpps_76    bpps_77 bpps_78
    ## 1       0       0       0       0       0       0 0.00000000 0.00141133       0
    ## 2       0       0       0       0       0       0 0.00000000 0.00443669       0
    ## 3       0       0       0       0       0       0 0.00287931 0.00000000       0
    ## 4       0       0       0       0       0       0 0.00000000 0.00000000       0
    ## 5       0       0       0       0       0       0 0.00140816 0.00000000       0
    ## 6       0       0       0       0       0       0 0.04401610 0.00000000       0
    ##      bpps_79    bpps_80    bpps_81   bpps_82 bpps_83 bpps_84    bpps_85 bpps_86
    ## 1 0.00275790 0.00598010 0.00597894 0.0138868       0       0 0.00152801       0
    ## 2 0.00969451 0.00376965 0.02291480 0.0000000       0       0 0.00000000       0
    ## 3 0.00000000 0.01750240 0.00000000 0.0000000       0       0 0.00000000       0
    ## 4 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 5 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 6 0.00000000 0.00235197 0.00000000 0.0000000       0       0 0.00000000       0
    ##   bpps_87 bpps_88 bpps_89 bpps_90 bpps_91 bpps_92 bpps_93    bpps_94 bpps_95
    ## 1       0       0       0       0       0       0       0 0.00952557       0
    ## 2       0       0       0       0       0       0       0 0.00578259       0
    ## 3       0       0       0       0       0       0       0 0.00000000       0
    ## 4       0       0       0       0       0       0       0 0.00000000       0
    ## 5       0       0       0       0       0       0       0 0.00000000       0
    ## 6       0       0       0       0       0       0       0 0.00000000       0
    ##   bpps_96    bpps_97 bpps_98 bpps_99   bpps_100 bpps_101 bpps_102   bpps_103
    ## 1       0 0.01114590       0       0 0.01163650        0        0 0.01053770
    ## 2       0 0.00633638       0       0 0.00603195        0        0 0.00563282
    ## 3       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 4       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 5       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 6       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ##   bpps_104 bpps_105   bpps_106 signal_to_noise SN_filter reactivity deg_Mg_pH10
    ## 1        0        0 0.01467360           6.894         1     0.3297      0.7556
    ## 2        0        0 0.00620374           6.894         1     1.5693      2.9830
    ## 3        0        0 0.00000000           6.894         1     1.1227      0.2526
    ## 4        0        0 0.00000000           6.894         1     0.8686      1.3789
    ## 5        0        0 0.00000000           6.894         1     0.7217      0.6376
    ## 6        0        0 0.00000000           6.894         1     0.4384      0.3313
    ##   deg_pH10 deg_Mg_50C deg_50C
    ## 1   2.3375     0.3581  0.6382
    ## 2   3.5060     2.9683  3.4773
    ## 3   0.3008     0.2589  0.9988
    ## 4   1.0108     1.4552  1.3228
    ## 5   0.2635     0.7244  0.7877
    ## 6   0.3403     0.4971  0.5890

On change les types des variables qui sont mal codées.

``` r
data=data %>% mutate(sequence = as.factor(sequence)) %>% 
  mutate(seq_be = as.factor(seq_be)) %>% 
  mutate(seq_af = as.factor(seq_af)) %>% 
  mutate(sequence = as.factor(sequence)) %>% 
  mutate(structure = as.factor(structure)) %>%
  mutate(struct_be = as.factor(struct_be)) %>% 
  mutate(struct_af = as.factor(struct_af)) %>% 
  mutate(predicted_loop_type = as.factor(predicted_loop_type)) %>% 
  mutate(loop_type_be = as.factor(loop_type_be)) %>% 
  mutate(loop_type_af = as.factor(loop_type_af)) 
```

``` r
length_sequence_train <- 68
```

On filtre maintenant les données qui ont SN\_filter=0.

``` r
print(sum(is.na(data)))
```

    ## [1] 0

``` r
print(sum(data$SN_filter==0)/length_sequence_train) # Nombre d'individus dont le SN_filter=0
```

    ## [1] 811

``` r
data=data[data$SN_filter==1,]
rownames(data)=NULL#1:108052
```

Plutôt que mettre à 0 les valeurs négatives, on va effectuer une
translation sur chaque label en soustrayant chacune de ses valeurs par
la valeur minimale du label puis en ajoutant un bruit afin de se placer
sur \(\mathbb{R}_+^*\).

``` r
p = dim(data)[2]
bruit = 1e-12
```

Initialement, il existe des valeurs négatives pour nos labels.

``` r
sum(data[,(p-4):p] <= 0) # nb total de lignes où il existe des labels qui ont des valeurs négatives
```

    ## [1] 23008

On peut aussi afficher le nombre de lignes où il y a des valeurs
négatives pour chacun de nos labels. On peut remarquer que chaque label
en possède.

``` r
sum(data$reactivity <= 0)
```

    ## [1] 7070

``` r
sum(data$deg_50C <= 0)
```

    ## [1] 5512

``` r
sum(data$deg_Mg_50C <= 0)
```

    ## [1] 4495

``` r
sum(data$deg_pH10 <= 0)
```

    ## [1] 3937

``` r
sum(data$deg_Mg_pH10 <= 0)
```

    ## [1] 1994

On stocke une copie des données initiales dans un dataframe, afin de
pouvoir les utiliser pour calculer les erreurs de prédiction de nos
futurs modèles mais aussi pour construire les futurs modèles Random
Forest (il n’y a pas besoin de translater les labels pour ces modèle).

``` r
# original_data <- data
```

On effectue une translation pour se placer sur \(\mathbb{R}_+^*\).

``` r
translation_labels <- c()
for (i in (p-4):p)
{
  # On stocke les valeurs utilisées lors des translations de chaque label
  # afin de pouvoir revenir à leurs valeurs initiales
  translation_labels <- c(translation_labels, min(data[,i]) - bruit) 
  # On soustrait à chaque label son minimum (qui est une valeur strictement négative)
  # l'ajout du bruit permet ensuite d'éliminer les valeurs nulles.
  data[,i] <- data[,i] - min(data[,i]) + bruit 
}
translation_labels <- data.frame(t(translation_labels))
colnames(translation_labels) <- colnames(data)[(p-4):p]
```

On a bien retiré toutes les valeurs négatives.

``` r
sum(data[,(p-4):p] <= 0) # Il n'y a plus aucune valeur négative
```

    ## [1] 0

Il suffira d’ajouter pour chaque label sa valeur dans ce dataframe pour
revenir à ses valeurs initiales.

``` r
translation_labels
```

    ##   reactivity deg_Mg_pH10 deg_pH10 deg_Mg_50C deg_50C
    ## 1    -0.3851     -0.2853  -0.4997    -0.4982 -0.4965

<a id="split1"></a>

# Séparation train/validation

``` r
tamp=train_test_split(data)
index_train = tamp$index_train

data_train=tamp$train
rownames(data_train) <- NULL

data_val=tamp$val
rownames(data_val) <- NULL

rm(tamp)
```

``` r
# Valeurs initiales des labels pour le train
# original_data_train = original_data[index_train,]
# rownames(original_data_train) <- NULL

# Valeurs initiales des labels pour la validation
# original_data_val = original_data[-index_train,]
# rownames(original_data_val) <- NULL
```

``` r
sum(is.na(data_train))
```

    ## [1] 0

``` r
sum(is.na(data_val))
```

    ## [1] 0

``` r
dim(data_train)[1]+dim(data_val)[1]-dim(data)[1]
```

    ## [1] 0

<a id="glm"></a>

# GLM: loi Gamma

Initialisation de vecteurs pour stocker nos résultats.

Résultats pour le label `reactivity`.

``` r
models_reactivity <- c()
errors_reactivity_train <- c()
errors_reactivity_val <- c()
```

Résultats pour le label `deg_Mg_pH10`.

``` r
models_deg_Mg_pH10 <- c()
errors_deg_Mg_pH10_train <- c()
errors_deg_Mg_pH10_val <- c()
```

Résultats pour le label `deg_pH10`.

``` r
models_deg_pH10 <- c()
errors_deg_pH10_train <- c()
errors_deg_pH10_val <- c()
```

Résultats pour le label `deg_Mg_50C`.

``` r
models_deg_Mg_50C <- c()
errors_deg_Mg_50C_train <- c()
errors_deg_Mg_50C_val <- c()
```

Résultats pour le label `deg_50C`.

``` r
models_deg_50C <- c()
errors_deg_50C_train <- c()
errors_deg_50C_val <- c()
```

Formule du modèle initial utilisé.

``` r
formula_model_full <- " ~ sequence + index_sequence + structure + predicted_loop_type + seq_be + seq_af + struct_be + struct_af + loop_type_be + loop_type_af"
for(i in 0:106)
{
  formula_model_full <- paste0(formula_model_full, " + bpps_", i)
}
print(formula_model_full)
```

    ## [1] " ~ sequence + index_sequence + structure + predicted_loop_type + seq_be + seq_af + struct_be + struct_af + loop_type_be + loop_type_af + bpps_0 + bpps_1 + bpps_2 + bpps_3 + bpps_4 + bpps_5 + bpps_6 + bpps_7 + bpps_8 + bpps_9 + bpps_10 + bpps_11 + bpps_12 + bpps_13 + bpps_14 + bpps_15 + bpps_16 + bpps_17 + bpps_18 + bpps_19 + bpps_20 + bpps_21 + bpps_22 + bpps_23 + bpps_24 + bpps_25 + bpps_26 + bpps_27 + bpps_28 + bpps_29 + bpps_30 + bpps_31 + bpps_32 + bpps_33 + bpps_34 + bpps_35 + bpps_36 + bpps_37 + bpps_38 + bpps_39 + bpps_40 + bpps_41 + bpps_42 + bpps_43 + bpps_44 + bpps_45 + bpps_46 + bpps_47 + bpps_48 + bpps_49 + bpps_50 + bpps_51 + bpps_52 + bpps_53 + bpps_54 + bpps_55 + bpps_56 + bpps_57 + bpps_58 + bpps_59 + bpps_60 + bpps_61 + bpps_62 + bpps_63 + bpps_64 + bpps_65 + bpps_66 + bpps_67 + bpps_68 + bpps_69 + bpps_70 + bpps_71 + bpps_72 + bpps_73 + bpps_74 + bpps_75 + bpps_76 + bpps_77 + bpps_78 + bpps_79 + bpps_80 + bpps_81 + bpps_82 + bpps_83 + bpps_84 + bpps_85 + bpps_86 + bpps_87 + bpps_88 + bpps_89 + bpps_90 + bpps_91 + bpps_92 + bpps_93 + bpps_94 + bpps_95 + bpps_96 + bpps_97 + bpps_98 + bpps_99 + bpps_100 + bpps_101 + bpps_102 + bpps_103 + bpps_104 + bpps_105 + bpps_106"

## Reactivity

### Premier modèle

``` r
formula_gamma_reactivity = paste0("reactivity", formula_model_full)
```

``` r
model_gamma_reactivity = glm(formula = formula_gamma_reactivity,
                             family = Gamma(link = "log"), data = data_train)
```

``` r
summary(model_gamma_reactivity)
```

    ## 
    ## Call:
    ## glm(formula = formula_gamma_reactivity, family = Gamma(link = "log"), 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -1.53120  -0.24496  -0.06357   0.13649   2.88323  
    ## 
    ## Coefficients: (7 not defined because of singularities)
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.431e-01  7.261e-03  19.710  < 2e-16 ***
    ## sequenceC            -1.624e-01  3.953e-03 -41.095  < 2e-16 ***
    ## sequenceG             3.635e-02  3.473e-03  10.468  < 2e-16 ***
    ## sequenceU             3.902e-02  4.076e-03   9.573  < 2e-16 ***
    ## index_sequence       -5.001e-03  8.892e-05 -56.244  < 2e-16 ***
    ## structure)            5.503e-02  7.363e-03   7.473 7.89e-14 ***
    ## structure.            1.623e-01  1.133e-02  14.320  < 2e-16 ***
    ## predicted_loop_typeE -1.630e-01  1.820e-02  -8.958  < 2e-16 ***
    ## predicted_loop_typeH -1.499e-01  1.254e-02 -11.950  < 2e-16 ***
    ## predicted_loop_typeI -2.427e-01  1.126e-02 -21.542  < 2e-16 ***
    ## predicted_loop_typeM -1.583e-01  1.475e-02 -10.734  < 2e-16 ***
    ## predicted_loop_typeS         NA         NA      NA       NA    
    ## predicted_loop_typeX -1.630e-01  1.670e-02  -9.759  < 2e-16 ***
    ## seq_beC              -6.043e-03  3.741e-03  -1.615 0.106260    
    ## seq_beG               6.970e-02  3.283e-03  21.233  < 2e-16 ***
    ## seq_beO               6.799e-02  1.700e-02   3.998 6.38e-05 ***
    ## seq_beU               7.087e-02  3.890e-03  18.217  < 2e-16 ***
    ## seq_afC              -2.664e-01  3.752e-03 -71.018  < 2e-16 ***
    ## seq_afG              -2.904e-01  3.467e-03 -83.762  < 2e-16 ***
    ## seq_afO              -9.110e-02  1.309e-02  -6.960 3.43e-12 ***
    ## seq_afU               4.526e-02  3.921e-03  11.544  < 2e-16 ***
    ## struct_be)            2.617e-03  5.946e-03   0.440 0.659878    
    ## struct_be.            7.134e-02  9.885e-03   7.218 5.33e-13 ***
    ## struct_beO                   NA         NA      NA       NA    
    ## struct_af)            4.971e-02  5.942e-03   8.366  < 2e-16 ***
    ## struct_af.            1.650e-01  9.895e-03  16.677  < 2e-16 ***
    ## struct_afO                   NA         NA      NA       NA    
    ## loop_type_beE        -4.426e-02  1.486e-02  -2.978 0.002899 ** 
    ## loop_type_beH        -3.183e-02  1.100e-02  -2.893 0.003819 ** 
    ## loop_type_beI        -6.188e-03  1.049e-02  -0.590 0.555106    
    ## loop_type_beM        -5.495e-03  1.323e-02  -0.415 0.678010    
    ## loop_type_beO                NA         NA      NA       NA    
    ## loop_type_beS                NA         NA      NA       NA    
    ## loop_type_beX        -1.154e-02  1.512e-02  -0.763 0.445549    
    ## loop_type_afE        -1.174e-01  1.438e-02  -8.167 3.21e-16 ***
    ## loop_type_afH         4.330e-02  1.099e-02   3.939 8.18e-05 ***
    ## loop_type_afI        -7.012e-02  1.049e-02  -6.685 2.32e-11 ***
    ## loop_type_afM        -1.284e-02  1.293e-02  -0.994 0.320452    
    ## loop_type_afO                NA         NA      NA       NA    
    ## loop_type_afS                NA         NA      NA       NA    
    ## loop_type_afX        -2.312e-02  1.395e-02  -1.658 0.097375 .  
    ## bpps_0               -1.216e+00  1.341e-01  -9.072  < 2e-16 ***
    ## bpps_1               -1.022e+00  1.313e-01  -7.783 7.17e-15 ***
    ## bpps_2               -4.715e-02  2.095e-01  -0.225 0.821964    
    ## bpps_3               -8.376e-01  2.764e-01  -3.031 0.002441 ** 
    ## bpps_4               -4.348e-01  1.946e-01  -2.234 0.025488 *  
    ## bpps_5               -4.639e-01  2.252e-02 -20.597  < 2e-16 ***
    ## bpps_6               -5.352e-01  1.753e-02 -30.527  < 2e-16 ***
    ## bpps_7               -5.836e-01  1.647e-02 -35.428  < 2e-16 ***
    ## bpps_8               -5.726e-01  1.588e-02 -36.054  < 2e-16 ***
    ## bpps_9               -6.534e-01  1.646e-02 -39.682  < 2e-16 ***
    ## bpps_10              -6.392e-01  1.623e-02 -39.393  < 2e-16 ***
    ## bpps_11              -6.525e-01  1.681e-02 -38.818  < 2e-16 ***
    ## bpps_12              -6.463e-01  1.708e-02 -37.841  < 2e-16 ***
    ## bpps_13              -6.288e-01  1.798e-02 -34.980  < 2e-16 ***
    ## bpps_14              -6.638e-01  1.828e-02 -36.324  < 2e-16 ***
    ## bpps_15              -6.261e-01  1.873e-02 -33.420  < 2e-16 ***
    ## bpps_16              -6.285e-01  1.858e-02 -33.825  < 2e-16 ***
    ## bpps_17              -6.345e-01  1.691e-02 -37.523  < 2e-16 ***
    ## bpps_18              -6.149e-01  1.706e-02 -36.050  < 2e-16 ***
    ## bpps_19              -6.394e-01  1.715e-02 -37.283  < 2e-16 ***
    ## bpps_20              -6.902e-01  1.683e-02 -40.998  < 2e-16 ***
    ## bpps_21              -6.642e-01  1.667e-02 -39.839  < 2e-16 ***
    ## bpps_22              -6.817e-01  1.670e-02 -40.825  < 2e-16 ***
    ## bpps_23              -6.398e-01  1.753e-02 -36.508  < 2e-16 ***
    ## bpps_24              -6.046e-01  1.702e-02 -35.531  < 2e-16 ***
    ## bpps_25              -6.373e-01  1.742e-02 -36.578  < 2e-16 ***
    ## bpps_26              -6.364e-01  1.678e-02 -37.928  < 2e-16 ***
    ## bpps_27              -6.321e-01  1.664e-02 -37.989  < 2e-16 ***
    ## bpps_28              -6.457e-01  1.685e-02 -38.320  < 2e-16 ***
    ## bpps_29              -7.017e-01  1.666e-02 -42.123  < 2e-16 ***
    ## bpps_30              -7.022e-01  1.630e-02 -43.079  < 2e-16 ***
    ## bpps_31              -6.555e-01  1.610e-02 -40.711  < 2e-16 ***
    ## bpps_32              -6.565e-01  1.639e-02 -40.046  < 2e-16 ***
    ## bpps_33              -6.839e-01  1.722e-02 -39.725  < 2e-16 ***
    ## bpps_34              -6.027e-01  1.925e-02 -31.319  < 2e-16 ***
    ## bpps_35              -5.941e-01  2.103e-02 -28.243  < 2e-16 ***
    ## bpps_36              -5.395e-01  1.899e-02 -28.404  < 2e-16 ***
    ## bpps_37              -5.053e-01  1.893e-02 -26.695  < 2e-16 ***
    ## bpps_38              -5.640e-01  1.724e-02 -32.708  < 2e-16 ***
    ## bpps_39              -5.702e-01  1.731e-02 -32.934  < 2e-16 ***
    ## bpps_40              -6.188e-01  1.626e-02 -38.061  < 2e-16 ***
    ## bpps_41              -6.722e-01  1.583e-02 -42.459  < 2e-16 ***
    ## bpps_42              -6.690e-01  1.588e-02 -42.134  < 2e-16 ***
    ## bpps_43              -6.420e-01  1.649e-02 -38.942  < 2e-16 ***
    ## bpps_44              -6.220e-01  1.750e-02 -35.544  < 2e-16 ***
    ## bpps_45              -6.180e-01  1.770e-02 -34.914  < 2e-16 ***
    ## bpps_46              -6.033e-01  1.779e-02 -33.919  < 2e-16 ***
    ## bpps_47              -6.240e-01  1.675e-02 -37.258  < 2e-16 ***
    ## bpps_48              -5.533e-01  1.658e-02 -33.364  < 2e-16 ***
    ## bpps_49              -4.728e-01  1.618e-02 -29.216  < 2e-16 ***
    ## bpps_50              -5.870e-01  1.580e-02 -37.161  < 2e-16 ***
    ## bpps_51              -6.079e-01  1.685e-02 -36.073  < 2e-16 ***
    ## bpps_52              -6.261e-01  1.675e-02 -37.371  < 2e-16 ***
    ## bpps_53              -6.969e-01  1.720e-02 -40.517  < 2e-16 ***
    ## bpps_54              -6.462e-01  1.692e-02 -38.197  < 2e-16 ***
    ## bpps_55              -6.229e-01  1.795e-02 -34.695  < 2e-16 ***
    ## bpps_56              -6.567e-01  1.777e-02 -36.947  < 2e-16 ***
    ## bpps_57              -5.849e-01  1.727e-02 -33.860  < 2e-16 ***
    ## bpps_58              -6.569e-01  1.745e-02 -37.647  < 2e-16 ***
    ## bpps_59              -6.313e-01  1.714e-02 -36.834  < 2e-16 ***
    ## bpps_60              -6.255e-01  1.689e-02 -37.042  < 2e-16 ***
    ## bpps_61              -6.524e-01  1.631e-02 -39.997  < 2e-16 ***
    ## bpps_62              -6.674e-01  1.588e-02 -42.027  < 2e-16 ***
    ## bpps_63              -7.064e-01  1.601e-02 -44.108  < 2e-16 ***
    ## bpps_64              -6.668e-01  1.655e-02 -40.304  < 2e-16 ***
    ## bpps_65              -6.698e-01  1.766e-02 -37.931  < 2e-16 ***
    ## bpps_66              -6.220e-01  1.968e-02 -31.599  < 2e-16 ***
    ## bpps_67              -5.812e-01  2.644e-02 -21.979  < 2e-16 ***
    ## bpps_68              -3.974e-01  1.148e-01  -3.463 0.000535 ***
    ## bpps_69              -5.630e-01  1.166e-01  -4.829 1.38e-06 ***
    ## bpps_70              -5.081e-01  1.179e-01  -4.309 1.64e-05 ***
    ## bpps_71              -5.704e-01  1.170e-01  -4.876 1.08e-06 ***
    ## bpps_72              -5.671e-01  1.184e-01  -4.789 1.68e-06 ***
    ## bpps_73              -6.351e-01  1.235e-01  -5.141 2.74e-07 ***
    ## bpps_74              -5.854e-01  1.160e-01  -5.047 4.50e-07 ***
    ## bpps_75              -6.215e-01  1.236e-01  -5.029 4.93e-07 ***
    ## bpps_76              -8.443e-01  1.219e-01  -6.927 4.33e-12 ***
    ## bpps_77              -7.309e-01  1.121e-01  -6.521 7.01e-11 ***
    ## bpps_78              -8.988e-01  1.260e-01  -7.133 9.93e-13 ***
    ## bpps_79              -1.063e+00  1.299e-01  -8.187 2.70e-16 ***
    ## bpps_80              -3.621e-01  1.362e-01  -2.658 0.007859 ** 
    ## bpps_81              -8.171e-01  1.389e-01  -5.882 4.08e-09 ***
    ## bpps_82              -4.347e-01  1.436e-01  -3.027 0.002468 ** 
    ## bpps_83              -7.197e-01  1.419e-01  -5.072 3.95e-07 ***
    ## bpps_84              -6.207e-01  1.577e-01  -3.935 8.32e-05 ***
    ## bpps_85              -5.526e-01  1.892e-01  -2.920 0.003498 ** 
    ## bpps_86              -4.192e-01  1.970e-01  -2.128 0.033331 *  
    ## bpps_87               4.570e-01  2.897e-01   1.577 0.114697    
    ## bpps_88              -3.508e-01  2.623e-01  -1.337 0.181161    
    ## bpps_89              -1.845e-01  2.284e-01  -0.808 0.419174    
    ## bpps_90              -1.008e+00  1.607e-01  -6.276 3.50e-10 ***
    ## bpps_91              -6.772e-01  2.051e-01  -3.301 0.000963 ***
    ## bpps_92               3.850e-01  3.782e-01   1.018 0.308684    
    ## bpps_93               1.081e-01  2.852e-01   0.379 0.704717    
    ## bpps_94               3.244e-01  2.353e-01   1.379 0.167922    
    ## bpps_95               5.436e-01  3.542e-01   1.535 0.124831    
    ## bpps_96              -1.290e+00  6.174e-01  -2.090 0.036619 *  
    ## bpps_97              -9.232e-01  5.016e-01  -1.840 0.065711 .  
    ## bpps_98              -1.023e+00  8.028e-01  -1.274 0.202660    
    ## bpps_99              -2.040e+00  9.468e-01  -2.155 0.031172 *  
    ## bpps_100             -6.898e-01  7.692e-01  -0.897 0.369893    
    ## bpps_101             -1.573e+00  1.126e+00  -1.397 0.162550    
    ## bpps_102              1.237e+00  1.035e+00   1.195 0.231982    
    ## bpps_103              2.630e+00  7.458e-01   3.526 0.000422 ***
    ## bpps_104              6.249e-01  1.041e+00   0.601 0.548155    
    ## bpps_105             -1.411e+00  8.809e-01  -1.602 0.109070    
    ## bpps_106             -9.013e-01  5.801e-01  -1.554 0.120263    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 0.1252911)
    ## 
    ##     Null deviance: 22756.3  on 86427  degrees of freedom
    ## Residual deviance:  9149.7  on 86287  degrees of freedom
    ## AIC: -16597
    ## 
    ## Number of Fisher Scoring iterations: 6

Il est important de noter que le premier modèle n’est pas de plein rang,
donc on ne peut pas se fier à ses prédictions. <br> Cependant, la
pénalisation va nous aider à résoudre ce problème.

``` r
y_pred_gamma_train = predict.glm(model_gamma_reactivity,data_train,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_train <- mean((y_pred_gamma_train-data_train$reactivity)^2,na.rm=TRUE)
print(error_gamma_train)
```

    ## [1] 0.1068768

``` r
y_pred_gamma_val=predict.glm(model_gamma_reactivity,data_val,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_val <- mean((y_pred_gamma_val-data_val$reactivity)^2,na.rm=TRUE)
print(error_gamma_val)
```

    ## [1] 0.1016558

``` r
models_reactivity <- c(models_reactivity, "model_gamma")
errors_reactivity_train <- c(errors_reactivity_train, error_gamma_train)
errors_reactivity_val <- c(errors_reactivity_val, error_gamma_val)
rm(error_gamma_val, error_gamma_train, y_pred_gamma_train, y_pred_gamma_val)
```

### Pénalisation ridge et lasso

On commence par calculer la matrice de design du
model\_gamma\_reactivity sur le train et le test.

``` r
# Matrice de design du train
data_train_pen = model.matrix(model_gamma_reactivity)
#head(data_train_pen)
```

``` r
# Pour faire la matrice de design de la validation
model_gamma_reactivity_val = glm(formula = formula_gamma_reactivity,
                                 family = Gamma(link = "log"), data = data_val)
data_val_pen = model.matrix(model_gamma_reactivity_val)
#head(data_val_pen)

# On supprime le modèle sur le test
rm(model_gamma_reactivity_val)
```

On pénalise le model\_gamma\_reactivity avec une pénalité ridge. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_reactivity_pen_ridge = cv.glmnet(data_train_pen, data_train$reactivity,
#                                             type.measure = "mse",
#                                             alpha = 0,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_reactivity_pen_ridge, "model_gamma_reactivity_pen_ridge.rds")
```

Chargement du modèle.

``` r
model_gamma_reactivity_pen_ridge <- readRDS("model_gamma_reactivity_pen_ridge.rds")
```

``` r
coef(model_gamma_reactivity_pen_ridge, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.1786622185
    ## (Intercept)           .           
    ## sequenceC            -0.1328994583
    ## sequenceG             0.0216523427
    ## sequenceU             0.0216305990
    ## index_sequence       -0.0044879502
    ## structure)            0.0507295230
    ## structure.            0.0780241110
    ## predicted_loop_typeE -0.0480957051
    ## predicted_loop_typeH -0.0004723771
    ## predicted_loop_typeI -0.1247645540
    ## predicted_loop_typeM -0.0374363351
    ## predicted_loop_typeS -0.0865190954
    ## predicted_loop_typeX -0.0458950735
    ## seq_beC              -0.0038828913
    ## seq_beG               0.0770569886
    ## seq_beO              -0.0241045775
    ## seq_beU               0.0577063810
    ## seq_afC              -0.2049616017
    ## seq_afG              -0.2211032111
    ## seq_afO              -0.0447441713
    ## seq_afU               0.0471460817
    ## struct_be)            0.0107950953
    ## struct_be.            0.0288905626
    ## struct_beO           -0.0211023473
    ## struct_af)            0.0417627640
    ## struct_af.            0.0650899866
    ## struct_afO           -0.0435198294
    ## loop_type_beE        -0.0393476042
    ## loop_type_beH        -0.0460132253
    ## loop_type_beI        -0.0046888368
    ## loop_type_beM         0.0010281560
    ## loop_type_beO        -0.0212012080
    ## loop_type_beS        -0.0297592324
    ## loop_type_beX        -0.0047051742
    ## loop_type_afE        -0.0245122410
    ## loop_type_afH         0.0514587942
    ## loop_type_afI        -0.0554592105
    ## loop_type_afM        -0.0113371044
    ## loop_type_afO        -0.0448990668
    ## loop_type_afS        -0.0647534782
    ## loop_type_afX        -0.0126112979
    ## bpps_0               -1.0899896677
    ## bpps_1               -0.7540941322
    ## bpps_2               -0.2206824866
    ## bpps_3               -0.7306859236
    ## bpps_4               -0.3341901220
    ## bpps_5               -0.2178107035
    ## bpps_6               -0.2345924065
    ## bpps_7               -0.2576452046
    ## bpps_8               -0.2554470895
    ## bpps_9               -0.3212980391
    ## bpps_10              -0.3133676437
    ## bpps_11              -0.3231094520
    ## bpps_12              -0.3163377783
    ## bpps_13              -0.3122903824
    ## bpps_14              -0.3303853045
    ## bpps_15              -0.3043358350
    ## bpps_16              -0.2957633564
    ## bpps_17              -0.3201366904
    ## bpps_18              -0.2969757517
    ## bpps_19              -0.3164331559
    ## bpps_20              -0.3464526822
    ## bpps_21              -0.3393922475
    ## bpps_22              -0.3538004812
    ## bpps_23              -0.3157573104
    ## bpps_24              -0.2977109673
    ## bpps_25              -0.3133221261
    ## bpps_26              -0.3108726177
    ## bpps_27              -0.2998983632
    ## bpps_28              -0.3151876781
    ## bpps_29              -0.3512394971
    ## bpps_30              -0.3471132555
    ## bpps_31              -0.3161422931
    ## bpps_32              -0.3190200524
    ## bpps_33              -0.3437266872
    ## bpps_34              -0.2843988801
    ## bpps_35              -0.2935846067
    ## bpps_36              -0.2483022529
    ## bpps_37              -0.2331825132
    ## bpps_38              -0.2734008495
    ## bpps_39              -0.2576561927
    ## bpps_40              -0.2851971176
    ## bpps_41              -0.3171132728
    ## bpps_42              -0.3104586012
    ## bpps_43              -0.2956939529
    ## bpps_44              -0.2965371549
    ## bpps_45              -0.3013886707
    ## bpps_46              -0.2787777395
    ## bpps_47              -0.2980719929
    ## bpps_48              -0.2605516031
    ## bpps_49              -0.2055605214
    ## bpps_50              -0.2698123049
    ## bpps_51              -0.2741090904
    ## bpps_52              -0.2952986764
    ## bpps_53              -0.3424583895
    ## bpps_54              -0.3070821708
    ## bpps_55              -0.2841115245
    ## bpps_56              -0.3112444737
    ## bpps_57              -0.2726227904
    ## bpps_58              -0.3155808253
    ## bpps_59              -0.2957384140
    ## bpps_60              -0.2834898342
    ## bpps_61              -0.3107053761
    ## bpps_62              -0.3241729761
    ## bpps_63              -0.3514989106
    ## bpps_64              -0.3273876671
    ## bpps_65              -0.3240056241
    ## bpps_66              -0.3053773801
    ## bpps_67              -0.2810912812
    ## bpps_68              -0.2235402808
    ## bpps_69              -0.4016908449
    ## bpps_70              -0.3322165564
    ## bpps_71              -0.3465613911
    ## bpps_72              -0.4115517766
    ## bpps_73              -0.3983870974
    ## bpps_74              -0.3238495190
    ## bpps_75              -0.4779792149
    ## bpps_76              -0.7186274089
    ## bpps_77              -0.5171714917
    ## bpps_78              -0.4448884645
    ## bpps_79              -0.5960634277
    ## bpps_80              -0.2032825795
    ## bpps_81              -0.5366458017
    ## bpps_82              -0.3200173400
    ## bpps_83              -0.4978097219
    ## bpps_84              -0.4271410163
    ## bpps_85              -0.3384947065
    ## bpps_86              -0.1189730062
    ## bpps_87               0.6381242416
    ## bpps_88              -0.2786886085
    ## bpps_89              -0.1670528653
    ## bpps_90              -0.7976171216
    ## bpps_91              -0.6242298878
    ## bpps_92               0.3529354096
    ## bpps_93              -0.1552040436
    ## bpps_94               0.4562596503
    ## bpps_95               0.3347893922
    ## bpps_96              -1.0415106723
    ## bpps_97              -0.7748114743
    ## bpps_98              -0.8524953341
    ## bpps_99              -1.3439733286
    ## bpps_100             -0.3703759451
    ## bpps_101             -1.0007330334
    ## bpps_102              0.1859643276
    ## bpps_103              2.2078107203
    ## bpps_104              0.0512690147
    ## bpps_105             -0.4952535448
    ## bpps_106              0.1022374789

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation ridge.

``` r
y_pred_ridge_gamma_train = predict(model_gamma_reactivity_pen_ridge, data_train_pen,
                                   type = "response", s = "lambda.min")
y_pred_ridge_gamma_val = predict(model_gamma_reactivity_pen_ridge, data_val_pen,
                                 type = "response", s = "lambda.min")
error_ridge_gamma_train <- mean((y_pred_ridge_gamma_train-data_train$reactivity)^2,na.rm=TRUE)
print(error_ridge_gamma_train)
```

    ## [1] 0.1152234

``` r
error_ridge_gamma_val <- mean((y_pred_ridge_gamma_val-data_val$reactivity)^2,na.rm=TRUE)
print(error_ridge_gamma_val)
```

    ## [1] 0.1104566

On pénalise le model\_gamma\_reactivity avec une pénalité lasso. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_reactivity_pen_lasso = cv.glmnet(data_train_pen, data_train$reactivity,
#                                             type.measure = "mse",
#                                             alpha = 1,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_reactivity_pen_lasso, "model_gamma_reactivity_pen_lasso.rds")
```

Chargement du modèle.

``` r
model_gamma_reactivity_pen_lasso <- readRDS("model_gamma_reactivity_pen_lasso.rds")
```

``` r
coef(model_gamma_reactivity_pen_lasso, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.1430457923
    ## (Intercept)           .           
    ## sequenceC            -0.1212098958
    ## sequenceG             0.0335706262
    ## sequenceU             0.0313183422
    ## index_sequence       -0.0050559425
    ## structure)            0.0744663959
    ## structure.            0.1525531653
    ## predicted_loop_typeE -0.1604756068
    ## predicted_loop_typeH -0.0983803725
    ## predicted_loop_typeI -0.2262518716
    ## predicted_loop_typeM -0.1318329181
    ## predicted_loop_typeS -0.0353058116
    ## predicted_loop_typeX -0.1411490974
    ## seq_beC               0.0028621398
    ## seq_beG               0.0852259515
    ## seq_beO              -0.0350513443
    ## seq_beU               0.0682784070
    ## seq_afC              -0.2196406498
    ## seq_afG              -0.2377864490
    ## seq_afO               .           
    ## seq_afU               0.0417078526
    ## struct_be)            0.0095321655
    ## struct_be.            0.0562474329
    ## struct_beO           -0.0008642420
    ## struct_af)            0.0526484459
    ## struct_af.            0.1226828664
    ## struct_afO            .           
    ## loop_type_beE        -0.0426602951
    ## loop_type_beH        -0.0573706248
    ## loop_type_beI        -0.0048419446
    ## loop_type_beM         0.0089424439
    ## loop_type_beO        -0.0009710586
    ## loop_type_beS        -0.0010830072
    ## loop_type_beX         0.0074592077
    ## loop_type_afE        -0.0195655007
    ## loop_type_afH         0.0640471511
    ## loop_type_afI        -0.0547207278
    ## loop_type_afM        -0.0125062758
    ## loop_type_afO        -0.0724587030
    ## loop_type_afS        -0.0002948314
    ## loop_type_afX        -0.0086558794
    ## bpps_0               -1.2800334735
    ## bpps_1               -0.8546971758
    ## bpps_2               -0.2798576756
    ## bpps_3               -0.8888219458
    ## bpps_4               -0.4898229137
    ## bpps_5               -0.3552651845
    ## bpps_6               -0.3700373384
    ## bpps_7               -0.3956477547
    ## bpps_8               -0.3913283777
    ## bpps_9               -0.4626345093
    ## bpps_10              -0.4580692358
    ## bpps_11              -0.4674933286
    ## bpps_12              -0.4582868700
    ## bpps_13              -0.4565192821
    ## bpps_14              -0.4744704528
    ## bpps_15              -0.4462636311
    ## bpps_16              -0.4365627502
    ## bpps_17              -0.4602472105
    ## bpps_18              -0.4331477159
    ## bpps_19              -0.4578628315
    ## bpps_20              -0.4873526719
    ## bpps_21              -0.4794703826
    ## bpps_22              -0.4953778422
    ## bpps_23              -0.4540216041
    ## bpps_24              -0.4330280850
    ## bpps_25              -0.4528030414
    ## bpps_26              -0.4475992951
    ## bpps_27              -0.4338547410
    ## bpps_28              -0.4503309949
    ## bpps_29              -0.4913147897
    ## bpps_30              -0.4846379227
    ## bpps_31              -0.4541771952
    ## bpps_32              -0.4551156065
    ## bpps_33              -0.4817474854
    ## bpps_34              -0.4154360236
    ## bpps_35              -0.4264464942
    ## bpps_36              -0.3767183524
    ## bpps_37              -0.3586229741
    ## bpps_38              -0.4016556713
    ## bpps_39              -0.3793532439
    ## bpps_40              -0.4048608247
    ## bpps_41              -0.4423931099
    ## bpps_42              -0.4359361716
    ## bpps_43              -0.4213869593
    ## bpps_44              -0.4229164271
    ## bpps_45              -0.4250159667
    ## bpps_46              -0.3992059435
    ## bpps_47              -0.4198293158
    ## bpps_48              -0.3799984092
    ## bpps_49              -0.3208422341
    ## bpps_50              -0.3874944118
    ## bpps_51              -0.3927100458
    ## bpps_52              -0.4153930650
    ## bpps_53              -0.4665329160
    ## bpps_54              -0.4279442383
    ## bpps_55              -0.4026332361
    ## bpps_56              -0.4310143296
    ## bpps_57              -0.3899624962
    ## bpps_58              -0.4359495411
    ## bpps_59              -0.4130125994
    ## bpps_60              -0.3980509457
    ## bpps_61              -0.4318358240
    ## bpps_62              -0.4444865946
    ## bpps_63              -0.4756309090
    ## bpps_64              -0.4483851503
    ## bpps_65              -0.4468571658
    ## bpps_66              -0.4306525679
    ## bpps_67              -0.4037938308
    ## bpps_68              -0.3278897381
    ## bpps_69              -0.5141986402
    ## bpps_70              -0.4392633930
    ## bpps_71              -0.4714295441
    ## bpps_72              -0.5446089247
    ## bpps_73              -0.5473862236
    ## bpps_74              -0.4564081258
    ## bpps_75              -0.5470896406
    ## bpps_76              -0.8547475894
    ## bpps_77              -0.6836770998
    ## bpps_78              -0.5802913267
    ## bpps_79              -0.7453699823
    ## bpps_80              -0.2944446249
    ## bpps_81              -0.6580821237
    ## bpps_82              -0.4228347705
    ## bpps_83              -0.6074232899
    ## bpps_84              -0.5596689383
    ## bpps_85              -0.4759808497
    ## bpps_86              -0.2279977691
    ## bpps_87               0.5074072767
    ## bpps_88              -0.3704698145
    ## bpps_89              -0.2648953713
    ## bpps_90              -0.9589404697
    ## bpps_91              -0.7047464869
    ## bpps_92               0.2007315493
    ## bpps_93              -0.1423235979
    ## bpps_94               0.3381593653
    ## bpps_95               0.3349556539
    ## bpps_96              -1.2703476079
    ## bpps_97              -1.0221340165
    ## bpps_98              -1.0065744039
    ## bpps_99              -1.6212705181
    ## bpps_100             -0.8352990288
    ## bpps_101             -1.1830878884
    ## bpps_102              0.4535609526
    ## bpps_103              2.7566657758
    ## bpps_104              .           
    ## bpps_105             -1.1736903269
    ## bpps_106             -0.3830092375

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation lasso.

``` r
y_pred_lasso_gamma_train = predict(model_gamma_reactivity_pen_lasso, data_train_pen,
                                   type="response", s="lambda.min")
error_lasso_gamma_train <- mean((y_pred_lasso_gamma_train-data_train$reactivity)^2,na.rm=TRUE)
print(error_lasso_gamma_train)
```

    ## [1] 0.1141861

``` r
y_pred_lasso_gamma_val = predict(model_gamma_reactivity_pen_lasso, data_val_pen,
                                 type="response", s="lambda.min")
error_lasso_gamma_val <- mean((y_pred_lasso_gamma_val-data_val$reactivity)^2,na.rm=TRUE)
print(error_lasso_gamma_val)
```

    ## [1] 0.1092906

On stocke les résultats et on supprime les variables temporaires.

``` r
models_reactivity <- c(models_reactivity, "model_gamma_ridge", "model_gamma_lasso")
errors_reactivity_train <- c(errors_reactivity_train, error_ridge_gamma_train,
                             error_lasso_gamma_train)
errors_reactivity_val <- c(errors_reactivity_val, error_ridge_gamma_val, error_lasso_gamma_val)
rm(error_ridge_gamma_val, error_lasso_gamma_val,
   error_ridge_gamma_train, error_lasso_gamma_train,
   y_pred_ridge_gamma_train, y_pred_ridge_gamma_val,
   y_pred_lasso_gamma_train, y_pred_lasso_gamma_val)
```

### Pénalisation elastic-net

On choisit \(\alpha\) qui minimise le MSE sur la validation.

``` r
#alpha_opti_enet_gamma_reactivity =
#  alpha_opti_enet(data_train = data_train_pen, data_val = data_val_pen,
#                  y_true_train = data_train$reactivity,
#                  y_true_val = data_val$reactivity)
```

On trouve \(\alpha = 0.6\).

``` r
#print(alpha_opti_enet_gamma_reactivity)
```

On construit le modèle avec le choix optimal pour \(\alpha\).

``` r
#model_gamma_reactivity_pen_enet = cv.glmnet(data_train_pen, data_train$reactivity,
#                                             type.measure = "mse",
#                                             alpha = alpha_opti_enet_gamma_reactivity,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_reactivity_pen_enet, "model_gamma_reactivity_pen_enet.rds")
```

Chargement du modèle.

``` r
model_gamma_reactivity_pen_enet <- readRDS("model_gamma_reactivity_pen_enet.rds")
```

``` r
coef(model_gamma_reactivity_pen_enet, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.2338250073
    ## (Intercept)           .           
    ## sequenceC            -0.1211339592
    ## sequenceG             0.0336351736
    ## sequenceU             0.0313783470
    ## index_sequence       -0.0050550884
    ## structure)            0.0742273117
    ## structure.            0.0602108006
    ## predicted_loop_typeE -0.1584619712
    ## predicted_loop_typeH -0.0975787172
    ## predicted_loop_typeI -0.2254157303
    ## predicted_loop_typeM -0.1308664710
    ## predicted_loop_typeS -0.1264589337
    ## predicted_loop_typeX -0.1404222501
    ## seq_beC               0.0028795285
    ## seq_beG               0.0852441277
    ## seq_beO              -0.0325497436
    ## seq_beU               0.0682938323
    ## seq_afC              -0.2196039472
    ## seq_afG              -0.2377632662
    ## seq_afO              -0.0234997609
    ## seq_afU               0.0417424551
    ## struct_be)            0.0096317705
    ## struct_be.            0.0570953284
    ## struct_beO           -0.0023010068
    ## struct_af)            0.0527437922
    ## struct_af.            0.1229996651
    ## struct_afO           -0.0197062829
    ## loop_type_beE        -0.0433043447
    ## loop_type_beH        -0.0573998845
    ## loop_type_beI        -0.0048846107
    ## loop_type_beM         0.0089993727
    ## loop_type_beO        -0.0019233881
    ## loop_type_beS        -0.0002716945
    ## loop_type_beX         0.0075968223
    ## loop_type_afE        -0.0205625178
    ## loop_type_afH         0.0636306974
    ## loop_type_afI        -0.0551777340
    ## loop_type_afM        -0.0130848993
    ## loop_type_afO        -0.0294892758
    ## loop_type_afS        -0.0004265087
    ## loop_type_afX        -0.0091482119
    ## bpps_0               -1.2809938841
    ## bpps_1               -0.8556997641
    ## bpps_2               -0.2808850430
    ## bpps_3               -0.8904531023
    ## bpps_4               -0.4909161909
    ## bpps_5               -0.3555822856
    ## bpps_6               -0.3704418433
    ## bpps_7               -0.3960793941
    ## bpps_8               -0.3917625882
    ## bpps_9               -0.4630600632
    ## bpps_10              -0.4584873435
    ## bpps_11              -0.4679218071
    ## bpps_12              -0.4586990028
    ## bpps_13              -0.4569405365
    ## bpps_14              -0.4748902821
    ## bpps_15              -0.4467116208
    ## bpps_16              -0.4370017863
    ## bpps_17              -0.4606767985
    ## bpps_18              -0.4335785622
    ## bpps_19              -0.4583041611
    ## bpps_20              -0.4877771634
    ## bpps_21              -0.4798993249
    ## bpps_22              -0.4958047152
    ## bpps_23              -0.4544622680
    ## bpps_24              -0.4334245725
    ## bpps_25              -0.4532011024
    ## bpps_26              -0.4480143037
    ## bpps_27              -0.4342838534
    ## bpps_28              -0.4507571343
    ## bpps_29              -0.4917501766
    ## bpps_30              -0.4850694286
    ## bpps_31              -0.4546154508
    ## bpps_32              -0.4555657451
    ## bpps_33              -0.4821933878
    ## bpps_34              -0.4158941322
    ## bpps_35              -0.4269067625
    ## bpps_36              -0.3771453252
    ## bpps_37              -0.3590998106
    ## bpps_38              -0.4021050938
    ## bpps_39              -0.3798271334
    ## bpps_40              -0.4053116241
    ## bpps_41              -0.4428341933
    ## bpps_42              -0.4363917154
    ## bpps_43              -0.4218454198
    ## bpps_44              -0.4234025952
    ## bpps_45              -0.4255173330
    ## bpps_46              -0.3996790531
    ## bpps_47              -0.4202909461
    ## bpps_48              -0.3804730332
    ## bpps_49              -0.3213336946
    ## bpps_50              -0.3879677279
    ## bpps_51              -0.3931859700
    ## bpps_52              -0.4158680953
    ## bpps_53              -0.4670135583
    ## bpps_54              -0.4284159540
    ## bpps_55              -0.4031477923
    ## bpps_56              -0.4315015048
    ## bpps_57              -0.3904526032
    ## bpps_58              -0.4364421114
    ## bpps_59              -0.4135144344
    ## bpps_60              -0.3985216602
    ## bpps_61              -0.4323080651
    ## bpps_62              -0.4449467396
    ## bpps_63              -0.4760881139
    ## bpps_64              -0.4488385289
    ## bpps_65              -0.4472492160
    ## bpps_66              -0.4310761535
    ## bpps_67              -0.4038982896
    ## bpps_68              -0.3287813709
    ## bpps_69              -0.5150303536
    ## bpps_70              -0.4400907637
    ## bpps_71              -0.4722161625
    ## bpps_72              -0.5454108330
    ## bpps_73              -0.5482889223
    ## bpps_74              -0.4572801991
    ## bpps_75              -0.5476694768
    ## bpps_76              -0.8553589582
    ## bpps_77              -0.6844004065
    ## bpps_78              -0.5811753212
    ## bpps_79              -0.7463124324
    ## bpps_80              -0.2954261200
    ## bpps_81              -0.6589776922
    ## bpps_82              -0.4236481781
    ## bpps_83              -0.6083506737
    ## bpps_84              -0.5608534010
    ## bpps_85              -0.4771765464
    ## bpps_86              -0.2291931580
    ## bpps_87               0.5084052041
    ## bpps_88              -0.3719510315
    ## bpps_89              -0.2663092930
    ## bpps_90              -0.9601482043
    ## bpps_91              -0.7059577341
    ## bpps_92               0.2026045315
    ## bpps_93              -0.1439513132
    ## bpps_94               0.3401429151
    ## bpps_95               0.3376493725
    ## bpps_96              -1.2735229262
    ## bpps_97              -1.0255464680
    ## bpps_98              -1.0121001680
    ## bpps_99              -1.6317840927
    ## bpps_100             -0.8508638071
    ## bpps_101             -1.1842884561
    ## bpps_102              0.4712853773
    ## bpps_103              2.7760454150
    ## bpps_104              .           
    ## bpps_105             -1.1834883591
    ## bpps_106             -0.3864762828

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation elastic-net.

``` r
y_pred_enet_gamma_train = predict(model_gamma_reactivity_pen_enet, data_train_pen,
                                   type = "response", s = "lambda.min")
error_enet_gamma_train <- mean((y_pred_enet_gamma_train - data_train$reactivity)^2, na.rm=TRUE)
print(error_enet_gamma_train)
```

    ## [1] 0.1141859

``` r
y_pred_enet_gamma_val = predict(model_gamma_reactivity_pen_enet, data_val_pen,
                                 type = "response", s = "lambda.min")
error_enet_gamma_val <- mean((y_pred_enet_gamma_val - data_val$reactivity)^2, na.rm=TRUE)
print(error_enet_gamma_val)
```

    ## [1] 0.1092899

On stocke les résultats et on supprime les variables temporaires.

``` r
models_reactivity <- c(models_reactivity, "model_gamma_enet")
errors_reactivity_train <- c(errors_reactivity_train, error_enet_gamma_train)
errors_reactivity_val <- c(errors_reactivity_val, error_enet_gamma_val)
rm(error_enet_gamma_train, error_enet_gamma_val,
   y_pred_enet_gamma_train, y_pred_enet_gamma_val)
```

### Récapitulatif des résultats

``` r
models_reactivity_errors_df <- data.frame(models_reactivity,
                                          errors_reactivity_train,
                                          errors_reactivity_val)
```

``` r
models_reactivity_errors_df
```

    ##   models_reactivity errors_reactivity_train errors_reactivity_val
    ## 1       model_gamma               0.1068768             0.1016558
    ## 2 model_gamma_ridge               0.1152234             0.1104566
    ## 3 model_gamma_lasso               0.1141861             0.1092906
    ## 4  model_gamma_enet               0.1141859             0.1092899

Le meilleur modèle (au sens de la minimisation du MSE sur la validation)
est le `model_gamma_enet` (si on exclut le premier modèle qui n’était
pas de plein rang).

``` r
models_reactivity_errors_df[which.min(errors_reactivity_val[-1]) + 1, ]
```

    ##   models_reactivity errors_reactivity_train errors_reactivity_val
    ## 4  model_gamma_enet               0.1141859             0.1092899

## deg\_Mg\_pH10

### Premier modèle

``` r
formula_gamma_deg_Mg_pH10 = paste0("deg_Mg_pH10", formula_model_full)
```

``` r
model_gamma_deg_Mg_pH10 = glm(formula = formula_gamma_deg_Mg_pH10,
                              family = Gamma(link = "log"), data = data_train)
```

``` r
summary(model_gamma_deg_Mg_pH10)
```

    ## 
    ## Call:
    ## glm(formula = formula_gamma_deg_Mg_pH10, family = Gamma(link = "log"), 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2336  -0.3104  -0.0960   0.1462   4.7865  
    ## 
    ## Coefficients: (7 not defined because of singularities)
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)          -0.0752991  0.0094029  -8.008 1.18e-15 ***
    ## sequenceC             0.0580910  0.0051190  11.348  < 2e-16 ***
    ## sequenceG             0.2219012  0.0044969  49.345  < 2e-16 ***
    ## sequenceU             0.1310492  0.0052787  24.826  < 2e-16 ***
    ## index_sequence       -0.0053870  0.0001151 -46.785  < 2e-16 ***
    ## structure)            0.0346754  0.0095351   3.637 0.000276 ***
    ## structure.            0.1428356  0.0146755   9.733  < 2e-16 ***
    ## predicted_loop_typeE  0.0507855  0.0235693   2.155 0.031186 *  
    ## predicted_loop_typeH -0.2005409  0.0162454 -12.344  < 2e-16 ***
    ## predicted_loop_typeI -0.3188556  0.0145880 -21.857  < 2e-16 ***
    ## predicted_loop_typeM -0.0607218  0.0191034  -3.179 0.001481 ** 
    ## predicted_loop_typeS         NA         NA      NA       NA    
    ## predicted_loop_typeX -0.0442084  0.0216263  -2.044 0.040937 *  
    ## seq_beC              -0.0474028  0.0048451  -9.784  < 2e-16 ***
    ## seq_beG               0.0703225  0.0042511  16.542  < 2e-16 ***
    ## seq_beO               0.0161048  0.0220212   0.731 0.464580    
    ## seq_beU               0.0855649  0.0050379  16.984  < 2e-16 ***
    ## seq_afC              -0.2500636  0.0048585 -51.469  < 2e-16 ***
    ## seq_afG              -0.3058735  0.0044903 -68.118  < 2e-16 ***
    ## seq_afO               0.3101969  0.0169498  18.301  < 2e-16 ***
    ## seq_afU               0.3296206  0.0050771  64.922  < 2e-16 ***
    ## struct_be)            0.0938403  0.0076996  12.188  < 2e-16 ***
    ## struct_be.            0.1240731  0.0128005   9.693  < 2e-16 ***
    ## struct_beO                   NA         NA      NA       NA    
    ## struct_af)            0.0646310  0.0076951   8.399  < 2e-16 ***
    ## struct_af.            0.1777790  0.0128141  13.874  < 2e-16 ***
    ## struct_afO                   NA         NA      NA       NA    
    ## loop_type_beE        -0.0948413  0.0192458  -4.928 8.33e-07 ***
    ## loop_type_beH         0.0202922  0.0142469   1.424 0.154357    
    ## loop_type_beI        -0.0170928  0.0135789  -1.259 0.208115    
    ## loop_type_beM        -0.0239393  0.0171391  -1.397 0.162487    
    ## loop_type_beO                NA         NA      NA       NA    
    ## loop_type_beS                NA         NA      NA       NA    
    ## loop_type_beX        -0.0606223  0.0195854  -3.095 0.001967 ** 
    ## loop_type_afE        -0.3206984  0.0186185 -17.225  < 2e-16 ***
    ## loop_type_afH        -0.0919437  0.0142349  -6.459 1.06e-10 ***
    ## loop_type_afI        -0.0647637  0.0135822  -4.768 1.86e-06 ***
    ## loop_type_afM        -0.0267803  0.0167416  -1.600 0.109685    
    ## loop_type_afO                NA         NA      NA       NA    
    ## loop_type_afS                NA         NA      NA       NA    
    ## loop_type_afX        -0.0096253  0.0180600  -0.533 0.594062    
    ## bpps_0               -1.0523101  0.1736056  -6.061 1.35e-09 ***
    ## bpps_1               -0.8598833  0.1700094  -5.058 4.25e-07 ***
    ## bpps_2               -0.5701533  0.2713334  -2.101 0.035617 *  
    ## bpps_3               -1.2608241  0.3579111  -3.523 0.000427 ***
    ## bpps_4               -0.6063876  0.2520477  -2.406 0.016137 *  
    ## bpps_5               -0.2632236  0.0291656  -9.025  < 2e-16 ***
    ## bpps_6               -0.3196738  0.0227042 -14.080  < 2e-16 ***
    ## bpps_7               -0.4373412  0.0213329 -20.501  < 2e-16 ***
    ## bpps_8               -0.4511917  0.0205670 -21.938  < 2e-16 ***
    ## bpps_9               -0.4880342  0.0213219 -22.889  < 2e-16 ***
    ## bpps_10              -0.5752945  0.0210134 -27.378  < 2e-16 ***
    ## bpps_11              -0.5926744  0.0217676 -27.227  < 2e-16 ***
    ## bpps_12              -0.5324343  0.0221162 -24.074  < 2e-16 ***
    ## bpps_13              -0.5572696  0.0232777 -23.940  < 2e-16 ***
    ## bpps_14              -0.6151627  0.0236669 -25.992  < 2e-16 ***
    ## bpps_15              -0.6221824  0.0242610 -25.645  < 2e-16 ***
    ## bpps_16              -0.6190102  0.0240612 -25.727  < 2e-16 ***
    ## bpps_17              -0.5862437  0.0218977 -26.772  < 2e-16 ***
    ## bpps_18              -0.5665480  0.0220901 -25.647  < 2e-16 ***
    ## bpps_19              -0.5948619  0.0222103 -26.783  < 2e-16 ***
    ## bpps_20              -0.6238446  0.0217997 -28.617  < 2e-16 ***
    ## bpps_21              -0.6606376  0.0215910 -30.598  < 2e-16 ***
    ## bpps_22              -0.6086353  0.0216239 -28.146  < 2e-16 ***
    ## bpps_23              -0.6342329  0.0226955 -27.945  < 2e-16 ***
    ## bpps_24              -0.6133786  0.0220346 -27.837  < 2e-16 ***
    ## bpps_25              -0.5870419  0.0225630 -26.018  < 2e-16 ***
    ## bpps_26              -0.5635591  0.0217301 -25.934  < 2e-16 ***
    ## bpps_27              -0.5854445  0.0215487 -27.168  < 2e-16 ***
    ## bpps_28              -0.6063938  0.0218198 -27.791  < 2e-16 ***
    ## bpps_29              -0.6480980  0.0215717 -30.044  < 2e-16 ***
    ## bpps_30              -0.6581763  0.0211093 -31.179  < 2e-16 ***
    ## bpps_31              -0.6431314  0.0208498 -30.846  < 2e-16 ***
    ## bpps_32              -0.6525106  0.0212288 -30.737  < 2e-16 ***
    ## bpps_33              -0.6493560  0.0222934 -29.128  < 2e-16 ***
    ## bpps_34              -0.5741010  0.0249226 -23.035  < 2e-16 ***
    ## bpps_35              -0.6220143  0.0272393 -22.835  < 2e-16 ***
    ## bpps_36              -0.5041721  0.0245954 -20.499  < 2e-16 ***
    ## bpps_37              -0.4916176  0.0245143 -20.054  < 2e-16 ***
    ## bpps_38              -0.5961309  0.0223310 -26.695  < 2e-16 ***
    ## bpps_39              -0.5273996  0.0224197 -23.524  < 2e-16 ***
    ## bpps_40              -0.5608314  0.0210555 -26.636  < 2e-16 ***
    ## bpps_41              -0.5650619  0.0205010 -27.563  < 2e-16 ***
    ## bpps_42              -0.6049130  0.0205627 -29.418  < 2e-16 ***
    ## bpps_43              -0.5849177  0.0213496 -27.397  < 2e-16 ***
    ## bpps_44              -0.5497267  0.0226617 -24.258  < 2e-16 ***
    ## bpps_45              -0.5455664  0.0229222 -23.801  < 2e-16 ***
    ## bpps_46              -0.4957340  0.0230334 -21.522  < 2e-16 ***
    ## bpps_47              -0.4941011  0.0216878 -22.782  < 2e-16 ***
    ## bpps_48              -0.5142905  0.0214771 -23.946  < 2e-16 ***
    ## bpps_49              -0.5205840  0.0209568 -24.841  < 2e-16 ***
    ## bpps_50              -0.5751958  0.0204566 -28.118  < 2e-16 ***
    ## bpps_51              -0.5046010  0.0218250 -23.120  < 2e-16 ***
    ## bpps_52              -0.5905411  0.0216955 -27.220  < 2e-16 ***
    ## bpps_53              -0.5749288  0.0222754 -25.810  < 2e-16 ***
    ## bpps_54              -0.6074759  0.0219087 -27.728  < 2e-16 ***
    ## bpps_55              -0.5732223  0.0232501 -24.655  < 2e-16 ***
    ## bpps_56              -0.6189935  0.0230162 -26.894  < 2e-16 ***
    ## bpps_57              -0.5447639  0.0223684 -24.354  < 2e-16 ***
    ## bpps_58              -0.6009865  0.0225947 -26.599  < 2e-16 ***
    ## bpps_59              -0.5396843  0.0221962 -24.314  < 2e-16 ***
    ## bpps_60              -0.5512011  0.0218688 -25.205  < 2e-16 ***
    ## bpps_61              -0.5532052  0.0211224 -26.190  < 2e-16 ***
    ## bpps_62              -0.5800759  0.0205635 -28.209  < 2e-16 ***
    ## bpps_63              -0.5924112  0.0207384 -28.566  < 2e-16 ***
    ## bpps_64              -0.5616068  0.0214261 -26.211  < 2e-16 ***
    ## bpps_65              -0.5539933  0.0228688 -24.225  < 2e-16 ***
    ## bpps_66              -0.5066139  0.0254902 -19.875  < 2e-16 ***
    ## bpps_67              -0.3982278  0.0342455 -11.629  < 2e-16 ***
    ## bpps_68              -0.3729297  0.1486086  -2.509 0.012093 *  
    ## bpps_69              -0.4214908  0.1509938  -2.791 0.005248 ** 
    ## bpps_70              -0.4678087  0.1527005  -3.064 0.002188 ** 
    ## bpps_71              -0.5993003  0.1514688  -3.957 7.61e-05 ***
    ## bpps_72              -0.5026808  0.1533674  -3.278 0.001047 ** 
    ## bpps_73              -0.4502377  0.1599763  -2.814 0.004888 ** 
    ## bpps_74              -0.5029448  0.1502023  -3.348 0.000813 ***
    ## bpps_75              -0.4540567  0.1600373  -2.837 0.004552 ** 
    ## bpps_76              -0.9843014  0.1578365  -6.236 4.50e-10 ***
    ## bpps_77              -0.4058222  0.1451443  -2.796 0.005175 ** 
    ## bpps_78              -0.7125156  0.1631842  -4.366 1.26e-05 ***
    ## bpps_79              -0.9626832  0.1681875  -5.724 1.04e-08 ***
    ## bpps_80              -0.4934652  0.1763858  -2.798 0.005149 ** 
    ## bpps_81              -0.7018216  0.1799049  -3.901 9.58e-05 ***
    ## bpps_82              -0.3595550  0.1859697  -1.933 0.053189 .  
    ## bpps_83              -0.4083596  0.1837691  -2.222 0.026277 *  
    ## bpps_84              -0.1301484  0.2042566  -0.637 0.524009    
    ## bpps_85              -0.5092985  0.2450285  -2.079 0.037664 *  
    ## bpps_86              -0.4786451  0.2551218  -1.876 0.060639 .  
    ## bpps_87               1.8335412  0.3751329   4.888 1.02e-06 ***
    ## bpps_88              -0.0507360  0.3396953  -0.149 0.881272    
    ## bpps_89               0.4659445  0.2957531   1.575 0.115156    
    ## bpps_90              -0.1373454  0.2080711  -0.660 0.509199    
    ## bpps_91              -0.7329238  0.2656318  -2.759 0.005796 ** 
    ## bpps_92               1.6116429  0.4897546   3.291 0.001000 ***
    ## bpps_93               1.8568497  0.3693907   5.027 5.00e-07 ***
    ## bpps_94               0.2955288  0.3046859   0.970 0.332076    
    ## bpps_95               0.7513121  0.4586804   1.638 0.101428    
    ## bpps_96              -2.2083686  0.7995144  -2.762 0.005744 ** 
    ## bpps_97               1.7814613  0.6496170   2.742 0.006102 ** 
    ## bpps_98              -0.2280712  1.0396737  -0.219 0.826364    
    ## bpps_99              -0.0558357  1.2260751  -0.046 0.963677    
    ## bpps_100             -3.1834503  0.9961576  -3.196 0.001395 ** 
    ## bpps_101             -1.7409104  1.4583114  -1.194 0.232565    
    ## bpps_102             -0.6913975  1.3403481  -0.516 0.605971    
    ## bpps_103              5.3351707  0.9657898   5.524 3.32e-08 ***
    ## bpps_104             -0.4052954  1.3475695  -0.301 0.763598    
    ## bpps_105             -3.5428114  1.1407014  -3.106 0.001898 ** 
    ## bpps_106             -0.3764571  0.7512680  -0.501 0.616305    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 0.2101154)
    ## 
    ##     Null deviance: 26227  on 86427  degrees of freedom
    ## Residual deviance: 14049  on 86287  degrees of freedom
    ## AIC: 13326
    ## 
    ## Number of Fisher Scoring iterations: 9

Il est important de noter que le premier modèle n’est pas de plein rang,
donc on ne peut pas se fier à ses prédictions. <br> Cependant, la
pénalisation va nous aider à résoudre ce problème.

``` r
y_pred_gamma_train = predict.glm(model_gamma_deg_Mg_pH10,data_train,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_train <- mean((y_pred_gamma_train-data_train$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_gamma_train)
```

    ## [1] 0.1776042

``` r
y_pred_gamma_val=predict.glm(model_gamma_deg_Mg_pH10,data_val,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_val <- mean((y_pred_gamma_val-data_val$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_gamma_val)
```

    ## [1] 0.1791602

``` r
models_deg_Mg_pH10 <- c(models_deg_Mg_pH10, "model_gamma")
errors_deg_Mg_pH10_train <- c(errors_deg_Mg_pH10_train, error_gamma_train)
errors_deg_Mg_pH10_val <- c(errors_deg_Mg_pH10_val, error_gamma_val)
rm(error_gamma_val, error_gamma_train, y_pred_gamma_train, y_pred_gamma_val)
```

### Pénalisation ridge et lasso

On commence par calculer la matrice de design du
model\_gamma\_deg\_Mg\_pH10 sur le train et le test.

``` r
# Matrice de design du train
data_train_pen = model.matrix(model_gamma_deg_Mg_pH10)
#head(data_train_pen)
```

``` r
# Pour faire la matrice de design de la validation
model_gamma_deg_Mg_pH10_val = glm(formula = formula_gamma_deg_Mg_pH10,
                                 family = Gamma(link = "log"), data = data_val)
data_val_pen = model.matrix(model_gamma_deg_Mg_pH10_val)
#head(data_val_pen)

# On supprime le modèle sur le test
rm(model_gamma_deg_Mg_pH10_val)
```

On pénalise le model\_gamma\_deg\_Mg\_pH10 avec une pénalité ridge. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_Mg_pH10_pen_ridge = cv.glmnet(data_train_pen, data_train$deg_Mg_pH10,
#                                             type.measure = "mse",
#                                             alpha = 0,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_pH10_pen_ridge, "model_gamma_deg_Mg_pH10_pen_ridge.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_pH10_pen_ridge <- readRDS("model_gamma_deg_Mg_pH10_pen_ridge.rds")
```

``` r
coef(model_gamma_deg_Mg_pH10_pen_ridge, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                 1
    ## (Intercept)           1.025314287
    ## (Intercept)           .          
    ## sequenceC             0.037803193
    ## sequenceG             0.179041385
    ## sequenceU             0.123894670
    ## index_sequence       -0.004678260
    ## structure)            0.033170056
    ## structure.            0.067872858
    ## predicted_loop_typeE  0.014016607
    ## predicted_loop_typeH -0.110761887
    ## predicted_loop_typeI -0.200051537
    ## predicted_loop_typeM  0.007448353
    ## predicted_loop_typeS -0.076582676
    ## predicted_loop_typeX  0.022799166
    ## seq_beC              -0.028073871
    ## seq_beG               0.084035833
    ## seq_beO              -0.060061945
    ## seq_beU               0.076180039
    ## seq_afC              -0.164338636
    ## seq_afG              -0.190351046
    ## seq_afO               0.069253768
    ## seq_afU               0.288330926
    ## struct_be)            0.074741426
    ## struct_be.            0.051458249
    ## struct_beO           -0.053393397
    ## struct_af)            0.049954700
    ## struct_af.            0.056554309
    ## struct_afO            0.071027997
    ## loop_type_beE        -0.051259295
    ## loop_type_beH         0.006876073
    ## loop_type_beI        -0.018295858
    ## loop_type_beM        -0.014079689
    ## loop_type_beO        -0.051738085
    ## loop_type_beS        -0.050214998
    ## loop_type_beX        -0.038756276
    ## loop_type_afE        -0.105184957
    ## loop_type_afH        -0.037321394
    ## loop_type_afI        -0.033584157
    ## loop_type_afM         0.004080343
    ## loop_type_afO         0.067730524
    ## loop_type_afS        -0.066237570
    ## loop_type_afX         0.019067449
    ## bpps_0               -0.894699563
    ## bpps_1               -0.749581551
    ## bpps_2               -0.733782354
    ## bpps_3               -1.243157696
    ## bpps_4               -0.477132735
    ## bpps_5               -0.129852046
    ## bpps_6               -0.154665469
    ## bpps_7               -0.219758500
    ## bpps_8               -0.229983642
    ## bpps_9               -0.273246464
    ## bpps_10              -0.328837847
    ## bpps_11              -0.346537085
    ## bpps_12              -0.290888155
    ## bpps_13              -0.322773934
    ## bpps_14              -0.356376252
    ## bpps_15              -0.341650414
    ## bpps_16              -0.336422559
    ## bpps_17              -0.333017847
    ## bpps_18              -0.304629271
    ## bpps_19              -0.332968056
    ## bpps_20              -0.354410206
    ## bpps_21              -0.385421470
    ## bpps_22              -0.353273059
    ## bpps_23              -0.363972187
    ## bpps_24              -0.358779376
    ## bpps_25              -0.328908204
    ## bpps_26              -0.328824502
    ## bpps_27              -0.315747131
    ## bpps_28              -0.341379943
    ## bpps_29              -0.372236590
    ## bpps_30              -0.376749570
    ## bpps_31              -0.347908893
    ## bpps_32              -0.373567385
    ## bpps_33              -0.384949950
    ## bpps_34              -0.323648535
    ## bpps_35              -0.361056670
    ## bpps_36              -0.271637283
    ## bpps_37              -0.260282700
    ## bpps_38              -0.331218515
    ## bpps_39              -0.272372703
    ## bpps_40              -0.296121679
    ## bpps_41              -0.294273847
    ## bpps_42              -0.314842216
    ## bpps_43              -0.328979376
    ## bpps_44              -0.310947126
    ## bpps_45              -0.309682163
    ## bpps_46              -0.262466188
    ## bpps_47              -0.265186095
    ## bpps_48              -0.279333035
    ## bpps_49              -0.278511910
    ## bpps_50              -0.317759946
    ## bpps_51              -0.255142280
    ## bpps_52              -0.321184772
    ## bpps_53              -0.326147244
    ## bpps_54              -0.343538221
    ## bpps_55              -0.290929938
    ## bpps_56              -0.333960149
    ## bpps_57              -0.288051727
    ## bpps_58              -0.329091382
    ## bpps_59              -0.280601053
    ## bpps_60              -0.282368721
    ## bpps_61              -0.305138343
    ## bpps_62              -0.322642042
    ## bpps_63              -0.335507530
    ## bpps_64              -0.316603400
    ## bpps_65              -0.306078979
    ## bpps_66              -0.286716383
    ## bpps_67              -0.240677082
    ## bpps_68              -0.213155384
    ## bpps_69              -0.287919924
    ## bpps_70              -0.273700087
    ## bpps_71              -0.360323386
    ## bpps_72              -0.353337112
    ## bpps_73              -0.341200798
    ## bpps_74              -0.276804432
    ## bpps_75              -0.375028138
    ## bpps_76              -0.856630914
    ## bpps_77              -0.252694921
    ## bpps_78              -0.446028800
    ## bpps_79              -0.644093846
    ## bpps_80              -0.302335835
    ## bpps_81              -0.539699191
    ## bpps_82              -0.300175543
    ## bpps_83              -0.306142426
    ## bpps_84              -0.056445995
    ## bpps_85              -0.364593475
    ## bpps_86              -0.347593462
    ## bpps_87               1.107474588
    ## bpps_88               0.076453342
    ## bpps_89               0.405913673
    ## bpps_90              -0.135870233
    ## bpps_91              -0.724034220
    ## bpps_92               1.988756964
    ## bpps_93               1.106476814
    ## bpps_94               0.742397225
    ## bpps_95               0.192385119
    ## bpps_96              -1.862047674
    ## bpps_97               2.133561171
    ## bpps_98              -0.595131483
    ## bpps_99              -0.302293181
    ## bpps_100             -1.961368944
    ## bpps_101             -1.183543544
    ## bpps_102             -0.869736136
    ## bpps_103              4.033177441
    ## bpps_104             -0.888253260
    ## bpps_105             -2.562488696
    ## bpps_106              1.380385862

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation ridge.

``` r
y_pred_ridge_gamma_train = predict(model_gamma_deg_Mg_pH10_pen_ridge, data_train_pen,
                                   type = "response", s = "lambda.min")
y_pred_ridge_gamma_val = predict(model_gamma_deg_Mg_pH10_pen_ridge, data_val_pen,
                                 type = "response", s = "lambda.min")
error_ridge_gamma_train <- mean((y_pred_ridge_gamma_train-data_train$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_ridge_gamma_train)
```

    ## [1] 0.1849441

``` r
error_ridge_gamma_val <- mean((y_pred_ridge_gamma_val-data_val$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_ridge_gamma_val)
```

    ## [1] 0.1875455

On pénalise le model\_gamma\_deg\_Mg\_pH10 avec une pénalité lasso. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_Mg_pH10_pen_lasso = cv.glmnet(data_train_pen, data_train$deg_Mg_pH10,
#                                             type.measure = "mse",
#                                             alpha = 1,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_pH10_pen_lasso, "model_gamma_deg_Mg_pH10_pen_lasso.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_pH10_pen_lasso <- readRDS("model_gamma_deg_Mg_pH10_pen_lasso.rds")
```

``` r
coef(model_gamma_deg_Mg_pH10_pen_lasso, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.035166e+00
    ## (Intercept)           .           
    ## sequenceC             6.223983e-02
    ## sequenceG             2.031866e-01
    ## sequenceU             1.458218e-01
    ## index_sequence       -5.059159e-03
    ## structure)            2.794498e-02
    ## structure.            1.471848e-01
    ## predicted_loop_typeE  1.626971e-02
    ## predicted_loop_typeH -1.864277e-01
    ## predicted_loop_typeI -2.691632e-01
    ## predicted_loop_typeM -4.757876e-02
    ## predicted_loop_typeS  .           
    ## predicted_loop_typeX -2.956039e-02
    ## seq_beC              -2.320769e-02
    ## seq_beG               9.088033e-02
    ## seq_beO              -1.485170e-01
    ## seq_beU               8.459922e-02
    ## seq_afC              -1.654973e-01
    ## seq_afG              -1.938534e-01
    ## seq_afO               1.096067e-01
    ## seq_afU               2.986827e-01
    ## struct_be)            8.775802e-02
    ## struct_be.            1.038563e-01
    ## struct_beO           -8.519751e-04
    ## struct_af)            6.438566e-02
    ## struct_af.            9.280744e-04
    ## struct_afO            2.781254e-02
    ## loop_type_beE        -7.929145e-02
    ## loop_type_beH         1.440723e-02
    ## loop_type_beI        -1.434576e-02
    ## loop_type_beM        -9.198340e-03
    ## loop_type_beO        -6.337166e-05
    ## loop_type_beS        -6.057590e-04
    ## loop_type_beX        -3.378584e-02
    ## loop_type_afE        -1.665724e-01
    ## loop_type_afH        -4.902440e-02
    ## loop_type_afI        -5.214339e-02
    ## loop_type_afM        -1.773374e-02
    ## loop_type_afO         .           
    ## loop_type_afS        -1.447844e-01
    ## loop_type_afX        -2.531297e-04
    ## bpps_0               -1.069418e+00
    ## bpps_1               -8.860816e-01
    ## bpps_2               -8.310213e-01
    ## bpps_3               -1.423194e+00
    ## bpps_4               -6.272998e-01
    ## bpps_5               -2.198886e-01
    ## bpps_6               -2.478465e-01
    ## bpps_7               -3.167726e-01
    ## bpps_8               -3.255552e-01
    ## bpps_9               -3.694794e-01
    ## bpps_10              -4.305217e-01
    ## bpps_11              -4.509110e-01
    ## bpps_12              -3.931056e-01
    ## bpps_13              -4.274379e-01
    ## bpps_14              -4.598532e-01
    ## bpps_15              -4.444315e-01
    ## bpps_16              -4.382749e-01
    ## bpps_17              -4.355774e-01
    ## bpps_18              -4.010933e-01
    ## bpps_19              -4.329822e-01
    ## bpps_20              -4.540975e-01
    ## bpps_21              -4.861335e-01
    ## bpps_22              -4.567487e-01
    ## bpps_23              -4.666874e-01
    ## bpps_24              -4.569401e-01
    ## bpps_25              -4.290650e-01
    ## bpps_26              -4.276331e-01
    ## bpps_27              -4.124750e-01
    ## bpps_28              -4.383692e-01
    ## bpps_29              -4.728353e-01
    ## bpps_30              -4.768785e-01
    ## bpps_31              -4.483286e-01
    ## bpps_32              -4.755482e-01
    ## bpps_33              -4.882818e-01
    ## bpps_34              -4.225424e-01
    ## bpps_35              -4.599144e-01
    ## bpps_36              -3.649832e-01
    ## bpps_37              -3.524769e-01
    ## bpps_38              -4.274994e-01
    ## bpps_39              -3.638147e-01
    ## bpps_40              -3.827258e-01
    ## bpps_41              -3.821427e-01
    ## bpps_42              -4.058858e-01
    ## bpps_43              -4.235906e-01
    ## bpps_44              -4.063545e-01
    ## bpps_45              -4.016651e-01
    ## bpps_46              -3.505869e-01
    ## bpps_47              -3.534278e-01
    ## bpps_48              -3.698160e-01
    ## bpps_49              -3.684778e-01
    ## bpps_50              -4.088681e-01
    ## bpps_51              -3.413018e-01
    ## bpps_52              -4.105833e-01
    ## bpps_53              -4.172238e-01
    ## bpps_54              -4.368073e-01
    ## bpps_55              -3.813225e-01
    ## bpps_56              -4.245986e-01
    ## bpps_57              -3.754714e-01
    ## bpps_58              -4.194601e-01
    ## bpps_59              -3.698995e-01
    ## bpps_60              -3.667363e-01
    ## bpps_61              -3.946119e-01
    ## bpps_62              -4.100914e-01
    ## bpps_63              -4.259140e-01
    ## bpps_64              -4.045906e-01
    ## bpps_65              -3.920350e-01
    ## bpps_66              -3.756672e-01
    ## bpps_67              -3.182659e-01
    ## bpps_68              -3.230786e-01
    ## bpps_69              -3.813731e-01
    ## bpps_70              -3.551333e-01
    ## bpps_71              -4.593244e-01
    ## bpps_72              -4.528246e-01
    ## bpps_73              -4.493185e-01
    ## bpps_74              -3.872169e-01
    ## bpps_75              -4.021657e-01
    ## bpps_76              -9.204792e-01
    ## bpps_77              -3.678357e-01
    ## bpps_78              -5.729552e-01
    ## bpps_79              -7.772517e-01
    ## bpps_80              -3.890483e-01
    ## bpps_81              -6.383522e-01
    ## bpps_82              -3.796171e-01
    ## bpps_83              -3.931876e-01
    ## bpps_84              -1.529308e-01
    ## bpps_85              -4.925513e-01
    ## bpps_86              -4.426297e-01
    ## bpps_87               9.951969e-01
    ## bpps_88              -1.570808e-02
    ## bpps_89               2.800862e-01
    ## bpps_90              -3.194599e-01
    ## bpps_91              -8.293011e-01
    ## bpps_92               1.857342e+00
    ## bpps_93               1.095380e+00
    ## bpps_94               5.427054e-01
    ## bpps_95               1.352125e-01
    ## bpps_96              -2.226465e+00
    ## bpps_97               2.361621e+00
    ## bpps_98              -6.933447e-01
    ## bpps_99              -2.644152e-01
    ## bpps_100             -3.310798e+00
    ## bpps_101             -1.325176e+00
    ## bpps_102             -8.614248e-01
    ## bpps_103              5.097771e+00
    ## bpps_104             -1.022711e+00
    ## bpps_105             -3.238616e+00
    ## bpps_106              9.065648e-01

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation lasso.

``` r
y_pred_lasso_gamma_train = predict(model_gamma_deg_Mg_pH10_pen_lasso, data_train_pen,
                                   type="response", s="lambda.min")
error_lasso_gamma_train <- mean((y_pred_lasso_gamma_train-data_train$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_lasso_gamma_train)
```

    ## [1] 0.1843446

``` r
y_pred_lasso_gamma_val = predict(model_gamma_deg_Mg_pH10_pen_lasso, data_val_pen,
                                 type="response", s="lambda.min")
error_lasso_gamma_val <- mean((y_pred_lasso_gamma_val-data_val$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_lasso_gamma_val)
```

    ## [1] 0.1868774

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_Mg_pH10 <- c(models_deg_Mg_pH10, "model_gamma_ridge", "model_gamma_lasso")
errors_deg_Mg_pH10_train <- c(errors_deg_Mg_pH10_train, error_ridge_gamma_train,
                             error_lasso_gamma_train)
errors_deg_Mg_pH10_val <- c(errors_deg_Mg_pH10_val, error_ridge_gamma_val, error_lasso_gamma_val)
rm(error_ridge_gamma_val, error_lasso_gamma_val,
   error_ridge_gamma_train, error_lasso_gamma_train,
   y_pred_ridge_gamma_train, y_pred_ridge_gamma_val,
   y_pred_lasso_gamma_train, y_pred_lasso_gamma_val)
```

### Pénalisation elastic-net

On choisit \(\alpha\) qui minimise le MSE sur la validation.

``` r
#alpha_opti_enet_gamma_deg_Mg_pH10 =
#  alpha_opti_enet(data_train = data_train_pen, data_val = data_val_pen,
#                  y_true_train = data_train$deg_Mg_pH10,
#                  y_true_val = data_val$deg_Mg_pH10)
```

On trouve \(\alpha = 0.7\).

``` r
#print(alpha_opti_enet_gamma_deg_Mg_pH10)
```

On construit le modèle avec le choix optimal pour \(\alpha\).

``` r
#model_gamma_deg_Mg_pH10_pen_enet = cv.glmnet(data_train_pen, data_train$deg_Mg_pH10,
#                                             type.measure = "mse",
#                                             alpha = alpha_opti_enet_gamma_deg_Mg_pH10,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_pH10_pen_enet, "model_gamma_deg_Mg_pH10_pen_enet.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_pH10_pen_enet <- readRDS("model_gamma_deg_Mg_pH10_pen_enet.rds")
```

``` r
coef(model_gamma_deg_Mg_pH10_pen_enet, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.152934e+00
    ## (Intercept)           .           
    ## sequenceC             6.217344e-02
    ## sequenceG             2.031237e-01
    ## sequenceU             1.457676e-01
    ## index_sequence       -5.057055e-03
    ## structure)            2.789980e-02
    ## structure.            2.736379e-02
    ## predicted_loop_typeE  1.702414e-02
    ## predicted_loop_typeH -1.852430e-01
    ## predicted_loop_typeI -2.682227e-01
    ## predicted_loop_typeM -4.665419e-02
    ## predicted_loop_typeS -1.189451e-01
    ## predicted_loop_typeX -2.861798e-02
    ## seq_beC              -2.322335e-02
    ## seq_beG               9.087351e-02
    ## seq_beO              -1.363352e-01
    ## seq_beU               8.457656e-02
    ## seq_afC              -1.655008e-01
    ## seq_afG              -1.938531e-01
    ## seq_afO               4.315315e-02
    ## seq_afU               2.986614e-01
    ## struct_be)            8.766365e-02
    ## struct_be.            1.041034e-01
    ## struct_beO           -1.283279e-02
    ## struct_af)            6.435407e-02
    ## struct_af.            2.383042e-03
    ## struct_afO            5.830235e-02
    ## loop_type_beE        -7.941203e-02
    ## loop_type_beH         1.413184e-02
    ## loop_type_beI        -1.459551e-02
    ## loop_type_beM        -9.474603e-03
    ## loop_type_beO        -7.801004e-05
    ## loop_type_beS        -5.571743e-04
    ## loop_type_beX        -3.412672e-02
    ## loop_type_afE        -1.668739e-01
    ## loop_type_afH        -4.961404e-02
    ## loop_type_afI        -5.254021e-02
    ## loop_type_afM        -1.810531e-02
    ## loop_type_afO         3.691134e-02
    ## loop_type_afS        -1.437174e-01
    ## loop_type_afX        -6.205567e-04
    ## bpps_0               -1.068875e+00
    ## bpps_1               -8.857367e-01
    ## bpps_2               -8.307489e-01
    ## bpps_3               -1.422879e+00
    ## bpps_4               -6.270150e-01
    ## bpps_5               -2.196486e-01
    ## bpps_6               -2.476231e-01
    ## bpps_7               -3.165541e-01
    ## bpps_8               -3.253440e-01
    ## bpps_9               -3.692611e-01
    ## bpps_10              -4.302976e-01
    ## bpps_11              -4.506749e-01
    ## bpps_12              -3.928726e-01
    ## bpps_13              -4.271974e-01
    ## bpps_14              -4.596245e-01
    ## bpps_15              -4.442216e-01
    ## bpps_16              -4.380587e-01
    ## bpps_17              -4.353374e-01
    ## bpps_18              -4.008867e-01
    ## bpps_19              -4.327722e-01
    ## bpps_20              -4.538916e-01
    ## bpps_21              -4.859314e-01
    ## bpps_22              -4.565454e-01
    ## bpps_23              -4.664734e-01
    ## bpps_24              -4.567495e-01
    ## bpps_25              -4.288597e-01
    ## bpps_26              -4.274288e-01
    ## bpps_27              -4.122723e-01
    ## bpps_28              -4.381772e-01
    ## bpps_29              -4.726351e-01
    ## bpps_30              -4.766745e-01
    ## bpps_31              -4.481201e-01
    ## bpps_32              -4.753464e-01
    ## bpps_33              -4.880764e-01
    ## bpps_34              -4.223576e-01
    ## bpps_35              -4.597409e-01
    ## bpps_36              -3.648054e-01
    ## bpps_37              -3.523101e-01
    ## bpps_38              -4.273088e-01
    ## bpps_39              -3.636443e-01
    ## bpps_40              -3.825901e-01
    ## bpps_41              -3.820050e-01
    ## bpps_42              -4.057398e-01
    ## bpps_43              -4.234401e-01
    ## bpps_44              -4.062260e-01
    ## bpps_45              -4.015334e-01
    ## bpps_46              -3.504611e-01
    ## bpps_47              -3.532898e-01
    ## bpps_48              -3.696779e-01
    ## bpps_49              -3.683486e-01
    ## bpps_50              -4.087490e-01
    ## bpps_51              -3.411916e-01
    ## bpps_52              -4.104759e-01
    ## bpps_53              -4.171201e-01
    ## bpps_54              -4.366850e-01
    ## bpps_55              -3.812072e-01
    ## bpps_56              -4.244817e-01
    ## bpps_57              -3.753769e-01
    ## bpps_58              -4.193648e-01
    ## bpps_59              -3.697894e-01
    ## bpps_60              -3.666505e-01
    ## bpps_61              -3.945166e-01
    ## bpps_62              -4.099972e-01
    ## bpps_63              -4.258156e-01
    ## bpps_64              -4.044936e-01
    ## bpps_65              -3.919423e-01
    ## bpps_66              -3.755468e-01
    ## bpps_67              -3.181662e-01
    ## bpps_68              -3.228552e-01
    ## bpps_69              -3.811474e-01
    ## bpps_70              -3.549969e-01
    ## bpps_71              -4.590707e-01
    ## bpps_72              -4.526042e-01
    ## bpps_73              -4.491067e-01
    ## bpps_74              -3.870675e-01
    ## bpps_75              -4.020043e-01
    ## bpps_76              -9.204382e-01
    ## bpps_77              -3.676078e-01
    ## bpps_78              -5.726063e-01
    ## bpps_79              -7.770677e-01
    ## bpps_80              -3.889228e-01
    ## bpps_81              -6.382368e-01
    ## bpps_82              -3.794370e-01
    ## bpps_83              -3.930982e-01
    ## bpps_84              -1.528734e-01
    ## bpps_85              -4.922299e-01
    ## bpps_86              -4.423263e-01
    ## bpps_87               9.953375e-01
    ## bpps_88              -1.550623e-02
    ## bpps_89               2.802235e-01
    ## bpps_90              -3.190352e-01
    ## bpps_91              -8.291457e-01
    ## bpps_92               1.857703e+00
    ## bpps_93               1.095440e+00
    ## bpps_94               5.432502e-01
    ## bpps_95               1.350038e-01
    ## bpps_96              -2.226189e+00
    ## bpps_97               2.360426e+00
    ## bpps_98              -6.932861e-01
    ## bpps_99              -2.638867e-01
    ## bpps_100             -3.305646e+00
    ## bpps_101             -1.324613e+00
    ## bpps_102             -8.618846e-01
    ## bpps_103              5.093658e+00
    ## bpps_104             -1.022387e+00
    ## bpps_105             -3.237314e+00
    ## bpps_106              9.076623e-01

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation elastic-net.

``` r
y_pred_enet_gamma_train = predict(model_gamma_deg_Mg_pH10_pen_enet, data_train_pen,
                                   type = "response", s = "lambda.min")
error_enet_gamma_train <- mean((y_pred_enet_gamma_train - data_train$deg_Mg_pH10)^2, na.rm=TRUE)
print(error_enet_gamma_train)
```

    ## [1] 0.1843448

``` r
y_pred_enet_gamma_val = predict(model_gamma_deg_Mg_pH10_pen_enet, data_val_pen,
                                 type = "response", s = "lambda.min")
error_enet_gamma_val <- mean((y_pred_enet_gamma_val - data_val$deg_Mg_pH10)^2, na.rm=TRUE)
print(error_enet_gamma_val)
```

    ## [1] 0.1868764

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_Mg_pH10 <- c(models_deg_Mg_pH10, "model_gamma_enet")
errors_deg_Mg_pH10_train <- c(errors_deg_Mg_pH10_train, error_enet_gamma_train)
errors_deg_Mg_pH10_val <- c(errors_deg_Mg_pH10_val, error_enet_gamma_val)
rm(error_enet_gamma_train, error_enet_gamma_val,
   y_pred_enet_gamma_train, y_pred_enet_gamma_val)
```

### Récapitulatif des résultats

``` r
models_deg_Mg_pH10_errors_df <- data.frame(models_deg_Mg_pH10,
                                          errors_deg_Mg_pH10_train,
                                          errors_deg_Mg_pH10_val)
```

``` r
models_deg_Mg_pH10_errors_df
```

    ##   models_deg_Mg_pH10 errors_deg_Mg_pH10_train errors_deg_Mg_pH10_val
    ## 1        model_gamma                0.1776042              0.1791602
    ## 2  model_gamma_ridge                0.1849441              0.1875455
    ## 3  model_gamma_lasso                0.1843446              0.1868774
    ## 4   model_gamma_enet                0.1843448              0.1868764

Le meilleur modèle (au sens de la minimisation du MSE sur la validation)
est le `model_gamma_lasso` (si on exclut le premier modèle qui n’était
pas de plein rang).

``` r
models_deg_Mg_pH10_errors_df[which.min(errors_deg_Mg_pH10_val[-1]) + 1, ]
```

    ##   models_deg_Mg_pH10 errors_deg_Mg_pH10_train errors_deg_Mg_pH10_val
    ## 4   model_gamma_enet                0.1843448              0.1868764

## deg\_pH10

### Premier modèle

``` r
formula_gamma_deg_pH10 =  paste0("deg_pH10", formula_model_full)
```

``` r
model_gamma_deg_pH10 = glm(formula = formula_gamma_deg_pH10,
                             family = Gamma(link = "log"), data = data_train)
```

``` r
summary(model_gamma_deg_pH10)
```

    ## 
    ## Call:
    ## glm(formula = formula_gamma_deg_pH10, family = Gamma(link = "log"), 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -3.0740  -0.2285  -0.0644   0.1210   4.0622  
    ## 
    ## Coefficients: (7 not defined because of singularities)
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           5.608e-02  7.257e-03   7.727 1.11e-14 ***
    ## sequenceC             9.782e-02  3.951e-03  24.758  < 2e-16 ***
    ## sequenceG             1.780e-01  3.471e-03  51.271  < 2e-16 ***
    ## sequenceU             1.242e-01  4.074e-03  30.480  < 2e-16 ***
    ## index_sequence       -4.670e-03  8.887e-05 -52.549  < 2e-16 ***
    ## structure)            2.848e-02  7.359e-03   3.870 0.000109 ***
    ## structure.            6.864e-02  1.133e-02   6.060 1.37e-09 ***
    ## predicted_loop_typeE  3.120e-02  1.819e-02   1.715 0.086354 .  
    ## predicted_loop_typeH -1.412e-01  1.254e-02 -11.262  < 2e-16 ***
    ## predicted_loop_typeI -1.919e-01  1.126e-02 -17.042  < 2e-16 ***
    ## predicted_loop_typeM  2.170e-02  1.474e-02   1.472 0.141080    
    ## predicted_loop_typeS         NA         NA      NA       NA    
    ## predicted_loop_typeX  4.872e-02  1.669e-02   2.919 0.003518 ** 
    ## seq_beC              -2.073e-02  3.740e-03  -5.545 2.95e-08 ***
    ## seq_beG               7.868e-02  3.281e-03  23.980  < 2e-16 ***
    ## seq_beO               7.493e-01  1.700e-02  44.087  < 2e-16 ***
    ## seq_beU               5.757e-02  3.888e-03  14.804  < 2e-16 ***
    ## seq_afC              -1.846e-01  3.750e-03 -49.225  < 2e-16 ***
    ## seq_afG              -1.835e-01  3.466e-03 -52.932  < 2e-16 ***
    ## seq_afO               4.066e-01  1.308e-02  31.080  < 2e-16 ***
    ## seq_afU               1.657e-01  3.919e-03  42.273  < 2e-16 ***
    ## struct_be)            1.012e-01  5.943e-03  17.036  < 2e-16 ***
    ## struct_be.            1.093e-01  9.880e-03  11.064  < 2e-16 ***
    ## struct_beO                   NA         NA      NA       NA    
    ## struct_af)            2.102e-02  5.939e-03   3.539 0.000402 ***
    ## struct_af.            5.527e-02  9.890e-03   5.588 2.30e-08 ***
    ## struct_afO                   NA         NA      NA       NA    
    ## loop_type_beE         3.832e-02  1.485e-02   2.580 0.009894 ** 
    ## loop_type_beH         5.022e-02  1.100e-02   4.567 4.96e-06 ***
    ## loop_type_beI        -4.709e-03  1.048e-02  -0.449 0.653190    
    ## loop_type_beM         2.341e-02  1.323e-02   1.770 0.076741 .  
    ## loop_type_beO                NA         NA      NA       NA    
    ## loop_type_beS                NA         NA      NA       NA    
    ## loop_type_beX        -8.306e-03  1.512e-02  -0.549 0.582684    
    ## loop_type_afE        -3.712e-02  1.437e-02  -2.583 0.009794 ** 
    ## loop_type_afH        -5.056e-02  1.099e-02  -4.601 4.20e-06 ***
    ## loop_type_afI        -1.097e-02  1.048e-02  -1.046 0.295571    
    ## loop_type_afM        -1.578e-02  1.292e-02  -1.221 0.221964    
    ## loop_type_afO                NA         NA      NA       NA    
    ## loop_type_afS                NA         NA      NA       NA    
    ## loop_type_afX         2.862e-02  1.394e-02   2.053 0.040033 *  
    ## bpps_0               -4.235e-02  1.340e-01  -0.316 0.751933    
    ## bpps_1               -1.858e-01  1.312e-01  -1.416 0.156766    
    ## bpps_2                4.056e-01  2.094e-01   1.937 0.052758 .  
    ## bpps_3               -4.466e-01  2.762e-01  -1.617 0.105922    
    ## bpps_4               -3.082e-01  1.945e-01  -1.584 0.113170    
    ## bpps_5                3.277e-02  2.251e-02   1.456 0.145419    
    ## bpps_6               -2.058e-01  1.752e-02 -11.746  < 2e-16 ***
    ## bpps_7               -2.828e-01  1.647e-02 -17.175  < 2e-16 ***
    ## bpps_8               -3.146e-01  1.587e-02 -19.819  < 2e-16 ***
    ## bpps_9               -3.631e-01  1.646e-02 -22.063  < 2e-16 ***
    ## bpps_10              -4.399e-01  1.622e-02 -27.123  < 2e-16 ***
    ## bpps_11              -4.310e-01  1.680e-02 -25.651  < 2e-16 ***
    ## bpps_12              -4.188e-01  1.707e-02 -24.537  < 2e-16 ***
    ## bpps_13              -4.505e-01  1.797e-02 -25.075  < 2e-16 ***
    ## bpps_14              -4.565e-01  1.827e-02 -24.988  < 2e-16 ***
    ## bpps_15              -4.647e-01  1.873e-02 -24.819  < 2e-16 ***
    ## bpps_16              -4.568e-01  1.857e-02 -24.597  < 2e-16 ***
    ## bpps_17              -4.542e-01  1.690e-02 -26.876  < 2e-16 ***
    ## bpps_18              -4.387e-01  1.705e-02 -25.731  < 2e-16 ***
    ## bpps_19              -4.843e-01  1.714e-02 -28.249  < 2e-16 ***
    ## bpps_20              -4.923e-01  1.683e-02 -29.258  < 2e-16 ***
    ## bpps_21              -5.107e-01  1.666e-02 -30.643  < 2e-16 ***
    ## bpps_22              -4.658e-01  1.669e-02 -27.908  < 2e-16 ***
    ## bpps_23              -4.565e-01  1.752e-02 -26.061  < 2e-16 ***
    ## bpps_24              -4.289e-01  1.701e-02 -25.217  < 2e-16 ***
    ## bpps_25              -4.468e-01  1.741e-02 -25.659  < 2e-16 ***
    ## bpps_26              -4.271e-01  1.677e-02 -25.465  < 2e-16 ***
    ## bpps_27              -4.662e-01  1.663e-02 -28.031  < 2e-16 ***
    ## bpps_28              -4.776e-01  1.684e-02 -28.357  < 2e-16 ***
    ## bpps_29              -5.268e-01  1.665e-02 -31.640  < 2e-16 ***
    ## bpps_30              -5.198e-01  1.629e-02 -31.906  < 2e-16 ***
    ## bpps_31              -5.034e-01  1.609e-02 -31.279  < 2e-16 ***
    ## bpps_32              -5.030e-01  1.638e-02 -30.696  < 2e-16 ***
    ## bpps_33              -4.945e-01  1.721e-02 -28.740  < 2e-16 ***
    ## bpps_34              -4.537e-01  1.924e-02 -23.587  < 2e-16 ***
    ## bpps_35              -4.935e-01  2.102e-02 -23.471  < 2e-16 ***
    ## bpps_36              -4.052e-01  1.898e-02 -21.346  < 2e-16 ***
    ## bpps_37              -4.010e-01  1.892e-02 -21.192  < 2e-16 ***
    ## bpps_38              -4.830e-01  1.724e-02 -28.021  < 2e-16 ***
    ## bpps_39              -4.345e-01  1.730e-02 -25.110  < 2e-16 ***
    ## bpps_40              -4.380e-01  1.625e-02 -26.952  < 2e-16 ***
    ## bpps_41              -4.336e-01  1.582e-02 -27.406  < 2e-16 ***
    ## bpps_42              -4.523e-01  1.587e-02 -28.501  < 2e-16 ***
    ## bpps_43              -4.543e-01  1.648e-02 -27.571  < 2e-16 ***
    ## bpps_44              -4.221e-01  1.749e-02 -24.132  < 2e-16 ***
    ## bpps_45              -3.817e-01  1.769e-02 -21.577  < 2e-16 ***
    ## bpps_46              -3.927e-01  1.778e-02 -22.090  < 2e-16 ***
    ## bpps_47              -4.208e-01  1.674e-02 -25.139  < 2e-16 ***
    ## bpps_48              -4.441e-01  1.658e-02 -26.788  < 2e-16 ***
    ## bpps_49              -4.223e-01  1.617e-02 -26.105  < 2e-16 ***
    ## bpps_50              -4.521e-01  1.579e-02 -28.634  < 2e-16 ***
    ## bpps_51              -4.151e-01  1.685e-02 -24.640  < 2e-16 ***
    ## bpps_52              -4.543e-01  1.675e-02 -27.132  < 2e-16 ***
    ## bpps_53              -4.616e-01  1.719e-02 -26.851  < 2e-16 ***
    ## bpps_54              -4.728e-01  1.691e-02 -27.963  < 2e-16 ***
    ## bpps_55              -4.506e-01  1.794e-02 -25.107  < 2e-16 ***
    ## bpps_56              -4.701e-01  1.776e-02 -26.463  < 2e-16 ***
    ## bpps_57              -4.175e-01  1.726e-02 -24.180  < 2e-16 ***
    ## bpps_58              -4.450e-01  1.744e-02 -25.518  < 2e-16 ***
    ## bpps_59              -3.954e-01  1.713e-02 -23.082  < 2e-16 ***
    ## bpps_60              -3.856e-01  1.688e-02 -22.846  < 2e-16 ***
    ## bpps_61              -3.796e-01  1.630e-02 -23.282  < 2e-16 ***
    ## bpps_62              -3.475e-01  1.587e-02 -21.892  < 2e-16 ***
    ## bpps_63              -3.473e-01  1.601e-02 -21.697  < 2e-16 ***
    ## bpps_64              -3.024e-01  1.654e-02 -18.286  < 2e-16 ***
    ## bpps_65              -3.223e-01  1.765e-02 -18.257  < 2e-16 ***
    ## bpps_66              -2.589e-01  1.967e-02 -13.160  < 2e-16 ***
    ## bpps_67              -2.581e-01  2.643e-02  -9.766  < 2e-16 ***
    ## bpps_68              -2.558e-01  1.147e-01  -2.230 0.025762 *  
    ## bpps_69              -3.543e-01  1.165e-01  -3.040 0.002364 ** 
    ## bpps_70              -4.218e-01  1.179e-01  -3.579 0.000346 ***
    ## bpps_71              -4.494e-01  1.169e-01  -3.844 0.000121 ***
    ## bpps_72              -3.373e-01  1.184e-01  -2.850 0.004378 ** 
    ## bpps_73              -2.868e-01  1.235e-01  -2.323 0.020187 *  
    ## bpps_74              -4.450e-01  1.159e-01  -3.838 0.000124 ***
    ## bpps_75              -3.025e-01  1.235e-01  -2.449 0.014338 *  
    ## bpps_76              -5.969e-01  1.218e-01  -4.900 9.62e-07 ***
    ## bpps_77              -2.921e-01  1.120e-01  -2.607 0.009124 ** 
    ## bpps_78              -4.252e-01  1.259e-01  -3.376 0.000737 ***
    ## bpps_79              -5.799e-01  1.298e-01  -4.468 7.92e-06 ***
    ## bpps_80              -1.286e-01  1.361e-01  -0.945 0.344671    
    ## bpps_81              -4.853e-01  1.389e-01  -3.495 0.000474 ***
    ## bpps_82              -2.520e-01  1.435e-01  -1.756 0.079115 .  
    ## bpps_83              -2.005e-01  1.418e-01  -1.414 0.157384    
    ## bpps_84               1.278e-02  1.577e-01   0.081 0.935387    
    ## bpps_85              -4.139e-01  1.891e-01  -2.189 0.028632 *  
    ## bpps_86              -3.636e-01  1.969e-01  -1.847 0.064814 .  
    ## bpps_87               6.057e-01  2.895e-01   2.092 0.036455 *  
    ## bpps_88              -2.775e-01  2.622e-01  -1.058 0.289915    
    ## bpps_89              -8.414e-02  2.283e-01  -0.369 0.712411    
    ## bpps_90              -2.158e-01  1.606e-01  -1.344 0.179087    
    ## bpps_91              -1.074e+00  2.050e-01  -5.237 1.63e-07 ***
    ## bpps_92               1.525e+00  3.780e-01   4.034 5.48e-05 ***
    ## bpps_93               8.830e-01  2.851e-01   3.097 0.001954 ** 
    ## bpps_94               4.504e-01  2.352e-01   1.915 0.055477 .  
    ## bpps_95               5.995e-01  3.540e-01   1.693 0.090392 .  
    ## bpps_96              -1.627e+00  6.171e-01  -2.636 0.008391 ** 
    ## bpps_97               9.329e-01  5.014e-01   1.861 0.062792 .  
    ## bpps_98              -5.765e-01  8.024e-01  -0.718 0.472503    
    ## bpps_99              -9.628e-01  9.463e-01  -1.017 0.308939    
    ## bpps_100             -3.210e+00  7.689e-01  -4.174 2.99e-05 ***
    ## bpps_101             -1.803e+00  1.126e+00  -1.602 0.109127    
    ## bpps_102              1.356e-01  1.035e+00   0.131 0.895682    
    ## bpps_103              5.046e+00  7.454e-01   6.769 1.31e-11 ***
    ## bpps_104              3.000e-02  1.040e+00   0.029 0.976988    
    ## bpps_105             -1.887e+00  8.804e-01  -2.144 0.032067 *  
    ## bpps_106              1.549e+00  5.798e-01   2.671 0.007560 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 0.1251687)
    ## 
    ##     Null deviance: 18798  on 86427  degrees of freedom
    ## Residual deviance:  8808  on 86287  degrees of freedom
    ## AIC: 21074
    ## 
    ## Number of Fisher Scoring iterations: 7

Il est important de noter que le premier modèle n’est pas de plein rang,
donc on ne peut pas se fier à ses prédictions. <br> Cependant, la
pénalisation va nous aider à résoudre ce problème.

``` r
y_pred_gamma_train = predict.glm(model_gamma_deg_pH10,data_train,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_train <- mean((y_pred_gamma_train-data_train$deg_pH10)^2,na.rm=TRUE)
print(error_gamma_train)
```

    ## [1] 0.1800793

``` r
y_pred_gamma_val=predict.glm(model_gamma_deg_pH10,data_val,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_val <- mean((y_pred_gamma_val-data_val$deg_pH10)^2,na.rm=TRUE)
print(error_gamma_val)
```

    ## [1] 0.1733897

``` r
models_deg_pH10 <- c(models_deg_pH10, "model_gamma")
errors_deg_pH10_train <- c(errors_deg_pH10_train, error_gamma_train)
errors_deg_pH10_val <- c(errors_deg_pH10_val, error_gamma_val)
rm(error_gamma_val, error_gamma_train, y_pred_gamma_train, y_pred_gamma_val)
```

### Pénalisation ridge et lasso

On commence par calculer la matrice de design du model\_gamma\_deg\_pH10
sur le train et le test.

``` r
# Matrice de design du train
data_train_pen = model.matrix(model_gamma_deg_pH10)
#head(data_train_pen)
```

``` r
# Pour faire la matrice de design de la validation
model_gamma_deg_pH10_val = glm(formula = formula_gamma_deg_pH10,
                                 family = Gamma(link = "log"), data = data_val)
data_val_pen = model.matrix(model_gamma_deg_pH10_val)
#head(data_val_pen)

# On supprime le modèle sur le test
rm(model_gamma_deg_pH10_val)
```

On pénalise le model\_gamma\_deg\_pH10 avec une pénalité ridge. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_pH10_pen_ridge = cv.glmnet(data_train_pen, data_train$deg_pH10,
#                                           type.measure = "mse",
#                                           alpha = 0,
#                                           trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_pH10_pen_ridge, "model_gamma_deg_pH10_pen_ridge.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_pH10_pen_ridge <- readRDS("model_gamma_deg_pH10_pen_ridge.rds")
```

``` r
coef(model_gamma_deg_pH10_pen_ridge, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.1244664530
    ## (Intercept)           .           
    ## sequenceC             0.0914838796
    ## sequenceG             0.2112828829
    ## sequenceU             0.1361268525
    ## index_sequence       -0.0055476572
    ## structure)            0.0374701028
    ## structure.            0.0516459906
    ## predicted_loop_typeE  0.0826013830
    ## predicted_loop_typeH -0.0799102109
    ## predicted_loop_typeI -0.1407182868
    ## predicted_loop_typeM  0.0757527148
    ## predicted_loop_typeS -0.0609152284
    ## predicted_loop_typeX  0.1142675688
    ## seq_beC              -0.0055558198
    ## seq_beG               0.1321285235
    ## seq_beO               0.3509261766
    ## seq_beU               0.0696206286
    ## seq_afC              -0.1701529770
    ## seq_afG              -0.1596331861
    ## seq_afO               0.1503358253
    ## seq_afU               0.1461714590
    ## struct_be)            0.0950802611
    ## struct_be.            0.0484081604
    ## struct_beO            0.3570367057
    ## struct_af)            0.0371235365
    ## struct_af.            0.0264030859
    ## struct_afO            0.1490295822
    ## loop_type_beE         0.0237564168
    ## loop_type_beH         0.0252415587
    ## loop_type_beI        -0.0153342461
    ## loop_type_beM         0.0246007548
    ## loop_type_beO         0.3582674938
    ## loop_type_beS        -0.0695241960
    ## loop_type_beX         0.0004047355
    ## loop_type_afE         0.0748288831
    ## loop_type_afH        -0.0518486773
    ## loop_type_afI        -0.0162227452
    ## loop_type_afM        -0.0252382300
    ## loop_type_afO         0.1481358830
    ## loop_type_afS        -0.0368614358
    ## loop_type_afX         0.0234200069
    ## bpps_0               -0.0759433041
    ## bpps_1               -0.2788311722
    ## bpps_2                0.1899622622
    ## bpps_3               -0.4490882748
    ## bpps_4               -0.3348179447
    ## bpps_5                0.1461082319
    ## bpps_6               -0.0889399710
    ## bpps_7               -0.1439599923
    ## bpps_8               -0.1717579289
    ## bpps_9               -0.2198194779
    ## bpps_10              -0.2895190415
    ## bpps_11              -0.2939925053
    ## bpps_12              -0.2774943256
    ## bpps_13              -0.3060404014
    ## bpps_14              -0.3000681541
    ## bpps_15              -0.3038045142
    ## bpps_16              -0.2882683543
    ## bpps_17              -0.2942463917
    ## bpps_18              -0.2802346424
    ## bpps_19              -0.3174648751
    ## bpps_20              -0.3242018493
    ## bpps_21              -0.3415835541
    ## bpps_22              -0.3224475868
    ## bpps_23              -0.3048154928
    ## bpps_24              -0.2874109029
    ## bpps_25              -0.2967802874
    ## bpps_26              -0.2766635482
    ## bpps_27              -0.2907007347
    ## bpps_28              -0.3084524018
    ## bpps_29              -0.3507194726
    ## bpps_30              -0.3440502264
    ## bpps_31              -0.3186719596
    ## bpps_32              -0.3316760122
    ## bpps_33              -0.3387160354
    ## bpps_34              -0.2969708510
    ## bpps_35              -0.3296067197
    ## bpps_36              -0.2465667620
    ## bpps_37              -0.2410696752
    ## bpps_38              -0.3053360545
    ## bpps_39              -0.2535770407
    ## bpps_40              -0.2539565413
    ## bpps_41              -0.2559877062
    ## bpps_42              -0.2700505879
    ## bpps_43              -0.2848910760
    ## bpps_44              -0.2638025314
    ## bpps_45              -0.2357685855
    ## bpps_46              -0.2222869682
    ## bpps_47              -0.2478160319
    ## bpps_48              -0.2718812651
    ## bpps_49              -0.2524721172
    ## bpps_50              -0.2795803349
    ## bpps_51              -0.2362189940
    ## bpps_52              -0.2756226621
    ## bpps_53              -0.2920086231
    ## bpps_54              -0.3087832764
    ## bpps_55              -0.2625898404
    ## bpps_56              -0.2845855996
    ## bpps_57              -0.2506455898
    ## bpps_58              -0.2741449166
    ## bpps_59              -0.2367963601
    ## bpps_60              -0.2234136147
    ## bpps_61              -0.2314679540
    ## bpps_62              -0.2100045147
    ## bpps_63              -0.2164288742
    ## bpps_64              -0.1825872521
    ## bpps_65              -0.1947266649
    ## bpps_66              -0.1527458770
    ## bpps_67              -0.1491607441
    ## bpps_68              -0.1398466366
    ## bpps_69              -0.3390927239
    ## bpps_70              -0.3458483086
    ## bpps_71              -0.3558883288
    ## bpps_72              -0.2583574095
    ## bpps_73              -0.2211680048
    ## bpps_74              -0.3295033930
    ## bpps_75              -0.3075427825
    ## bpps_76              -0.6708098362
    ## bpps_77              -0.2511091573
    ## bpps_78              -0.3144539249
    ## bpps_79              -0.5108916939
    ## bpps_80              -0.0616146484
    ## bpps_81              -0.4762099027
    ## bpps_82              -0.2666433183
    ## bpps_83              -0.2042318830
    ## bpps_84               0.0420922847
    ## bpps_85              -0.4213878399
    ## bpps_86              -0.3676655074
    ## bpps_87               0.7773832785
    ## bpps_88              -0.2510201773
    ## bpps_89              -0.0284686000
    ## bpps_90              -0.2130077902
    ## bpps_91              -1.1290149381
    ## bpps_92               2.0211634923
    ## bpps_93               0.5013230151
    ## bpps_94               0.8685510861
    ## bpps_95               0.3933709479
    ## bpps_96              -1.5884341449
    ## bpps_97               0.7207144658
    ## bpps_98              -0.7780642940
    ## bpps_99              -1.1853530991
    ## bpps_100             -2.1050411590
    ## bpps_101             -1.7234023991
    ## bpps_102             -0.4203183619
    ## bpps_103              5.3215032019
    ## bpps_104             -0.3626848013
    ## bpps_105             -1.4379149607
    ## bpps_106              4.0511749310

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation ridge.

``` r
y_pred_ridge_gamma_train = predict(model_gamma_deg_pH10_pen_ridge, data_train_pen,
                                   type = "response", s = "lambda.min")
y_pred_ridge_gamma_val = predict(model_gamma_deg_pH10_pen_ridge, data_val_pen,
                                 type = "response", s = "lambda.min")
error_ridge_gamma_train <- mean((y_pred_ridge_gamma_train-data_train$deg_pH10)^2,na.rm=TRUE)
print(error_ridge_gamma_train)
```

    ## [1] 0.1896827

``` r
error_ridge_gamma_val <- mean((y_pred_ridge_gamma_val-data_val$deg_pH10)^2,na.rm=TRUE)
print(error_ridge_gamma_val)
```

    ## [1] 0.1838563

On pénalise le model\_gamma\_deg\_pH10 avec une pénalité lasso. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_pH10_pen_lasso = cv.glmnet(data_train_pen, data_train$deg_pH10,
#                                           type.measure = "mse",
#                                           alpha = 1,
#                                           trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_pH10_pen_lasso, "model_gamma_deg_pH10_pen_lasso.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_pH10_pen_lasso <- readRDS("model_gamma_deg_pH10_pen_lasso.rds")
```

``` r
coef(model_gamma_deg_pH10_pen_lasso, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.197119e+00
    ## (Intercept)           .           
    ## sequenceC             1.269390e-01
    ## sequenceG             2.441173e-01
    ## sequenceU             1.669321e-01
    ## index_sequence       -6.074390e-03
    ## structure)            3.340987e-02
    ## structure.            8.946647e-02
    ## predicted_loop_typeE  7.145270e-02
    ## predicted_loop_typeH -1.374500e-01
    ## predicted_loop_typeI -1.936532e-01
    ## predicted_loop_typeM  4.526957e-02
    ## predicted_loop_typeS -1.243089e-03
    ## predicted_loop_typeX  9.272834e-02
    ## seq_beC               4.447809e-03
    ## seq_beG               1.446481e-01
    ## seq_beO               9.908649e-01
    ## seq_beU               8.404542e-02
    ## seq_afC              -1.746105e-01
    ## seq_afG              -1.666138e-01
    ## seq_afO               4.222335e-01
    ## seq_afU               1.522663e-01
    ## struct_be)            1.190988e-01
    ## struct_be.            .           
    ## struct_beO            4.174802e-03
    ## struct_af)            4.654501e-02
    ## struct_af.            2.307246e-05
    ## struct_afO            4.899387e-04
    ## loop_type_beE        -8.241884e-04
    ## loop_type_beH         3.400598e-02
    ## loop_type_beI        -1.187056e-02
    ## loop_type_beM         2.969686e-02
    ## loop_type_beO         .           
    ## loop_type_beS        -1.264586e-01
    ## loop_type_beX         3.534233e-03
    ## loop_type_afE         7.693014e-02
    ## loop_type_afH        -3.034272e-02
    ## loop_type_afI        -4.269048e-04
    ## loop_type_afM        -2.037206e-02
    ## loop_type_afO         1.653839e-02
    ## loop_type_afS        -4.614622e-02
    ## loop_type_afX         2.915057e-02
    ## bpps_0               -2.915626e-01
    ## bpps_1               -4.488385e-01
    ## bpps_2                7.496182e-02
    ## bpps_3               -6.421869e-01
    ## bpps_4               -5.086284e-01
    ## bpps_5                4.503291e-02
    ## bpps_6               -1.992455e-01
    ## bpps_7               -2.578412e-01
    ## bpps_8               -2.836262e-01
    ## bpps_9               -3.330840e-01
    ## bpps_10              -4.112135e-01
    ## bpps_11              -4.179052e-01
    ## bpps_12              -3.999108e-01
    ## bpps_13              -4.310813e-01
    ## bpps_14              -4.217262e-01
    ## bpps_15              -4.251566e-01
    ## bpps_16              -4.081697e-01
    ## bpps_17              -4.143757e-01
    ## bpps_18              -3.954319e-01
    ## bpps_19              -4.378183e-01
    ## bpps_20              -4.432463e-01
    ## bpps_21              -4.620161e-01
    ## bpps_22              -4.463013e-01
    ## bpps_23              -4.265247e-01
    ## bpps_24              -4.038193e-01
    ## bpps_25              -4.177735e-01
    ## bpps_26              -3.934801e-01
    ## bpps_27              -4.052713e-01
    ## bpps_28              -4.231119e-01
    ## bpps_29              -4.719222e-01
    ## bpps_30              -4.637713e-01
    ## bpps_31              -4.396207e-01
    ## bpps_32              -4.529036e-01
    ## bpps_33              -4.605274e-01
    ## bpps_34              -4.137097e-01
    ## bpps_35              -4.470462e-01
    ## bpps_36              -3.579628e-01
    ## bpps_37              -3.505924e-01
    ## bpps_38              -4.189330e-01
    ## bpps_39              -3.600739e-01
    ## bpps_40              -3.543026e-01
    ## bpps_41              -3.594682e-01
    ## bpps_42              -3.780995e-01
    ## bpps_43              -3.966865e-01
    ## bpps_44              -3.737545e-01
    ## bpps_45              -3.400349e-01
    ## bpps_46              -3.254738e-01
    ## bpps_47              -3.525914e-01
    ## bpps_48              -3.798346e-01
    ## bpps_49              -3.577612e-01
    ## bpps_50              -3.852460e-01
    ## bpps_51              -3.368681e-01
    ## bpps_52              -3.799332e-01
    ## bpps_53              -3.988219e-01
    ## bpps_54              -4.184636e-01
    ## bpps_55              -3.688073e-01
    ## bpps_56              -3.902261e-01
    ## bpps_57              -3.532485e-01
    ## bpps_58              -3.798295e-01
    ## bpps_59              -3.406011e-01
    ## bpps_60              -3.208792e-01
    ## bpps_61              -3.344161e-01
    ## bpps_62              -3.100619e-01
    ## bpps_63              -3.199805e-01
    ## bpps_64              -2.832296e-01
    ## bpps_65              -2.964479e-01
    ## bpps_66              -2.580298e-01
    ## bpps_67              -2.504547e-01
    ## bpps_68              -2.682796e-01
    ## bpps_69              -4.476580e-01
    ## bpps_70              -4.461630e-01
    ## bpps_71              -4.721951e-01
    ## bpps_72              -3.729205e-01
    ## bpps_73              -3.462262e-01
    ## bpps_74              -4.613707e-01
    ## bpps_75              -3.157486e-01
    ## bpps_76              -7.367022e-01
    ## bpps_77              -3.964170e-01
    ## bpps_78              -4.592960e-01
    ## bpps_79              -6.656435e-01
    ## bpps_80              -1.484908e-01
    ## bpps_81              -5.873182e-01
    ## bpps_82              -3.580754e-01
    ## bpps_83              -2.981693e-01
    ## bpps_84              -6.835374e-02
    ## bpps_85              -5.933032e-01
    ## bpps_86              -4.906628e-01
    ## bpps_87               6.290770e-01
    ## bpps_88              -3.786607e-01
    ## bpps_89              -1.875311e-01
    ## bpps_90              -4.403964e-01
    ## bpps_91              -1.279822e+00
    ## bpps_92               1.883598e+00
    ## bpps_93               4.419872e-01
    ## bpps_94               6.816631e-01
    ## bpps_95               3.482070e-01
    ## bpps_96              -1.915093e+00
    ## bpps_97               7.782131e-01
    ## bpps_98              -8.709235e-01
    ## bpps_99              -1.503099e+00
    ## bpps_100             -4.106210e+00
    ## bpps_101             -2.117146e+00
    ## bpps_102             -9.587949e-02
    ## bpps_103              7.013103e+00
    ## bpps_104             -3.685856e-01
    ## bpps_105             -2.194494e+00
    ## bpps_106              3.501715e+00

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation lasso.

``` r
y_pred_lasso_gamma_train = predict(model_gamma_deg_pH10_pen_lasso, data_train_pen,
                                   type="response", s="lambda.min")
error_lasso_gamma_train <- mean((y_pred_lasso_gamma_train-data_train$deg_pH10)^2,na.rm=TRUE)
print(error_lasso_gamma_train)
```

    ## [1] 0.1889196

``` r
y_pred_lasso_gamma_val = predict(model_gamma_deg_pH10_pen_lasso, data_val_pen,
                                 type="response", s="lambda.min")
error_lasso_gamma_val <- mean((y_pred_lasso_gamma_val-data_val$deg_pH10)^2,na.rm=TRUE)
print(error_lasso_gamma_val)
```

    ## [1] 0.1827357

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_pH10 <- c(models_deg_pH10, "model_gamma_ridge", "model_gamma_lasso")
errors_deg_pH10_train <- c(errors_deg_pH10_train, error_ridge_gamma_train,
                             error_lasso_gamma_train)
errors_deg_pH10_val <- c(errors_deg_pH10_val, error_ridge_gamma_val, error_lasso_gamma_val)
rm(error_ridge_gamma_val, error_lasso_gamma_val,
   error_ridge_gamma_train, error_lasso_gamma_train,
   y_pred_ridge_gamma_train, y_pred_ridge_gamma_val,
   y_pred_lasso_gamma_train, y_pred_lasso_gamma_val)
```

### Pénalisation elastic-net

On choisit \(\alpha\) qui minimise le MSE sur la validation.

``` r
#alpha_opti_enet_gamma_deg_pH10 =
#  alpha_opti_enet(data_train = data_train_pen, data_val = data_val_pen,
#                  y_true_train = data_train$deg_pH10,
#                  y_true_val = data_val$deg_pH10)
```

On trouve \(\alpha = 0.5\).

``` r
#print(alpha_opti_enet_gamma_deg_pH10)
```

On construit le modèle avec le choix optimal pour \(\alpha\).

``` r
#model_gamma_deg_pH10_pen_enet = cv.glmnet(data_train_pen, data_train$deg_pH10,
#                                          type.measure = "mse",
#                                          alpha = alpha_opti_enet_gamma_deg_pH10,
#                                          trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_pH10_pen_enet, "model_gamma_deg_pH10_pen_enet.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_pH10_pen_enet <- readRDS("model_gamma_deg_pH10_pen_enet.rds")
```

``` r
coef(model_gamma_deg_pH10_pen_enet, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.282844e+00
    ## (Intercept)           .           
    ## sequenceC             1.270007e-01
    ## sequenceG             2.441481e-01
    ## sequenceU             1.669606e-01
    ## index_sequence       -6.074396e-03
    ## structure)            3.337244e-02
    ## structure.            3.781657e-03
    ## predicted_loop_typeE  7.198911e-02
    ## predicted_loop_typeH -1.373374e-01
    ## predicted_loop_typeI -1.935283e-01
    ## predicted_loop_typeM  4.546383e-02
    ## predicted_loop_typeS -8.655974e-02
    ## predicted_loop_typeX  9.283716e-02
    ## seq_beC               4.472915e-03
    ## seq_beG               1.446563e-01
    ## seq_beO               3.276055e-01
    ## seq_beU               8.406167e-02
    ## seq_afC              -1.745679e-01
    ## seq_afG              -1.665806e-01
    ## seq_afO               1.540931e-01
    ## seq_afU               1.522943e-01
    ## struct_be)            1.190830e-01
    ## struct_be.            .           
    ## struct_beO            3.351504e-01
    ## struct_af)            4.657191e-02
    ## struct_af.            3.000095e-05
    ## struct_afO            1.473523e-01
    ## loop_type_beE        -1.174583e-03
    ## loop_type_beH         3.413816e-02
    ## loop_type_beI        -1.181538e-02
    ## loop_type_beM         2.980177e-02
    ## loop_type_beO         3.318360e-01
    ## loop_type_beS        -1.263531e-01
    ## loop_type_beX         3.659566e-03
    ## loop_type_afE         7.670415e-02
    ## loop_type_afH        -3.064391e-02
    ## loop_type_afI        -7.066973e-04
    ## loop_type_afM        -2.070100e-02
    ## loop_type_afO         1.375989e-01
    ## loop_type_afS        -4.638787e-02
    ## loop_type_afX         2.892155e-02
    ## bpps_0               -2.924891e-01
    ## bpps_1               -4.498044e-01
    ## bpps_2                7.610696e-02
    ## bpps_3               -6.439748e-01
    ## bpps_4               -5.098717e-01
    ## bpps_5                4.480872e-02
    ## bpps_6               -1.996325e-01
    ## bpps_7               -2.582278e-01
    ## bpps_8               -2.839973e-01
    ## bpps_9               -3.334468e-01
    ## bpps_10              -4.115639e-01
    ## bpps_11              -4.182646e-01
    ## bpps_12              -4.002742e-01
    ## bpps_13              -4.314487e-01
    ## bpps_14              -4.220895e-01
    ## bpps_15              -4.255308e-01
    ## bpps_16              -4.085422e-01
    ## bpps_17              -4.147342e-01
    ## bpps_18              -3.957877e-01
    ## bpps_19              -4.381850e-01
    ## bpps_20              -4.436011e-01
    ## bpps_21              -4.623708e-01
    ## bpps_22              -4.466598e-01
    ## bpps_23              -4.268914e-01
    ## bpps_24              -4.041558e-01
    ## bpps_25              -4.181046e-01
    ## bpps_26              -3.938356e-01
    ## bpps_27              -4.056296e-01
    ## bpps_28              -4.234673e-01
    ## bpps_29              -4.722755e-01
    ## bpps_30              -4.641260e-01
    ## bpps_31              -4.399847e-01
    ## bpps_32              -4.532788e-01
    ## bpps_33              -4.608991e-01
    ## bpps_34              -4.141081e-01
    ## bpps_35              -4.474248e-01
    ## bpps_36              -3.583226e-01
    ## bpps_37              -3.509882e-01
    ## bpps_38              -4.192923e-01
    ## bpps_39              -3.604562e-01
    ## bpps_40              -3.546700e-01
    ## bpps_41              -3.598318e-01
    ## bpps_42              -3.784693e-01
    ## bpps_43              -3.970689e-01
    ## bpps_44              -3.741457e-01
    ## bpps_45              -3.404336e-01
    ## bpps_46              -3.258676e-01
    ## bpps_47              -3.529669e-01
    ## bpps_48              -3.802122e-01
    ## bpps_49              -3.581409e-01
    ## bpps_50              -3.856294e-01
    ## bpps_51              -3.372609e-01
    ## bpps_52              -3.803122e-01
    ## bpps_53              -3.992089e-01
    ## bpps_54              -4.188444e-01
    ## bpps_55              -3.692151e-01
    ## bpps_56              -3.906187e-01
    ## bpps_57              -3.536396e-01
    ## bpps_58              -3.802245e-01
    ## bpps_59              -3.409982e-01
    ## bpps_60              -3.212681e-01
    ## bpps_61              -3.348061e-01
    ## bpps_62              -3.104412e-01
    ## bpps_63              -3.203580e-01
    ## bpps_64              -2.836063e-01
    ## bpps_65              -2.967886e-01
    ## bpps_66              -2.583814e-01
    ## bpps_67              -2.505731e-01
    ## bpps_68              -2.690954e-01
    ## bpps_69              -4.484619e-01
    ## bpps_70              -4.469372e-01
    ## bpps_71              -4.729892e-01
    ## bpps_72              -3.737400e-01
    ## bpps_73              -3.471497e-01
    ## bpps_74              -4.621811e-01
    ## bpps_75              -3.164814e-01
    ## bpps_76              -7.373394e-01
    ## bpps_77              -3.971461e-01
    ## bpps_78              -4.602328e-01
    ## bpps_79              -6.665220e-01
    ## bpps_80              -1.494206e-01
    ## bpps_81              -5.882016e-01
    ## bpps_82              -3.589615e-01
    ## bpps_83              -2.991113e-01
    ## bpps_84              -6.947861e-02
    ## bpps_85              -5.944974e-01
    ## bpps_86              -4.919549e-01
    ## bpps_87               6.304920e-01
    ## bpps_88              -3.801851e-01
    ## bpps_89              -1.890110e-01
    ## bpps_90              -4.415388e-01
    ## bpps_91              -1.281345e+00
    ## bpps_92               1.885433e+00
    ## bpps_93               4.438950e-01
    ## bpps_94               6.819473e-01
    ## bpps_95               3.513832e-01
    ## bpps_96              -1.918532e+00
    ## bpps_97               7.833037e-01
    ## bpps_98              -8.763274e-01
    ## bpps_99              -1.503654e+00
    ## bpps_100             -4.123220e+00
    ## bpps_101             -2.116908e+00
    ## bpps_102             -9.507695e-02
    ## bpps_103              7.025561e+00
    ## bpps_104             -3.704265e-01
    ## bpps_105             -2.197229e+00
    ## bpps_106              3.503753e+00

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation elastic-net.

``` r
y_pred_enet_gamma_train = predict(model_gamma_deg_pH10_pen_enet, data_train_pen,
                                   type = "response", s = "lambda.min")
error_enet_gamma_train <- mean((y_pred_enet_gamma_train - data_train$deg_pH10)^2, na.rm=TRUE)
print(error_enet_gamma_train)
```

    ## [1] 0.1889191

``` r
y_pred_enet_gamma_val = predict(model_gamma_deg_pH10_pen_enet, data_val_pen,
                                 type = "response", s = "lambda.min")
error_enet_gamma_val <- mean((y_pred_enet_gamma_val - data_val$deg_pH10)^2, na.rm=TRUE)
print(error_enet_gamma_val)
```

    ## [1] 0.1827355

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_pH10 <- c(models_deg_pH10, "model_gamma_enet")
errors_deg_pH10_train <- c(errors_deg_pH10_train, error_enet_gamma_train)
errors_deg_pH10_val <- c(errors_deg_pH10_val, error_enet_gamma_val)
rm(error_enet_gamma_train, error_enet_gamma_val,
   y_pred_enet_gamma_train, y_pred_enet_gamma_val)
```

### Récapitulatif des résultats

``` r
models_deg_pH10_errors_df <- data.frame(models_deg_pH10,
                                          errors_deg_pH10_train,
                                          errors_deg_pH10_val)
```

``` r
models_deg_pH10_errors_df
```

    ##     models_deg_pH10 errors_deg_pH10_train errors_deg_pH10_val
    ## 1       model_gamma             0.1800793           0.1733897
    ## 2 model_gamma_ridge             0.1896827           0.1838563
    ## 3 model_gamma_lasso             0.1889196           0.1827357
    ## 4  model_gamma_enet             0.1889191           0.1827355

Le meilleur modèle (au sens de la minimisation du MSE sur la validation)
est le `model_gamma_lasso` (si on exclut le premier modèle qui n’était
pas de plein rang).

``` r
models_deg_pH10_errors_df[which.min(errors_deg_pH10_val[-1]) + 1, ]
```

    ##    models_deg_pH10 errors_deg_pH10_train errors_deg_pH10_val
    ## 4 model_gamma_enet             0.1889191           0.1827355

## deg\_Mg\_50C

### Premier modèle

``` r
formula_gamma_deg_Mg_50C =  paste0("deg_Mg_50C", formula_model_full)
```

``` r
model_gamma_deg_Mg_50C = glm(formula = formula_gamma_deg_Mg_50C,
                             family = Gamma(link = "log"), data = data_train)
```

``` r
summary(model_gamma_deg_Mg_50C)
```

    ## 
    ## Call:
    ## glm(formula = formula_gamma_deg_Mg_50C, family = Gamma(link = "log"), 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -2.34118  -0.22592  -0.05715   0.12226   3.09523  
    ## 
    ## Coefficients: (7 not defined because of singularities)
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           1.820e-01  6.944e-03  26.203  < 2e-16 ***
    ## sequenceC            -5.546e-03  3.780e-03  -1.467 0.142377    
    ## sequenceG             7.377e-02  3.321e-03  22.213  < 2e-16 ***
    ## sequenceU             3.648e-02  3.898e-03   9.359  < 2e-16 ***
    ## index_sequence       -4.622e-03  8.504e-05 -54.358  < 2e-16 ***
    ## structure)            2.682e-02  7.042e-03   3.808 0.000140 ***
    ## structure.            4.234e-02  1.084e-02   3.907 9.36e-05 ***
    ## predicted_loop_typeE  4.864e-02  1.741e-02   2.794 0.005201 ** 
    ## predicted_loop_typeH -1.708e-01  1.200e-02 -14.238  < 2e-16 ***
    ## predicted_loop_typeI -2.046e-01  1.077e-02 -18.993  < 2e-16 ***
    ## predicted_loop_typeM -5.680e-02  1.411e-02  -4.026 5.68e-05 ***
    ## predicted_loop_typeS         NA         NA      NA       NA    
    ## predicted_loop_typeX -6.025e-02  1.597e-02  -3.772 0.000162 ***
    ## seq_beC              -4.497e-02  3.578e-03 -12.567  < 2e-16 ***
    ## seq_beG               3.896e-02  3.140e-03  12.409  < 2e-16 ***
    ## seq_beO              -1.431e-01  1.626e-02  -8.796  < 2e-16 ***
    ## seq_beU               4.942e-02  3.721e-03  13.282  < 2e-16 ***
    ## seq_afC              -1.998e-01  3.588e-03 -55.676  < 2e-16 ***
    ## seq_afG              -2.249e-01  3.316e-03 -67.815  < 2e-16 ***
    ## seq_afO               9.766e-02  1.252e-02   7.802 6.19e-15 ***
    ## seq_afU               1.948e-01  3.750e-03  51.939  < 2e-16 ***
    ## struct_be)            6.319e-02  5.686e-03  11.112  < 2e-16 ***
    ## struct_be.            9.804e-02  9.453e-03  10.371  < 2e-16 ***
    ## struct_beO                   NA         NA      NA       NA    
    ## struct_af)            5.822e-02  5.683e-03  10.244  < 2e-16 ***
    ## struct_af.            1.394e-01  9.464e-03  14.727  < 2e-16 ***
    ## struct_afO                   NA         NA      NA       NA    
    ## loop_type_beE        -3.378e-02  1.421e-02  -2.377 0.017465 *  
    ## loop_type_beH         1.878e-02  1.052e-02   1.785 0.074275 .  
    ## loop_type_beI        -1.203e-02  1.003e-02  -1.199 0.230429    
    ## loop_type_beM        -1.117e-03  1.266e-02  -0.088 0.929655    
    ## loop_type_beO                NA         NA      NA       NA    
    ## loop_type_beS                NA         NA      NA       NA    
    ## loop_type_beX        -1.036e-02  1.446e-02  -0.716 0.473771    
    ## loop_type_afE        -1.211e-01  1.375e-02  -8.805  < 2e-16 ***
    ## loop_type_afH        -2.630e-02  1.051e-02  -2.502 0.012356 *  
    ## loop_type_afI        -1.550e-02  1.003e-02  -1.546 0.122182    
    ## loop_type_afM         4.340e-02  1.236e-02   3.510 0.000448 ***
    ## loop_type_afO                NA         NA      NA       NA    
    ## loop_type_afS                NA         NA      NA       NA    
    ## loop_type_afX         8.152e-02  1.334e-02   6.112 9.89e-10 ***
    ## bpps_0               -5.722e-01  1.282e-01  -4.463 8.08e-06 ***
    ## bpps_1               -5.722e-01  1.256e-01  -4.557 5.20e-06 ***
    ## bpps_2               -4.609e-01  2.004e-01  -2.300 0.021451 *  
    ## bpps_3               -1.050e+00  2.643e-01  -3.971 7.15e-05 ***
    ## bpps_4               -7.810e-01  1.861e-01  -4.196 2.72e-05 ***
    ## bpps_5               -3.195e-01  2.154e-02 -14.832  < 2e-16 ***
    ## bpps_6               -3.124e-01  1.677e-02 -18.629  < 2e-16 ***
    ## bpps_7               -4.074e-01  1.575e-02 -25.860  < 2e-16 ***
    ## bpps_8               -4.149e-01  1.519e-02 -27.313  < 2e-16 ***
    ## bpps_9               -4.604e-01  1.575e-02 -29.240  < 2e-16 ***
    ## bpps_10              -5.487e-01  1.552e-02 -35.355  < 2e-16 ***
    ## bpps_11              -5.228e-01  1.608e-02 -32.523  < 2e-16 ***
    ## bpps_12              -4.818e-01  1.633e-02 -29.500  < 2e-16 ***
    ## bpps_13              -5.080e-01  1.719e-02 -29.548  < 2e-16 ***
    ## bpps_14              -5.494e-01  1.748e-02 -31.433  < 2e-16 ***
    ## bpps_15              -5.267e-01  1.792e-02 -29.399  < 2e-16 ***
    ## bpps_16              -5.245e-01  1.777e-02 -29.517  < 2e-16 ***
    ## bpps_17              -5.154e-01  1.617e-02 -31.869  < 2e-16 ***
    ## bpps_18              -4.931e-01  1.631e-02 -30.224  < 2e-16 ***
    ## bpps_19              -5.404e-01  1.640e-02 -32.946  < 2e-16 ***
    ## bpps_20              -5.451e-01  1.610e-02 -33.861  < 2e-16 ***
    ## bpps_21              -5.581e-01  1.595e-02 -35.001  < 2e-16 ***
    ## bpps_22              -5.365e-01  1.597e-02 -33.597  < 2e-16 ***
    ## bpps_23              -5.229e-01  1.676e-02 -31.199  < 2e-16 ***
    ## bpps_24              -5.412e-01  1.627e-02 -33.257  < 2e-16 ***
    ## bpps_25              -5.121e-01  1.666e-02 -30.735  < 2e-16 ***
    ## bpps_26              -4.971e-01  1.605e-02 -30.974  < 2e-16 ***
    ## bpps_27              -5.168e-01  1.591e-02 -32.474  < 2e-16 ***
    ## bpps_28              -5.336e-01  1.611e-02 -33.115  < 2e-16 ***
    ## bpps_29              -5.892e-01  1.593e-02 -36.986  < 2e-16 ***
    ## bpps_30              -5.768e-01  1.559e-02 -37.001  < 2e-16 ***
    ## bpps_31              -5.378e-01  1.540e-02 -34.925  < 2e-16 ***
    ## bpps_32              -5.742e-01  1.568e-02 -36.625  < 2e-16 ***
    ## bpps_33              -5.772e-01  1.646e-02 -35.059  < 2e-16 ***
    ## bpps_34              -5.334e-01  1.841e-02 -28.980  < 2e-16 ***
    ## bpps_35              -5.473e-01  2.012e-02 -27.205  < 2e-16 ***
    ## bpps_36              -4.438e-01  1.816e-02 -24.432  < 2e-16 ***
    ## bpps_37              -4.293e-01  1.810e-02 -23.711  < 2e-16 ***
    ## bpps_38              -5.295e-01  1.649e-02 -32.107  < 2e-16 ***
    ## bpps_39              -4.794e-01  1.656e-02 -28.956  < 2e-16 ***
    ## bpps_40              -5.060e-01  1.555e-02 -32.539  < 2e-16 ***
    ## bpps_41              -5.134e-01  1.514e-02 -33.908  < 2e-16 ***
    ## bpps_42              -5.313e-01  1.519e-02 -34.983  < 2e-16 ***
    ## bpps_43              -5.259e-01  1.577e-02 -33.355  < 2e-16 ***
    ## bpps_44              -5.021e-01  1.674e-02 -30.003  < 2e-16 ***
    ## bpps_45              -4.928e-01  1.693e-02 -29.113  < 2e-16 ***
    ## bpps_46              -4.562e-01  1.701e-02 -26.817  < 2e-16 ***
    ## bpps_47              -4.565e-01  1.602e-02 -28.499  < 2e-16 ***
    ## bpps_48              -4.785e-01  1.586e-02 -30.169  < 2e-16 ***
    ## bpps_49              -4.661e-01  1.548e-02 -30.113  < 2e-16 ***
    ## bpps_50              -5.143e-01  1.511e-02 -34.040  < 2e-16 ***
    ## bpps_51              -4.678e-01  1.612e-02 -29.022  < 2e-16 ***
    ## bpps_52              -5.375e-01  1.602e-02 -33.549  < 2e-16 ***
    ## bpps_53              -5.236e-01  1.645e-02 -31.829  < 2e-16 ***
    ## bpps_54              -5.418e-01  1.618e-02 -33.486  < 2e-16 ***
    ## bpps_55              -4.909e-01  1.717e-02 -28.591  < 2e-16 ***
    ## bpps_56              -5.396e-01  1.700e-02 -31.742  < 2e-16 ***
    ## bpps_57              -4.831e-01  1.652e-02 -29.242  < 2e-16 ***
    ## bpps_58              -5.018e-01  1.669e-02 -30.070  < 2e-16 ***
    ## bpps_59              -4.846e-01  1.639e-02 -29.564  < 2e-16 ***
    ## bpps_60              -4.751e-01  1.615e-02 -29.418  < 2e-16 ***
    ## bpps_61              -5.158e-01  1.560e-02 -33.067  < 2e-16 ***
    ## bpps_62              -5.009e-01  1.519e-02 -32.986  < 2e-16 ***
    ## bpps_63              -5.087e-01  1.532e-02 -33.215  < 2e-16 ***
    ## bpps_64              -4.837e-01  1.582e-02 -30.567  < 2e-16 ***
    ## bpps_65              -4.721e-01  1.689e-02 -27.952  < 2e-16 ***
    ## bpps_66              -3.994e-01  1.883e-02 -21.216  < 2e-16 ***
    ## bpps_67              -3.611e-01  2.529e-02 -14.278  < 2e-16 ***
    ## bpps_68              -2.923e-01  1.098e-01  -2.664 0.007733 ** 
    ## bpps_69              -3.075e-01  1.115e-01  -2.758 0.005819 ** 
    ## bpps_70              -4.464e-01  1.128e-01  -3.958 7.55e-05 ***
    ## bpps_71              -4.453e-01  1.119e-01  -3.981 6.86e-05 ***
    ## bpps_72              -3.529e-01  1.133e-01  -3.115 0.001838 ** 
    ## bpps_73              -4.660e-01  1.181e-01  -3.944 8.01e-05 ***
    ## bpps_74              -3.995e-01  1.109e-01  -3.602 0.000316 ***
    ## bpps_75              -3.242e-01  1.182e-01  -2.743 0.006087 ** 
    ## bpps_76              -6.456e-01  1.166e-01  -5.538 3.06e-08 ***
    ## bpps_77              -1.935e-01  1.072e-01  -1.805 0.071124 .  
    ## bpps_78              -4.118e-01  1.205e-01  -3.417 0.000634 ***
    ## bpps_79              -6.782e-01  1.242e-01  -5.460 4.77e-08 ***
    ## bpps_80              -4.031e-01  1.303e-01  -3.094 0.001973 ** 
    ## bpps_81              -6.608e-01  1.329e-01  -4.973 6.59e-07 ***
    ## bpps_82              -2.667e-01  1.373e-01  -1.942 0.052121 .  
    ## bpps_83              -2.853e-01  1.357e-01  -2.102 0.035566 *  
    ## bpps_84               3.503e-04  1.508e-01   0.002 0.998147    
    ## bpps_85              -2.626e-01  1.810e-01  -1.451 0.146739    
    ## bpps_86              -4.191e-01  1.884e-01  -2.225 0.026115 *  
    ## bpps_87               5.741e-01  2.770e-01   2.072 0.038234 *  
    ## bpps_88               4.287e-02  2.509e-01   0.171 0.864302    
    ## bpps_89               6.973e-01  2.184e-01   3.192 0.001411 ** 
    ## bpps_90               3.868e-01  1.537e-01   2.517 0.011843 *  
    ## bpps_91              -5.917e-01  1.962e-01  -3.016 0.002562 ** 
    ## bpps_92               1.124e+00  3.617e-01   3.106 0.001895 ** 
    ## bpps_93               1.137e+00  2.728e-01   4.169 3.07e-05 ***
    ## bpps_94               3.431e-01  2.250e-01   1.525 0.127341    
    ## bpps_95               1.770e-01  3.387e-01   0.523 0.601222    
    ## bpps_96              -1.407e+00  5.905e-01  -2.383 0.017193 *  
    ## bpps_97               1.235e+00  4.798e-01   2.574 0.010056 *  
    ## bpps_98              -8.688e-01  7.678e-01  -1.132 0.257843    
    ## bpps_99              -1.004e+00  9.055e-01  -1.109 0.267446    
    ## bpps_100             -1.678e+00  7.357e-01  -2.281 0.022576 *  
    ## bpps_101             -8.927e-01  1.077e+00  -0.829 0.407166    
    ## bpps_102              7.610e-01  9.899e-01   0.769 0.442051    
    ## bpps_103              3.527e+00  7.133e-01   4.944 7.66e-07 ***
    ## bpps_104             -4.244e-01  9.952e-01  -0.426 0.669774    
    ## bpps_105             -2.015e+00  8.424e-01  -2.392 0.016755 *  
    ## bpps_106              3.410e-01  5.548e-01   0.615 0.538828    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 0.1146001)
    ## 
    ##     Null deviance: 17244.3  on 86427  degrees of freedom
    ## Residual deviance:  8451.1  on 86287  degrees of freedom
    ## AIC: 12091
    ## 
    ## Number of Fisher Scoring iterations: 6

Il est important de noter que le premier modèle n’est pas de plein rang,
donc on ne peut pas se fier à ses prédictions. <br> Cependant, la
pénalisation va nous aider à résoudre ce problème.

``` r
y_pred_gamma_train = predict.glm(model_gamma_deg_Mg_50C,data_train,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_train <- mean((y_pred_gamma_train-data_train$deg_Mg_50C)^2,na.rm=TRUE)
print(error_gamma_train)
```

    ## [1] 0.1431525

``` r
y_pred_gamma_val=predict.glm(model_gamma_deg_Mg_50C,data_val,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_val <- mean((y_pred_gamma_val-data_val$deg_Mg_50C)^2,na.rm=TRUE)
print(error_gamma_val)
```

    ## [1] 0.1432973

``` r
models_deg_Mg_50C <- c(models_deg_Mg_50C, "model_gamma")
errors_deg_Mg_50C_train <- c(errors_deg_Mg_50C_train, error_gamma_train)
errors_deg_Mg_50C_val <- c(errors_deg_Mg_50C_val, error_gamma_val)
rm(error_gamma_val, error_gamma_train, y_pred_gamma_train, y_pred_gamma_val)
```

### Pénalisation ridge et lasso

On commence par calculer la matrice de design du
model\_gamma\_deg\_Mg\_50C sur le train et le test.

``` r
# Matrice de design du train
data_train_pen = model.matrix(model_gamma_deg_Mg_50C)
#head(data_train_pen)
```

``` r
# Pour faire la matrice de design de la validation
model_gamma_deg_Mg_50C_val = glm(formula = formula_gamma_deg_Mg_50C,
                                 family = Gamma(link = "log"), data = data_val)
data_val_pen = model.matrix(model_gamma_deg_Mg_50C_val)
#head(data_val_pen)

# On supprime le modèle sur le test
rm(model_gamma_deg_Mg_50C_val)
```

On pénalise le model\_gamma\_deg\_Mg\_50C avec une pénalité ridge. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_Mg_50C_pen_ridge = cv.glmnet(data_train_pen, data_train$deg_Mg_50C,
#                                             type.measure = "mse",
#                                             alpha = 0,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_50C_pen_ridge, "model_gamma_deg_Mg_50C_pen_ridge.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_50C_pen_ridge <- readRDS("model_gamma_deg_Mg_50C_pen_ridge.rds")
```

``` r
coef(model_gamma_deg_Mg_50C_pen_ridge, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                 1
    ## (Intercept)           1.236655454
    ## (Intercept)           .          
    ## sequenceC            -0.012970503
    ## sequenceG             0.081885535
    ## sequenceU             0.042174338
    ## index_sequence       -0.005084986
    ## structure)            0.037565563
    ## structure.            0.042908450
    ## predicted_loop_typeE  0.049706836
    ## predicted_loop_typeH -0.100941544
    ## predicted_loop_typeI -0.144211905
    ## predicted_loop_typeM  0.012374042
    ## predicted_loop_typeS -0.051935102
    ## predicted_loop_typeX  0.006409215
    ## seq_beC              -0.034753592
    ## seq_beG               0.068382207
    ## seq_beO              -0.106361415
    ## seq_beU               0.053225650
    ## seq_afC              -0.171012009
    ## seq_afG              -0.190199962
    ## seq_afO               0.011749879
    ## seq_afU               0.198488842
    ## struct_be)            0.063244122
    ## struct_be.            0.051171310
    ## struct_beO           -0.099971232
    ## struct_af)            0.055353906
    ## struct_af.            0.061291657
    ## struct_afO            0.012133860
    ## loop_type_beE        -0.004781565
    ## loop_type_beH         0.005013189
    ## loop_type_beI        -0.014189579
    ## loop_type_beM         0.002573754
    ## loop_type_beO        -0.097208317
    ## loop_type_beS        -0.047636022
    ## loop_type_beX         0.004120558
    ## loop_type_afE        -0.009276175
    ## loop_type_afH        -0.019199358
    ## loop_type_afI        -0.014151273
    ## loop_type_afM         0.040199963
    ## loop_type_afO         0.009607603
    ## loop_type_afS        -0.064817373
    ## loop_type_afX         0.084257728
    ## bpps_0               -0.574513594
    ## bpps_1               -0.611581089
    ## bpps_2               -0.576765615
    ## bpps_3               -1.174354502
    ## bpps_4               -0.672477516
    ## bpps_5               -0.178534496
    ## bpps_6               -0.162504558
    ## bpps_7               -0.231771767
    ## bpps_8               -0.236306477
    ## bpps_9               -0.285458525
    ## bpps_10              -0.352802374
    ## bpps_11              -0.344923869
    ## bpps_12              -0.303064447
    ## bpps_13              -0.332719110
    ## bpps_14              -0.357433989
    ## bpps_15              -0.328941486
    ## bpps_16              -0.325267922
    ## bpps_17              -0.332054958
    ## bpps_18              -0.307866149
    ## bpps_19              -0.346562612
    ## bpps_20              -0.351239023
    ## bpps_21              -0.370365372
    ## bpps_22              -0.354098072
    ## bpps_23              -0.337771989
    ## bpps_24              -0.354368314
    ## bpps_25              -0.329720363
    ## bpps_26              -0.319461296
    ## bpps_27              -0.317892242
    ## bpps_28              -0.343010673
    ## bpps_29              -0.381409337
    ## bpps_30              -0.374837411
    ## bpps_31              -0.331499536
    ## bpps_32              -0.373048751
    ## bpps_33              -0.382797567
    ## bpps_34              -0.340318083
    ## bpps_35              -0.354380294
    ## bpps_36              -0.267865182
    ## bpps_37              -0.253846189
    ## bpps_38              -0.331841734
    ## bpps_39              -0.275158441
    ## bpps_40              -0.302084672
    ## bpps_41              -0.305505681
    ## bpps_42              -0.316551630
    ## bpps_43              -0.323765215
    ## bpps_44              -0.311121044
    ## bpps_45              -0.309616856
    ## bpps_46              -0.262088850
    ## bpps_47              -0.273110394
    ## bpps_48              -0.287249757
    ## bpps_49              -0.271625633
    ## bpps_50              -0.316606967
    ## bpps_51              -0.268963539
    ## bpps_52              -0.327660158
    ## bpps_53              -0.325642303
    ## bpps_54              -0.342469339
    ## bpps_55              -0.281345631
    ## bpps_56              -0.328182168
    ## bpps_57              -0.284237254
    ## bpps_58              -0.307808884
    ## bpps_59              -0.287955122
    ## bpps_60              -0.272824045
    ## bpps_61              -0.318604494
    ## bpps_62              -0.310009848
    ## bpps_63              -0.322531868
    ## bpps_64              -0.301977296
    ## bpps_65              -0.294646614
    ## bpps_66              -0.245065818
    ## bpps_67              -0.245289033
    ## bpps_68              -0.177837643
    ## bpps_69              -0.247281695
    ## bpps_70              -0.346070835
    ## bpps_71              -0.294464286
    ## bpps_72              -0.259895588
    ## bpps_73              -0.349532108
    ## bpps_74              -0.238418127
    ## bpps_75              -0.280102508
    ## bpps_76              -0.664088985
    ## bpps_77              -0.108384386
    ## bpps_78              -0.263150531
    ## bpps_79              -0.503151143
    ## bpps_80              -0.270921493
    ## bpps_81              -0.557579332
    ## bpps_82              -0.233053448
    ## bpps_83              -0.229248627
    ## bpps_84               0.084776199
    ## bpps_85              -0.196371213
    ## bpps_86              -0.250908919
    ## bpps_87               0.659004889
    ## bpps_88               0.125714387
    ## bpps_89               0.805473354
    ## bpps_90               0.340086021
    ## bpps_91              -0.672474999
    ## bpps_92               1.417108726
    ## bpps_93               0.729482303
    ## bpps_94               0.630649067
    ## bpps_95               0.030044559
    ## bpps_96              -1.287497854
    ## bpps_97               1.152540900
    ## bpps_98              -0.845638229
    ## bpps_99              -1.005017494
    ## bpps_100             -0.893950533
    ## bpps_101             -0.854614372
    ## bpps_102              0.094774350
    ## bpps_103              3.599565860
    ## bpps_104             -0.806699269
    ## bpps_105             -1.400592485
    ## bpps_106              1.995925204

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation ridge.

``` r
y_pred_ridge_gamma_train = predict(model_gamma_deg_Mg_50C_pen_ridge, data_train_pen,
                                   type = "response", s = "lambda.min")
y_pred_ridge_gamma_val = predict(model_gamma_deg_Mg_50C_pen_ridge, data_val_pen,
                                 type = "response", s = "lambda.min")
error_ridge_gamma_train <- mean((y_pred_ridge_gamma_train-data_train$deg_Mg_50C)^2,na.rm=TRUE)
print(error_ridge_gamma_train)
```

    ## [1] 0.1506517

``` r
error_ridge_gamma_val <- mean((y_pred_ridge_gamma_val-data_val$deg_Mg_50C)^2,na.rm=TRUE)
print(error_ridge_gamma_val)
```

    ## [1] 0.1511386

On pénalise le model\_gamma\_deg\_Mg\_50C avec une pénalité lasso. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_Mg_50C_pen_lasso = cv.glmnet(data_train_pen, data_train$deg_Mg_50C,
#                                             type.measure = "mse",
#                                             alpha = 1,
#                                             trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_50C_pen_lasso, "model_gamma_deg_Mg_50C_pen_lasso.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_50C_pen_lasso <- readRDS("model_gamma_deg_Mg_50C_pen_lasso.rds")
```

``` r
coef(model_gamma_deg_Mg_50C_pen_lasso, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.294204e+00
    ## (Intercept)           .           
    ## sequenceC             8.697616e-03
    ## sequenceG             1.018875e-01
    ## sequenceU             5.925357e-02
    ## index_sequence       -5.586581e-03
    ## structure)            3.092706e-02
    ## structure.            4.164020e-02
    ## predicted_loop_typeE  5.635770e-02
    ## predicted_loop_typeH -1.705596e-01
    ## predicted_loop_typeI -2.036249e-01
    ## predicted_loop_typeM -3.508104e-02
    ## predicted_loop_typeS -2.817345e-02
    ## predicted_loop_typeX -4.574366e-02
    ## seq_beC              -3.000253e-02
    ## seq_beG               7.456794e-02
    ## seq_beO              -2.987061e-01
    ## seq_beU               6.124121e-02
    ## seq_afC              -1.745516e-01
    ## seq_afG              -1.964889e-01
    ## seq_afO               6.912844e-04
    ## seq_afU               2.059224e-01
    ## struct_be)            7.946300e-02
    ## struct_be.            1.068768e-01
    ## struct_beO           -2.785229e-03
    ## struct_af)            7.308909e-02
    ## struct_af.            2.202441e-02
    ## struct_afO            3.439315e-05
    ## loop_type_beE        -4.969796e-02
    ## loop_type_beH         7.049765e-03
    ## loop_type_beI        -1.650292e-02
    ## loop_type_beM         2.981501e-03
    ## loop_type_beO        -2.482834e-03
    ## loop_type_beS         .           
    ## loop_type_beX         9.737745e-03
    ## loop_type_afE        -3.623573e-02
    ## loop_type_afH        -8.421953e-03
    ## loop_type_afI        -1.370371e-02
    ## loop_type_afM         3.912331e-02
    ## loop_type_afO         .           
    ## loop_type_afS        -1.067190e-01
    ## loop_type_afX         9.128240e-02
    ## bpps_0               -7.656037e-01
    ## bpps_1               -7.592197e-01
    ## bpps_2               -6.758234e-01
    ## bpps_3               -1.364899e+00
    ## bpps_4               -8.504545e-01
    ## bpps_5               -2.985281e-01
    ## bpps_6               -2.821593e-01
    ## bpps_7               -3.555334e-01
    ## bpps_8               -3.574578e-01
    ## bpps_9               -4.086219e-01
    ## bpps_10              -4.817081e-01
    ## bpps_11              -4.749970e-01
    ## bpps_12              -4.308224e-01
    ## bpps_13              -4.635992e-01
    ## bpps_14              -4.871055e-01
    ## bpps_15              -4.568332e-01
    ## bpps_16              -4.525267e-01
    ## bpps_17              -4.607528e-01
    ## bpps_18              -4.308631e-01
    ## bpps_19              -4.742723e-01
    ## bpps_20              -4.777273e-01
    ## bpps_21              -4.972910e-01
    ## bpps_22              -4.831127e-01
    ## bpps_23              -4.653955e-01
    ## bpps_24              -4.778345e-01
    ## bpps_25              -4.545914e-01
    ## bpps_26              -4.441596e-01
    ## bpps_27              -4.401218e-01
    ## bpps_28              -4.660011e-01
    ## bpps_29              -5.085552e-01
    ## bpps_30              -5.009488e-01
    ## bpps_31              -4.575120e-01
    ## bpps_32              -5.007064e-01
    ## bpps_33              -5.116237e-01
    ## bpps_34              -4.643500e-01
    ## bpps_35              -4.783363e-01
    ## bpps_36              -3.856305e-01
    ## bpps_37              -3.702073e-01
    ## bpps_38              -4.528519e-01
    ## bpps_39              -3.902495e-01
    ## bpps_40              -4.129353e-01
    ## bpps_41              -4.185086e-01
    ## bpps_42              -4.321068e-01
    ## bpps_43              -4.422962e-01
    ## bpps_44              -4.298001e-01
    ## bpps_45              -4.254003e-01
    ## bpps_46              -3.736765e-01
    ## bpps_47              -3.853940e-01
    ## bpps_48              -4.010089e-01
    ## bpps_49              -3.841497e-01
    ## bpps_50              -4.303774e-01
    ## bpps_51              -3.790690e-01
    ## bpps_52              -4.410288e-01
    ## bpps_53              -4.401600e-01
    ## bpps_54              -4.587584e-01
    ## bpps_55              -3.942327e-01
    ## bpps_56              -4.426876e-01
    ## bpps_57              -3.949914e-01
    ## bpps_58              -4.211429e-01
    ## bpps_59              -4.001676e-01
    ## bpps_60              -3.797077e-01
    ## bpps_61              -4.325522e-01
    ## bpps_62              -4.212470e-01
    ## bpps_63              -4.361414e-01
    ## bpps_64              -4.130551e-01
    ## bpps_65              -4.031114e-01
    ## bpps_66              -3.558546e-01
    ## bpps_67              -3.396734e-01
    ## bpps_68              -2.942858e-01
    ## bpps_69              -3.549642e-01
    ## bpps_70              -4.490852e-01
    ## bpps_71              -4.138714e-01
    ## bpps_72              -3.793343e-01
    ## bpps_73              -4.856774e-01
    ## bpps_74              -3.700913e-01
    ## bpps_75              -3.256672e-01
    ## bpps_76              -7.500943e-01
    ## bpps_77              -2.332230e-01
    ## bpps_78              -4.032545e-01
    ## bpps_79              -6.539795e-01
    ## bpps_80              -3.732926e-01
    ## bpps_81              -6.762668e-01
    ## bpps_82              -3.249646e-01
    ## bpps_83              -3.265991e-01
    ## bpps_84              -2.855704e-02
    ## bpps_85              -3.346927e-01
    ## bpps_86              -3.617567e-01
    ## bpps_87               5.245966e-01
    ## bpps_88               1.183404e-02
    ## bpps_89               6.964719e-01
    ## bpps_90               1.564044e-01
    ## bpps_91              -7.804134e-01
    ## bpps_92               1.270428e+00
    ## bpps_93               7.168232e-01
    ## bpps_94               4.564142e-01
    ## bpps_95               .           
    ## bpps_96              -1.577689e+00
    ## bpps_97               1.208879e+00
    ## bpps_98              -1.028441e+00
    ## bpps_99              -1.142385e+00
    ## bpps_100             -2.007158e+00
    ## bpps_101             -9.359674e-01
    ## bpps_102              2.192202e-01
    ## bpps_103              4.575785e+00
    ## bpps_104             -9.850832e-01
    ## bpps_105             -2.112747e+00
    ## bpps_106              1.523922e+00

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation lasso.

``` r
y_pred_lasso_gamma_train = predict(model_gamma_deg_Mg_50C_pen_lasso, data_train_pen,
                                   type="response", s="lambda.min")
error_lasso_gamma_train <- mean((y_pred_lasso_gamma_train-data_train$deg_Mg_50C)^2,na.rm=TRUE)
print(error_lasso_gamma_train)
```

    ## [1] 0.1499072

``` r
y_pred_lasso_gamma_val = predict(model_gamma_deg_Mg_50C_pen_lasso, data_val_pen,
                                 type="response", s="lambda.min")
error_lasso_gamma_val <- mean((y_pred_lasso_gamma_val-data_val$deg_Mg_50C)^2,na.rm=TRUE)
print(error_lasso_gamma_val)
```

    ## [1] 0.1503065

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_Mg_50C <- c(models_deg_Mg_50C, "model_gamma_ridge", "model_gamma_lasso")
errors_deg_Mg_50C_train <- c(errors_deg_Mg_50C_train, error_ridge_gamma_train,
                             error_lasso_gamma_train)
errors_deg_Mg_50C_val <- c(errors_deg_Mg_50C_val, error_ridge_gamma_val, error_lasso_gamma_val)
rm(error_ridge_gamma_val, error_lasso_gamma_val,
   error_ridge_gamma_train, error_lasso_gamma_train,
   y_pred_ridge_gamma_train, y_pred_ridge_gamma_val,
   y_pred_lasso_gamma_train, y_pred_lasso_gamma_val)
```

### Pénalisation elastic-net

On choisit \(\alpha\) qui minimise le MSE sur la validation.

``` r
#alpha_opti_enet_gamma_deg_Mg_50C =
#  alpha_opti_enet(data_train = data_train_pen, data_val = data_val_pen,
#                  y_true_train = data_train$deg_Mg_50C,
#                  y_true_val = data_val$deg_Mg_50C)
```

On trouve \(\alpha = 1\). Cela correspond à la pénalisation lasso.

``` r
#print(alpha_opti_enet_gamma_deg_Mg_50C)
```

On construit le modèle avec le choix optimal pour \(\alpha\).

``` r
#model_gamma_deg_Mg_50C_pen_enet = cv.glmnet(data_train_pen, data_train$deg_Mg_50C,
#                                            type.measure = "mse",
#                                            alpha = alpha_opti_enet_gamma_deg_Mg_50C,
#                                            trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_Mg_50C_pen_enet, "model_gamma_deg_Mg_50C_pen_enet.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_Mg_50C_pen_enet <- readRDS("model_gamma_deg_Mg_50C_pen_enet.rds")
```

``` r
coef(model_gamma_deg_Mg_50C_pen_enet, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.294204e+00
    ## (Intercept)           .           
    ## sequenceC             8.697616e-03
    ## sequenceG             1.018875e-01
    ## sequenceU             5.925357e-02
    ## index_sequence       -5.586581e-03
    ## structure)            3.092706e-02
    ## structure.            4.164020e-02
    ## predicted_loop_typeE  5.635770e-02
    ## predicted_loop_typeH -1.705596e-01
    ## predicted_loop_typeI -2.036249e-01
    ## predicted_loop_typeM -3.508104e-02
    ## predicted_loop_typeS -2.817345e-02
    ## predicted_loop_typeX -4.574366e-02
    ## seq_beC              -3.000253e-02
    ## seq_beG               7.456794e-02
    ## seq_beO              -2.987061e-01
    ## seq_beU               6.124121e-02
    ## seq_afC              -1.745516e-01
    ## seq_afG              -1.964889e-01
    ## seq_afO               6.912844e-04
    ## seq_afU               2.059224e-01
    ## struct_be)            7.946300e-02
    ## struct_be.            1.068768e-01
    ## struct_beO           -2.785229e-03
    ## struct_af)            7.308909e-02
    ## struct_af.            2.202441e-02
    ## struct_afO            3.439315e-05
    ## loop_type_beE        -4.969796e-02
    ## loop_type_beH         7.049765e-03
    ## loop_type_beI        -1.650292e-02
    ## loop_type_beM         2.981501e-03
    ## loop_type_beO        -2.482834e-03
    ## loop_type_beS         .           
    ## loop_type_beX         9.737745e-03
    ## loop_type_afE        -3.623573e-02
    ## loop_type_afH        -8.421953e-03
    ## loop_type_afI        -1.370371e-02
    ## loop_type_afM         3.912331e-02
    ## loop_type_afO         .           
    ## loop_type_afS        -1.067190e-01
    ## loop_type_afX         9.128240e-02
    ## bpps_0               -7.656037e-01
    ## bpps_1               -7.592197e-01
    ## bpps_2               -6.758234e-01
    ## bpps_3               -1.364899e+00
    ## bpps_4               -8.504545e-01
    ## bpps_5               -2.985281e-01
    ## bpps_6               -2.821593e-01
    ## bpps_7               -3.555334e-01
    ## bpps_8               -3.574578e-01
    ## bpps_9               -4.086219e-01
    ## bpps_10              -4.817081e-01
    ## bpps_11              -4.749970e-01
    ## bpps_12              -4.308224e-01
    ## bpps_13              -4.635992e-01
    ## bpps_14              -4.871055e-01
    ## bpps_15              -4.568332e-01
    ## bpps_16              -4.525267e-01
    ## bpps_17              -4.607528e-01
    ## bpps_18              -4.308631e-01
    ## bpps_19              -4.742723e-01
    ## bpps_20              -4.777273e-01
    ## bpps_21              -4.972910e-01
    ## bpps_22              -4.831127e-01
    ## bpps_23              -4.653955e-01
    ## bpps_24              -4.778345e-01
    ## bpps_25              -4.545914e-01
    ## bpps_26              -4.441596e-01
    ## bpps_27              -4.401218e-01
    ## bpps_28              -4.660011e-01
    ## bpps_29              -5.085552e-01
    ## bpps_30              -5.009488e-01
    ## bpps_31              -4.575120e-01
    ## bpps_32              -5.007064e-01
    ## bpps_33              -5.116237e-01
    ## bpps_34              -4.643500e-01
    ## bpps_35              -4.783363e-01
    ## bpps_36              -3.856305e-01
    ## bpps_37              -3.702073e-01
    ## bpps_38              -4.528519e-01
    ## bpps_39              -3.902495e-01
    ## bpps_40              -4.129353e-01
    ## bpps_41              -4.185086e-01
    ## bpps_42              -4.321068e-01
    ## bpps_43              -4.422962e-01
    ## bpps_44              -4.298001e-01
    ## bpps_45              -4.254003e-01
    ## bpps_46              -3.736765e-01
    ## bpps_47              -3.853940e-01
    ## bpps_48              -4.010089e-01
    ## bpps_49              -3.841497e-01
    ## bpps_50              -4.303774e-01
    ## bpps_51              -3.790690e-01
    ## bpps_52              -4.410288e-01
    ## bpps_53              -4.401600e-01
    ## bpps_54              -4.587584e-01
    ## bpps_55              -3.942327e-01
    ## bpps_56              -4.426876e-01
    ## bpps_57              -3.949914e-01
    ## bpps_58              -4.211429e-01
    ## bpps_59              -4.001676e-01
    ## bpps_60              -3.797077e-01
    ## bpps_61              -4.325522e-01
    ## bpps_62              -4.212470e-01
    ## bpps_63              -4.361414e-01
    ## bpps_64              -4.130551e-01
    ## bpps_65              -4.031114e-01
    ## bpps_66              -3.558546e-01
    ## bpps_67              -3.396734e-01
    ## bpps_68              -2.942858e-01
    ## bpps_69              -3.549642e-01
    ## bpps_70              -4.490852e-01
    ## bpps_71              -4.138714e-01
    ## bpps_72              -3.793343e-01
    ## bpps_73              -4.856774e-01
    ## bpps_74              -3.700913e-01
    ## bpps_75              -3.256672e-01
    ## bpps_76              -7.500943e-01
    ## bpps_77              -2.332230e-01
    ## bpps_78              -4.032545e-01
    ## bpps_79              -6.539795e-01
    ## bpps_80              -3.732926e-01
    ## bpps_81              -6.762668e-01
    ## bpps_82              -3.249646e-01
    ## bpps_83              -3.265991e-01
    ## bpps_84              -2.855704e-02
    ## bpps_85              -3.346927e-01
    ## bpps_86              -3.617567e-01
    ## bpps_87               5.245966e-01
    ## bpps_88               1.183404e-02
    ## bpps_89               6.964719e-01
    ## bpps_90               1.564044e-01
    ## bpps_91              -7.804134e-01
    ## bpps_92               1.270428e+00
    ## bpps_93               7.168232e-01
    ## bpps_94               4.564142e-01
    ## bpps_95               .           
    ## bpps_96              -1.577689e+00
    ## bpps_97               1.208879e+00
    ## bpps_98              -1.028441e+00
    ## bpps_99              -1.142385e+00
    ## bpps_100             -2.007158e+00
    ## bpps_101             -9.359674e-01
    ## bpps_102              2.192202e-01
    ## bpps_103              4.575785e+00
    ## bpps_104             -9.850832e-01
    ## bpps_105             -2.112747e+00
    ## bpps_106              1.523922e+00

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation elastic-net.

``` r
y_pred_enet_gamma_train = predict(model_gamma_deg_Mg_50C_pen_enet, data_train_pen,
                                   type = "response", s = "lambda.min")
error_enet_gamma_train <- mean((y_pred_enet_gamma_train - data_train$deg_Mg_50C)^2, na.rm=TRUE)
print(error_enet_gamma_train)
```

    ## [1] 0.1499072

``` r
y_pred_enet_gamma_val = predict(model_gamma_deg_Mg_50C_pen_enet, data_val_pen,
                                 type = "response", s = "lambda.min")
error_enet_gamma_val <- mean((y_pred_enet_gamma_val - data_val$deg_Mg_50C)^2, na.rm=TRUE)
print(error_enet_gamma_val)
```

    ## [1] 0.1503065

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_Mg_50C <- c(models_deg_Mg_50C, "model_gamma_enet")
errors_deg_Mg_50C_train <- c(errors_deg_Mg_50C_train, error_enet_gamma_train)
errors_deg_Mg_50C_val <- c(errors_deg_Mg_50C_val, error_enet_gamma_val)
rm(error_enet_gamma_train, error_enet_gamma_val,
   y_pred_enet_gamma_train, y_pred_enet_gamma_val)
```

### Récapitulatif des résultats

``` r
models_deg_Mg_50C_errors_df <- data.frame(models_deg_Mg_50C,
                                          errors_deg_Mg_50C_train,
                                          errors_deg_Mg_50C_val)
```

``` r
models_deg_Mg_50C_errors_df
```

    ##   models_deg_Mg_50C errors_deg_Mg_50C_train errors_deg_Mg_50C_val
    ## 1       model_gamma               0.1431525             0.1432973
    ## 2 model_gamma_ridge               0.1506517             0.1511386
    ## 3 model_gamma_lasso               0.1499072             0.1503065
    ## 4  model_gamma_enet               0.1499072             0.1503065

Le meilleur modèle (au sens de la minimisation du MSE sur la validation)
est le `model_gamma_lasso` (si on exclut le premier modèle qui n’était
pas de plein rang).

``` r
models_deg_Mg_50C_errors_df[which.min(errors_deg_Mg_50C_val[-1]) + 1, ]
```

    ##   models_deg_Mg_50C errors_deg_Mg_50C_train errors_deg_Mg_50C_val
    ## 3 model_gamma_lasso               0.1499072             0.1503065

## deg\_50C

### Premier modèle

``` r
formula_gamma_deg_50C = paste0("deg_50C", formula_model_full)
```

``` r
model_gamma_deg_50C = glm(formula = formula_gamma_deg_50C,
                             family = Gamma(link = "log"), data = data_train)
```

``` r
summary(model_gamma_deg_50C)
```

    ## 
    ## Call:
    ## glm(formula = formula_gamma_deg_50C, family = Gamma(link = "log"), 
    ##     data = data_train)
    ## 
    ## Deviance Residuals: 
    ##      Min        1Q    Median        3Q       Max  
    ## -2.15246  -0.21040  -0.05005   0.13040   2.32573  
    ## 
    ## Coefficients: (7 not defined because of singularities)
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)           2.482e-01  6.249e-03  39.715  < 2e-16 ***
    ## sequenceC            -1.359e-02  3.402e-03  -3.996 6.45e-05 ***
    ## sequenceG             7.751e-02  2.989e-03  25.935  < 2e-16 ***
    ## sequenceU             4.081e-02  3.508e-03  11.633  < 2e-16 ***
    ## index_sequence       -4.497e-03  7.653e-05 -58.763  < 2e-16 ***
    ## structure)            1.793e-02  6.337e-03   2.829 0.004666 ** 
    ## structure.           -7.047e-03  9.753e-03  -0.722 0.470000    
    ## predicted_loop_typeE  2.608e-02  1.566e-02   1.665 0.095929 .  
    ## predicted_loop_typeH -7.958e-02  1.080e-02  -7.371 1.71e-13 ***
    ## predicted_loop_typeI -1.357e-01  9.695e-03 -13.993  < 2e-16 ***
    ## predicted_loop_typeM -3.246e-02  1.270e-02  -2.557 0.010572 *  
    ## predicted_loop_typeS         NA         NA      NA       NA    
    ## predicted_loop_typeX -2.622e-02  1.437e-02  -1.824 0.068113 .  
    ## seq_beC              -4.003e-02  3.220e-03 -12.430  < 2e-16 ***
    ## seq_beG               1.784e-02  2.825e-03   6.313 2.74e-10 ***
    ## seq_beO              -1.176e-03  1.464e-02  -0.080 0.935974    
    ## seq_beU               4.943e-02  3.348e-03  14.765  < 2e-16 ***
    ## seq_afC              -3.062e-01  3.229e-03 -94.828  < 2e-16 ***
    ## seq_afG              -2.153e-01  2.984e-03 -72.156  < 2e-16 ***
    ## seq_afO               1.461e-01  1.126e-02  12.968  < 2e-16 ***
    ## seq_afU               6.478e-02  3.374e-03  19.200  < 2e-16 ***
    ## struct_be)            5.080e-02  5.117e-03   9.927  < 2e-16 ***
    ## struct_be.            7.091e-02  8.507e-03   8.335  < 2e-16 ***
    ## struct_beO                   NA         NA      NA       NA    
    ## struct_af)            3.913e-02  5.114e-03   7.651 2.02e-14 ***
    ## struct_af.            6.123e-02  8.516e-03   7.190 6.54e-13 ***
    ## struct_afO                   NA         NA      NA       NA    
    ## loop_type_beE         1.296e-02  1.279e-02   1.013 0.310829    
    ## loop_type_beH         4.184e-02  9.468e-03   4.419 9.93e-06 ***
    ## loop_type_beI         3.203e-03  9.024e-03   0.355 0.722673    
    ## loop_type_beM         8.438e-03  1.139e-02   0.741 0.458844    
    ## loop_type_beO                NA         NA      NA       NA    
    ## loop_type_beS                NA         NA      NA       NA    
    ## loop_type_beX        -3.013e-02  1.302e-02  -2.315 0.020623 *  
    ## loop_type_afE        -4.502e-02  1.237e-02  -3.638 0.000274 ***
    ## loop_type_afH        -2.877e-02  9.460e-03  -3.041 0.002356 ** 
    ## loop_type_afI         3.341e-02  9.027e-03   3.702 0.000214 ***
    ## loop_type_afM         5.256e-02  1.113e-02   4.724 2.32e-06 ***
    ## loop_type_afO                NA         NA      NA       NA    
    ## loop_type_afS                NA         NA      NA       NA    
    ## loop_type_afX         9.190e-02  1.200e-02   7.656 1.93e-14 ***
    ## bpps_0                1.321e-01  1.154e-01   1.145 0.252198    
    ## bpps_1               -5.165e-01  1.130e-01  -4.571 4.86e-06 ***
    ## bpps_2               -3.073e-01  1.803e-01  -1.704 0.088327 .  
    ## bpps_3               -7.030e-01  2.379e-01  -2.955 0.003124 ** 
    ## bpps_4               -4.790e-01  1.675e-01  -2.860 0.004240 ** 
    ## bpps_5               -1.336e-01  1.938e-02  -6.894 5.47e-12 ***
    ## bpps_6               -2.129e-01  1.509e-02 -14.107  < 2e-16 ***
    ## bpps_7               -3.103e-01  1.418e-02 -21.886  < 2e-16 ***
    ## bpps_8               -3.491e-01  1.367e-02 -25.542  < 2e-16 ***
    ## bpps_9               -4.038e-01  1.417e-02 -28.498  < 2e-16 ***
    ## bpps_10              -4.777e-01  1.397e-02 -34.207  < 2e-16 ***
    ## bpps_11              -4.769e-01  1.447e-02 -32.964  < 2e-16 ***
    ## bpps_12              -4.231e-01  1.470e-02 -28.786  < 2e-16 ***
    ## bpps_13              -4.400e-01  1.547e-02 -28.440  < 2e-16 ***
    ## bpps_14              -4.763e-01  1.573e-02 -30.279  < 2e-16 ***
    ## bpps_15              -4.480e-01  1.612e-02 -27.784  < 2e-16 ***
    ## bpps_16              -4.404e-01  1.599e-02 -27.539  < 2e-16 ***
    ## bpps_17              -4.199e-01  1.455e-02 -28.856  < 2e-16 ***
    ## bpps_18              -4.329e-01  1.468e-02 -29.484  < 2e-16 ***
    ## bpps_19              -4.865e-01  1.476e-02 -32.957  < 2e-16 ***
    ## bpps_20              -5.019e-01  1.449e-02 -34.644  < 2e-16 ***
    ## bpps_21              -5.106e-01  1.435e-02 -35.582  < 2e-16 ***
    ## bpps_22              -4.546e-01  1.437e-02 -31.630  < 2e-16 ***
    ## bpps_23              -4.657e-01  1.508e-02 -30.878  < 2e-16 ***
    ## bpps_24              -4.398e-01  1.464e-02 -30.031  < 2e-16 ***
    ## bpps_25              -4.656e-01  1.500e-02 -31.048  < 2e-16 ***
    ## bpps_26              -4.338e-01  1.444e-02 -30.036  < 2e-16 ***
    ## bpps_27              -4.588e-01  1.432e-02 -32.037  < 2e-16 ***
    ## bpps_28              -4.761e-01  1.450e-02 -32.833  < 2e-16 ***
    ## bpps_29              -5.134e-01  1.434e-02 -35.812  < 2e-16 ***
    ## bpps_30              -5.138e-01  1.403e-02 -36.622  < 2e-16 ***
    ## bpps_31              -5.081e-01  1.386e-02 -36.666  < 2e-16 ***
    ## bpps_32              -5.084e-01  1.411e-02 -36.034  < 2e-16 ***
    ## bpps_33              -5.303e-01  1.482e-02 -35.793  < 2e-16 ***
    ## bpps_34              -4.517e-01  1.656e-02 -27.268  < 2e-16 ***
    ## bpps_35              -4.803e-01  1.810e-02 -26.530  < 2e-16 ***
    ## bpps_36              -3.381e-01  1.635e-02 -20.683  < 2e-16 ***
    ## bpps_37              -3.963e-01  1.629e-02 -24.323  < 2e-16 ***
    ## bpps_38              -4.570e-01  1.484e-02 -30.792  < 2e-16 ***
    ## bpps_39              -4.236e-01  1.490e-02 -28.429  < 2e-16 ***
    ## bpps_40              -4.500e-01  1.399e-02 -32.159  < 2e-16 ***
    ## bpps_41              -4.593e-01  1.362e-02 -33.713  < 2e-16 ***
    ## bpps_42              -4.766e-01  1.367e-02 -34.877  < 2e-16 ***
    ## bpps_43              -4.708e-01  1.419e-02 -33.179  < 2e-16 ***
    ## bpps_44              -4.598e-01  1.506e-02 -30.527  < 2e-16 ***
    ## bpps_45              -4.271e-01  1.523e-02 -28.037  < 2e-16 ***
    ## bpps_46              -4.047e-01  1.531e-02 -26.437  < 2e-16 ***
    ## bpps_47              -4.309e-01  1.441e-02 -29.896  < 2e-16 ***
    ## bpps_48              -4.610e-01  1.427e-02 -32.299  < 2e-16 ***
    ## bpps_49              -4.177e-01  1.393e-02 -29.991  < 2e-16 ***
    ## bpps_50              -4.686e-01  1.360e-02 -34.469  < 2e-16 ***
    ## bpps_51              -4.352e-01  1.450e-02 -30.003  < 2e-16 ***
    ## bpps_52              -4.869e-01  1.442e-02 -33.768  < 2e-16 ***
    ## bpps_53              -4.938e-01  1.480e-02 -33.352  < 2e-16 ***
    ## bpps_54              -4.886e-01  1.456e-02 -33.559  < 2e-16 ***
    ## bpps_55              -4.451e-01  1.545e-02 -28.805  < 2e-16 ***
    ## bpps_56              -4.996e-01  1.530e-02 -32.661  < 2e-16 ***
    ## bpps_57              -4.212e-01  1.487e-02 -28.334  < 2e-16 ***
    ## bpps_58              -4.656e-01  1.502e-02 -31.009  < 2e-16 ***
    ## bpps_59              -4.422e-01  1.475e-02 -29.976  < 2e-16 ***
    ## bpps_60              -4.276e-01  1.453e-02 -29.422  < 2e-16 ***
    ## bpps_61              -4.653e-01  1.404e-02 -33.148  < 2e-16 ***
    ## bpps_62              -4.207e-01  1.367e-02 -30.785  < 2e-16 ***
    ## bpps_63              -4.539e-01  1.378e-02 -32.930  < 2e-16 ***
    ## bpps_64              -3.877e-01  1.424e-02 -27.224  < 2e-16 ***
    ## bpps_65              -4.052e-01  1.520e-02 -26.661  < 2e-16 ***
    ## bpps_66              -3.129e-01  1.694e-02 -18.468  < 2e-16 ***
    ## bpps_67              -2.768e-01  2.276e-02 -12.162  < 2e-16 ***
    ## bpps_68              -1.502e-01  9.876e-02  -1.521 0.128381    
    ## bpps_69              -2.057e-01  1.003e-01  -2.049 0.040420 *  
    ## bpps_70              -3.495e-01  1.015e-01  -3.444 0.000574 ***
    ## bpps_71              -3.109e-01  1.007e-01  -3.089 0.002012 ** 
    ## bpps_72              -2.865e-01  1.019e-01  -2.810 0.004948 ** 
    ## bpps_73              -2.210e-01  1.063e-01  -2.079 0.037661 *  
    ## bpps_74              -2.289e-01  9.982e-02  -2.293 0.021872 *  
    ## bpps_75              -6.284e-02  1.064e-01  -0.591 0.554644    
    ## bpps_76              -5.105e-01  1.049e-01  -4.866 1.14e-06 ***
    ## bpps_77              -6.980e-02  9.646e-02  -0.724 0.469312    
    ## bpps_78              -2.987e-01  1.085e-01  -2.754 0.005880 ** 
    ## bpps_79              -5.295e-01  1.118e-01  -4.737 2.17e-06 ***
    ## bpps_80              -6.687e-02  1.172e-01  -0.570 0.568358    
    ## bpps_81              -3.453e-01  1.196e-01  -2.888 0.003879 ** 
    ## bpps_82              -3.291e-01  1.236e-01  -2.662 0.007761 ** 
    ## bpps_83              -1.725e-01  1.221e-01  -1.412 0.157922    
    ## bpps_84              -8.537e-02  1.357e-01  -0.629 0.529444    
    ## bpps_85              -3.841e-01  1.628e-01  -2.359 0.018346 *  
    ## bpps_86              -2.027e-01  1.696e-01  -1.196 0.231806    
    ## bpps_87              -1.953e-02  2.493e-01  -0.078 0.937556    
    ## bpps_88              -2.081e-01  2.258e-01  -0.922 0.356672    
    ## bpps_89               4.595e-01  1.966e-01   2.338 0.019410 *  
    ## bpps_90               3.395e-01  1.383e-01   2.455 0.014074 *  
    ## bpps_91              -5.262e-01  1.765e-01  -2.981 0.002875 ** 
    ## bpps_92               1.226e+00  3.255e-01   3.766 0.000166 ***
    ## bpps_93               1.591e+00  2.455e-01   6.479 9.28e-11 ***
    ## bpps_94               3.061e-01  2.025e-01   1.512 0.130647    
    ## bpps_95               6.680e-01  3.048e-01   2.191 0.028430 *  
    ## bpps_96              -1.959e+00  5.314e-01  -3.687 0.000227 ***
    ## bpps_97               1.398e+00  4.317e-01   3.238 0.001203 ** 
    ## bpps_98              -5.914e-01  6.910e-01  -0.856 0.392077    
    ## bpps_99              -3.371e-01  8.148e-01  -0.414 0.679104    
    ## bpps_100             -9.485e-01  6.620e-01  -1.433 0.151931    
    ## bpps_101             -8.777e-01  9.692e-01  -0.906 0.365142    
    ## bpps_102              5.173e-01  8.908e-01   0.581 0.561407    
    ## bpps_103              2.232e+00  6.419e-01   3.478 0.000506 ***
    ## bpps_104             -5.645e-02  8.956e-01  -0.063 0.949738    
    ## bpps_105             -1.030e+00  7.581e-01  -1.359 0.174059    
    ## bpps_106              1.147e+00  4.993e-01   2.298 0.021560 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 0.09280471)
    ## 
    ##     Null deviance: 14493.2  on 86427  degrees of freedom
    ## Residual deviance:  7237.7  on 86287  degrees of freedom
    ## AIC: 3460.9
    ## 
    ## Number of Fisher Scoring iterations: 6

Il est important de noter que le premier modèle n’est pas de plein rang,
donc on ne peut pas se fier à ses prédictions. <br> Cependant, la
pénalisation va nous aider à résoudre ce problème.

``` r
y_pred_gamma_train = predict.glm(model_gamma_deg_50C,data_train,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_train <- mean((y_pred_gamma_train-data_train$deg_50C)^2,na.rm=TRUE)
print(error_gamma_train)
```

    ## [1] 0.1024536

``` r
y_pred_gamma_val=predict.glm(model_gamma_deg_50C,data_val,type="response")
```

    ## Warning in predict.lm(object, newdata, se.fit, scale = 1, type = if (type == :
    ## prediction from a rank-deficient fit may be misleading

``` r
error_gamma_val <- mean((y_pred_gamma_val-data_val$deg_50C)^2,na.rm=TRUE)
print(error_gamma_val)
```

    ## [1] 0.1013885

``` r
models_deg_50C <- c(models_deg_50C, "model_gamma")
errors_deg_50C_train <- c(errors_deg_50C_train, error_gamma_train)
errors_deg_50C_val <- c(errors_deg_50C_val, error_gamma_val)
rm(error_gamma_val, error_gamma_train, y_pred_gamma_train, y_pred_gamma_val)
```

### Pénalisation ridge et lasso

On commence par calculer la matrice de design du model\_gamma\_deg\_50C
sur le train et le test.

``` r
# Matrice de design du train
data_train_pen = model.matrix(model_gamma_deg_50C)
#head(data_train_pen)
```

``` r
# Pour faire la matrice de design de la validation
model_gamma_deg_50C_val = glm(formula = formula_gamma_deg_50C,
                              family = Gamma(link = "log"), data = data_val)
data_val_pen = model.matrix(model_gamma_deg_50C_val)
#head(data_val_pen)

# On supprime le modèle sur le test
rm(model_gamma_deg_50C_val)
```

On pénalise le model\_gamma\_deg\_50C avec une pénalité ridge. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_50C_pen_ridge = cv.glmnet(data_train_pen, data_train$deg_50C,
#                                          type.measure = "mse",
#                                          alpha = 0,
#                                          trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_50C_pen_ridge, "model_gamma_deg_50C_pen_ridge.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_50C_pen_ridge <- readRDS("model_gamma_deg_50C_pen_ridge.rds")
```

``` r
coef(model_gamma_deg_50C_pen_ridge, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                 1
    ## (Intercept)           1.233764010
    ## (Intercept)           .          
    ## sequenceC            -0.015650951
    ## sequenceG             0.085929931
    ## sequenceU             0.044556750
    ## index_sequence       -0.004774663
    ## structure)            0.027603616
    ## structure.            0.021505279
    ## predicted_loop_typeE  0.046013397
    ## predicted_loop_typeH -0.029841463
    ## predicted_loop_typeI -0.092784549
    ## predicted_loop_typeM  0.011034466
    ## predicted_loop_typeS -0.030225006
    ## predicted_loop_typeX  0.020090354
    ## seq_beC              -0.029898428
    ## seq_beG               0.046648189
    ## seq_beO              -0.048970833
    ## seq_beU               0.050613785
    ## seq_afC              -0.256156525
    ## seq_afG              -0.186761028
    ## seq_afO               0.039727388
    ## seq_afU               0.061863688
    ## struct_be)            0.049082780
    ## struct_be.            0.037749806
    ## struct_beO           -0.043505498
    ## struct_af)            0.040609463
    ## struct_af.            0.030739723
    ## struct_afO            0.038862225
    ## loop_type_beE         0.021143457
    ## loop_type_beH         0.023495309
    ## loop_type_beI        -0.001332178
    ## loop_type_beM         0.009904480
    ## loop_type_beO        -0.040438048
    ## loop_type_beS        -0.037221734
    ## loop_type_beX        -0.021520907
    ## loop_type_afE         0.030820581
    ## loop_type_afH        -0.030367078
    ## loop_type_afI         0.019993082
    ## loop_type_afM         0.038242054
    ## loop_type_afO         0.037887012
    ## loop_type_afS        -0.035090618
    ## loop_type_afX         0.076721605
    ## bpps_0                0.063804429
    ## bpps_1               -0.499116983
    ## bpps_2               -0.361069036
    ## bpps_3               -0.688370766
    ## bpps_4               -0.379321121
    ## bpps_5               -0.013839350
    ## bpps_6               -0.083717147
    ## bpps_7               -0.160924265
    ## bpps_8               -0.191851907
    ## bpps_9               -0.244328938
    ## bpps_10              -0.303944999
    ## bpps_11              -0.306371016
    ## bpps_12              -0.260767355
    ## bpps_13              -0.281868127
    ## bpps_14              -0.297354436
    ## bpps_15              -0.276251835
    ## bpps_16              -0.266803842
    ## bpps_17              -0.261021679
    ## bpps_18              -0.267968554
    ## bpps_19              -0.307766929
    ## bpps_20              -0.319586463
    ## bpps_21              -0.331397062
    ## bpps_22              -0.294033116
    ## bpps_23              -0.296755311
    ## bpps_24              -0.280449524
    ## bpps_25              -0.297658286
    ## bpps_26              -0.271192806
    ## bpps_27              -0.277424054
    ## bpps_28              -0.297287017
    ## bpps_29              -0.327741509
    ## bpps_30              -0.326872910
    ## bpps_31              -0.314360583
    ## bpps_32              -0.322080884
    ## bpps_33              -0.342436211
    ## bpps_34              -0.283021750
    ## bpps_35              -0.305219717
    ## bpps_36              -0.188142413
    ## bpps_37              -0.230195231
    ## bpps_38              -0.279694655
    ## bpps_39              -0.241247517
    ## bpps_40              -0.262864195
    ## bpps_41              -0.273453329
    ## bpps_42              -0.283552827
    ## bpps_43              -0.285548730
    ## bpps_44              -0.279489567
    ## bpps_45              -0.260037649
    ## bpps_46              -0.230122993
    ## bpps_47              -0.257561061
    ## bpps_48              -0.275176171
    ## bpps_49              -0.237226646
    ## bpps_50              -0.284704819
    ## bpps_51              -0.249830320
    ## bpps_52              -0.293627846
    ## bpps_53              -0.304936864
    ## bpps_54              -0.307318981
    ## bpps_55              -0.257024275
    ## bpps_56              -0.300430879
    ## bpps_57              -0.242959826
    ## bpps_58              -0.281008939
    ## bpps_59              -0.256424961
    ## bpps_60              -0.245906070
    ## bpps_61              -0.283241365
    ## bpps_62              -0.246889968
    ## bpps_63              -0.283240581
    ## bpps_64              -0.231841970
    ## bpps_65              -0.250692163
    ## bpps_66              -0.181303563
    ## bpps_67              -0.167653232
    ## bpps_68              -0.062137856
    ## bpps_69              -0.173221297
    ## bpps_70              -0.269809714
    ## bpps_71              -0.193041058
    ## bpps_72              -0.190158302
    ## bpps_73              -0.151659437
    ## bpps_74              -0.100575781
    ## bpps_75              -0.049218687
    ## bpps_76              -0.508057837
    ## bpps_77               0.054456316
    ## bpps_78              -0.193515248
    ## bpps_79              -0.390574729
    ## bpps_80               0.017803536
    ## bpps_81              -0.280515163
    ## bpps_82              -0.271901950
    ## bpps_83              -0.101773322
    ## bpps_84               0.009185620
    ## bpps_85              -0.307218029
    ## bpps_86              -0.113229810
    ## bpps_87               0.265769827
    ## bpps_88              -0.168553324
    ## bpps_89               0.498056846
    ## bpps_90               0.292632740
    ## bpps_91              -0.630309759
    ## bpps_92               1.518501271
    ## bpps_93               1.172977699
    ## bpps_94               0.551994334
    ## bpps_95               0.427392889
    ## bpps_96              -1.641758413
    ## bpps_97               1.162506222
    ## bpps_98              -0.620207030
    ## bpps_99              -0.599037317
    ## bpps_100             -0.535997123
    ## bpps_101             -0.786149810
    ## bpps_102              0.127912361
    ## bpps_103              2.784294855
    ## bpps_104             -0.342163250
    ## bpps_105             -0.486589776
    ## bpps_106              2.787837575

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation ridge.

``` r
y_pred_ridge_gamma_train = predict(model_gamma_deg_50C_pen_ridge, data_train_pen,
                                   type = "response", s = "lambda.min")
y_pred_ridge_gamma_val = predict(model_gamma_deg_50C_pen_ridge, data_val_pen,
                                 type = "response", s = "lambda.min")
error_ridge_gamma_train <- mean((y_pred_ridge_gamma_train-data_train$deg_50C)^2,na.rm=TRUE)
print(error_ridge_gamma_train)
```

    ## [1] 0.1067088

``` r
error_ridge_gamma_val <- mean((y_pred_ridge_gamma_val-data_val$deg_50C)^2,na.rm=TRUE)
print(error_ridge_gamma_val)
```

    ## [1] 0.1060946

On pénalise le model\_gamma\_deg\_50C avec une pénalité lasso. On
choisira dans la suite le \(\lambda\) qui minimise l’erreur de cross
validation avec `s = "lambda.min"`. On peut afficher les coefficients du
modèle correspondant.

``` r
#model_gamma_deg_50C_pen_lasso = cv.glmnet(data_train_pen, data_train$deg_50C,
#                                          type.measure = "mse",
#                                          alpha = 1,
#                                          trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_50C_pen_lasso, "model_gamma_deg_50C_pen_lasso.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_50C_pen_lasso <- readRDS("model_gamma_deg_50C_pen_lasso.rds")
```

``` r
coef(model_gamma_deg_50C_pen_lasso, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                  1
    ## (Intercept)           1.282584e+00
    ## (Intercept)           .           
    ## sequenceC             3.718663e-03
    ## sequenceG             1.037246e-01
    ## sequenceU             5.952255e-02
    ## index_sequence       -5.206251e-03
    ## structure)            2.127951e-02
    ## structure.           -3.458738e-04
    ## predicted_loop_typeE  5.245702e-02
    ## predicted_loop_typeH -6.133051e-02
    ## predicted_loop_typeI -1.243975e-01
    ## predicted_loop_typeM -1.064427e-02
    ## predicted_loop_typeS -7.387515e-03
    ## predicted_loop_typeX -2.815124e-03
    ## seq_beC              -2.566868e-02
    ## seq_beG               5.147492e-02
    ## seq_beO              -1.199854e-01
    ## seq_beU               5.834336e-02
    ## seq_afC              -2.694233e-01
    ## seq_afG              -1.994751e-01
    ## seq_afO               9.027109e-02
    ## seq_afU               5.851586e-02
    ## struct_be)            6.288936e-02
    ## struct_be.            7.728934e-02
    ## struct_beO           -2.600452e-03
    ## struct_af)            5.439860e-02
    ## struct_af.            .           
    ## struct_afO            7.804371e-04
    ## loop_type_beE        -4.426377e-03
    ## loop_type_beH         2.664321e-02
    ## loop_type_beI         .           
    ## loop_type_beM         1.471372e-02
    ## loop_type_beO        -3.460967e-04
    ## loop_type_beS        -2.085616e-05
    ## loop_type_beX        -1.474965e-02
    ## loop_type_afE         2.397737e-02
    ## loop_type_afH        -1.979410e-02
    ## loop_type_afI         2.908123e-02
    ## loop_type_afM         4.398996e-02
    ## loop_type_afO         4.111346e-03
    ## loop_type_afS        -5.531125e-02
    ## loop_type_afX         8.871278e-02
    ## bpps_0               -9.459019e-02
    ## bpps_1               -6.167621e-01
    ## bpps_2               -4.299283e-01
    ## bpps_3               -8.381779e-01
    ## bpps_4               -5.235118e-01
    ## bpps_5               -1.178186e-01
    ## bpps_6               -1.892294e-01
    ## bpps_7               -2.707000e-01
    ## bpps_8               -3.001418e-01
    ## bpps_9               -3.554490e-01
    ## bpps_10              -4.209561e-01
    ## bpps_11              -4.235744e-01
    ## bpps_12              -3.744919e-01
    ## bpps_13              -3.984377e-01
    ## bpps_14              -4.129905e-01
    ## bpps_15              -3.910702e-01
    ## bpps_16              -3.803015e-01
    ## bpps_17              -3.738701e-01
    ## bpps_18              -3.789449e-01
    ## bpps_19              -4.242709e-01
    ## bpps_20              -4.352348e-01
    ## bpps_21              -4.472094e-01
    ## bpps_22              -4.100709e-01
    ## bpps_23              -4.116974e-01
    ## bpps_24              -3.913525e-01
    ## bpps_25              -4.124298e-01
    ## bpps_26              -3.836267e-01
    ## bpps_27              -3.871612e-01
    ## bpps_28              -4.082075e-01
    ## bpps_29              -4.434939e-01
    ## bpps_30              -4.406671e-01
    ## bpps_31              -4.299502e-01
    ## bpps_32              -4.365355e-01
    ## bpps_33              -4.581738e-01
    ## bpps_34              -3.939107e-01
    ## bpps_35              -4.180013e-01
    ## bpps_36              -2.939948e-01
    ## bpps_37              -3.356989e-01
    ## bpps_38              -3.878809e-01
    ## bpps_39              -3.444521e-01
    ## bpps_40              -3.634125e-01
    ## bpps_41              -3.782913e-01
    ## bpps_42              -3.900677e-01
    ## bpps_43              -3.933728e-01
    ## bpps_44              -3.872110e-01
    ## bpps_45              -3.645889e-01
    ## bpps_46              -3.328915e-01
    ## bpps_47              -3.611474e-01
    ## bpps_48              -3.795169e-01
    ## bpps_49              -3.388926e-01
    ## bpps_50              -3.881788e-01
    ## bpps_51              -3.514465e-01
    ## bpps_52              -3.981582e-01
    ## bpps_53              -4.114511e-01
    ## bpps_54              -4.135476e-01
    ## bpps_55              -3.607168e-01
    ## bpps_56              -4.054503e-01
    ## bpps_57              -3.453852e-01
    ## bpps_58              -3.859105e-01
    ## bpps_59              -3.587202e-01
    ## bpps_60              -3.444192e-01
    ## bpps_61              -3.891447e-01
    ## bpps_62              -3.484261e-01
    ## bpps_63              -3.885622e-01
    ## bpps_64              -3.337895e-01
    ## bpps_65              -3.531705e-01
    ## bpps_66              -2.839380e-01
    ## bpps_67              -2.605462e-01
    ## bpps_68              -1.576285e-01
    ## bpps_69              -2.608014e-01
    ## bpps_70              -3.601370e-01
    ## bpps_71              -2.934492e-01
    ## bpps_72              -2.950483e-01
    ## bpps_73              -2.664007e-01
    ## bpps_74              -2.161911e-01
    ## bpps_75              -7.140513e-02
    ## bpps_76              -5.894704e-01
    ## bpps_77              -6.693949e-02
    ## bpps_78              -3.096341e-01
    ## bpps_79              -5.170362e-01
    ## bpps_80              -5.945307e-02
    ## bpps_81              -3.761995e-01
    ## bpps_82              -3.562767e-01
    ## bpps_83              -1.843134e-01
    ## bpps_84              -9.512559e-02
    ## bpps_85              -4.402390e-01
    ## bpps_86              -2.099450e-01
    ## bpps_87               1.250288e-01
    ## bpps_88              -2.563191e-01
    ## bpps_89               3.948119e-01
    ## bpps_90               1.422384e-01
    ## bpps_91              -7.067807e-01
    ## bpps_92               1.415668e+00
    ## bpps_93               1.219040e+00
    ## bpps_94               4.061061e-01
    ## bpps_95               4.146023e-01
    ## bpps_96              -2.028438e+00
    ## bpps_97               1.201849e+00
    ## bpps_98              -7.794030e-01
    ## bpps_99              -5.985034e-01
    ## bpps_100             -1.380261e+00
    ## bpps_101             -9.264376e-01
    ## bpps_102              2.054188e-01
    ## bpps_103              3.462633e+00
    ## bpps_104             -4.393403e-01
    ## bpps_105             -1.035173e+00
    ## bpps_106              2.424762e+00

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation lasso.

``` r
y_pred_lasso_gamma_train = predict(model_gamma_deg_50C_pen_lasso, data_train_pen,
                                   type="response", s="lambda.min")
error_lasso_gamma_train <- mean((y_pred_lasso_gamma_train-data_train$deg_50C)^2,na.rm=TRUE)
print(error_lasso_gamma_train)
```

    ## [1] 0.1061319

``` r
y_pred_lasso_gamma_val = predict(model_gamma_deg_50C_pen_lasso, data_val_pen,
                                 type="response", s="lambda.min")
error_lasso_gamma_val <- mean((y_pred_lasso_gamma_val-data_val$deg_50C)^2,na.rm=TRUE)
print(error_lasso_gamma_val)
```

    ## [1] 0.1052459

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_50C <- c(models_deg_50C, "model_gamma_ridge", "model_gamma_lasso")
errors_deg_50C_train <- c(errors_deg_50C_train, error_ridge_gamma_train,
                             error_lasso_gamma_train)
errors_deg_50C_val <- c(errors_deg_50C_val, error_ridge_gamma_val, error_lasso_gamma_val)
rm(error_ridge_gamma_val, error_lasso_gamma_val,
   error_ridge_gamma_train, error_lasso_gamma_train,
   y_pred_ridge_gamma_train, y_pred_ridge_gamma_val,
   y_pred_lasso_gamma_train, y_pred_lasso_gamma_val)
```

### Pénalisation elastic-net

On choisit \(\alpha\) qui minimise le MSE sur la validation.

``` r
#alpha_opti_enet_gamma_deg_50C =
#  alpha_opti_enet(data_train = data_train_pen, data_val = data_val_pen,
#                  y_true_train = data_train$deg_50C,
#                  y_true_val = data_val$deg_50C)
```

On trouve \(\alpha = 0.9\).

``` r
#print(alpha_opti_enet_gamma_deg_50C)
```

On construit le modèle avec le choix optimal pour \(\alpha\).

``` r
#model_gamma_deg_50C_pen_enet = cv.glmnet(data_train_pen, data_train$deg_50C,
#                                         type.measure = "mse",
#                                         alpha = alpha_opti_enet_gamma_deg_50C,
#                                         trace.it = 1)
```

Sauvegarde du modèle.

``` r
#saveRDS(model_gamma_deg_50C_pen_enet, "model_gamma_deg_50C_pen_enet.rds")
```

Chargement du modèle.

``` r
model_gamma_deg_50C_pen_enet <- readRDS("model_gamma_deg_50C_pen_enet.rds")
```

``` r
coef(model_gamma_deg_50C_pen_enet, s = "lambda.min")
```

    ## 149 x 1 sparse Matrix of class "dgCMatrix"
    ##                                 1
    ## (Intercept)           1.281691172
    ## (Intercept)           .          
    ## sequenceC             0.003605559
    ## sequenceG             0.103638327
    ## sequenceU             0.059430212
    ## index_sequence       -0.005205080
    ## structure)            0.020693693
    ## structure.            .          
    ## predicted_loop_typeE  0.056228327
    ## predicted_loop_typeH -0.059836382
    ## predicted_loop_typeI -0.122909651
    ## predicted_loop_typeM -0.009057070
    ## predicted_loop_typeS -0.005450353
    ## predicted_loop_typeX -0.001402770
    ## seq_beC              -0.025664361
    ## seq_beG               0.051471290
    ## seq_beO              -0.115670004
    ## seq_beU               0.058314694
    ## seq_afC              -0.269427918
    ## seq_afG              -0.199495080
    ## seq_afO               0.080028888
    ## seq_afU               0.058491805
    ## struct_be)            0.063141638
    ## struct_be.            0.077553265
    ## struct_beO           -0.007685591
    ## struct_af)            0.054655080
    ## struct_af.            .          
    ## struct_afO            0.009719679
    ## loop_type_beE        -0.005418477
    ## loop_type_beH         0.026479964
    ## loop_type_beI         .          
    ## loop_type_beM         0.014472869
    ## loop_type_beO        -0.000162315
    ## loop_type_beS         .          
    ## loop_type_beX        -0.014792008
    ## loop_type_afE         0.021415326
    ## loop_type_afH        -0.020905300
    ## loop_type_afI         0.027906479
    ## loop_type_afM         0.042810457
    ## loop_type_afO         0.004100376
    ## loop_type_afS        -0.056557579
    ## loop_type_afX         0.087557465
    ## bpps_0               -0.093608693
    ## bpps_1               -0.615872814
    ## bpps_2               -0.429299610
    ## bpps_3               -0.836925463
    ## bpps_4               -0.522534500
    ## bpps_5               -0.117172930
    ## bpps_6               -0.188793618
    ## bpps_7               -0.270308743
    ## bpps_8               -0.299779647
    ## bpps_9               -0.355112832
    ## bpps_10              -0.420576424
    ## bpps_11              -0.423168066
    ## bpps_12              -0.374083704
    ## bpps_13              -0.398028990
    ## bpps_14              -0.412582218
    ## bpps_15              -0.390716415
    ## bpps_16              -0.379926150
    ## bpps_17              -0.373511090
    ## bpps_18              -0.378602746
    ## bpps_19              -0.423915429
    ## bpps_20              -0.434867640
    ## bpps_21              -0.446847069
    ## bpps_22              -0.409718204
    ## bpps_23              -0.411312178
    ## bpps_24              -0.390932900
    ## bpps_25              -0.412008942
    ## bpps_26              -0.383236414
    ## bpps_27              -0.386813411
    ## bpps_28              -0.407862427
    ## bpps_29              -0.443133208
    ## bpps_30              -0.440308009
    ## bpps_31              -0.429577727
    ## bpps_32              -0.436173142
    ## bpps_33              -0.457808153
    ## bpps_34              -0.393522748
    ## bpps_35              -0.417628778
    ## bpps_36              -0.293593420
    ## bpps_37              -0.335372064
    ## bpps_38              -0.387549470
    ## bpps_39              -0.344143322
    ## bpps_40              -0.363105279
    ## bpps_41              -0.377986626
    ## bpps_42              -0.389771462
    ## bpps_43              -0.393029248
    ## bpps_44              -0.386921864
    ## bpps_45              -0.364337948
    ## bpps_46              -0.332591506
    ## bpps_47              -0.360837959
    ## bpps_48              -0.379218255
    ## bpps_49              -0.338620509
    ## bpps_50              -0.387909848
    ## bpps_51              -0.351167684
    ## bpps_52              -0.397891145
    ## bpps_53              -0.411187812
    ## bpps_54              -0.413260316
    ## bpps_55              -0.360453233
    ## bpps_56              -0.405168728
    ## bpps_57              -0.345124713
    ## bpps_58              -0.385644718
    ## bpps_59              -0.358466535
    ## bpps_60              -0.344139075
    ## bpps_61              -0.388870856
    ## bpps_62              -0.348143019
    ## bpps_63              -0.388264895
    ## bpps_64              -0.333501401
    ## bpps_65              -0.352741723
    ## bpps_66              -0.283494029
    ## bpps_67              -0.259642342
    ## bpps_68              -0.157069742
    ## bpps_69              -0.260243739
    ## bpps_70              -0.359532334
    ## bpps_71              -0.292693783
    ## bpps_72              -0.294321214
    ## bpps_73              -0.265644400
    ## bpps_74              -0.215506768
    ## bpps_75              -0.070731241
    ## bpps_76              -0.589051156
    ## bpps_77              -0.066086861
    ## bpps_78              -0.308771391
    ## bpps_79              -0.516445527
    ## bpps_80              -0.059003910
    ## bpps_81              -0.375610572
    ## bpps_82              -0.355427977
    ## bpps_83              -0.183771033
    ## bpps_84              -0.094530484
    ## bpps_85              -0.439083462
    ## bpps_86              -0.208529565
    ## bpps_87               0.124781179
    ## bpps_88              -0.254837738
    ## bpps_89               0.394503809
    ## bpps_90               0.142210235
    ## bpps_91              -0.705725029
    ## bpps_92               1.415203829
    ## bpps_93               1.217091805
    ## bpps_94               0.405694289
    ## bpps_95               0.412520230
    ## bpps_96              -2.024736855
    ## bpps_97               1.202054202
    ## bpps_98              -0.776199499
    ## bpps_99              -0.586806928
    ## bpps_100             -1.376497701
    ## bpps_101             -0.924620159
    ## bpps_102              0.186451980
    ## bpps_103              3.459795491
    ## bpps_104             -0.437900543
    ## bpps_105             -1.027762368
    ## bpps_106              2.426145605

On calcule les prédictions et les erreurs pour le modèle avec
pénalisation elastic-net.

``` r
y_pred_enet_gamma_train = predict(model_gamma_deg_50C_pen_enet, data_train_pen,
                                   type = "response", s = "lambda.min")
error_enet_gamma_train <- mean((y_pred_enet_gamma_train - data_train$deg_50C)^2, na.rm=TRUE)
print(error_enet_gamma_train)
```

    ## [1] 0.1061323

``` r
y_pred_enet_gamma_val = predict(model_gamma_deg_50C_pen_enet, data_val_pen,
                                 type = "response", s = "lambda.min")
error_enet_gamma_val <- mean((y_pred_enet_gamma_val - data_val$deg_50C)^2, na.rm=TRUE)
print(error_enet_gamma_val)
```

    ## [1] 0.1052456

On stocke les résultats et on supprime les variables temporaires.

``` r
models_deg_50C <- c(models_deg_50C, "model_gamma_enet")
errors_deg_50C_train <- c(errors_deg_50C_train, error_enet_gamma_train)
errors_deg_50C_val <- c(errors_deg_50C_val, error_enet_gamma_val)
rm(error_enet_gamma_train, error_enet_gamma_val,
   y_pred_enet_gamma_train, y_pred_enet_gamma_val)
```

### Récapitulatif des résultats

``` r
models_deg_50C_errors_df <- data.frame(models_deg_50C,
                                       errors_deg_50C_train,
                                       errors_deg_50C_val)
```

``` r
models_deg_50C_errors_df
```

    ##      models_deg_50C errors_deg_50C_train errors_deg_50C_val
    ## 1       model_gamma            0.1024536          0.1013885
    ## 2 model_gamma_ridge            0.1067088          0.1060946
    ## 3 model_gamma_lasso            0.1061319          0.1052459
    ## 4  model_gamma_enet            0.1061323          0.1052456

Le meilleur modèle (au sens de la minimisation du MSE sur la validation)
est le `model_gamma_lasso` (si on exclut le premier modèle qui n’était
pas de plein rang).

``` r
models_deg_50C_errors_df[which.min(errors_deg_50C_val[-1]) + 1, ]
```

    ##     models_deg_50C errors_deg_50C_train errors_deg_50C_val
    ## 4 model_gamma_enet            0.1061323          0.1052456

<a id="soumission1"></a>

# Soumission GLM

``` r
#alpha_enet_df <- data.frame(reactivity = alpha_opti_enet_gamma_reactivity,
#                            deg_Mg_pH10 = alpha_opti_enet_gamma_deg_Mg_pH10,
#                            deg_pH10 = alpha_opti_enet_gamma_deg_pH10,
#                            deg_Mg_50C = alpha_opti_enet_gamma_deg_Mg_50C,
#                            deg_50C = alpha_opti_enet_gamma_deg_50C)
```

``` r
#alpha_enet_df
```

``` r
##save(alpha_enet_df, file = "alpha_enet_df.Rda")
load(file = "alpha_enet_df.Rda")
```

``` r
alpha_opti_enet_gamma_reactivity <- alpha_enet_df$reactivity
  
alpha_opti_enet_gamma_deg_Mg_pH10 <- alpha_enet_df$deg_Mg_pH10
  
alpha_opti_enet_gamma_deg_pH10 <- alpha_enet_df$deg_pH10
  
alpha_opti_enet_gamma_deg_Mg_50C <- alpha_enet_df$deg_Mg_50C
  
alpha_opti_enet_gamma_deg_50C <- alpha_enet_df$deg_50C
```

``` r
##data_test=read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_test.csv")
#data_test = read.csv("data_test.csv")
```

``` r
#data_test = data_test[,-1] %>% mutate(sequence = as.factor(sequence)) %>% 
#  mutate(seq_be = as.factor(seq_be)) %>% 
#  mutate(seq_af = as.factor(seq_af)) %>% 
#  mutate(structure = as.factor(structure)) %>% 
#  mutate(predicted_loop_type = as.factor(predicted_loop_type))
#
## On ajoute de "faux labels" pour pouvoir construire la matrice de design du test
## La matrice de design d'un modèle n'est pas influencée par la valeur des labels
## donc cette démarche est correcte
#data_test = data_test %>% mutate(reactivity = rep(0.5, nrow(data_test))) %>% 
#  mutate(deg_Mg_pH10 = rep(0.5, nrow(data_test))) %>% 
#  mutate(deg_pH10 = rep(0.5, nrow(data_test))) %>% 
#  mutate(deg_Mg_50C = rep(0.5, nrow(data_test))) %>% 
#  mutate(deg_50C = rep(0.5, nrow(data_test)))
```

``` r
#head(data_test)
```

``` r
#head(data_test[,119:123])
```

``` r
##y_test_pred=read.csv(file = "~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/sample_submission.csv")

#y_test_pred = read.csv(file = "sample_submission.csv")
```

``` r
#model_reactivity = readRDS("model_gamma_reactivity_pen_enet.rds")
#model_deg_Mg_pH10 = readRDS("model_gamma_deg_Mg_pH10_pen_enet.rds")
#model_deg_pH10 = readRDS("model_gamma_deg_pH10_pen_enet.rds")
#model_deg_Mg_50C = readRDS("model_gamma_deg_Mg_50C_pen_enet.rds")
#model_deg_50C = readRDS("model_gamma_deg_50C_pen_enet.rds")
```

``` r
## Pour faire la matrice de design du train

#model_gamma_reactivity_train = glm(formula = formula_gamma_reactivity,
#                               family = Gamma(link = "log"), data = data)
#data_pen_reactivity = model.matrix(model_gamma_reactivity_train)
#
#model_gamma_deg_Mg_pH10_train = glm(formula = formula_gamma_deg_Mg_pH10,
#                               family = Gamma(link = "log"), data = data)
#data_pen_deg_Mg_pH10 = model.matrix(model_gamma_deg_Mg_pH10_train)
#
#model_gamma_deg_pH10_train = glm(formula = formula_gamma_deg_pH10,
#                               family = Gamma(link = "log"), data = data)
#data_pen_deg_pH10 = model.matrix(model_gamma_deg_pH10_train)
#
#model_gamma_deg_Mg_50C_train = glm(formula = formula_gamma_deg_Mg_50C,
#                                  family = Gamma(link = "log"), data = data)
#data_pen_deg_Mg_50C = model.matrix(model_gamma_deg_Mg_50C_train)
#
#model_gamma_deg_50C_train = glm(formula = formula_gamma_deg_50C,
#                               family = Gamma(link = "log"), data = data)
#data_pen_deg_50C = model.matrix(model_gamma_deg_50C_train)
```

``` r
#model_reactivity = update(object = model_reactivity,
#                          x = data_pen_reactivity, y = data$reactivity)
#model_deg_Mg_pH10 = update(object = model_deg_Mg_pH10,
#                           x = data_pen_deg_Mg_pH10, y = data$deg_Mg_pH10)
#model_deg_pH10 = update(object = model_deg_pH10,
#                        x = data_pen_deg_pH10, y = data$deg_pH10)
#model_deg_Mg_50C = update(object = model_deg_Mg_50C,
#                          x = data_pen_deg_Mg_50C, y = data$deg_Mg_50C)
#model_deg_50C = update(object = model_deg_50C,
#                       x = data_pen_deg_50C, y = data$deg_50C)
```

``` r
#saveRDS(model_reactivity, file = "model_reactivity.rds")
#saveRDS(model_deg_Mg_pH10, file = "model_deg_Mg_pH10.rds")
#saveRDS(model_deg_pH10, file = "model_deg_pH10.rds")
#saveRDS(model_deg_Mg_50C, file = "model_deg_Mg_50C.rds")
#saveRDS(model_deg_50C, file = "model_deg_50C.rds")
```

``` r
#model_reactivity = readRDS("model_reactivity.rds")
#model_deg_Mg_pH10 = readRDS("model_deg_Mg_pH10.rds")
#model_deg_pH10 = readRDS("model_deg_pH10.rds")
#model_deg_Mg_50C = readRDS("model_deg_Mg_50C.rds")
#model_deg_50C = readRDS("model_deg_50C.rds")
```

``` r
## Pour faire la matrice de design du test

#model_gamma_reactivity_test = glm(formula = formula_gamma_reactivity,
#                               family = Gamma(link = "log"), data = data_test)
#data_test_pen_reactivity = model.matrix(model_gamma_reactivity_test)
#
#model_gamma_deg_Mg_pH10_test = glm(formula = formula_gamma_deg_Mg_pH10,
#                               family = Gamma(link = "log"), data = data_test)
#data_test_pen_deg_Mg_pH10 = model.matrix(model_gamma_deg_Mg_pH10_test)
#
#model_gamma_deg_pH10_test = glm(formula = formula_gamma_deg_pH10,
#                               family = Gamma(link = "log"), data = data_test)
#data_test_pen_deg_pH10 = model.matrix(model_gamma_deg_pH10_test)
#
#model_gamma_deg_Mg_50C_test = glm(formula = formula_gamma_deg_Mg_50C,
#                                  family = Gamma(link = "log"), data = data_test)
#data_test_pen_deg_Mg_50C = model.matrix(model_gamma_deg_Mg_50C_test)
#
#model_gamma_deg_50C_test = glm(formula = formula_gamma_deg_50C,
#                               family = Gamma(link = "log"), data = data_test)
#data_test_pen_deg_50C = model.matrix(model_gamma_deg_50C_test)
```

``` r
## On supprime les modèles sur le test
#rm(model_gamma_reactivity_test, model_gamma_deg_Mg_pH10_test,
#   model_gamma_deg_pH10_test, model_gamma_deg_Mg_50C_test,
#   model_gamma_deg_50C_test)
```

``` r
## ATTENTION: nos modèles prédisent les labels translatés, donc il faut revenir aux labels initiaux en retirant la translation (on a stocké l'opposé de la translation de chaque label dans translation_labels, d'où le "+" au lieu du "-")

#y_test_pred = y_test_pred %>%
#  mutate(reactivity = predict(model_reactivity, data_test_pen_reactivity,
#                              type="response", s="lambda.min") +
#           translation_labels[1]) %>%
#  mutate(deg_Mg_pH10 = predict(model_deg_Mg_pH10, data_test_pen_deg_Mg_pH10,
#                               type="response", s="lambda.min") +
#           translation_labels[2]) %>%
#  mutate(deg_pH10 = predict(model_deg_pH10, data_test_pen_deg_pH10,
#                            type="response", s="lambda.min") +
#           translation_labels[3]) %>%
#  mutate(deg_Mg_50C = predict(model_deg_Mg_50C, data_test_pen_deg_Mg_50C,
#                              type="response", s="lambda.min") +
#           translation_labels[4]) %>%
#  mutate(deg_50C = predict(model_deg_50C, data_test_pen_deg_50C,
#                           type="response", s="lambda.min") +
#           translation_labels[5]) %>% mutate_all(unlist)
```

``` r
#save(y_test_pred, file = "sample_submission_GLM.Rda")
```

``` r
#load(file = "sample_submission_GLM.Rda")
```

``` r
#fwrite(y_test_pred, "sample_submission_GLM.csv")
```

<a id="data2"></a>

# Second chargement des données

Chargement du jeu de données.

``` r
# data = read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_train.csv")
data = read.csv("data_train.csv")
head(data) # une colonne en trop
```

    ##   X             id sequence index_sequence seq_be seq_af structure struct_be
    ## 1 0 id_001f94081_0        G              1      O      G         .         O
    ## 2 1 id_001f94081_1        G              2      G      A         .         .
    ## 3 2 id_001f94081_2        A              3      G      A         .         .
    ## 4 3 id_001f94081_3        A              4      A      A         .         .
    ## 5 4 id_001f94081_4        A              5      A      A         .         .
    ## 6 5 id_001f94081_5        A              6      A      G         (         .
    ##   struct_af predicted_loop_type loop_type_be loop_type_af bpps_0 bpps_1 bpps_2
    ## 1         .                   E            O            E      0      0      0
    ## 2         .                   E            E            E      0      0      0
    ## 3         .                   E            E            E      0      0      0
    ## 4         .                   E            E            E      0      0      0
    ## 5         (                   E            E            S      0      0      0
    ## 6         (                   S            E            S      0      0      0
    ##   bpps_3 bpps_4 bpps_5 bpps_6     bpps_7     bpps_8     bpps_9    bpps_10
    ## 1      0      0      0      0 0.00655413 0.00922102 0.00809437 0.02178570
    ## 2      0      0      0      0 0.01820530 0.00511209 0.03865270 0.00000000
    ## 3      0      0      0      0 0.00000000 0.02759040 0.00000000 0.00000000
    ## 4      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 5      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 6      0      0      0      0 0.00000000 0.00310716 0.00000000 0.00117008
    ##   bpps_11 bpps_12 bpps_13 bpps_14 bpps_15    bpps_16 bpps_17 bpps_18 bpps_19
    ## 1       0       0       0       0       0 0.00112002       0       0       0
    ## 2       0       0       0       0       0 0.00000000       0       0       0
    ## 3       0       0       0       0       0 0.00000000       0       0       0
    ## 4       0       0       0       0       0 0.00000000       0       0       0
    ## 5       0       0       0       0       0 0.00000000       0       0       0
    ## 6       0       0       0       0       0 0.00000000       0       0       0
    ##   bpps_20 bpps_21 bpps_22    bpps_23    bpps_24 bpps_25 bpps_26 bpps_27 bpps_28
    ## 1       0       0       0 0.00465301 0.00241507       0       0       0       0
    ## 2       0       0       0 0.00432340 0.00000000       0       0       0       0
    ## 3       0       0       0 0.00000000 0.00000000       0       0       0       0
    ## 4       0       0       0 0.00000000 0.00127806       0       0       0       0
    ## 5       0       0       0 0.00000000 0.00284297       0       0       0       0
    ## 6       0       0       0 0.00000000 0.06989900       0       0       0       0
    ##      bpps_29    bpps_30 bpps_31    bpps_32 bpps_33 bpps_34 bpps_35    bpps_36
    ## 1 0.01146960 0.00492862       0 0.00353196       0       0       0 0.00000000
    ## 2 0.00856126 0.00000000       0 0.00113814       0       0       0 0.00000000
    ## 3 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00000000
    ## 4 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00105140
    ## 5 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00702873
    ## 6 0.00000000 0.00685149       0 0.00000000       0       0       0 0.00000000
    ##      bpps_37    bpps_38    bpps_39    bpps_40 bpps_41 bpps_42 bpps_43 bpps_44
    ## 1 0.00000000 0.00000000 0.00159406 0.00629747       0       0       0       0
    ## 2 0.00000000 0.00144827 0.01117350 0.00000000       0       0       0       0
    ## 3 0.00132569 0.01070460 0.00000000 0.00000000       0       0       0       0
    ## 4 0.00947066 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 5 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 6 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ##   bpps_45 bpps_46 bpps_47 bpps_48 bpps_49 bpps_50 bpps_51 bpps_52 bpps_53
    ## 1       0       0       0       0       0       0       0       0       0
    ## 2       0       0       0       0       0       0       0       0       0
    ## 3       0       0       0       0       0       0       0       0       0
    ## 4       0       0       0       0       0       0       0       0       0
    ## 5       0       0       0       0       0       0       0       0       0
    ## 6       0       0       0       0       0       0       0       0       0
    ##   bpps_54 bpps_55    bpps_56    bpps_57    bpps_58 bpps_59    bpps_60 bpps_61
    ## 1       0       0 0.00000000 0.00529590 0.00605378       0 0.00000000       0
    ## 2       0       0 0.00515096 0.00579555 0.00000000       0 0.00000000       0
    ## 3       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 4       0       0 0.00000000 0.00000000 0.00000000       0 0.00132209       0
    ## 5       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 6       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ##     bpps_62   bpps_63 bpps_64 bpps_65    bpps_66 bpps_67 bpps_68 bpps_69
    ## 1 0.0012753 0.0136668       0       0 0.00152313       0       0       0
    ## 2 0.0133479 0.0000000       0       0 0.00000000       0       0       0
    ## 3 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 4 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 5 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 6 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ##   bpps_70 bpps_71 bpps_72 bpps_73 bpps_74 bpps_75    bpps_76    bpps_77 bpps_78
    ## 1       0       0       0       0       0       0 0.00000000 0.00141133       0
    ## 2       0       0       0       0       0       0 0.00000000 0.00443669       0
    ## 3       0       0       0       0       0       0 0.00287931 0.00000000       0
    ## 4       0       0       0       0       0       0 0.00000000 0.00000000       0
    ## 5       0       0       0       0       0       0 0.00140816 0.00000000       0
    ## 6       0       0       0       0       0       0 0.04401610 0.00000000       0
    ##      bpps_79    bpps_80    bpps_81   bpps_82 bpps_83 bpps_84    bpps_85 bpps_86
    ## 1 0.00275790 0.00598010 0.00597894 0.0138868       0       0 0.00152801       0
    ## 2 0.00969451 0.00376965 0.02291480 0.0000000       0       0 0.00000000       0
    ## 3 0.00000000 0.01750240 0.00000000 0.0000000       0       0 0.00000000       0
    ## 4 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 5 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 6 0.00000000 0.00235197 0.00000000 0.0000000       0       0 0.00000000       0
    ##   bpps_87 bpps_88 bpps_89 bpps_90 bpps_91 bpps_92 bpps_93    bpps_94 bpps_95
    ## 1       0       0       0       0       0       0       0 0.00952557       0
    ## 2       0       0       0       0       0       0       0 0.00578259       0
    ## 3       0       0       0       0       0       0       0 0.00000000       0
    ## 4       0       0       0       0       0       0       0 0.00000000       0
    ## 5       0       0       0       0       0       0       0 0.00000000       0
    ## 6       0       0       0       0       0       0       0 0.00000000       0
    ##   bpps_96    bpps_97 bpps_98 bpps_99   bpps_100 bpps_101 bpps_102   bpps_103
    ## 1       0 0.01114590       0       0 0.01163650        0        0 0.01053770
    ## 2       0 0.00633638       0       0 0.00603195        0        0 0.00563282
    ## 3       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 4       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 5       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 6       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ##   bpps_104 bpps_105   bpps_106 signal_to_noise SN_filter reactivity deg_Mg_pH10
    ## 1        0        0 0.01467360           6.894         1     0.3297      0.7556
    ## 2        0        0 0.00620374           6.894         1     1.5693      2.9830
    ## 3        0        0 0.00000000           6.894         1     1.1227      0.2526
    ## 4        0        0 0.00000000           6.894         1     0.8686      1.3789
    ## 5        0        0 0.00000000           6.894         1     0.7217      0.6376
    ## 6        0        0 0.00000000           6.894         1     0.4384      0.3313
    ##   deg_pH10 deg_Mg_50C deg_50C
    ## 1   2.3375     0.3581  0.6382
    ## 2   3.5060     2.9683  3.4773
    ## 3   0.3008     0.2589  0.9988
    ## 4   1.0108     1.4552  1.3228
    ## 5   0.2635     0.7244  0.7877
    ## 6   0.3403     0.4971  0.5890

``` r
data = data[,-1]
head(data)
```

    ##               id sequence index_sequence seq_be seq_af structure struct_be
    ## 1 id_001f94081_0        G              1      O      G         .         O
    ## 2 id_001f94081_1        G              2      G      A         .         .
    ## 3 id_001f94081_2        A              3      G      A         .         .
    ## 4 id_001f94081_3        A              4      A      A         .         .
    ## 5 id_001f94081_4        A              5      A      A         .         .
    ## 6 id_001f94081_5        A              6      A      G         (         .
    ##   struct_af predicted_loop_type loop_type_be loop_type_af bpps_0 bpps_1 bpps_2
    ## 1         .                   E            O            E      0      0      0
    ## 2         .                   E            E            E      0      0      0
    ## 3         .                   E            E            E      0      0      0
    ## 4         .                   E            E            E      0      0      0
    ## 5         (                   E            E            S      0      0      0
    ## 6         (                   S            E            S      0      0      0
    ##   bpps_3 bpps_4 bpps_5 bpps_6     bpps_7     bpps_8     bpps_9    bpps_10
    ## 1      0      0      0      0 0.00655413 0.00922102 0.00809437 0.02178570
    ## 2      0      0      0      0 0.01820530 0.00511209 0.03865270 0.00000000
    ## 3      0      0      0      0 0.00000000 0.02759040 0.00000000 0.00000000
    ## 4      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 5      0      0      0      0 0.00000000 0.00000000 0.00000000 0.00000000
    ## 6      0      0      0      0 0.00000000 0.00310716 0.00000000 0.00117008
    ##   bpps_11 bpps_12 bpps_13 bpps_14 bpps_15    bpps_16 bpps_17 bpps_18 bpps_19
    ## 1       0       0       0       0       0 0.00112002       0       0       0
    ## 2       0       0       0       0       0 0.00000000       0       0       0
    ## 3       0       0       0       0       0 0.00000000       0       0       0
    ## 4       0       0       0       0       0 0.00000000       0       0       0
    ## 5       0       0       0       0       0 0.00000000       0       0       0
    ## 6       0       0       0       0       0 0.00000000       0       0       0
    ##   bpps_20 bpps_21 bpps_22    bpps_23    bpps_24 bpps_25 bpps_26 bpps_27 bpps_28
    ## 1       0       0       0 0.00465301 0.00241507       0       0       0       0
    ## 2       0       0       0 0.00432340 0.00000000       0       0       0       0
    ## 3       0       0       0 0.00000000 0.00000000       0       0       0       0
    ## 4       0       0       0 0.00000000 0.00127806       0       0       0       0
    ## 5       0       0       0 0.00000000 0.00284297       0       0       0       0
    ## 6       0       0       0 0.00000000 0.06989900       0       0       0       0
    ##      bpps_29    bpps_30 bpps_31    bpps_32 bpps_33 bpps_34 bpps_35    bpps_36
    ## 1 0.01146960 0.00492862       0 0.00353196       0       0       0 0.00000000
    ## 2 0.00856126 0.00000000       0 0.00113814       0       0       0 0.00000000
    ## 3 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00000000
    ## 4 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00105140
    ## 5 0.00000000 0.00000000       0 0.00000000       0       0       0 0.00702873
    ## 6 0.00000000 0.00685149       0 0.00000000       0       0       0 0.00000000
    ##      bpps_37    bpps_38    bpps_39    bpps_40 bpps_41 bpps_42 bpps_43 bpps_44
    ## 1 0.00000000 0.00000000 0.00159406 0.00629747       0       0       0       0
    ## 2 0.00000000 0.00144827 0.01117350 0.00000000       0       0       0       0
    ## 3 0.00132569 0.01070460 0.00000000 0.00000000       0       0       0       0
    ## 4 0.00947066 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 5 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ## 6 0.00000000 0.00000000 0.00000000 0.00000000       0       0       0       0
    ##   bpps_45 bpps_46 bpps_47 bpps_48 bpps_49 bpps_50 bpps_51 bpps_52 bpps_53
    ## 1       0       0       0       0       0       0       0       0       0
    ## 2       0       0       0       0       0       0       0       0       0
    ## 3       0       0       0       0       0       0       0       0       0
    ## 4       0       0       0       0       0       0       0       0       0
    ## 5       0       0       0       0       0       0       0       0       0
    ## 6       0       0       0       0       0       0       0       0       0
    ##   bpps_54 bpps_55    bpps_56    bpps_57    bpps_58 bpps_59    bpps_60 bpps_61
    ## 1       0       0 0.00000000 0.00529590 0.00605378       0 0.00000000       0
    ## 2       0       0 0.00515096 0.00579555 0.00000000       0 0.00000000       0
    ## 3       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 4       0       0 0.00000000 0.00000000 0.00000000       0 0.00132209       0
    ## 5       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ## 6       0       0 0.00000000 0.00000000 0.00000000       0 0.00000000       0
    ##     bpps_62   bpps_63 bpps_64 bpps_65    bpps_66 bpps_67 bpps_68 bpps_69
    ## 1 0.0012753 0.0136668       0       0 0.00152313       0       0       0
    ## 2 0.0133479 0.0000000       0       0 0.00000000       0       0       0
    ## 3 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 4 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 5 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ## 6 0.0000000 0.0000000       0       0 0.00000000       0       0       0
    ##   bpps_70 bpps_71 bpps_72 bpps_73 bpps_74 bpps_75    bpps_76    bpps_77 bpps_78
    ## 1       0       0       0       0       0       0 0.00000000 0.00141133       0
    ## 2       0       0       0       0       0       0 0.00000000 0.00443669       0
    ## 3       0       0       0       0       0       0 0.00287931 0.00000000       0
    ## 4       0       0       0       0       0       0 0.00000000 0.00000000       0
    ## 5       0       0       0       0       0       0 0.00140816 0.00000000       0
    ## 6       0       0       0       0       0       0 0.04401610 0.00000000       0
    ##      bpps_79    bpps_80    bpps_81   bpps_82 bpps_83 bpps_84    bpps_85 bpps_86
    ## 1 0.00275790 0.00598010 0.00597894 0.0138868       0       0 0.00152801       0
    ## 2 0.00969451 0.00376965 0.02291480 0.0000000       0       0 0.00000000       0
    ## 3 0.00000000 0.01750240 0.00000000 0.0000000       0       0 0.00000000       0
    ## 4 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 5 0.00000000 0.00000000 0.00000000 0.0000000       0       0 0.00000000       0
    ## 6 0.00000000 0.00235197 0.00000000 0.0000000       0       0 0.00000000       0
    ##   bpps_87 bpps_88 bpps_89 bpps_90 bpps_91 bpps_92 bpps_93    bpps_94 bpps_95
    ## 1       0       0       0       0       0       0       0 0.00952557       0
    ## 2       0       0       0       0       0       0       0 0.00578259       0
    ## 3       0       0       0       0       0       0       0 0.00000000       0
    ## 4       0       0       0       0       0       0       0 0.00000000       0
    ## 5       0       0       0       0       0       0       0 0.00000000       0
    ## 6       0       0       0       0       0       0       0 0.00000000       0
    ##   bpps_96    bpps_97 bpps_98 bpps_99   bpps_100 bpps_101 bpps_102   bpps_103
    ## 1       0 0.01114590       0       0 0.01163650        0        0 0.01053770
    ## 2       0 0.00633638       0       0 0.00603195        0        0 0.00563282
    ## 3       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 4       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 5       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ## 6       0 0.00000000       0       0 0.00000000        0        0 0.00000000
    ##   bpps_104 bpps_105   bpps_106 signal_to_noise SN_filter reactivity deg_Mg_pH10
    ## 1        0        0 0.01467360           6.894         1     0.3297      0.7556
    ## 2        0        0 0.00620374           6.894         1     1.5693      2.9830
    ## 3        0        0 0.00000000           6.894         1     1.1227      0.2526
    ## 4        0        0 0.00000000           6.894         1     0.8686      1.3789
    ## 5        0        0 0.00000000           6.894         1     0.7217      0.6376
    ## 6        0        0 0.00000000           6.894         1     0.4384      0.3313
    ##   deg_pH10 deg_Mg_50C deg_50C
    ## 1   2.3375     0.3581  0.6382
    ## 2   3.5060     2.9683  3.4773
    ## 3   0.3008     0.2589  0.9988
    ## 4   1.0108     1.4552  1.3228
    ## 5   0.2635     0.7244  0.7877
    ## 6   0.3403     0.4971  0.5890

On change les types des variables qui sont mal codées.

``` r
data=data %>% mutate(sequence = as.factor(sequence)) %>% 
  mutate(seq_be = as.factor(seq_be)) %>% 
  mutate(seq_af = as.factor(seq_af)) %>% 
  mutate(sequence = as.factor(sequence)) %>% 
  mutate(structure = as.factor(structure)) %>%
  mutate(struct_be = as.factor(struct_be)) %>% 
  mutate(struct_af = as.factor(struct_af)) %>% 
  mutate(predicted_loop_type = as.factor(predicted_loop_type)) %>% 
  mutate(loop_type_be = as.factor(loop_type_be)) %>% 
  mutate(loop_type_af = as.factor(loop_type_af)) 
```

``` r
length_sequence_train <- 68
```

On filtre maintenant les données qui ont SN\_filter=0.

``` r
print(sum(is.na(data)))
```

    ## [1] 0

``` r
print(sum(data$SN_filter==0)/length_sequence_train) # Nombre d'individus dont le SN_filter=0
```

    ## [1] 811

``` r
data=data[data$SN_filter==1,]
rownames(data)=NULL
```

<a id="split2"></a>

# Séparation train/validation

``` r
tamp=train_test_split(data)
index_train = tamp$index_train

data_train=tamp$train
rownames(data_train) <- NULL

data_val=tamp$val
rownames(data_val) <- NULL
```

``` r
sum(is.na(data_train))
```

    ## [1] 0

``` r
sum(is.na(data_val))
```

    ## [1] 0

``` r
dim(data_train)[1]+dim(data_val)[1]-dim(data)[1]
```

    ## [1] 0

<a id="rf"></a>

# Random Forest

Initialisation de vecteurs pour stocker nos résultats.

``` r
models_RF <- c()
errors_RF_train <- c()
errors_RF_val <- c()
```

Formule du modèle initial utilisé.

``` r
formula_model_full <- " ~ sequence + index_sequence + structure + predicted_loop_type + seq_be + seq_af + struct_be + struct_af + loop_type_be + loop_type_af"
for(i in 0:106)
{
  formula_model_full <- paste0(formula_model_full, " + bpps_", i)
}
print(formula_model_full)
```

    ## [1] " ~ sequence + index_sequence + structure + predicted_loop_type + seq_be + seq_af + struct_be + struct_af + loop_type_be + loop_type_af + bpps_0 + bpps_1 + bpps_2 + bpps_3 + bpps_4 + bpps_5 + bpps_6 + bpps_7 + bpps_8 + bpps_9 + bpps_10 + bpps_11 + bpps_12 + bpps_13 + bpps_14 + bpps_15 + bpps_16 + bpps_17 + bpps_18 + bpps_19 + bpps_20 + bpps_21 + bpps_22 + bpps_23 + bpps_24 + bpps_25 + bpps_26 + bpps_27 + bpps_28 + bpps_29 + bpps_30 + bpps_31 + bpps_32 + bpps_33 + bpps_34 + bpps_35 + bpps_36 + bpps_37 + bpps_38 + bpps_39 + bpps_40 + bpps_41 + bpps_42 + bpps_43 + bpps_44 + bpps_45 + bpps_46 + bpps_47 + bpps_48 + bpps_49 + bpps_50 + bpps_51 + bpps_52 + bpps_53 + bpps_54 + bpps_55 + bpps_56 + bpps_57 + bpps_58 + bpps_59 + bpps_60 + bpps_61 + bpps_62 + bpps_63 + bpps_64 + bpps_65 + bpps_66 + bpps_67 + bpps_68 + bpps_69 + bpps_70 + bpps_71 + bpps_72 + bpps_73 + bpps_74 + bpps_75 + bpps_76 + bpps_77 + bpps_78 + bpps_79 + bpps_80 + bpps_81 + bpps_82 + bpps_83 + bpps_84 + bpps_85 + bpps_86 + bpps_87 + bpps_88 + bpps_89 + bpps_90 + bpps_91 + bpps_92 + bpps_93 + bpps_94 + bpps_95 + bpps_96 + bpps_97 + bpps_98 + bpps_99 + bpps_100 + bpps_101 + bpps_102 + bpps_103 + bpps_104 + bpps_105 + bpps_106"

### Reactivity

``` r
formula_model_RF_reactivity <- paste0("reactivity", formula_model_full)
```

``` r
#model_RF_reactivity = randomForest(x = data_train[, 2:118], y = data_train$reactivity,
#                                   ntree=20, do.trace = 1)
```

``` r
#saveRDS(model_RF_reactivity, file = "model_RF_reactivity.rds")
model_RF_reactivity = readRDS(file = "model_RF_reactivity.rds")
```

``` r
summary(model_RF_reactivity)
```

    ##                 Length Class  Mode     
    ## call                5  -none- call     
    ## type                1  -none- character
    ## predicted       86428  -none- numeric  
    ## mse                20  -none- numeric  
    ## rsq                20  -none- numeric  
    ## oob.times       86428  -none- numeric  
    ## importance        117  -none- numeric  
    ## importanceSD        0  -none- NULL     
    ## localImportance     0  -none- NULL     
    ## proximity           0  -none- NULL     
    ## ntree               1  -none- numeric  
    ## mtry                1  -none- numeric  
    ## forest             11  -none- list     
    ## coefs               0  -none- NULL     
    ## y               86428  -none- numeric  
    ## test                0  -none- NULL     
    ## inbag               0  -none- NULL

``` r
y_pred_RF_train = predict(model_RF_reactivity,data_train,type="response")
error_RF_train <- mean((y_pred_RF_train-data_train$reactivity)^2,na.rm=TRUE)
print(error_RF_train)
```

    ## [1] 0.029551

``` r
y_pred_RF_val=predict(model_RF_reactivity,data_val,type="response")
error_RF_val <- mean((y_pred_RF_val-data_val$reactivity)^2,na.rm=TRUE)
print(error_RF_val)
```

    ## [1] 0.03071405

``` r
models_RF <- c(models_RF, "reactivity")
errors_RF_train <- c(errors_RF_train, error_RF_train)
errors_RF_val <- c(errors_RF_val, error_RF_val)
```

### deg\_Mg\_pH10

``` r
formula_model_RF_deg_Mg_pH10 <- paste0("deg_Mg_pH10", formula_model_full)
```

``` r
#model_RF_deg_Mg_pH10 = randomForest(x = data_train[, 2:118], y = data_train$deg_Mg_pH10,
#                                 ntree=20, do.trace = 1)
```

``` r
#saveRDS(model_RF_deg_Mg_pH10, file = "model_RF_deg_Mg_pH10.rds")
model_RF_deg_Mg_pH10 = readRDS(file = "model_RF_deg_Mg_pH10.rds")
```

``` r
summary(model_RF_deg_Mg_pH10)
```

    ##                 Length Class  Mode     
    ## call                5  -none- call     
    ## type                1  -none- character
    ## predicted       86428  -none- numeric  
    ## mse                20  -none- numeric  
    ## rsq                20  -none- numeric  
    ## oob.times       86428  -none- numeric  
    ## importance        117  -none- numeric  
    ## importanceSD        0  -none- NULL     
    ## localImportance     0  -none- NULL     
    ## proximity           0  -none- NULL     
    ## ntree               1  -none- numeric  
    ## mtry                1  -none- numeric  
    ## forest             11  -none- list     
    ## coefs               0  -none- NULL     
    ## y               86428  -none- numeric  
    ## test                0  -none- NULL     
    ## inbag               0  -none- NULL

``` r
y_pred_RF_train = predict(model_RF_deg_Mg_pH10,data_train,type="response")
error_RF_train <- mean((y_pred_RF_train-data_train$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_RF_train)
```

    ## [1] 0.0462261

``` r
y_pred_RF_val=predict(model_RF_deg_Mg_pH10,data_val,type="response")
error_RF_val <- mean((y_pred_RF_val-data_val$deg_Mg_pH10)^2,na.rm=TRUE)
print(error_RF_val)
```

    ## [1] 0.05464076

``` r
models_RF <- c(models_RF, "deg_Mg_pH10")
errors_RF_train <- c(errors_RF_train, error_RF_train)
errors_RF_val <- c(errors_RF_val, error_RF_val)
```

### deg\_pH10

``` r
formula_model_RF_deg_pH10 <- paste0("deg_pH10", formula_model_full)
```

``` r
#model_RF_deg_pH10 = randomForest(x = data_train[, 2:118], y = data_train$deg_pH10,
#                                 ntree=20, do.trace = 1)
```

``` r
#saveRDS(model_RF_deg_pH10, file = "model_RF_deg_pH10.rds")
model_RF_deg_pH10 = readRDS(file = "model_RF_deg_pH10.rds")
```

``` r
summary(model_RF_deg_pH10)
```

    ##                 Length Class  Mode     
    ## call                5  -none- call     
    ## type                1  -none- character
    ## predicted       86428  -none- numeric  
    ## mse                20  -none- numeric  
    ## rsq                20  -none- numeric  
    ## oob.times       86428  -none- numeric  
    ## importance        117  -none- numeric  
    ## importanceSD        0  -none- NULL     
    ## localImportance     0  -none- NULL     
    ## proximity           0  -none- NULL     
    ## ntree               1  -none- numeric  
    ## mtry                1  -none- numeric  
    ## forest             11  -none- list     
    ## coefs               0  -none- NULL     
    ## y               86428  -none- numeric  
    ## test                0  -none- NULL     
    ## inbag               0  -none- NULL

``` r
y_pred_RF_train = predict(model_RF_deg_pH10,data_train,type="response")
error_RF_train <- mean((y_pred_RF_train-data_train$deg_pH10)^2,na.rm=TRUE)
print(error_RF_train)
```

    ## [1] 0.03617675

``` r
y_pred_RF_val=predict(model_RF_deg_pH10,data_val,type="response")
error_RF_val <- mean((y_pred_RF_val-data_val$deg_pH10)^2,na.rm=TRUE)
print(error_RF_val)
```

    ## [1] 0.04016071

``` r
models_RF <- c(models_RF, "deg_pH10")
errors_RF_train <- c(errors_RF_train, error_RF_train)
errors_RF_val <- c(errors_RF_val, error_RF_val)
```

### deg\_Mg\_50C

``` r
formula_model_RF_deg_Mg_50C <- paste0("deg_Mg_50C", formula_model_full)
```

``` r
#model_RF_deg_Mg_50C = randomForest(x = data_train[, 2:118], y = data_train$deg_Mg_50C,
#                                   ntree=20, do.trace = 1)
```

``` r
#saveRDS(model_RF_deg_Mg_50C, file = "model_RF_deg_Mg_50C.rds")
model_RF_deg_Mg_50C = readRDS(file = "model_RF_deg_Mg_50C.rds")
```

``` r
summary(model_RF_deg_Mg_50C)
```

    ##                 Length Class  Mode     
    ## call                5  -none- call     
    ## type                1  -none- character
    ## predicted       86428  -none- numeric  
    ## mse                20  -none- numeric  
    ## rsq                20  -none- numeric  
    ## oob.times       86428  -none- numeric  
    ## importance        117  -none- numeric  
    ## importanceSD        0  -none- NULL     
    ## localImportance     0  -none- NULL     
    ## proximity           0  -none- NULL     
    ## ntree               1  -none- numeric  
    ## mtry                1  -none- numeric  
    ## forest             11  -none- list     
    ## coefs               0  -none- NULL     
    ## y               86428  -none- numeric  
    ## test                0  -none- NULL     
    ## inbag               0  -none- NULL

``` r
y_pred_RF_train = predict(model_RF_deg_Mg_50C,data_train,type="response")
error_RF_train <- mean((y_pred_RF_train-data_train$deg_Mg_50C)^2,na.rm=TRUE)
print(error_RF_train)
```

    ## [1] 0.03645121

``` r
y_pred_RF_val=predict(model_RF_deg_Mg_50C,data_val,type="response")
error_RF_val <- mean((y_pred_RF_val-data_val$deg_Mg_50C)^2,na.rm=TRUE)
print(error_RF_val)
```

    ## [1] 0.03922437

``` r
models_RF <- c(models_RF, "deg_Mg_50C")
errors_RF_train <- c(errors_RF_train, error_RF_train)
errors_RF_val <- c(errors_RF_val, error_RF_val)
```

### deg\_50C

``` r
formula_model_RF_deg_50C <- paste0("deg_50C", formula_model_full)
```

``` r
#model_RF_deg_50C = randomForest(x = data_train[, 2:118], y = data_train$deg_50C,
#                                ntree=20, do.trace = 1)
```

``` r
#saveRDS(model_RF_deg_50C, file = "model_RF_deg_50C.rds")
model_RF_deg_50C = readRDS(file = "model_RF_deg_50C.rds")
```

``` r
summary(model_RF_deg_Mg_50C)
```

    ##                 Length Class  Mode     
    ## call                5  -none- call     
    ## type                1  -none- character
    ## predicted       86428  -none- numeric  
    ## mse                20  -none- numeric  
    ## rsq                20  -none- numeric  
    ## oob.times       86428  -none- numeric  
    ## importance        117  -none- numeric  
    ## importanceSD        0  -none- NULL     
    ## localImportance     0  -none- NULL     
    ## proximity           0  -none- NULL     
    ## ntree               1  -none- numeric  
    ## mtry                1  -none- numeric  
    ## forest             11  -none- list     
    ## coefs               0  -none- NULL     
    ## y               86428  -none- numeric  
    ## test                0  -none- NULL     
    ## inbag               0  -none- NULL

``` r
y_pred_RF_train = predict(model_RF_deg_50C,data_train,type="response")
error_RF_train <- mean((y_pred_RF_train-data_train$deg_50C)^2,na.rm=TRUE)
print(error_RF_train)
```

    ## [1] 0.02785184

``` r
y_pred_RF_val=predict(model_RF_deg_50C,data_val,type="response")
error_RF_val <- mean((y_pred_RF_val-data_val$deg_50C)^2,na.rm=TRUE)
print(error_RF_val)
```

    ## [1] 0.02904935

``` r
models_RF <- c(models_RF, "deg_50C")
errors_RF_train <- c(errors_RF_train, error_RF_train)
errors_RF_val <- c(errors_RF_val, error_RF_val)
```

### Récapitulatif des résultats

``` r
models_RF_df <- data.frame(models_RF, errors_RF_train, errors_RF_val)
```

``` r
models_RF_df
```

    ##     models_RF errors_RF_train errors_RF_val
    ## 1  reactivity      0.02955100    0.03071405
    ## 2 deg_Mg_pH10      0.04622610    0.05464076
    ## 3    deg_pH10      0.03617675    0.04016071
    ## 4  deg_Mg_50C      0.03645121    0.03922437
    ## 5     deg_50C      0.02785184    0.02904935

<a id="soumission2"></a>

# Soumission Random Forest

``` r
##data_test=read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_test.csv")
#data_test = read.csv("data_test.csv")
```

``` r
#data_test = data_test[,-1] %>% mutate(sequence = as.factor(sequence)) %>% 
#  mutate(seq_be = as.factor(seq_be)) %>% 
#  mutate(seq_af = as.factor(seq_af)) %>% 
#  mutate(structure = as.factor(structure)) %>% 
#  mutate(predicted_loop_type = as.factor(predicted_loop_type))
```

``` r
##y_test_pred=read.csv(
##  file = "~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/sample_submission.csv")

#y_test_pred_RF = read.csv(file = "sample_submission.csv")
```

``` r
#model_RF_reactivity = readRDS("model_RF_reactivity.rds")
#model_RF_deg_Mg_pH10 = readRDS("model_RF_deg_Mg_pH10.rds")
#model_RF_deg_pH10 = readRDS("model_RF_deg_pH10.rds")
#model_RF_deg_Mg_50C = readRDS("model_RF_deg_Mg_50C.rds")
#model_RF_deg_50C = readRDS("model_RF_deg_50C.rds")
```

On réentraine les modèles en incorporant le jeu de données de
validation.

``` r
#model_RF_reactivity_submission = update(object = model_RF_reactivity,
#                                        x = data[, 2:118],
#                                        y = data$reactivity)
```

``` r
#saveRDS(model_RF_reactivity_submission, file = "model_RF_reactivity_submission.rds")
```

``` r
#model_RF_deg_Mg_pH10_submission = update(object = model_RF_deg_Mg_pH10,
#                                         x = data[, 2:118],
#                                         y = data$deg_Mg_pH10)
```

``` r
#saveRDS(model_RF_deg_Mg_pH10_submission, file = "model_RF_deg_Mg_pH10_submission.rds")
```

``` r
#model_RF_deg_pH10_submission = update(object = model_RF_deg_pH10,
#                                      x = data[, 2:118],
#                                      y = data$deg_pH10)
```

``` r
#saveRDS(model_RF_deg_pH10_submission, file = "model_RF_deg_pH10_submission.rds")
```

``` r
#model_RF_deg_Mg_50C_submission = update(object = model_RF_deg_Mg_50C,
#                                        x = data[, 2:118],
#                                        y = data$deg_Mg_50C)
```

``` r
#saveRDS(model_RF_deg_Mg_50C_submission, file = "model_RF_deg_Mg_50C_submission.rds")
```

``` r
#model_RF_deg_50C_submission = update(object = model_RF_deg_50C,
#                                     x = data[, 2:118],
#                                     y = data$deg_50C)
```

``` r
#saveRDS(model_RF_deg_50C_submission, file = "model_RF_deg_50C_submission.rds")
```

``` r
#saveRDS(model_RF_reactivity_submission, file = "model_RF_reactivity_submission.rds")
#saveRDS(model_RF_deg_Mg_pH10_submission, file = "model_RF_deg_Mg_pH10_submission.rds")
#saveRDS(model_RF_deg_pH10_submission, file = "model_RF_deg_pH10_submission.rds")
#saveRDS(model_RF_deg_Mg_50C_submission, file = "model_RF_deg_Mg_50C_submission.rds")
#saveRDS(model_RF_deg_50C_submission, file = "model_RF_deg_50C_submission.rds")
```

``` r
#model_RF_reactivity_submission = readRDS("model_RF_reactivity_submision.rds")
#model_RF_deg_Mg_pH10_submission = readRDS("model_RF_deg_Mg_pH10_submision.rds")
#model_RF_deg_pH10_submission = readRDS("model_RF_deg_pH10_submision.rds")
#model_RF_deg_Mg_50C_submission = readRDS("model_RF_deg_Mg_50C_submision.rds")
#model_RF_deg_50C_submission = readRDS("model_RF_deg_50C_submision.rds")
```

``` r
#y_test_pred_RF = y_test_pred_RF %>%
#  mutate(reactivity = predict(model_RF_reactivity_submission,
#                              data_test, type="response")) %>%
#  mutate(deg_Mg_pH10 = predict(model_RF_deg_Mg_pH10_submission,
#                               data_test, type="response")) %>%
#  mutate(deg_pH10 = predict(model_RF_deg_pH10_submission,
#                            data_test, type="response")) %>%
#  mutate(deg_Mg_50C = predict(model_RF_deg_Mg_50C_submission,
#                              data_test, type="response")) %>%
#  mutate(deg_50C = predict(model_RF_deg_50C_submission,
#                           data_test, type="response")) %>%
#  mutate_all(unlist)
```

``` r
#save(y_test_pred_RF, file = "sample_submission_RF.Rda")
```

``` r
#load(file = "sample_submission_RF.Rda")
```

``` r
#head(y_test_pred_RF)
```

``` r
#fwrite(y_test_pred_RF, "sample_submission_RF.csv")
```
