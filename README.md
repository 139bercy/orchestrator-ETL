# Orchestrator ETL

Ce projet représente le service d'orchestation utilisé avec data-upload et ELK sur les différents projets de datascience du BercyHub.

# ETL par défaut
Ce projet contient le dossier `default-ETL` qui définit l'ensemble des éléments nécessaires pour lancer **pypel** avec une configuration par défaut.
Une configuration, définie par le fichier `parameters.json`, identifie un process exécutable dans lequel les données sont chargées depuis le dossier `default` lui-même présent dans le dossier de stockage (dans le container docker `/data`).
Elles sont ensuite transformées avec une configuration minimale représentée par `pypel.processes.Process.Process` avec `pypel.processes.Process.MinimalTransformer` comme seul et unique transformer.
Enfin les données sont stocké dans un index nommé `pypel-default`.

Pour modifier cette configuration, il faut remplacer le fichier `parameters.json` en y intégrant les informations voulues.

# Service d'orchestration
Ce projet contient le dossier `orchestrator` qui définit l'ensemble des éléments nécessaires pour lancer l'orchestrateur de l'ETL.
À chaque fichier de configuration présent dans `config`, l'orchestrateur enregistre un process qui va surveiller le dossier indiqué dans le fichier (variable `WATCH_DIR`).
Dès qu'un fichier apparaît dans ce dossier, l'orchestrateur lance le script identifié dans le fichier de config sous le nom de variable `COMMAND`
Le script fourni dans le dossier `scripts`, et qui est celui utilisé pour démarrer **pypel** démarre un conteneur Docker capable de traiter le nouveau fichier déposé dans le dossier.
Ce sont l'ensemble des variables présentes dans le fichier de config qui permettre de définir les différents paramètres et variables d'environnement permettant de configurer le conteneur et donc le processus pypel.

## TODO
- [ ] Définition d'une interface graphique permettant de gérer les configurations
- [ ] Définition d'un backend capable de stocker les informations de configuration dans une base de données
- [x] Définition d'un ETL "par défaut" qui utilise PyPel et qui exécute les transformations minimales
  - Cet ETL prend donc un dossier en lecture
  - Pour chaque fichier dans ce dossier, il exécute `pypel.processes.Process.Process` avec `pypel.processes.Process.MinimalTransformer` comme seul et unique transformer
  - L'ensemble des données sont ensuite chargées dans un ELK dans l'index `default-ETL`
