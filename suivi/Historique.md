# suivi-du-data-camp-DeSantiago_Boulahfa_Akrout

Outil de réunion utilisé : Discord.
Lien : https://discord.gg/AdE39hSMD9

Semaine 1. 22 Janvier au 29 Janvier :
- Création de l'équipe
- Réflexion sur l'objectif du projet
- Premières manipulations de la base de données

Semaine 2. 29 Janvier au 05 Février :
- Récolte d'informations sur les variables de la base de données.
- Élaboration de pistes à explorer.
- Transformation du jeu de données pour les statistiques descriptives.
test.

**Vendredi 29 Janvier** :

Leyth -> Netoyage des données, creation d'une première base de données sur les données train exploitable en Python et R ( data frame ).

**Samedi 06 Février** :

Kylliann -> Travail sur les statistiques descriptives sur les variables, création de la partie visualisation du GitHub, recherche de documentation sur le Multi-Target Regressor, structuration du code, tests d'exploitation de la piste de réflexion sur les prédictions successives, premiers essais de modèles naifs.

Jawad -> Travail sur la réorganisation et la visualisation des données (pie plots, density plots, ...), recherche d'informations sur le jeu de données (forum Kaggle, article: https://daslab.stanford.edu/site_data/pub_pdf/2014_Seetin_MIMB.pdf).

Leyth -> Statistiques descriptives sur les différentes variables, histogrames densité des scores et des scores par groupes, test d'adéquation des scores selon les différents groupes ( nucléotides et structures ). Création de premier modèles GLM ( gaussien, gamma et inverse gaussienne ) simples.

**Dimanche 07 Février** :

Kylliann -> poursuite du travail sur les modèles basiques, recodage de la base de données, MSE sur les modèles basiques pour le label 'reactivity'

Jawad -> Visualisation des données: ajout de scatter plots et d'histogrammes, recherche d'informations sur le jeu de données (https://www.kaggle.com/c/stanford-covid-vaccine/discussion/182320)

Leyth -> Creation de nouvelles variables pour améliorer les modèles ( trop significatif avec de mauvais scores ). Modèles GLM avec ces nouvelles variables, intéractions et aic.   

**Lundi 08 Février** :

Kylliann -> Ajout de la correlation entre les labels. Travail sur les modèles simple. Première soumission avec un modèle simple. Le score obtenu est 1.96760

![](Historique.png)

**Mardi 09 Février** :

Leyth -> Création d'une fonction permettant de filtrer les données brutes dans l'espoir de pouvoir utiliser le bruit des données pour améliorer non modèles.

**Jeudi 11 Février** :

Kylliann -> Modification des modèles + correction d'une erreur lors de la prédiction des labels. 2 soumissions ont été faites.
La première est la correction de la 1ère soumission, avec un score public de 0.54976 et un score privé de 0.46440.
La deuxième soumission avec un modèle légèrement plus complexe a obtenu un score public de 0.42532 et un score privé de 0.49538.

Jawad -> Ajout d'un pie plot pour les predicted_loop_type.

**Vendredi 12 Février** :

Jawad -> Visualisation pour la variable predicted_loop_type (boxplots, histogrammes, densités, scatter plots), ajout de commentaires dans le fichier de visualisation.

Leyth -> Mise au propre des programmes pour les mettre sur GitHub.

**Samedi 20 Février** :

Jawad -> Essais de quelques modèles GLM basiques, début d'optimisation d'un modèle GLM sur le label reactivity (stepAIC: ne change rien aux résultats, pénalisation ridge et lasso).

**Dimanche 21 Février** :

Jawad -> Fin d'optimisation d'un modèle GLM sur le label reactivity (pénalisation ridge, lasso et elastic-net: n'apportent aucune amélioration).
Ecriture d'une fonction pour choisir alpha de façon optimale (dans une liste donnée) dans la pénalisation elastic-net.
Optimisation d'un modèle GLM sur le label deg_Mg_pH10 (stepAIC: pas d'amélioration, pénalisation ridge et lasso: pas d'amélioration, pénalisation elastic-net: légère amélioration).

**Lundi 22 Février** :

Jawad -> Optimisation de modèles GLM sur les labels deg_pH10, deg_Mg_50C et deg_50C (stepAIC, pénalisation ridge, lasso et elastic-net).
Récapitulatif:
- deg_pH10 : pas d'amélioration
- deg_Mg_50C: légère amélioration via l'elastic-net
- deg_50C: pas d'amélioration

**Vendredi 26 Février** :

Kylliann -> Création d'un nouveau jeu de données train et test, exploitant les valeurs des matrices contenue dans le dossier bpps

**Lundi 1 Mars**:

Jawad -> Essais d'optimisation de modèles GLM utilisant les BPPS.

**Mardi 2 Mars**:

Jawad -> Fin du travail d'optimisation de modèles GLM utilisant les BPPS: les modèles sans pénalisation ne sont pas de plein rang donc inutilisables en l'état.
Cependant, ce problème se résout après pénalisation.
Parmi la pénalisation ridge, lasso, et elastic-net, c'est la pénalisation lasso qui est toujours la meilleure.

Kylliann -> Construction des modèles de Deep Learning. Souci au niveau de la lecture des données dans le modèle MLP. La suite du travail se focalisera sur la création d'une structure pour les données permettant l'utilisation du DeepL, ainsi que la création d'un modèle type MLP et un modèle type CNN qui pourront ensuite être combinés à un modèle type RNN.

**Samedi 6 Mars**:

Kylliann -> Avance sur le modèle MLP, le modèle tourne avec les variables quantitatives mais toujours un souci sur les variables qualitatives.

**Dimanche 7 Mars**:

Kylliann -> modèle MLP : ajout du One-Hot-Encoding pour les variables qualitatives. Certaines variables ont dû être retirées pour la compatibilité avec la base de donnée test. Le souci étant la longueur des données test qui sont plus grande que celle du train, obligeant ainsi à adapter nos méthodes à ce problème.
Ce souci est autant vrai pour les variables qualitatives (ex : place du nucléotide dans l'ARN) que pour les modèles utilisés. On ne peut pas utiliser directement un CNN sur les matrices bpps par souci de différence de dimension entre le jeu train et le jeu test.

Jawad -> Premiers modèles Random Forest pour chacun des labels. On utilise les modèles GLM avec pénalisation lasso précédemment obtenus pour sélectionner les BPPS à inclure.

**Lundi 8 Mars**:

Jawad -> Modèles GLM: il y avait des erreurs de syntaxe à corriger. Une fois cela corrigé, il s'avère que la pénalisation elastic-net est généralement meilleur que le lasso.
Ecriture d'un fichier csv pour une soumission utilisant les modèles GLM avec pénalisation elastic-net.

**Mardi 9 Mars**:

Jawad -> Modèles Random Forest: après correction des erreurs de syntaxe sur les modèles GLM, il s'avère que la démarche consistant à utiliser les modèles GLM avec pénalisation lasso pour sélectionner les BPPS n'est plus pertinente.
Mise à jour du Readme avec les premiers modèles Random Forest.
Ecriture d'un fichier csv pour une soumission utilisant les premiers modèles Random Forest.

**Samedi 13 Mars**:

Jawad -> Modèles Random Forest: entrainement de modèles avec 20 arbres au lieu de 3. Correction d'erreurs dans les soumissions (il fallait réentrainer les modèles en incorporant le jeu de données de validation avant d'effectuer les prédictions sur le test).

**Dimanche 14 Mars**:

Jawad -> Modèles GLM: écriture d'un fichier csv pour une soumission utilisant les modèles GLM optimisés et réentrainés en ajoutant les données de validation.

**Lundi 15 Mars**:

Jawad -> Modèles Random Forest: écriture d'un fichier csv pour une soumission utilisant les modèles Random Forest réentrainés en ajoutant les données de validation.
