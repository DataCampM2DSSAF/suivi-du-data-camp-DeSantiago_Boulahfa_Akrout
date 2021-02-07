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

    data_filtered = read.csv("~/suivi-du-data-camp-DeSantiago_Boulahfa_Akrout/code/data_filtered.csv")
    colnames(data_filtered)[1] <- "Position"
    colnames(data_filtered)[2] <- "Covariable"

    data_filtered$Covariable = recode_factor(data_filtered$Covariable,"score_structure_boucle"="reactivity")

    noms=colnames(data_filtered)[3:1591]
    for (i in noms){
      data_filtered[which(data_filtered[,i]<0),i]=0
    }

    nucleotide=extraction_vect(data_filtered,'nucléotide')
    loop=extraction_vect(data_filtered,'structure_boucle')
    Y_reactivity = extraction_vect(data_filtered,'reactivity')
    Y_score_mg_ph10 = extraction_vect(data_filtered,'score_mg_ph10')
    Y_score_ph10 = extraction_vect(data_filtered,'score_ph10')
    Y_score_mg_50c = extraction_vect(data_filtered,'score_mg_50c')
    Y_score_50c = extraction_vect(data_filtered,'score_50c')

Modèles naifs
-------------

### LM

    model=lm(Y_reactivity~as.factor(nucleotide))
    summary(model)

    ## 
    ## Call:
    ## lm(formula = Y_reactivity ~ as.factor(nucleotide))
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.5279 -0.2954 -0.1140  0.1436  6.4088 
    ## 
    ## Coefficients:
    ##                         Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)             0.527889   0.002229  236.78   <2e-16 ***
    ## as.factor(nucleotide)1 -0.186672   0.003948  -47.28   <2e-16 ***
    ## as.factor(nucleotide)2 -0.379995   0.003704 -102.59   <2e-16 ***
    ## as.factor(nucleotide)3 -0.146530   0.003332  -43.98   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.4343 on 108048 degrees of freedom
    ## Multiple R-squared:  0.0901, Adjusted R-squared:  0.09007 
    ## F-statistic:  3566 on 3 and 108048 DF,  p-value: < 2.2e-16

    model=lm(Y_reactivity~as.factor(nucleotide)+as.factor(loop))
    summary(model)

    ## 
    ## Call:
    ## lm(formula = Y_reactivity ~ as.factor(nucleotide) + as.factor(loop))
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.7128 -0.2065 -0.0589  0.1161  6.0843 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)             0.2141660  0.0027459  77.994   <2e-16 ***
    ## as.factor(nucleotide)1  0.0006439  0.0036827   0.175   0.8612    
    ## as.factor(nucleotide)2 -0.1665111  0.0035298 -47.174   <2e-16 ***
    ## as.factor(nucleotide)3  0.0064320  0.0030963   2.077   0.0378 *  
    ## as.factor(loop)1        0.3697476  0.0066820  55.335   <2e-16 ***
    ## as.factor(loop)2        0.2462734  0.0044703  55.091   <2e-16 ***
    ## as.factor(loop)3        0.4652688  0.0083792  55.527   <2e-16 ***
    ## as.factor(loop)4        0.4922422  0.0037752 130.389   <2e-16 ***
    ## as.factor(loop)5        0.4852654  0.0035065 138.389   <2e-16 ***
    ## as.factor(loop)6        0.3066972  0.0063411  48.366   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3845 on 108042 degrees of freedom
    ## Multiple R-squared:  0.287,  Adjusted R-squared:  0.2869 
    ## F-statistic:  4831 on 9 and 108042 DF,  p-value: < 2.2e-16

### GLM : loi Gamma

    model=glm(Y_reactivity+1e-12~as.factor(nucleotide),family = Gamma)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = Y_reactivity + 1e-12 ~ as.factor(nucleotide), family = Gamma)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2100  -1.3359  -0.4552   0.3671   6.6143  
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)             1.89434    0.01168  162.24   <2e-16 ***
    ## as.factor(nucleotide)1  1.03635    0.02886   35.90   <2e-16 ***
    ## as.factor(nucleotide)2  4.86729    0.05652   86.12   <2e-16 ***
    ## as.factor(nucleotide)3  0.72787    0.02141   33.99   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.441874)
    ## 
    ##     Null deviance: 513847  on 108051  degrees of freedom
    ## Residual deviance: 494705  on 108048  degrees of freedom
    ## AIC: -186861
    ## 
    ## Number of Fisher Scoring iterations: 7

    model=glm(Y_reactivity+1e-12~as.factor(nucleotide)+as.factor(loop),family = Gamma)
    summary(model)

    ## 
    ## Call:
    ## glm(formula = Y_reactivity + 1e-12 ~ as.factor(nucleotide) + 
    ##     as.factor(loop), family = Gamma)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -7.2650  -1.1426  -0.4002   0.3192   7.2301  
    ## 
    ## Coefficients:
    ##                        Estimate Std. Error  t value Pr(>|t|)    
    ## (Intercept)             5.41195    0.03181  170.153  < 2e-16 ***
    ## as.factor(nucleotide)1 -0.10710    0.02397   -4.468 7.92e-06 ***
    ## as.factor(nucleotide)2  2.77159    0.05423   51.104  < 2e-16 ***
    ## as.factor(nucleotide)3 -0.10583    0.01817   -5.825 5.73e-09 ***
    ## as.factor(loop)1       -3.72832    0.04485  -83.120  < 2e-16 ***
    ## as.factor(loop)2       -3.24763    0.04024  -80.705  < 2e-16 ***
    ## as.factor(loop)3       -3.99562    0.04714  -84.761  < 2e-16 ***
    ## as.factor(loop)4       -4.03274    0.03280 -122.967  < 2e-16 ***
    ## as.factor(loop)5       -3.99720    0.03247 -123.092  < 2e-16 ***
    ## as.factor(loop)6       -3.51949    0.04646  -75.755  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for Gamma family taken to be 1.367066)
    ## 
    ##     Null deviance: 513847  on 108051  degrees of freedom
    ## Residual deviance: 462717  on 108042  degrees of freedom
    ## AIC: -197279
    ## 
    ## Number of Fisher Scoring iterations: 7
